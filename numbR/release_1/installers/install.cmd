:: Creates folder structure and copies files to install NumbR. 
:: Version 1.0.0
@echo off
:init 
	
	set install_path="%appdata%\NumbR"
	set meta_path=%install_path%\meta 

	if /i not exist %install_path% (
		md %install_path%
		md %meta_path%
	)	

:copy_files

	xcopy /s /e /h /k /y * %install_path%
	move /y bg_b.png %meta_path%
	move /y bg_w.png %meta_path%
	move /y numbr.ico %meta_path%
	move /y %install_path%\NumbR.exe "%userprofile%\desktop"

:policy

	powershell.exe -windowstyle hidden -command "set-executionpolicy remotesigned -force; stop-process powershell*"

:eof

	exit