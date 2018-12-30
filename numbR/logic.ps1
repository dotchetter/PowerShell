# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"
# Module purpose: application backend logic



function get_state() {
    
    <# Get the current state of the application by reading status of
    the radio button. If Mac is selected, all variables for Mac repair
    are loaded from json. Otherwise, PC variables are loaded. #>

    if ($state_checkbox_mac.checked -eq $true) {
        $state = 'mac'
    } elseif ($state_checkbox_pc.checked -eq $true) {
        $state = 'pc'
    }
    return $state
}



function compute_lpane_sum($cost, $low_lim, $upp_lim, $low_mult, $upp_mult) {

    <# Calculate the sum of left pane, which contains gross prices. Strings are 
    converted to integers and math performed on these operands. 
    Sum returned to be displayed in $gross_sum_box #>

    foreach ($num in $cost.items) {
        $num = (0 + $num)
        if ($num -le $low_lim) {
            $num = $num * $low_mult # 1.4
        } elseif ($num -ge $upp_lim) {
            $num = $num * $upp_mult # 1.2
        }   
        $cost_sum += $num
    }
 
    $cost_sum = [math]::round($cost_sum, [system.midpointrounding]::awayfromzero)
    return "$cost_sum Kr"
}



function compute_rpane_sum($num, $labour_cost, $ship_cost) {

    <# Calculate the sum of shipping with labour added to the total sum
    of costs in right pane.  #>

    $num = $num.trim('Kr')
    $num = (0 + $num)
    $misc_sum = ($num + $labour_cost + $ship_cost)
    return "$misc_sum Kr "
}



function compute_rpane_member($cost, $low_lim, $upp_lim, $low_mult, $upp_mult) {

    <# Calculate individual numbers added by the user to be displayed
    in the right pane. #>
    
    $cost = (0 + $cost)
    if ($cost -le $low_lim) {
        $cost = $cost * $low_mult # 1.4
    } elseif ($cost -ge $upp_lim) {
        $cost = $cost * $upp_mult # 1.2
    }
    return $cost
}



function set_rpane_values() {

    # set values in right pane boxes from global variables

    $labour_box.text = $global:labour
    $ship_cost_box.text = $global:shipping
    $upper_limit_box.text = $global:upper_limit
    $lower_limit_box.text = $global:lower_limit
    $upper_multiplicand_box.text = $global:upper_multiplicand
    $lower_multiplicand_box.text = $global:lower_multiplicand
}



function load_data($state, $value, $json) {

    <# Load attribute data from JSON containing multiplicands, 
    shipping cost and labour cost generated from GUI by the user. 
    State refers to PC or Mac values to load from JSON.#>

    $key_value = $json.$state.$value
    $key_value = 0 + $key_value
    return $key_value
}



function save_data() {

    # Todo. Save data to JSON from assigned values in boxes

}



function hide_console() {
    # Hide PS console window during runtime

    $console_window = [console.window]::getconsolewindow()
    [console.window]::showwindow($console_window, 0) #0 = hide
}



function set_global_values() {

    # Set values used for calculations based upon current application state

    $state = get_state
    $global:labour = load_data $state 'labour' $json
    $global:shipping = load_data $state 'shipping' $json
    $global:upper_limit = load_data $state 'upper_limit' $json
    $global:lower_limit = load_data $state 'lower_limit' $json
    $global:upper_multiplicand = load_data $state 'upper_multiplicand' $json
    $global:lower_multiplicand = load_data $state 'lower_multiplicand' $json

    verify_operands
}



function verify_operands() {

    # Verify that user hasn't entered illogical operands

    if ($global:lower_limit -ge $global:upper_limit) {
        $global:lower_limit = ($global:upper_limit - 1)
    } elseif ($global:upper_limit -le $global:lower_limit) {
        $global:upper_limit = $global:lower_limit + 1
    }
}