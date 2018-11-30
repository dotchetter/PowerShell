
# ## Description:
#   Installs ATK and SmartGesture on desktop client. 
# 
# ## abbreviations:
#   ATK = dependency
#   Smartgesture = Trackpad Driver

function install_atk {

    start-process msiexec.exe -wait -windowstyle hidden -argumentlist "/i .\409.msi /qn /norestart" 
    if ($error) {
        return 'error'
    }
}

function install_smartgesture {

    $asus_d3f = '.\Asus_D3F.exe'
    $pkg_to_uninstall = '{938CFBD4-0652-49E5-BB8B-153948865941}'
    $query = "select osarchitecture from win32_operatingsystem"
    $move_files_path_64 = "${env:programfiles(x86)}\ASUS\Asus Smart Gesture\AsTPCenter"
    $move_files_path_32 = "${env:programfiles}\ASUS\Asus Smart Gesture\AsTPCenter"
    $folder_to_move = '.\update' 
    $msiexec_argument = "/x $pkg_to_uninstall /qn /norestart"
    $bitness = (get-wmiobject -computername $env:computername -query $query).osarchitecture.split('-bit')[0]

    start-process msiexec.exe -wait -windowstyle hidden -argumentlist $msiexec_argument
    start-process $asus_d3f -wait -windowstyle hidden

    if ($bitness -eq '64') {
        $dest_path = $move_files_path_64
    } elseif ($bitness -eq '32') {
        $dest_path = $move_files_path_32
    }
    
    move-item $folder_to_move -destination $dest_path

    if ($error) {
        return 'error'
    }
}

function main {

    $atk_install = install_atk
    $smart_gesture_install = install_smartgesture
    if ($atk_install -or $smart_gesture_install -eq 'error') {
        $err_count = $error.count
        $err_string = "$err_count errors occured. See verbose log below: `n`n"
        $err_string,"`n",$error | out-file -debug -filepath '.\SmartGesture_install_error.log'
    }
}
main