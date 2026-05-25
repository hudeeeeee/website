const express = require('express');
const session = require('express-session');
const flash = require('connect-flash');
const path = require('path');
require('dotenv').config();

const app = express();

// View engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'src/views'));

// Static files
app.use(express.static(path.join(__dirname, 'public')));

// Body parsing
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Session
app.use(session({
  secret: process.env.SESSION_SECRET || 'fallback-secret-change-this',
  resave: false,
  saveUninitialized: false,
  cookie: { maxAge: 7 * 24 * 60 * 60 * 1000 }
}));

// Flash messages
app.use(flash());

// Locals cho tất cả views
const { ORDER_STATUS_LABEL, PAYMENT_STATUS_LABEL } = require('./src/utils/orderStatus');
app.use((req, res, next) => {
  res.locals.user = req.session.user || null;
  res.locals.cartCount = 0;
  res.locals.success = req.flash('success');
  res.locals.error = req.flash('error');
  res.locals.ORDER_STATUS = ORDER_STATUS_LABEL;
  res.locals.PAYMENT_STATUS = PAYMENT_STATUS_LABEL;
  next();
});

// Cart count middleware
const cartService = require('./src/services/cart.service');
app.use(async (req, res, next) => {
  if (req.session.user) {
    try {
      const summary = await cartService.getCartSummary(req.session.user.id);
      res.locals.cartCount = summary.count;
    } catch { res.locals.cartCount = 0; }
  }
  next();
});

// Routes
const routes = require('./src/routes/index.routes');
app.use('/', routes);

// Admin routes
const adminRoutes = require('./src/routes/admin.routes');
app.use('/admin', adminRoutes);

// Error handlers
const { notFound, errorHandler } = require('./src/middlewares/error.middleware');
app.use(notFound);
app.use(errorHandler);

module.exports = app;
