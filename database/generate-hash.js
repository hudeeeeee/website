const bcrypt = require('bcrypt');

async function main() {
  const adminHash = await bcrypt.hash('Admin@123456', 10);
  const customerHash = await bcrypt.hash('Customer@123', 10);

  console.log('-- Thay PLACEHOLDER trong seed.sql bằng các hash sau:');
  console.log('ADMIN hash:   ', adminHash);
  console.log('CUSTOMER hash:', customerHash);
  console.log('');
  console.log('-- Hoặc chạy lệnh sau để update trực tiếp:');
  console.log(`UPDATE users SET password_hash = '${adminHash}' WHERE email = 'admin@electroshop.com';`);
  console.log(`UPDATE users SET password_hash = '${customerHash}' WHERE role = 'customer';`);
}

main();
