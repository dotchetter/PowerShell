<#
* Description:
  Installs ATK and SmartGesture on desktop client. 

* abbreviations:
  ATK = dependency
  Smartgesture = Trackpad Driver
#>

function main {

    $timeout = $null
    $download_complete = $false
    while ($download_complete -eq $false) {
        $download_complete = get_payload
        $timeout += 1
        if ($timeout -ge 120) {
            throw('The wait for payload driver software timed out and failed (10 minutes)')
            error_handler($error)
            exit
        }
    }

    $install_path = get_install_path
    $atk_install_success = install_atk
    $smartgesture_success = install_smartgesture($install_path)
    if ($atk_install_success -or $smartgesture_success -eq 'error') {
        error_handler($error)
    }
}

function get_payload {
<# checks to see if all dependency files are fnished downloading 
    from MDM in current directory #>
    start-sleep(5)
    $evaluate = test-path "C:\temp\awscript\gs\SETUP.CAB", 
            "C:\temp\awscript\gs\setup.exe", 
            "C:\temp\awscript\gs\SetupTPDriver.msi", 
            "C:\temp\awscript\gs\D3F.exe",
            "C:\temp\awscript\gs\409.msi",
            "C:\temp\awscript\gs\update"
    
    if ($false -in $evaluate) {
        return $false
    } else {
        return $true
    }
}

function get_install_path {
# fetch OS bitness and return correct installation path

   $move_files_path_64 = "${env:programfiles(x86)}\ASUS\Asus Smart Gesture\AsTPCenter"
   $move_files_path_32 = "${env:programfiles}\ASUS\Asus Smart Gesture\AsTPCenter"
   $query = "select osarchitecture from win32_operatingsystem"
   $bitness = (get-wmiobject -computername $env:computername -query $query).osarchitecture.split('-bit')[0]
    if ($bitness -like '*64*') {
        $path = $move_files_path_64
    } elseif ($bitness -like '*32*') {
        $path = $move_files_path_32
    }
    return $path
}

function install_atk {
    
    start-process "msiexec.exe" -argumentlist "/i C:\temp\awscript\gs\409.msi /qn /norestart" -Wait
    if ($error) {
        return 'error'
    }
}

function install_smartgesture($install_path) {

    start-process "msiexec.exe" -argumentlist "/x {938CFBD4-0652-49E5-BB8B-153948865941} /qn /norestart"
    start-process "msiexec.exe" -argumentlist "/i C:\temp\awscript\gs\SetupTPDriver.msi /qn /norestart"
    start-process "C:\temp\awscript\gs\D3F.exe"
    md $install_path -Force
    copy-item '.\update' -Force -destination "$install_path"
    if ($error) {
        return 'error'
    }
}

function error_handler($error) {

    $err_count = $error.count
    $err_string = "$err_count errors occured. See verbose log below:"
    $err_string,"`n",$error | out-file -filepath 'C:\temp\awscript\gs\TpadDriver_install_error.log'
}
main