
## Quick start

* Use Win32 Disk Imager to create a USB drive from the .img file in this repository to use
the environment with Jönköping files: HPProBook430G5-JKPG.wim, HPProBookX360-JKPG.wim.

## Modify the project for use with other images

* Use Win32 Disk Imager to create a USB drive from the .img file in this repository.

* Modify automate_dism.ps1 source code
- Rename buttons in the code for the new images you want to deploy.
- Rename the buttons and image files, pointed on line 88 and 114 respectively.

* Compile the project and replace the files
- Compile automate_dism.ps1. I recommend using Ps2Exe.

- Mount the boot.wim file found on one of the partitions of your USB drive that you created on step 1. 

_ Navigate to your mount directory and replace <mountdirpath>\windows\system32\scripts\automate_dism.exe with your new file.

- Test the environment on a lab machine.


## Purpose

This project deploys images onto a windows machine by booting in to a WinPE environment with PowerShell and .Net framework components preloaded, to streamline image deployments of monolithic .wim image files.

If you use this software on computers in production, see these steps below that take place:

* Internal harddrive is completely erased(!) and partitioned for Windows 10 in UEFI by Microsoft's guidelines.

* The image selected is applied using DISM programmatically, and a progressbar is shown.

* Any error occuring will raise a GUI prompt and warn the user / distributor.

* If no error is encountered, the machine will shut off when deployment is complete.