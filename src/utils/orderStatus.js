const ORDER_STATUS_LABEL = {
  pending:    { label: 'Chờ xác nhận',  badge: 'warning'  },
  confirmed:  { label: 'Đã xác nhận',   badge: 'info'     },
  processing: { label: 'Đang chuẩn bị', badge: 'primary'  },
  shipping:   { label: 'Đang giao',      badge: 'primary'  },
  completed:  { label: 'Hoàn thành',     badge: 'success'  },
  cancelled:  { label: 'Đã hủy',         badge: 'danger'   }
};

const PAYMENT_STATUS_LABEL = {
  unpaid:   { label: 'Chưa thanh toán', badge: 'secondary' },
  pending:  { label: 'Chờ thanh toán',  badge: 'warning'   },
  paid:     { label: 'Đã thanh toán',   badge: 'success'   },
  failed:   { label: 'Thất bại',        badge: 'danger'    },
  refunded: { label: 'Đã hoàn tiền',    badge: 'info'      }
};

const VALID_ORDER_TRANSITIONS = {
  pending:    ['confirmed', 'cancelled'],
  confirmed:  ['processing', 'cancelled'],
  processing: ['shipping'],
  shipping:   ['completed'],
  completed:  [],
  cancelled:  []
};

module.exports = { ORDER_STATUS_LABEL, PAYMENT_STATUS_LABEL, VALID_ORDER_TRANSITIONS };
