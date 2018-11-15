
[int]$counter = 0
[array]$ALL_APPS = Get-AppxPackage | Select Name
[array]$REGVALUES = @(

    'HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}',
    'HKEY_CLASSES_ROOT\WOW6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}'
);
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


# find out if process process is running, return boolean
function alive {param($process)

    $status = get-process | where {$_.name -like '$process'}
    if ($status) {
        $its_alive = $true
    }
    else {
        $its_alive = $false
    }
    return $its_alive
}


# uninstalls Apps in array and removes provisioned packages to prevent automatic re-install 
function remove_app {param($app)
    
    get-appxpackage -allusers -name $app | Remove-AppxPackage
    get-appxprovisionedpackage -Online | where {$_.packagename -like '$app'} | 
    remove-appxprovisionedpackage -Online
}


# modify registry
function regmod {param($values)

    foreach ($value in $values) {
        reg delete $value /v System.IsPinnedToNameSpaceTree /f
        gpupdate /force
        start-sleep(3)
        reg add $value /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f
    }
}


# main
function main {

    if ($env:username -ne 'defaultuser0') {
        $is_alive = alive('onedrive')
        if ($is_alive -eq $true) {
            get-process | where {$_.name -like 'onedrive'} | stop-process
        }
        regmod($REGVALUES)
        foreach ($i in $ALL_APPS) {
            foreach ($j in $REM_ARR) {if ($i -like $j) {remove_app($j)}
            }
        }
    }
    else {
        $item = "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
        $value = "C:\temp\awscript\removeappxpkg.ps1"
        new-item -path $item -value $value -force
        exit
    }
}

main
if ($Error) {$Error | out-file $env:systemdrive\temp\awscript\error.log}