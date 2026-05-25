const slugify = require('slugify');

function toSlug(text) {
  return slugify(text, { lower: true, strict: true, locale: 'vi' });
}

module.exports = { toSlug };
