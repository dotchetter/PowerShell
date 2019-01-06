# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"
# Module purpose: application backend logic


function get_state() {
    <# Get the current state of the application by reading status of
    the radio button. If Mac is selected, all variables for Mac repair
    are loaded from json. Otherwise, PC variables are loaded. #>

    switch ($state_checkbox_mac.checked) {
        $true {$state = 'mac'}
        $false {

            if ($state_checkbox_pc.checked -eq $true) {
                $state = 'pc'
            } else {
                $state = 'ipad'
            }
        }
    }
    return $state
}


function compute_lpane_sum($cost, $low_lim, $upp_lim, $low_mult, $upp_mult) {
    <# Calculate the sum of left pane, which contains gross prices. 
    Strings are converted to integers and math performed on these operands. 
    Sum returned to be displayed in $gross_sum_box #>
    
    foreach ($num in $cost.items) {
    
        $num = (0 + $num)
        switch ($num) {
            {$_ -le $low_lim} {
                $_ = ($_ * $low_mult)
                $cost_sum += $_
            }
            {$_ -ge $upp_lim} {
                $_ = ($_ * $upp_mult)
                $cost_sum += $_
            }
        }
    }
    return "$cost_sum SEK"
}


function compute_rpane_sum($num, $labour_cost, $ship_cost) {
    <# Calculate the sum of shipping with labour added to the total sum
    of costs in right pane.  #>
    
    $num = $num.trim('SEK')
    $num = (0 + $num)
    $rpane_sum = ($num + $labour_cost + $ship_cost)

    if ($rounding_on_checkbox.checked -eq $true) {
        $rpane_sum = ([math]::round($rpane_sum, 0))
    }
    return "$rpane_sum SEK "
}


function get_current_customer() {
    <# Return the current name of customer selected in customer_menu
    in string format. Used to know which JSON to read, and save to. #>
    
    $current_customer = $customer_menu.selecteditem.tostring() + ".json"
    return $current_customer
}


function populate_customer_list($install_path) {
    <# Parse install directory for JSON config files. 
    Return output to $customer_menu list. If none is present,
    call create_json for default values. #>
    
    $json = test-path "$install_path\*.json"

    if (-not $json) {
        create_json $install_path 'Standard'
    }

    <# Get all JSON files in install directory and 
    add them in name format to the customer list #>
    foreach ($i in (get-childitem "$install_path\*.json" | 
        select-object $_.name -expandproperty basename)) {
            $customer_menu.items.add($i.tostring()) | out-null
    }
    $customer_menu.selecteditem = $customer_menu.items[0]
}


function get_json($install_path, $name) {
    # load correct JSON object depending on selected customer in menu.
    
    try {
        $json = get-content "$install_path\$name" | convertfrom-json
    } catch {
        user_prompt 'error' 'json load'
    }
    return $json
}


