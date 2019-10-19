
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

function stop($process) {
# find out if process process is running and end it
    $status = get-process -name *$process*
    if ($status) {
       $status.kill()
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

function next_logon() {
<# if the script is run during OOBE by MDM downloading the script prior to
the creation of a user profile, this function sets registry values that
will execute the script upon next logon for the user.#>

    $item = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce'
    $command_one = 'powershell.exe -command "set-executionpolicy bypass -force'
    $command_two = 'start-process powershell.exe -windowstyle hidden {C:\temp\awscript\removeappxpkg.ps1}"'
    $value = ($command_one + '; ' + $command_two)
    $name = 'Run Config Script'
    new-item -path "$item" -value "$value" -force
    $error.clear()
}

function error_handler($error) {

    $err_count = $error.count
    $err_string = "$err_count error(s) occured. See verbose log below:"
    $err_string,"`n",$error | out-file -filepath 'C:\temp\awscript\ConfigScript_error.log'
}

main