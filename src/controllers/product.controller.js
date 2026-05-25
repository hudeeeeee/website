const productService = require('../services/product.service');

const getHome = async (req, res) => {
  const featured = await productService.getFeaturedProducts();
  const categories = await productService.getAllCategories();
  res.render('pages/home', { title: 'ElectroShop - Đồ Điện Tử Chính Hãng', ...featured, categories });
};

const getProducts = async (req, res) => {
  const { keyword, category, brand, minPrice, maxPrice, onSale, inStock, sort, page } = req.query;
  const { products, pagination } = await productService.getProducts({
    keyword, category, brand, minPrice, maxPrice, onSale, inStock, sort, page: parseInt(page) || 1
  });
  const categories = await productService.getAllCategories();
  const brands = await productService.getAllBrands();

  res.render('pages/products/index', {
    title: keyword ? `Kết quả: "${keyword}"` : 'Tất cả sản phẩm',
    products, pagination, categories, brands, filters: req.query
  });
};

const getProductDetail = async (req, res) => {
  const product = await productService.getProductBySlug(req.params.slug);
  if (!product) return res.status(404).render('errors/404', { title: 'Sản phẩm không tìm thấy' });
  res.render('pages/products/detail', { title: product.name, product });
};

const getByCategory = async (req, res) => {
  const categories = await productService.getAllCategories();
  const cat = categories.find(c => c.slug === req.params.slug);
  if (!cat) return res.status(404).render('errors/404', { title: 'Danh mục không tìm thấy' });

  const { products, pagination } = await productService.getProducts({
    category: req.params.slug, ...req.query, page: parseInt(req.query.page) || 1
  });
  const brands = await productService.getAllBrands();

  res.render('pages/products/index', {
    title: cat.name,
    products, pagination, categories, brands,
    filters: { ...req.query, category: req.params.slug },
    currentCategory: cat
  });
};

module.exports = { getHome, getProducts, getProductDetail, getByCategory };