function compute_rpane_member($cost, $low_lim, $upp_lim, $low_mult, $upp_mult) {
    <# Calculate individual numbers added by the user to be displayed
    in the right pane. #>
    
    $cost = (0 + $cost)
    switch ($cost) {
        {$_ -le $low_lim} {$cost = $cost * $low_mult}
        {$_ -ge $upp_lim} {$cost = $cost * $upp_mult}
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


function set_global_values() {
    # Set values used for calculations based upon current application state
    
    try {
        $state = get_state
        $global:labour = load_data $state 'labour' $json
        $global:shipping = load_data $state 'shipping' $json
        $global:upper_limit = load_data $state 'upper_limit' $json
        $global:lower_limit = load_data $state 'lower_limit' $json
        $global:upper_multiplicand = load_data $state 'upper_multiplicand' $json
        $global:lower_multiplicand = load_data $state 'lower_multiplicand' $json
    } catch {
        user_prompt 'Error' 'set globals'
    }
    verify_operands
}


function create_json($install_path, $name) {
    # Initiate a new JSON file if none is present in install directory

    $json = @{
        darkmode = '0'
        laststate = 'mac'
        rounding = '1'
        'mac' = @{
            lower_limit = '499'
            upper_limit = '500'
            shipping = '200'
            labour = '900'
            upper_multiplicand = '1.2'
            lower_multiplicand = '1.4'
        }
        'pc' = @{
            lower_limit = '499'
            upper_limit = '500'
            shipping = '200'
            labour = '800'
            upper_multiplicand = '1.2'
            lower_multiplicand = '1.4'
        }
        'ipad' = @{
            lower_limit = '0'
            upper_limit = '2000'
            shipping = '200'
            labour = '0'
            upper_multiplicand = '1.05'
            lower_multiplicand = '0'
        }
    }
    try {
        $json | convertto-json | out-file "$install_path\$name.json"
    } catch {
        user_prompt 'Error' 'create json'
    }
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
    
    switch ($dark_mode_checkbox.checked) {
        $true {$mode = 'dark'}
        $false {$mode = 'bright'}
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
    $form.width = ($bg_img.width)
    $form.height = ($bg_img.height)
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


function re_init() {
    <# Re-initialize app with color mode and re-load values for chalkboard in case 
    user changes customer. #>
    
    $name = get_current_customer
    $json = get_json $install_path $name
    switch ($json.darkmode) {
        0 {
            $color_mode = 'bright'
            $bright_mode_checkbox.checked = $true
        }
        1 {
            $color_mode = 'dark'
            $dark_mode_checkbox.checked = $true
        }
    }

    switch ($json.laststate) {
        'pc' {$state_checkbox_pc.checked = $true}
        'mac' {$state_checkbox_mac.checked = $true}
    }
    
    switch ($json.rounding) {
        0 {$rounding_off_checkbox.checked = $true}
        1 {$rounding_on_checkbox.checked = $true}
    }

    set_global_values
    set_rpane_values
    set_color_mode $color_mode $dark_mode_shifters
    set_background $color_mode
}


function user_prompt($type, $trigger) {
    <# Handle errors or information and prompt user with messagebox.
    Type refers to Error or information prompt to show. Trigger is 
    which app function that asks for a prompt box. #>
    
    if ($type -eq 'Information') {
        switch ($trigger) {
            'clipboard' {$msg_body = 'Klart! kostnadsförslaget ligger i ditt urklipp. Klistra in för att få fram ditt kostnadsförslag.'}
            'save' {$msg_body = 'Griffeltavlan och inställningar har sparats för aktuell kund och appläge.'}
            'add cost' {$msg_body = 'Det där ser inte ut som ett tal. Försök igen. Separera flera priser med semikolon.'}
            'customer added' {$msg_body = 
            'Kund sparad! Alla värden på griffeltavlan sparas unikt för denna kund. Griffeltavlan har populerats med standardvärden.'}
            'no numbers' {$msg_body = 'Hmm.. det ser inte ut som att du matat in något?'}
        }
    } elseif ($type -eq 'Error') {
        switch  ($trigger) {
            'clipboard' {$msg_body = 'Cheesus! Något gick fel under kopieringen till din clipboard. Detta vet vi:' + "`n`n$error"}
            'save' {$msg_body = 'Aw snap! Något gick snett när NumbR skulle spara data. Detta vet vi:' + "`n`n$error"}
            'set globals' {$msg_body = 'Aw snap! NumbR kunde inte läsa in data. Detta vet vi:' + "`n`n$error"}
            'save input error' {$msg_body = 'Hej där! Här på griffeltavlan kan du endast ange siffror. Decimaltal skrivs med " . "'}
            'json load' {$msg_body = 'Computer says no! Något hände och det gick inte att läsa in filen. Detta vet vi:' + "`n`n$error"}
            'startup' {$msg_body = 'Aw snap! NumR kunde inte starta. Om felen fortsätter, prova ominstallera NumbR. Detta vet vi:' + "`n`n$error"}
            'customer added' {$msg_body = 'Järnspikar! Filen kunde inte sparas. Lite mer detaljerat uttryckt;' + "`n`n$error"}
            'create json' {$msg_body = 'Bomber och granater! Det gick inte att skapa en profil. Kontrollera att NumbR har åtkomst till mappen.' + "`n`n$error"}
        }
    }

    [windows.forms.messagebox]::show("$msg_body", "$type", 
    [windows.forms.messageboxbuttons]::Ok, [windows.forms.messageboxicon]::$type)
    $error.clear()
}