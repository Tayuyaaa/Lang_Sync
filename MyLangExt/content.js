document.addEventListener('keyup', (e) => {
    // Відсікаємо всі службові клавіші (Backspace, Enter, Shift тощо),
    // пропускаючи лише одиничні символи.
    if (e.key.length === 1) {
        if (e.key.match(/[а-яА-ЯіїєґІЇЄҐ]/)) {
            chrome.runtime.sendMessage({ lang: 'UKR' });
        } else if (e.key.match(/[a-zA-Z]/)) {
            chrome.runtime.sendMessage({ lang: 'ENG' });
        }
    }
});
