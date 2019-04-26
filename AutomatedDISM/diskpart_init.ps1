# Softare purpose: Bootable image deployment environment for Jönköping Kommun

<# 
$author = 'Simon Olofsson'
2019-02-25 Advania Sverige AB
This source code is not for public use. Any attempts to modify,
reverse-engineer or otherwise tamper with this software is strictly
prohibited. 
#>

start-process "diskpart" -windowstyle hidden -argumentlist "/s X:\Windows\System32\scripts\Windows10.txt" 