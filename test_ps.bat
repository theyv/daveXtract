@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo Testing PowerShell command...
echo.

:: Test 1: Direct key read (no timeout)
echo Test 1: Direct key read
powershell -NoLogo -NoProfile -Command "$k=[Console]::ReadKey($true); Write-Host 'Key:' $k.Key 'Modifiers:' $k.Modifiers"
echo.

:: Test 2: Timeout with no key (should exit 40)
echo Test 2: Timeout with no key (2.5s timeout)
powershell -NoLogo -NoProfile -Command "$limit=2500; $sw=[System.Diagnostics.Stopwatch]::StartNew(); while($sw.ElapsedMilliseconds -lt $limit) { if([Console]::KeyAvailable) { $k=[Console]::ReadKey($true); if($k.Key -eq 'Enter' -and $k.Modifiers -eq 'Shift'){exit 15} elseif($k.Key -eq 'Enter'){exit 10} elseif($k.Key -eq 'Delete'){exit 20} else {exit 30} } }; exit 40"
echo Exit code (timeout): %errorlevel%
echo.

pause
