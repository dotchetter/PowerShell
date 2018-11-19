
[array]$ALL_APPS = get-appxpackage | select name
[array]$REM_ARR = @(

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


# find out if process process is running and end it
function stop($process){

    $status = get-process | where {$_.name -like $process}
    if ($status) {
        get-process | where {$_.name -like $process} | stop-process
    }
}


# uninstalls Apps in array and removes provisioned packages to prevent automatic re-install 
function remove_app($app){
    
    get-appxpackage -allusers -name $app | remove-appxpackage
    get-appxprovisionedpackage -Online | where {$_.packagename -like $app} | 
    remove-appxprovisionedpackage -Online
}


# execute app removal, registry modification and sets reg-value
# -to disable onedrive if the file is run after oobe.
function main(){

    $reg_path_setup = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\oobe\Stats'
    $reg_path_onedrive = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive'

    $setup_finished = get-itemproperty -Path $reg_path_setup -name 'oobeusersignedin'
    if ($setup_finished){
        stop('onedrive*')
        start-sleep(10)
        reg add $reg_path_onedrive /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f
        gpupdate /wait:30
        foreach ($i in $ALL_APPS) {
            foreach ($j in $REM_ARR) {if ($i -like $j) {remove_app($j)}
            }
        }
    }
    else {
        $item = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
        $command_one = 'powershell.exe -command set-executionpolicy bypass -force'
        $command_two = 'start-process powershell.exe -windowstyle hidden {C:\temp\awscript\removeappxpkg.ps1}'
        $value = ($command_one + '; ' + $command_two)
        new-item -path $item -value $value -force
        if ($Error) {
            $Error | out-file $env:systemdrive\temp\awscript\ConfigScript_error.log
        }
    }
}

main