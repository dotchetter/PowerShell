# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"
# Module purpose: application button event listeners
# Each button triggers function calls. Functions called here are located in -
# separate module: 'event_handlrs.ps1'.

<# calculate sum with function call and return to sum_box.text
Button clicked: '$sum_button'. #>
$sum_btn_click = {sum_btn $rounding}


# Save to clipboard button. This saves all content in $lpane_list to clipboard memory.
$clipboard_button_click = {set_clipboard}


# Save data button. This saves all content on the chalkboard (rp_gui.ps1 box objects) -
# to JSON file. 
$save_data_button_click = {save_data $json}


<# Radio buttons setting application state. 
Button(s) clicked: '$state_checkbox_mac' and '$state_checkbox_pc'. #>  
$state_checkbox_mac.add_click({reset_app})
$state_checkbox_pc.add_click({reset_app})
$state_checkbox_ipad.add_click({reset_app})
$dark_mode_checkbox.add_click({

    $color_mode = get_color_mode
    set_color_mode $color_mode $dark_mode_shifters
    set_background $color_mode
    $state_panel.forecolor = 'white' 
    $darkmode_panel.forecolor = 'white'
})
$bright_mode_checkbox.add_click({
    $color_mode = get_color_mode
    set_color_mode $color_mode $dark_mode_shifters
    set_background $color_mode
})

# Customer list event listener. Triggers if selected customer changes.
$customer_menu.add_SelectedIndexChanged({

    $name = get_current_customer
    $json = get_json $install_path $name
    set_global_values
    set_rpane_values

})

# Add functionality for all buttons on gui
$add_cost.add_click({add_cost})
$reset.add_click({reset_app})
$sum_button.add_click($sum_btn_click)
$clipboard_button.add_click($clipboard_button_click)
$save_data_button.add_click($save_data_button_click)
$add_customer_button.add_click({new_customer})
