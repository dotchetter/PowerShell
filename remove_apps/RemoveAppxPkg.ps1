
[array]$ALL_APPS = get-appxpackage -allusers
[array]$REM_APPS = @(

    '*communicationsapps*',
    '*messaging*','*windowsfeedback*',
    '*skype*','*print3d*',
    '*getstarted*','*onedrive*',
    '*windowsmaps*','*xboxidentityprovider*',
    '*mspaint*','*xboxapp*',
    '*bingfinance*','*bingnews*',
    '*bingweather*','*gethelp*',
    '*solitairecollection*','*stickynotes*',
    '*photos*','*oneconnect*',
    '*xboxspeechtotextoverlay*','*xbox.tcui*'
    '*wallet*','*zunemusic*',
    '*storepurchaseapp*','*microsoft3dviewer*',
    '*onenote*','*bingsports*',
    '*officehub*','*zunevideo*'
);

function main() {
<# execute app removal, registry modification and sets reg-value
-to disable onedrive. If the file is run during oobe, next_logon() is 
initiated.
#>
    $reg_path_setup = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\oobe\Stats'
    $reg_path_onedrive = 'HKLM\Software\Policies\Microsoft\Windows\OneDrive'
    $setup_finished = get-itemproperty -Path $reg_path_setup -name 'oobeusersignedin'
    if ($setup_finished) {
        stop('onedrive')
        start-sleep(10)
        reg add $reg_path_onedrive /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f
        gpupdate /wait:10
        remove_apps $ALL_APPS $REM_APPS
    } else {
        next_logon
    }
    if ($error) {
        error_handler($error)
    }
}

function remove_apps($all, $removals) {
<# uninstalls apps in array and removes provisioned packages 
to prevent automatic re-install #>
    foreach ($i in $removals) {
        foreach ($j in $all) {
            if ($j.name -like $i) {
                get-appxpackage -allusers -Name $j.name | remove-appxpackage
                get-appxprovisionedpackage -online | where {$_.packagename -like $j.name} |
                remove-appxprovisionedpackage -online -allusers -packagename $j.name
            }
        }
    }
}


main