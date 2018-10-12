# 2018 Simon Olofsson
# Uninstalls Apps in array 

[array]$app_arr = @(
    "*Wallet*","*zunemusic*","*zunevideo*",
    "*onenote*","*bingsports*","*microsoftofficehub*",
    "*bingfinance*","*bingnews*","*bingweather*",
    "*gethelp*","*microsoftsolitairecollection*",
    "*storepurchasedapp*","*microsoft3dviewer*",
    "*xboxspeechtotextoverlay*","*xbox.tcui*",
    "*skypeapp*","*print3d*","*getstarted*",
    "*windowsmaps*","*xboxidentityprovider*",
    "*stickynotes*","*messaging*","*windowsfeedbackhub*"
);

foreach ($i in $app_arr) {
    Get-AppxPackage -allusers -name $i | Remove-AppxPackage
    Get-AppxProvisionedPackage -Online | where {$_.packagename -like $i} | 
    Remove-AppxProvisionedPackage -Online
}