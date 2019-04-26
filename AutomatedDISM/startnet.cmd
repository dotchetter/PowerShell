@echo off
:init
	powershell.exe -windowstyle hidden -command "set-executionpolicy unrestricted -force"
	"x:\windows\system32\scripts\automate_dism.exe"