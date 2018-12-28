
# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"


function compute($num_array, $x, $y) {

<# Calculate the sum of objects in cost list. 
Arguments is sum of strings from input costs and multiplicands.
Strings are converted to integers, and math performed on these operands. 
Sum returned to be displayed in left pane sum box. #>
    
    foreach ($num in $num_array) {
      $num = (0 + $num)
        if ($num -le 499) {
            $num = $num * $x
        } elseif ($num -ge 500) {
            $num = $num * $y
        }

        $cost_sum += $num
    }
    # append shipping and labour cost to the right pane
    $cost_sum = [math]::round($cost_sum, [system.midpointrounding]::awayfromzero) 
    return "$cost_sum Kr"
}



function compute_misc($num, $labour_cost, $ship_cost) {

<# Calculate the sum of shipping with labour added to the total sum
of costs in right pane. State refers to whether the labour cost is to
be incremented by 175 or not. #>

    $num = $num.trim('Kr')
    $num = (0 + $num)
    $misc_sum = ($num + $labour_cost + $ship_cost)
    return "$misc_sum Kr "
}


function load_data($value, $json_obj) {

<# Load attribute data from JSON containing multiplicands, 
shipping cost and labour cost generated from GUI by the user. #>
    
    $attrib = $json_obj.$value
    $attrib = 0 + $attrib
    if ($attrib) {
        return $attrib
    } else {
        $error
    }
}


function hide_console() {
# Hide PS console window during runtime

    $console_window = [console.window]::getconsolewindow()
    [console.window]::showwindow($console_window, 0) #0 = hide

}


function get_state($json_obj) {

    $state = $state_checkbox_mac.checked
    if ($state -eq $true) {
        $cost = load_data 'maclabour' $json
    } else {
        $cost = load_data 'pclabour' $json
    }
    return $cost
}