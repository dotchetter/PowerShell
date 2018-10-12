
# Uninstalls Apps in array and removes provisioned packages to prevent automatic re-install 

[array]$all_apps = Get-AppxPackage | Select Name
[array]$rem_arr = @(

    "*wallet*","*zunemusic*","*zunevideo*",
    "*onenote*","*bingsports*","*officehub*",
    "*bingfinance*","*bingnews*","*bingweather*",
    "*gethelp*","*solitairecollection*",
    "*storepurchaseapp*","*microsoft3dviewer*",
    "*xboxspeechtotextoverlay*","*xbox.tcui*",
    "*skype*","*print3d*","*getstarted*",
    "*windowsmaps*","*xboxidentityprovider*",
    "*stickynotes*","*messaging*","*windowsfeedback*"
);

function rmvapp {param($app)
    
    Get-AppxPackage -allusers -name $app | Remove-AppxPackage
    Get-AppxProvisionedPackage -Online | where {$_.packagename -like '$app'} | 
    Remove-AppxProvisionedPackage -Online
}

foreach ($i in $all_apps) {
    foreach ($j in $rem_arr) {if ($i -like $j) {rmvapp($j)}}}
