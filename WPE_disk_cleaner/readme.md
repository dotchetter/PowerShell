
## Purpose

This file is designed to run in winpe / winfe. It serves a simple purpose:
Enable non-technical users to boot from a USB device and clean the harddrive of a system. 
* Disclaimer * 
This software passes commands to built-in DISKPART sofware in Microsoft® Windows.
Currently, the command CLEAN is used to empty the internal drive 0 from all data including
recovery partition(s), including efi partition or system partition as well as operating system partition. 
Although data is deleted, the drive is NOT cleaned for secure data loss. This tool quickly erases the drive.
For a more recursive and secure deletion of data on the drive, consider changing the command in diskpart.dat from
'clean' to 'clean all'.

## Use case
Any one scenario where many computers need to get completely wiped quikly and easily.
No recovery partition(s) or OS partitions are present after cleaning the drive.

Please note that all buttons and prompts are written in Swedish and the file should be saved with WIN1252 for proper non-ASCII character display
unless rewritten to English.

## How to use
* Clone repository
* Create a Winpe / Winfe usb drive with powershell added:
  https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-adding-powershell-support-to-windows-pe

* Mount the 'boot.wim' file on the USB drive created. 

	(PS): md -f c:\mount
	
	(PS): dism /mount-image /imagefile:DRIVELETTER:\sources\boot.wim /index:1 /mountdir:C:\mount

* Navigate to C:\mount\windows\system32 and create folder "script"
* Copy the repository to C:\mount\windows\system32\script
* Load custom picture to render in the form (line 23) to the same directory and rename it appropriately, or change file path in line 23. 
* Commit the changes to the .wim and unmount
	(PS): dism /unmount-image /mountdir:C:\mount /commit

* Start the machine to wipe from the USB drive
 

## TODO:

* Evalate internal drive number successfully and pass to disk cleaning function
* Refactoring
* English version
