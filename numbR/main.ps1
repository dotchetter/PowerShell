# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"


# Initialize variable
$global:all_cost_sum = 0
$install_path = "$env:userprofile\git\powershell\NumbR"


# Import modules
. ($psscriptroot + "\gui.ps1")
. ($psscriptroot + "\logic.ps1")
. ($psscriptroot + "\_event_listnrs.ps1")



# Read json file and create instance object
$json = cat "$env:userprofile\git\powershell\NumbR\data.json" | convertfrom-json



<# Load values for mathematic calculations.
Multiplicands, shipping and labour costs are loaded from json.

$multi_x = operand is <= 499, $multi_y = operand is >= 500 
mac_increment refers to the increased labour cost for mac repair. #>

# Set state depending on radio buttons
if ($state_checkbox_mac.checked) {
    $labour_cost = 'maclabour'
} else {
    $labour_cost = 'pclabour'
}


$multi_x = load_data 'x' $json
$multi_y = load_data 'y' $json
$ship_cost = load_data 'ship' $json
$labour_cost = load_data $labour_cost $json



# Click functionality for objects
$add_cost.add_click($add_cost_btn_click)
$reset.add_click($reset_btn_click)
$sum_button.add_click($sum_btn_click)


# Form loop
hide_console
[system.windows.forms.application]::enablevisualstyles();
$form.showdialog()