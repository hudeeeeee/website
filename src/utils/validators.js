const validateEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
const validatePhone = (phone) => /^[0-9]{10,11}$/.test(phone);
const validatePassword = (pass) => pass && pass.length >= 8;
const validatePositiveInt = (n) => Number.isInteger(Number(n)) && Number(n) > 0;
module.exports = { validateEmail, validatePhone, validatePassword, validatePositiveInt };
