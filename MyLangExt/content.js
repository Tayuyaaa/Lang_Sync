document.addEventListener('keyup', (e) => {
    if (e.key.match(/[а-яА-ЯіїєґІЇЄҐ]/)) {
        chrome.runtime.sendMessage({ lang: 'UKR' });
    } else if (e.key.match(/[a-zA-Z]/)) {
        chrome.runtime.sendMessage({ lang: 'ENG' });
    }
});