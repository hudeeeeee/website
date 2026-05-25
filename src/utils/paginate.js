function paginate(totalItems, currentPage, pageSize = 12) {
  const totalPages = Math.ceil(totalItems / pageSize);
  const page = Math.max(1, Math.min(currentPage, totalPages));
  return {
    page,
    pageSize,
    totalItems,
    totalPages,
    offset: (page - 1) * pageSize,
    hasNext: page < totalPages,
    hasPrev: page > 1
  };
}
module.exports = { paginate };
