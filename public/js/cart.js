// ElectroShop - Cart AJAX

async function updateCartCount() {
  try {
    const res = await fetch('/cart/count');
    const data = await res.json();
    const badges = document.querySelectorAll('.cart-count-badge');
    badges.forEach(b => {
      b.textContent = data.count;
      b.style.display = data.count > 0 ? 'inline' : 'none';
    });
  } catch(e) {}
}

async function addToCart(productId, quantity = 1) {
  try {
    const res = await fetch('/cart/add', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ product_id: productId, quantity })
    });
    const data = await res.json();
    if (data.success) {
      updateCartCount();
      showToast('Đã thêm vào giỏ hàng', 'success');
    } else {
      showToast(data.message || 'Có lỗi xảy ra', 'danger');
    }
  } catch(e) {
    showToast('Có lỗi xảy ra', 'danger');
  }
}

function showToast(message, type = 'success') {
  const container = document.getElementById('toast-container') || createToastContainer();
  const id = 'toast-' + Date.now();
  const html = `
    <div id="${id}" class="toast align-items-center text-white bg-${type} border-0" role="alert">
      <div class="d-flex">
        <div class="toast-body">${message}</div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
      </div>
    </div>`;
  container.insertAdjacentHTML('beforeend', html);
  const toastEl = document.getElementById(id);
  bootstrap.Toast.getOrCreateInstance(toastEl, { delay: 3000 }).show();
  toastEl.addEventListener('hidden.bs.toast', () => toastEl.remove());
}

function createToastContainer() {
  const div = document.createElement('div');
  div.id = 'toast-container';
  div.className = 'toast-container position-fixed bottom-0 end-0 p-3';
  div.style.zIndex = '9999';
  document.body.appendChild(div);
  return div;
}

document.addEventListener('click', async (e) => {
  const btn = e.target.closest('.remove-item');
  if (!btn) return;
  const id = btn.dataset.id;
  try {
    const res = await fetch(`/cart/items/${id}`, { method: 'DELETE' });
    const data = await res.json();
    if (data.success) {
      updateCartCount();
      location.reload();
    } else {
      showToast(data.message || 'Có lỗi xảy ra', 'danger');
    }
  } catch(e) {
    showToast('Có lỗi xảy ra', 'danger');
  }
});
