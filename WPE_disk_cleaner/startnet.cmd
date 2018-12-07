@echo off
:init
	powershell.exe -windowstyle hidden -command "set-executionpolicy unrestricted -force"
	powershell.exe -file "x:\windows\system32\script\ondisk_wpe_disk_clean.ps1"
