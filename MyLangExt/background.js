const hostName = "com.rybka.lang.switcher";
let debounceTimer = null;

// Зберігаємо мову в постійну пам'ять Хрому
chrome.runtime.onMessage.addListener((msg, sender) => {
    if (msg.lang && sender.tab) {
        let key = 'tab_' + sender.tab.id;
        chrome.storage.local.set({ [key]: msg.lang });
    }
});

// Розумна функція перемикання із ЗАПОБІЖНИКОМ
function switchLanguage(tabId) {
    clearTimeout(debounceTimer); // Вбиваємо попередній наказ, якщо ти швидко клацнув далі
    
    // Чекаємо 100 мілісекунд, щоб Вінда точно зафіксувала нове вікно як активне
    debounceTimer = setTimeout(() => {
        let key = 'tab_' + tabId;
        chrome.storage.local.get([key], (result) => {
            let lang = result[key];
            if (lang) {
                chrome.runtime.sendNativeMessage(hostName, { text: lang });
            }
        });
    }, 100); 
}

// Слухаємо перемикання ВКЛАДОК
chrome.tabs.onActivated.addListener(activeInfo => {
    switchLanguage(activeInfo.tabId);
});

// Слухаємо перемикання ВІКОН Хрому
chrome.windows.onFocusChanged.addListener(windowId => {
    if (windowId !== chrome.windows.WINDOW_ID_NONE) {
        chrome.tabs.query({ active: true, windowId: windowId }, tabs => {
            if (tabs.length > 0) {
                switchLanguage(tabs[0].id);
            }
        });
    }
});

// Очищаємо базу від сміття при закритті вкладки
chrome.tabs.onRemoved.addListener(tabId => {
    let key = 'tab_' + tabId;
    chrome.storage.local.remove(key);
});
