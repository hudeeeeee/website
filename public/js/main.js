// ElectroShop - Main JS

// Auto-dismiss flash after 4s (backup, flash.ejs also handles this)
document.addEventListener('DOMContentLoaded', () => {
  setTimeout(() => {
    document.querySelectorAll('.alert').forEach(el => {
      try { bootstrap.Alert.getOrCreateInstance(el).close(); } catch(e) {}
    });
  }, 4000);

  // Loading state for forms
  document.querySelectorAll('form[data-loading]').forEach(form => {
    form.addEventListener('submit', () => {
      const btn = form.querySelector('[type="submit"]');
      if (btn) {
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...';
      }
    });
  });

  // Confirm before delete
  document.querySelectorAll('[data-confirm]').forEach(el => {
    el.addEventListener('click', (e) => {
      if (!confirm(el.dataset.confirm)) e.preventDefault();
    });
  });
});
