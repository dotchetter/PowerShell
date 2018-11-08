
# Uninstalls Apps in array and removes provisioned packages to prevent automatic re-install 

[array]$all_apps = Get-AppxPackage | Select Name
[array]$rem_arr = @(

    "*communicationsapps*",
    "*messaging*","*windowsfeedback*",
    "*skype*","*print3d*",
    "*getstarted*","*onedrive*",
    "*windowsmaps*","*xboxidentityprovider*",
    "*mspaint*","*xboxapp*",
    "*bingfinance*","*bingnews*",
    "*bingweather*","*gethelp*",
    "*solitairecollection*","*stickynotes*",
    "*photos*","*oneconnect*",
    "*xboxspeechtotextoverlay*","*xbox.tcui*"
    "*wallet*","*zunemusic*",
    "*storepurchaseapp*","*microsoft3dviewer*",
    "*onenote*","*bingsports*",
    "*officehub*","*zunevideo*"
);

function rmvapp {param($app)
    
    Get-AppxPackage -allusers -name $app | Remove-AppxPackage
    Get-AppxProvisionedPackage -Online | where {$_.packagename -like '$app'} | 
    Remove-AppxProvisionedPackage -Online
}

foreach ($i in $all_apps) {
    foreach ($j in $rem_arr) {if ($i -like $j) {rmvapp($j)}}}