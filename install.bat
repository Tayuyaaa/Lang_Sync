@echo off
chcp 65001 >nul
color 0A

echo =======================================================================
echo         АВТОМАТИЧНА ПАМ'ЯТЬ МОВИ ДЛЯ ВКЛАДОК БРАУЗЕРА
echo =======================================================================
echo Привіт! Цей скрипт налаштує перемикання мови зі швидкістю 1 мілісекунди.
echo Все працюватиме нативно і без фонових процесів.
echo.
echo ЩОБ ПОЧАТИ, ЗРОБИ 4 ПРОСТІ КРОКИ:
echo -----------------------------------------------------------------------
echo  1. Відкрий браузер і встав у адресний рядок: chrome://extensions/
echo  2. У правому верхньому куті увімкни "Режим розробника" (Developer mode).
echo  3. Натисни "Завантажити розпаковане" (Load unpacked) зліва зверху.
echo  4. Вибери папку "MyLangExt", яка лежить поруч із цим файлом.
echo.
echo Після цього браузер додасть розширення і покаже його ІДЕНТИФІКАТОР (ID).
echo Це довгий набір літер, наприклад: ghemmnokookabdajelnefjpdnjnlckdd
echo Скопіюй його!
echo -----------------------------------------------------------------------
echo.

set /p EXT_ID="Встав сюди скопійований ID (права кнопка миші) і натисни Enter: "

echo.
echo Працюю... Створюю мікро-програму для перемикання...

set "DIR=%~dp0"
set "JSON_DIR=%DIR:\=\\%"

:: 1. Створюємо вихідний код на C#
echo using System; using System.IO; using System.Runtime.InteropServices; using System.Text; class Program { [DllImport("user32.dll")] static extern IntPtr GetForegroundWindow(); [DllImport("user32.dll")] static extern bool PostMessage(IntPtr hWnd, uint Msg, int wParam, int lParam); static void Main() { Stream stdin = Console.OpenStandardInput(); byte[] lengthBytes = new byte[4]; if (stdin.Read(lengthBytes, 0, 4) == 4) { int length = BitConverter.ToInt32(lengthBytes, 0); byte[] buffer = new byte[length]; stdin.Read(buffer, 0, length); string msg = Encoding.UTF8.GetString(buffer); IntPtr hwnd = GetForegroundWindow(); if (msg.Contains("UKR")) { PostMessage(hwnd, 0x0050, 0, 0x0422); } else if (msg.Contains("ENG")) { PostMessage(hwnd, 0x0050, 0, 0x0409); } } } } > "%DIR%bridge.cs"

:: 2. Знаходимо вбудований компілятор Windows
set "CSC=%windir%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if not exist "%CSC%" set "CSC=%windir%\Microsoft.NET\Framework\v4.0.30319\csc.exe"

:: 3. Компілюємо мікро-exe і видаляємо вихідний код
"%CSC%" /nologo /out:"%DIR%bridge.exe" "%DIR%bridge.cs" >nul
del "%DIR%bridge.cs"

:: 4. Генеруємо host.json
echo { > "%DIR%host.json"
echo   "name": "com.rybka.lang.switcher", >> "%DIR%host.json"
echo   "description": "Native Messaging Host", >> "%DIR%host.json"
echo   "path": "%JSON_DIR%bridge.exe", >> "%DIR%host.json"
echo   "type": "stdio", >> "%DIR%host.json"
echo   "allowed_origins": [ >> "%DIR%host.json"
echo     "chrome-extension://%EXT_ID%/" >> "%DIR%host.json"
echo   ] >> "%DIR%host.json"
echo } >> "%DIR%host.json"

:: 5. Прописуємо в реєстр (тихо)
REG ADD "HKCU\Software\Google\Chrome\NativeMessagingHosts\com.rybka.lang.switcher" /ve /t REG_SZ /d "%DIR%host.json" /f >nul

echo.
echo =======================================================================
echo ГОТОВО! Зв'язок налаштовано, файли створено.
echo.
echo ФІНАЛЬНИЙ ШТРИХ:
echo ПЕРЕЗАПУСТИ БРАУЗЕР (закрий всі вікна і відкрий знову)!
echo Після цього можеш перемикати вкладки, мова буде запам'ятовуватися.
echo =======================================================================
echo Натисни будь-яку клавішу, щоб закрити це вікно...
pause >nul