# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"
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

$install_path = "$home\git\powershell\NumbR"
$icon = "$install_path\meta\numbr.ico"

# Import modules

try {
    . ("$install_path\lp_gui.ps1")
    . ("$install_path\rp_gui.ps1")
    . ("$install_path\logic.ps1")
    . ("$install_path\event_listnrs.ps1")
    . ("$install_path\nc_popup.ps1")
    . ("$install_path\event_handlrs.ps1")
} catch {
    user_prompt 'Error' 'startup'
    exit
}


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


<# Load JSON file(s), populate customer list and 
set number 1 in list as selected customer. 
If not present, create template 'standard.json' #>
try {
    populate_customer_list $install_path
    $name = get_current_customer
    $json = get_json $install_path $name
} catch {
    create_json $install_path 'Standard'
}


# Load color mode, app state and rounding state from JSON
if ($json.darkmode -eq 0) {
    $color_mode = 'bright'
    $bright_mode_checkbox.checked = $true
} else {
    $color_mode = 'dark'
    $dark_mode_checkbox.checked = $true
}


# Load last state from JSON
if ($json.laststate -eq 'pc') {
    $state_checkbox_pc.checked = $true
} else {
    $state_checkbox_mac.checked = $true
}


# Load rounding state from JSON
if ($json.rounding -eq 1) {
    $rounding_on_checkbox.checked = $true
} else {
    $rounding_off_checkbox.checked = $true
}


# Function calls, see separate module 'logic.ps1'
hide_console
reset_app
set_global_values
set_rpane_values
set_color_mode $color_mode $dark_mode_shifters
set_background $color_mode


# Convert values from string to Int32
foreach ($i in $global_vars) {
    $i = (0 + $i)
}

# Form loop
$form.showdialog()