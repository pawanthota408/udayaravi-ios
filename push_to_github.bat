@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo   Pushing UdayaRavi iOS Application to GitHub
echo ========================================================

cd /d "%~dp0"

set "REPO_NAME=udayaravi-ios"
set /p GH_USER="Enter your GitHub Username: "

if "%GH_USER%"=="" (
    echo [ERROR] GitHub username cannot be empty!
    pause
    exit /b 1
)

set "REMOTE_URL=https://github.com/%GH_USER%/%REPO_NAME%.git"

echo.
echo Adding remote: %REMOTE_URL%
git remote remove origin 2>nul
git remote add origin %REMOTE_URL%
git branch -M main

echo.
echo Pushing to GitHub... (A browser window or Git credential manager may open to sign in)
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   SUCCESS! Pushed to https://github.com/%GH_USER%/%REPO_NAME%
    echo   GitHub Actions will now automatically build your .ipa!
    echo ========================================================
) else (
    echo.
    echo [NOTE] If the repository does not exist yet on GitHub:
    echo 1. Go to https://github.com/new
    echo 2. Set repository name to: %REPO_NAME%
    echo 3. Keep it Public or Private (do NOT check Initialize with README)
    echo 4. Click 'Create repository' and run this script again!
)

pause

