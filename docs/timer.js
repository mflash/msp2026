/**
 * timer.js — Cronômetro regressivo flutuante para Reveal.js
 * Ativado pela tecla 'T' ou por clique no indicador.
 */

function initSlideTimer(minutes) {
  const TOTAL_SECONDS = (parseInt(minutes, 10) || 18) * 60;
  let remainingSeconds = TOTAL_SECONDS;
  let timerInterval = null;
  let isRunning = false;

  // Injeta estilos CSS se ainda não existirem
  if (!document.getElementById('slide-timer-style')) {
    const style = document.createElement('style');
    style.id = 'slide-timer-style';
    style.textContent = `
      .countdown-timer {
        position: fixed;
        top: 14px;
        right: 18px;
        z-index: 9999;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        border-radius: 20px;
        background: rgba(15, 23, 42, 0.9);
        border: 1.5px solid rgba(255, 230, 0, 0.5);
        color: #ffe600;
        font-family: 'Fira Code', monospace;
        font-size: 0.95rem;
        font-weight: 600;
        letter-spacing: 0.04em;
        box-shadow: 0 4px 18px rgba(0, 0, 0, 0.5);
        backdrop-filter: blur(8px);
        user-select: none;
        cursor: pointer;
        pointer-events: auto !important;
        transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
      }

      .countdown-timer:hover {
        border-color: #ffe600;
        transform: scale(1.05);
      }

      .countdown-timer.warning {
        color: #f7941d;
        border-color: #f7941d;
        background: rgba(30, 20, 10, 0.94);
      }

      .countdown-timer.danger {
        color: #ff4d4f;
        border-color: #ff4d4f;
        background: rgba(45, 10, 15, 0.95);
        animation: timer-pulse 1s infinite alternate;
      }

      @keyframes timer-pulse {
        from { transform: scale(1); box-shadow: 0 0 10px rgba(255, 77, 79, 0.4); }
        to { transform: scale(1.06); box-shadow: 0 0 20px rgba(255, 77, 79, 0.85); }
      }
    `;
    document.head.appendChild(style);
  }

  // Remove qualquer timer anterior caso reinicializado
  const existingTimer = document.getElementById('slide-timer');
  if (existingTimer) {
    existingTimer.remove();
  }

  // Cria o elemento visual do timer
  const timerEl = document.createElement('div');
  timerEl.id = 'slide-timer';
  timerEl.className = 'countdown-timer';
  timerEl.title = "Pressione 'T' ou clique para iniciar/pausar o cronômetro";
  timerEl.innerHTML = `
    <span>⏱</span>
    <span id="timer-display"></span>
    <span id="timer-hint" style="font-size: 0.65em; opacity: 0.75; margin-left: 2px;">[T]</span>
  `;

  // Anexa dentro de .reveal se existir, ou no body
  const container = document.querySelector('.reveal') || document.body;
  container.appendChild(timerEl);

  const displayEl = timerEl.querySelector('#timer-display');
  const hintEl = timerEl.querySelector('#timer-hint');

  function formatTime(sec) {
    const m = Math.floor(sec / 60).toString().padStart(2, '0');
    const s = (sec % 60).toString().padStart(2, '0');
    return `${m}:${s}`;
  }

  function updateUI() {
    displayEl.textContent = formatTime(remainingSeconds);

    if (remainingSeconds <= 60) {
      timerEl.classList.remove('warning');
      timerEl.classList.add('danger');
    } else if (remainingSeconds <= 180) {
      timerEl.classList.add('warning');
      timerEl.classList.remove('danger');
    } else {
      timerEl.classList.remove('warning', 'danger');
    }
  }

  function startTimer() {
    if (isRunning) return;
    if (remainingSeconds <= 0) {
      remainingSeconds = TOTAL_SECONDS;
    }
    isRunning = true;
    if (hintEl) hintEl.textContent = '⏸';
    timerInterval = setInterval(() => {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        updateUI();
      } else {
        clearInterval(timerInterval);
        timerInterval = null;
        isRunning = false;
        if (hintEl) hintEl.textContent = '⏹';
      }
    }, 1000);
  }

  function pauseTimer() {
    if (!isRunning) return;
    clearInterval(timerInterval);
    timerInterval = null;
    isRunning = false;
    if (hintEl) hintEl.textContent = '[T]';
  }

  function toggleTimer() {
    if (isRunning) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  // Interação via clique com o mouse
  timerEl.addEventListener('click', (e) => {
    e.stopPropagation();
    toggleTimer();
  });

  // Listener nativo do Reveal.js (se disponível)
  if (window.Reveal && typeof window.Reveal.addKeyBinding === 'function') {
    window.Reveal.addKeyBinding(
      { keyCode: 84, key: 'T', description: 'Iniciar/Pausar cronômetro' },
      toggleTimer
    );
  }

  // Listener global em modo captura (evita bloqueio por outros manipuladores)
  window.addEventListener(
    'keydown',
    (e) => {
      if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
      if (e.key === 't' || e.key === 'T' || e.code === 'KeyT' || e.keyCode === 84) {
        e.preventDefault();
        e.stopPropagation();
        toggleTimer();
      }
    },
    true
  );

  updateUI();
}
