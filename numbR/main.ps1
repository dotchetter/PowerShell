# Developed for Advania Sverige AB by Simon Olofsson
# Main module file for application "NumbR"
# module purpose: main


# Load framework and GUI dependencies
[void][system.reflection.assembly]::loadwithpartialname("system.windows.forms") 
add-type -assemblyname presentationcore,presentationframework
add-type -name window -namespace console -memberdefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'
$install_path = "$env:userprofile\git\powershell\NumbR"
$bg_img = [system.drawing.image]::fromfile("$install_path\meta\bg_2.png")
$icon = "$install_path\meta\numbr.ico"


# Import modules
. ($psscriptroot + "\lp_gui.ps1")
. ($psscriptroot + "\rp_gui.ps1")
. ($psscriptroot + "\logic.ps1")
. ($psscriptroot + "\event_listnrs.ps1")



# --- Initialize variables
$json = cat "$env:userprofile\git\powershell\NumbR\data.json" | convertfrom-json
$global:labour = 0
$global:shipping = 0
$global:upper_limit = 0
$global:lower_limit = 0
$global:upper_multiplicand = 0
$global:lower_multiplicand = 0

# Function calls
hide_console
set_global_values
set_rpane_values


# Convert values from string to Int32
$global:labour = (0 + $global:labour)
$global:shipping = (0 + $global:shipping)
$global:upper_limit = (0 + $global:upper_limit)
$global:lower_limit = (0 + $global:lower_limit)
$global:upper_multiplicand = (0 + $global:upper_multiplicand)
$global:lower_multiplicand = (0 + $global:lower_multiplicand)


<# Verify that lower limit is not greater than 
upper limit operand and vice versa #>
if ($lower_limit -ge $upper_limit) {
    $lower_limit = ($upper_limit - 1)
} elseif ($upper_limit -le $lower_limit) {
    $upper_limit = $lower_limit + 1
}


# Fill boxes in right GUI pane with values


# Initialize clicking functionality for objects on gui
$add_cost.add_click($add_cost_btn_click)
$reset.add_click($reset_btn_click)
$sum_button.add_click($sum_btn_click)


# Form loop
[system.windows.forms.application]::enablevisualstyles();
$form.showdialog()