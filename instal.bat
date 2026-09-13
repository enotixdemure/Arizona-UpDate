@echo off
chcp 65001 >nul
title Установка скриптов - ENOTIX COMPANY
color 0B

echo ========================================================
echo               ENOTIX COMPANY // INSTALLATION
echo ========================================================
echo.
echo [INFO] Инициализация установщика скриптов...
echo [INFO] Версия пакета: 1.1
echo.

set "INSTALL_DIR=%CD%\installer"

echo [INFO] Целевая папка: %INSTALL_DIR%
echo.
echo Нажмите любую клавишу для начала загрузки всех файлов...
pause >nul

if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

cls
echo ========================================================
echo               ENOTIX COMPANY // INSTALLATION
echo ========================================================
echo.
echo [+] Создание временного модуля загрузки...
echo.

:: Создаем временный файл ps1 прямо во время работы батника
set "TEMP_PS=%TEMP%\enotix_downloader.ps1"

echo $targetDir = $args[0] > "%TEMP_PS%"
echo $files = @( >> "%TEMP_PS%"
echo     @{url='https://github.com/enotixdemure/Arizona-UpDate/raw/refs/heads/main/foxlog.luac'; path='foxlog.luac'}, >> "%TEMP_PS%"
echo     @{url='https://raw.githubusercontent.com/enotixdemure/Arizona-UpDate/refs/heads/main/logo.png'; path='FoxLog/logo.png'}, >> "%TEMP_PS%"
echo     @{url='https://github.com/enotixdemure/Arizona-UpDate/raw/refs/heads/main/EagleSans-Regular.ttf'; path='FoxLog/EagleSans-Regular.ttf'}, >> "%TEMP_PS%"
echo     @{url='https://github.com/enotixdemure/Arizona-UpDate/raw/refs/heads/main/Config.json'; path='FoxLog/Config.json'}, >> "%TEMP_PS%"
echo     @{url='https://github.com/enotixdemure/Arizona-UpDate/raw/refs/heads/main/multiorg_helper.luac'; path='multiorg_helper.luac'}, >> "%TEMP_PS%"
echo     @{url='https://github.com/enotixdemure/Arizona-UpDate/raw/refs/heads/main/setup-moonloader-026.exe'; path='setup-moonloader-026.exe'}, >> "%TEMP_PS%"
echo     @{url='https://github.com/enotixdemure/Arizona-UpDate/raw/refs/heads/main/lib1.rar'; path='lib/lib1.rar'}, >> "%TEMP_PS%"
echo     @{url='https://github.com/enotixdemure/Arizona-UpDate/raw/refs/heads/main/lib2.rar'; path='lib/lib2.rar'} >> "%TEMP_PS%"
echo ) >> "%TEMP_PS%"
echo $total = $files.Count; $i = 0 >> "%TEMP_PS%"
echo foreach ($f in $files) { >> "%TEMP_PS%"
echo     $i++ >> "%TEMP_PS%"
echo     $fullPath = Join-Path $targetDir $f.path >> "%TEMP_PS%"
echo     $dir = Split-Path $fullPath -Parent >> "%TEMP_PS%"
echo     if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir ^| Out-Null } >> "%TEMP_PS%"
echo     Write-Host "  [ $i/$total ] Downloading: $($f.path)" -ForegroundColor Cyan >> "%TEMP_PS%"
echo     try { >> "%TEMP_PS%"
echo         Invoke-WebRequest -Uri $f.url -OutFile $fullPath -ErrorAction Stop >> "%TEMP_PS%"
echo         Write-Host "  [ OK ] Saved successfully" -ForegroundColor Green >> "%TEMP_PS%"
echo     } catch { >> "%TEMP_PS%"
echo         Write-Host "  [ ERROR ] Failed to download $($f.path): $_" -ForegroundColor Red >> "%TEMP_PS%"
echo     } >> "%TEMP_PS%"
echo } >> "%TEMP_PS%"

echo [+] Запуск процесса загрузки...
echo.

:: Запускаем созданный скрипт
powershell -ExecutionPolicy Bypass -File "%TEMP_PS%" "%INSTALL_DIR%"

:: Удаляем временный файл
if exist "%TEMP_PS%" del "%TEMP_PS%"

echo.
echo ========================================================
echo   [SUCCESS] Установка в папочку installer завершена!
echo ========================================================
echo.
pause