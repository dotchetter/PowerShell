
# Uninstalls Apps in array and removes provisioned packages to prevent automatic re-install 

[array]$all_apps = Get-AppxPackage | Select Name
[array]$rem_arr = @(

    "*skype*","*print3d*",
    "*getstarted*","*onedrive*",
    "*mspaint*","*xboxapp*",
    "*bingfinance*","*bingnews*",
    "*bingweather*","*gethelp*",
    "*messaging*","*windowsfeedback*",
    "*photos*","*oneconnect*",
    "*people*","*communicationsapps*",
    "*holographicfirstrun*",
    "*wallet*","*zunemusic*",
    "*onenote*","*bingsports*",
    "*officehub*","*zunevideo*",
    "*solitairecollection*","*stickynotes*",
    "*storepurchaseapp*","*microsoft3dviewer*",
    "*windowsmaps*","*xboxidentityprovider*",
    "*xboxspeechtotextoverlay*","*xbox.tcui*"
);

function rmvapp {param($app)
    
    Get-AppxPackage -allusers -name $app | Remove-AppxPackage
    Get-AppxProvisionedPackage -Online | where {$_.packagename -like '$app'} | 
    Remove-AppxProvisionedPackage -Online
}

foreach ($i in $all_apps) {
    foreach ($j in $rem_arr) {if ($i -like $j) {rmvapp($j)}}}