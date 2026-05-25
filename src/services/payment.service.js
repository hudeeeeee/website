const pool = require('../config/database');
const crypto = require('crypto');
const querystring = require('querystring');

async function getBankInfo(orderCode, userId) {
  const [rows] = await pool.query(
    'SELECT * FROM orders WHERE order_code = ? AND user_id = ?', [orderCode, userId]
  );
  if (!rows.length) return null;
  return {
    order: rows[0],
    bankAccount: process.env.BANK_ACCOUNT_NUMBER,
    bankName: process.env.BANK_NAME,
    accountName: process.env.BANK_ACCOUNT_NAME,
    transferContent: orderCode
  };
}

async function confirmBankPayment(orderId, transactionCode) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const [rows] = await conn.query('SELECT * FROM orders WHERE id = ?', [orderId]);
    if (!rows.length) throw new Error('Không tìm thấy đơn hàng');
    const order = rows[0];
    if (order.payment_status === 'paid') throw new Error('Đơn đã được thanh toán');

    await conn.query(
      "UPDATE payments SET payment_status = 'paid', transaction_code = ?, paid_at = NOW() WHERE order_id = ?",
      [transactionCode, orderId]
    );
    await conn.query(
      "UPDATE orders SET payment_status = 'paid', order_status = 'confirmed', updated_at = NOW() WHERE id = ?",
      [orderId]
    );

    const [items] = await conn.query('SELECT product_id, quantity FROM order_items WHERE order_id = ?', [orderId]);
    for (const item of items) {
      await conn.query(
        'UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ?',
        [item.quantity, item.product_id]
      );
      await conn.query(
        "UPDATE products SET status = 'out_of_stock' WHERE id = ? AND stock_quantity <= 0",
        [item.product_id]
      );
    }

    await conn.commit();
    return { success: true };
  } catch (err) {
    await conn.rollback();
    return { success: false, error: err.message };
  } finally {
    conn.release();
  }
}

function sortObject(obj) {
  return Object.keys(obj).sort().reduce((sorted, key) => {
    sorted[key] = obj[key];
    return sorted;
  }, {});
}

function createVNPayUrl(orderCode, amount, ipAddr) {
  const tmnCode = process.env.VNPAY_TMN_CODE;
  const secretKey = process.env.VNPAY_HASH_SECRET;
  const vnpUrl = process.env.VNPAY_URL;

  const date = new Date();
  const createDate = date.toISOString().replace(/[-T:.Z]/g, '').substring(0, 14);

  const params = sortObject({
    vnp_Version: '2.1.0',
    vnp_Command: 'pay',
    vnp_TmnCode: tmnCode,
    vnp_Amount: amount * 100,
    vnp_CurrCode: 'VND',
    vnp_TxnRef: orderCode,
    vnp_OrderInfo: `Thanh toan don hang ${orderCode}`,
    vnp_OrderType: 'other',
    vnp_Locale: 'vn',
    vnp_ReturnUrl: process.env.VNPAY_RETURN_URL,
    vnp_IpAddr: ipAddr,
    vnp_CreateDate: createDate
  });

  const signData = querystring.stringify(params, { encode: false });
  const hmac = crypto.createHmac('sha512', secretKey);
  const signed = hmac.update(Buffer.from(signData, 'utf-8')).digest('hex');
  params.vnp_SecureHash = signed;

  return `${vnpUrl}?${querystring.stringify(params, { encode: false })}`;
}

function verifyVNPayReturn(query) {
  const secureHash = query.vnp_SecureHash;
  const params = { ...query };
  delete params.vnp_SecureHash;
  delete params.vnp_SecureHashType;

  const sorted = sortObject(params);
  const signData = querystring.stringify(sorted, { encode: false });
  const hmac = crypto.createHmac('sha512', process.env.VNPAY_HASH_SECRET);
  const checkHash = hmac.update(Buffer.from(signData, 'utf-8')).digest('hex');

  return { valid: secureHash === checkHash, responseCode: query.vnp_ResponseCode };
}

async function handleVNPaySuccess(orderCode, transactionCode) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const [rows] = await conn.query('SELECT * FROM orders WHERE order_code = ?', [orderCode]);
    if (!rows.length) throw new Error('Không tìm thấy đơn hàng');
    const order = rows[0];

    if (order.payment_status === 'paid') {
      await conn.commit();
      return { success: true, alreadyPaid: true };
    }

    await conn.query(
      "UPDATE payments SET payment_status = 'paid', transaction_code = ?, paid_at = NOW() WHERE order_id = ?",
      [transactionCode, order.id]
    );
    await conn.query(
      "UPDATE orders SET payment_status = 'paid', order_status = 'confirmed', updated_at = NOW() WHERE id = ?",
      [order.id]
    );

    const [items] = await conn.query('SELECT product_id, quantity FROM order_items WHERE order_id = ?', [order.id]);
    for (const item of items) {
      await conn.query('UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ?',
        [item.quantity, item.product_id]);
      await conn.query("UPDATE products SET status = 'out_of_stock' WHERE id = ? AND stock_quantity <= 0",
        [item.product_id]);
    }

    await conn.commit();
    return { success: true };
  } catch (err) {
    await conn.rollback();
    return { success: false, error: err.message };
  } finally {
    conn.release();
  }
}

async function handleVNPayFailed(orderCode) {
  await pool.query(
    "UPDATE payments SET payment_status = 'failed' WHERE order_id = (SELECT id FROM orders WHERE order_code = ?)",
    [orderCode]
  );
  await pool.query(
    "UPDATE orders SET payment_status = 'failed' WHERE order_code = ?",
    [orderCode]
  );
}

module.exports = { getBankInfo, confirmBankPayment, createVNPayUrl, verifyVNPayReturn, handleVNPaySuccess, handleVNPayFailed };
