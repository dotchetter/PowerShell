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
            $num = ($num * $low_mult)
        } elseif ($num -ge $upp_lim) {
            $num = ($num * $upp_mult)
        }
        $cost_sum += $num
    }
    return "$cost_sum Kr"
}


function compute_rpane_sum($num, $labour_cost, $ship_cost) {
    <# Calculate the sum of shipping with labour added to the total sum
    of costs in right pane.  #>

    $num = $num.trim('Kr')
    $num = (0 + $num)
    $rpane_sum = ($num + $labour_cost + $ship_cost)
    
    if ($rounding_on_checkbox.checked -eq $true) {
        $rpane_sum = ([math]::round($rpane_sum, 0))
    }

    return "$rpane_sum Kr "
}


function compute_rpane_member($cost, $low_lim, $upp_lim, $low_mult, $upp_mult) {
    <# Calculate individual numbers added by the user to be displayed
    in the right pane. #>
    
    $cost = (0 + $cost)
    if ($cost -le $low_lim) {    
        $cost = $cost * $low_mult    
    } elseif ($cost -ge $upp_lim) {    
        $cost = $cost * $upp_mult
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
    # Verify that user hasn't entered illogical operands on the chalkboard

    if ($global:lower_limit -ge $global:upper_limit) {
        $global:lower_limit = ($global:upper_limit - 1)
    } elseif ($global:upper_limit -le $global:lower_limit) {
        $global:upper_limit = $global:lower_limit + 1
    }
}


function get_color_mode() {
    # Get current state from GUI whether dark mode is on or off

    if ($dark_mode_checkbox.checked -eq $true) {
        $mode = 'dark'
    } elseif ($bright_mode_checkbox.checked -eq $true) {
        $mode = 'bright'
    }

    return $mode
}


function set_background($mode) {
    # If dark mode is enabled, change form background.

    if ($mode -eq 'dark') {
        $bg_img = [system.drawing.image]::fromfile("$install_path\meta\bg_b.png")
    } elseif ($mode -eq 'bright') {
        $bg_img = [system.drawing.image]::fromfile("$install_path\meta\bg_w.png")
    }
    
    $form.backgroundimage = $bg_img
    $form.backgroundimagelayout = 'center'
    $form.width = ($bg_img.width + 15)
    $form.height = ($bg_img.height + 10)
}


function set_color_mode($mode, $objects) {
    <# Set all objects given as argument to the designated back and front color 
    to accomodate for either bright or dark mode. #>

    if ($mode -eq 'dark') {
       
        foreach ($object in $objects) {
            $object.backcolor = '51,51,51'
            $object.forecolor = 'white'
        }
   
    } elseif ($mode -eq 'bright') {
    
        foreach ($object in $objects) {
            $object.backcolor = 'white'
            $object.forecolor = 'black'
        }
    }
}


function set_rounding() {
    # Set rounding-mode from JSON on startup. (On or off)
   
    $rounding = load_data 'rounding' 'on' $json
    if ($rounding -eq 1) {
        $rounding_on_checkbox.checked = $true
    } else {
        $rounding_off_checkbox.checked = $true
    }
}


function set_clipboard() {

    try {
        if ($rpane_list.items) {
            set-clipboard $null
            set-clipboard -value $rpane_list.items
            set-clipboard -append ("`n`nTotalt: " + $net_sum_box.text)
        } 
    } catch {
        write-host 'BUGS BUGS EVERYWHERE.'
        write-host $error
    }
}