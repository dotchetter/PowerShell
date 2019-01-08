:: Uninstalls NumbR
:: Version 1.0.0
@echo off
:init 
	
	set install_path="%appdata%\NumbR"

:remove_files

	rd /s /q "%appdata%\numbR"
	if /i exist "%userprofile%\desktop\numbR.exe" (
		del /f /q "%userprofile%\desktop\numbR.exe"
	)

:policy

	powershell.exe -windowstyle hidden -command "set-executionpolicy restricted -force; stop-process -name powershell*"

:eof

	exit