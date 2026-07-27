@echo off
echo ============================================
echo   SecureShield Build
echo ============================================
echo.

set "CMAKE=C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"

echo [1/2] Configuring...
"%CMAKE%" -B build -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release -DSECURESHIELD_BUILD_GUI=ON -DCMAKE_PREFIX_PATH="C:/Qt/6.8.0/msvc2022_64"
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] Configure failed!
    pause
    exit /b 1
)

echo.
echo [2/2] Building...
"%CMAKE%" --build build --config Release
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] Build failed!
    pause
    exit /b 1
)

echo.
echo ============================================
echo   Deploying Qt DLLs + OpenSSL...
echo ============================================
"C:\Qt\6.8.0\msvc2022_64\bin\windeployqt.exe" --no-translations "build\bin\Release\SecureShield.exe" 2>nul

copy /Y "C:\Program Files\OpenSSL-Win64\bin\libcrypto-4-x64.dll" "build\bin\Release\" >nul
copy /Y "C:\Program Files\OpenSSL-Win64\bin\libssl-4-x64.dll" "build\bin\Release\" >nul

echo.
echo ============================================
echo   Build succeeded!
echo   exe: build\bin\Release\SecureShield.exe
echo ============================================
echo.
pause
