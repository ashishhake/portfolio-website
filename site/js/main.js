document.addEventListener("DOMContentLoaded", () => {
    // Typewriter logic
    const fullName = "Hi, I'm Ashish Hake.";
    const nameEl = document.getElementById("name-text");
    const skipBtn = document.getElementById("skip-btn");
    const heroSection = document.getElementById("about");
    const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    
    let i = 0;
    let typingInterval;
    
    function completeTyping() {
        clearInterval(typingInterval);
        nameEl.textContent = fullName;
        document.body.classList.add("typing-complete");
        skipBtn.style.display = "none";
    }

    if (prefersReducedMotion) {
        completeTyping();
    } else {
        typingInterval = setInterval(() => {
            if (i < fullName.length) {
                nameEl.textContent += fullName.charAt(i);
                i++;
            } else {
                completeTyping();
            }
        }, 100);
    }
    
    skipBtn.addEventListener("click", () => {
        completeTyping();
    });
});