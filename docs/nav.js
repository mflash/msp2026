/**
 * nav.js — Botão flutuante de retorno ao material base para Reveal.js
 * Deduz a página de destino pelo nome do arquivo de slides:
 *   slides_introducao.html -> index.html
 *   slides_NN_tema.html    -> NN_tema.html
 */

(function initSlideNav() {
  // Não exibe o botão na exportação para PDF
  if (/print-pdf/.test(window.location.search)) return;

  const file = window.location.pathname.split('/').pop() || '';
  const match = file.match(/^slides_(\d{2}_.+\.html)$/);
  const target = match ? match[1] : 'index.html';
  const label = match ? 'Material do módulo' : 'Material do curso';

  if (!document.getElementById('slide-nav-style')) {
    const style = document.createElement('style');
    style.id = 'slide-nav-style';
    style.textContent = `
      .slide-nav-back {
        position: fixed;
        top: 14px;
        left: 18px;
        z-index: 9999;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        border-radius: 20px;
        background: rgba(15, 23, 42, 0.9);
        border: 1.5px solid rgba(255, 230, 0, 0.5);
        color: #ffe600;
        font-family: 'Inter', system-ui, sans-serif;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        opacity: 0.75;
        transition: opacity 0.2s ease, border-color 0.2s ease;
      }
      .slide-nav-back:hover,
      .slide-nav-back:focus-visible {
        opacity: 1;
        border-color: #ffe600;
      }
    `;
    document.head.appendChild(style);
  }

  const link = document.createElement('a');
  link.className = 'slide-nav-back';
  link.href = target;
  link.title = 'Voltar ao material base';
  link.textContent = '📖 ' + label;
  document.body.appendChild(link);
})();
