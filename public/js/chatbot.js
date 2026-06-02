(() => {
  const toggle = document.getElementById('chatbot-toggle');
  const box = document.getElementById('chatbot-box');
  const iconOpen = document.getElementById('chatbot-icon-open');
  const iconClose = document.getElementById('chatbot-icon-close');
  const closeBtn = document.getElementById('chatbot-close-btn');
  const input = document.getElementById('chatbot-input');
  const sendBtn = document.getElementById('chatbot-send');
  const messages = document.getElementById('chatbot-messages');

  // conversation history for context
  const history = [];

  function openChat() {
    box.classList.add('open');
    iconOpen.style.display = 'none';
    iconClose.style.display = '';
    input.focus();
  }

  function closeChat() {
    box.classList.remove('open');
    iconOpen.style.display = '';
    iconClose.style.display = 'none';
  }

  toggle.addEventListener('click', () => {
    box.classList.contains('open') ? closeChat() : openChat();
  });
  closeBtn.addEventListener('click', closeChat);

  function appendMsg(text, role) {
    const div = document.createElement('div');
    div.className = `chat-msg ${role}`;
    div.innerHTML = text.replace(/\n/g, '<br>');
    messages.appendChild(div);
    messages.scrollTop = messages.scrollHeight;
    return div;
  }

  function setLoading(on) {
    sendBtn.disabled = on;
    input.disabled = on;
  }

  async function sendMessage() {
    const text = input.value.trim();
    if (!text) return;

    input.value = '';
    appendMsg(text, 'user');

    const typing = document.createElement('div');
    typing.className = 'chat-msg typing';
    typing.textContent = 'Huy Đạt đang gõ...';
    messages.appendChild(typing);
    messages.scrollTop = messages.scrollHeight;
    setLoading(true);

    try {
      const res = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: text, history })
      });

      const data = await res.json();
      typing.remove();

      if (data.error) {
        appendMsg('Ối, lỗi rồi bro: ' + data.error, 'bot');
      } else {
        history.push({ role: 'user', text });
        history.push({ role: 'model', text: data.reply });
        // keep last 10 turns to avoid token bloat
        if (history.length > 20) history.splice(0, 2);
        appendMsg(data.reply, 'bot');
      }
    } catch {
      typing.remove();
      appendMsg('Mạng lỗi rồi bro, thử lại đi 😅', 'bot');
    }

    setLoading(false);
    input.focus();
  }

  sendBtn.addEventListener('click', sendMessage);
  input.addEventListener('keydown', e => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  });
})();
