# Developed for Advania Sverige AB by Simon Olofsson
# Main module file for application "NumbR"
# module purpose: main


# Load framework and GUI dependencies
[void][system.reflection.assembly]::loadwithpartialname("system.windows.forms") 
[void][system.reflection.assembly]::loadwithpartialname("system.drawing") 
[system.windows.forms.application]::enablevisualstyles();
add-type -assemblyname presentationcore,presentationframework
add-type -name window -namespace console -memberdefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'

$install_path = "$env:userprofile\git\powershell\NumbR"
$icon = "$install_path\meta\numbr.ico"



# Import modules
. ($psscriptroot + "\lp_gui.ps1")
. ($psscriptroot + "\rp_gui.ps1")
. ($psscriptroot + "\logic.ps1")
. ($psscriptroot + "\event_listnrs.ps1")
. ($psscriptroot + "\event_handlrs.ps1")



# Initialize variables
$json = get-content "$env:userprofile\git\powershell\NumbR\data.json" | convertfrom-json

$global_vars = @(
    
    $global:labour,
    $global:shipping,
    $global:upper_limit,
    $global:lower_limit,
    $global:upper_multiplicand,
    $global:lower_multiplicand
)

$dark_mode_shifters = @(
    
    $darkmode_panel, $state_panel, $net_sum_box, 
    $rounding_panel, $darkmode_panel, $state_panel,
    $input_box, $lpane_list, $rpane_list, $gross_sum_box,
    $state_panel, $darkmode_panel
    
)


# Load color mode from JSON
$color_mode = load_data 'darkmode' 'true' $json

if ($color_mode -eq 0) {
    $color_mode = 'bright'
    $bright_mode_checkbox.checked = $true
} else {
    $color_mode = 'dark'
    $dark_mode_checkbox.checked = $true
}


# Load last state from JSON
$laststate = load_data 'laststate' 'mac' $json

if ($laststate -eq 0) {
    $state_checkbox_pc.checked = $true
} else {
    $state_checkbox_mac.checked = $true
}


# Function calls, see separate module 'logic.ps1'
hide_console
reset_btn
set_global_values
set_rpane_values
set_color_mode $color_mode $dark_mode_shifters
set_background $color_mode
set_rounding



# Convert values from string to Int32
foreach ($i in $global_vars) {
    $i = (0 + $i)
}


# Form loop
$form.showdialog()