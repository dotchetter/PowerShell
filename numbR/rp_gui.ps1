# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"
# Module purpose: Right pane GUI objects


<# Input value to calculate from if cost is greater than or equal to
assigned value by user. Saved to JSON object. #>
$upper_limit_box = new-object system.windows.forms.textbox
$upper_limit_box.top = 215
$upper_limit_box.left = 610
$upper_limit_box.width = 40


<# Input value to calculate from if cost is less than or equal to
 assigned value by user. Saved to JSON object.  #>
$lower_limit_box = new-object system.windows.forms.textbox
$lower_limit_box.top = 280
$lower_limit_box.left = 610
$lower_limit_box.width = 40


# Input value to set as multiplicand if cost is 'greater than'
$upper_multiplicand_box = new-object system.windows.forms.textbox
$upper_multiplicand_box.top = 215
$upper_multiplicand_box.left = 790
$upper_multiplicand_box.width = 40


# Input value to set as multiplicand if cost is 'lessthan'
$lower_multiplicand_box = new-object system.windows.forms.textbox
$lower_multiplicand_box.top = 282
$lower_multiplicand_box.left = 790
$lower_multiplicand_box.width = 40


# Input value to set shipping cost
$ship_cost_box = new-object system.windows.forms.textbox
$ship_cost_box.top = 318
$ship_cost_box.left = 790
$ship_cost_box.width = 40


# Input value to set labour cost for repair
$labour_box = new-object system.windows.forms.textbox
$labour_box.top = 354
$labour_box.left = 790
$labour_box.width = 40


# Group panel for application state radio buttons
$state_panel = new-object system.windows.forms.panel
$state_panel.location = '545, 630'
$state_panel.size = '50, 150'
$state_panel.backcolor = 'white'
$state_panel.visible = $true


# State radiobutton (pc)
$state_checkbox_pc = new-object system.windows.forms.radiobutton
$state_checkbox_pc.size = '50, 20'
$state_checkbox_pc.text = "PC"
$state_checkbox_pc.top = 5
$state_checkbox_pc.left = 0


# State radiobutton (mac)
$state_checkbox_mac = new-object system.windows.forms.radiobutton
$state_checkbox_mac.size = '60, 20'
$state_checkbox_mac.text = "Mac"
$state_checkbox_mac.top = 30
$state_checkbox_mac.left = 0


# State radiobutton (iPad)
$state_checkbox_ipad = new-object system.windows.forms.radiobutton
$state_checkbox_ipad.size = '80, 20'
$state_checkbox_ipad.text = 'iPad'
$state_checkbox_ipad.top = 55
$state_checkbox_ipad.left = 0


# Group panel for color mode radio buttons
$darkmode_panel = new-object system.windows.forms.panel
$darkmode_panel.location = '715, 630'
$darkmode_panel.size = '50, 50'
$darkmode_panel.backcolor = 'white'
$darkmode_panel.visible = $true


# Dark mode radiobutton
$dark_mode_checkbox = new-object system.windows.forms.radiobutton
$dark_mode_checkbox.size = '50, 20'
$dark_mode_checkbox.text = "På"
$dark_mode_checkbox.checked = $false
$dark_mode_checkbox.top = 5
$dark_mode_checkbox.left = 0


# Bright mode radiobutton (Dark mode 'Off')
$bright_mode_checkbox = new-object system.windows.forms.radiobutton
$bright_mode_checkbox.size = '50, 20'
$bright_mode_checkbox.text = "Av"
$bright_mode_checkbox.checked = $true
$bright_mode_checkbox.top = 30
$bright_mode_checkbox.left = 0


# Group panel for math rounding on or Off
$rounding_panel = new-object system.windows.forms.panel
$rounding_panel.location = '890, 630'
$rounding_panel.size = '50, 50'
$rounding_panel.backcolor = 'white'
$rounding_panel.visible = $true


# Rounding on radiobutton
$rounding_on_checkbox = new-object system.windows.forms.radiobutton
$rounding_on_checkbox.size = '50, 20'
$rounding_on_checkbox.text = 'På'
$rounding_on_checkbox.checked = $true
$rounding_on_checkbox.top = 5
$rounding_on_checkbox.left = 0


# Rounding off radiobutton
$rounding_off_checkbox = new-object system.windows.forms.radiobutton
$rounding_off_checkbox.size = '50, 20'
$rounding_off_checkbox.text = 'Av'
$rounding_off_checkbox.checked = $false
$rounding_off_checkbox.top = 30
$rounding_off_checkbox.left = 0


# Save data buttons
$save_data_button = new-object system.windows.forms.button
$save_data_button.top = 430
$save_data_button.left = 618
$save_data_button.width = 300
$save_data_button.height = 30
$save_data_button.text = 'Spara'
$save_data_button.flatstyle = 'flat'
$save_data_button.flatappearance.bordersize = 0


# Render objects
$form.controls.addrange(@(

    $rounding_panel, 
    $darkmode_panel,
    $state_panel, 
    $upper_limit_box,
    $lower_limit_box, 
    $upper_multiplicand_box,
    $lower_multiplicand_box, 
    $ship_cost_box,
    $labour_box,
    $save_data_button
    )
)


# Add radio buttons to corresponding groupbox
$state_panel.controls.addrange(@($state_checkbox_pc, $state_checkbox_mac, $state_checkbox_ipad))
$darkmode_panel.controls.addrange(@($dark_mode_checkbox, $bright_mode_checkbox))
$rounding_panel.controls.addrange(@($rounding_on_checkbox, $rounding_off_checkbox))