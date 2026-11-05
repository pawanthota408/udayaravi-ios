@echo off
title Push Udayaravi iOS to GitHub
cd /d "%~dp0"

echo ========================================================
echo   Pushing All iOS Files to pawanthota408/udayaravi-ios
echo ========================================================
echo Remote URL: https://github.com/pawanthota408/udayaravi-ios.git
echo Branch:     main
echo.

git branch -M main
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   SUCCESS! All files uploaded to:
    echo   https://github.com/pawanthota408/udayaravi-ios
    echo.
    echo   GitHub Actions will now build your .ipa automatically!
    echo ========================================================
) else (
    echo.
    echo [ERROR] Push failed. If prompted, please complete sign-in in the browser.
)

pause

