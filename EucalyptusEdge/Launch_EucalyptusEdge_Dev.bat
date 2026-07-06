@echo off
title Eucalyptus Edge - Dev Launcher
echo.
echo  =============================================
echo   EUCALYPTUS EDGE - Nature Fights Back!
echo   Launching UE 5.8 with MCP on port 8765...
echo  =============================================
echo.

rem Warn if an editor is already running (its MCP port can't be changed after launch)
tasklist /FI "IMAGENAME eq UnrealEditor.exe" 2>nul | find /I "UnrealEditor.exe" >nul
if not errorlevel 1 (
    echo  WARNING: An Unreal Editor instance is already running.
    echo  Close it first if it was not started by this launcher,
    echo  otherwise MCP will not be available on port 8765.
    echo.
    pause
)

start "" "E:\UE_5.8\Engine\Binaries\Win64\UnrealEditor.exe" "%~dp0EucalyptusEdge.uproject" -ModelContextProtocolPort=8765
