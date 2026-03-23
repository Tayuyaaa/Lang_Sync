const hostName = "com.rybka.lang.switcher";

// Зберігаємо мову в постійну пам'ять Хрому (замість змінної)
chrome.runtime.onMessage.addListener((msg, sender) => {
    if (msg.lang && sender.tab) {
        let key = 'tab_' + sender.tab.id;
        chrome.storage.local.set({ [key]: msg.lang });
    }
});

// Перемикаємо мову, витягуючи дані з бази
chrome.tabs.onActivated.addListener(activeInfo => {
    let key = 'tab_' + activeInfo.tabId;
    chrome.storage.local.get([key], (result) => {
        let lang = result[key];
        if (lang) {
            chrome.runtime.sendNativeMessage(hostName, { text: lang });
        }
    });
});

// Очищаємо базу від сміття, коли вкладка закривається
chrome.tabs.onRemoved.addListener(tabId => {
    let key = 'tab_' + tabId;
    chrome.storage.local.remove(key);
});