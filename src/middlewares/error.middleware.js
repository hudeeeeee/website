function notFound(req, res) {
  res.status(404).render('errors/404', { title: 'Trang không tìm thấy' });
}

function errorHandler(err, req, res, next) {
  console.error(err.stack);
  const status = err.status || 500;
  if (process.env.NODE_ENV === 'production') {
    res.status(status).render('errors/500', { title: 'Lỗi hệ thống' });
  } else {
    res.status(status).json({ error: err.message, stack: err.stack });
  }
}

module.exports = { notFound, errorHandler };
