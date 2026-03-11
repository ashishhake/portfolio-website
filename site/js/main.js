function toggleCard(card) {
  const isExpanded = card.classList.contains('expanded');
  document.querySelectorAll('.project-card.expanded').forEach(c => c.classList.remove('expanded'));
  if (!isExpanded) card.classList.add('expanded');
}

function filterPhase(phase) {
  document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
  event.target.classList.add('active');

  document.querySelectorAll('.project-card').forEach(card => {
    if (phase === 'all' || card.dataset.phase === phase) {
      card.classList.remove('hidden');
    } else {
      card.classList.add('hidden');
    }
  });
}

// Animate skill bars on load
window.addEventListener('load', () => {
  setTimeout(() => {
    document.querySelectorAll('.progress-bar-fill').forEach(bar => {
      bar.style.width = bar.dataset.width + '%';
    });
  }, 500);
});

// Stagger card animations
document.querySelectorAll('.project-card').forEach((card, i) => {
  card.style.animationDelay = (i * 0.08) + 's';
});