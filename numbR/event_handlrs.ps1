# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"
# Module purpose: application button event handlers



function add_cost() {
<#  Handle button clicked where user wants to add costs to calculation.
    Parse textbox text for ';' and separate numbers. Call functions to perform
    math on each value. #>

    # Warn user that entered characters are not allowed in input box
    if ($input_box.text -notmatch '^[0-9\;.,s]+$' ) {

        user_prompt 'Information' 'add cost'

    } else {
        
        $input_box.text = $input_box.text.replace(',','.')
        if ($input_box.text.contains(';')) {
            
            foreach ($i in $input_box.text.split(';')) {
                $lpane_list.items.add($i)
                $calculated_cost = 
                    compute_rpane_member $i $lower_limit $upper_limit $lower_multiplicand $upper_multiplicand
                $rpane_list.items.add("$calculated_cost SEK")
            }   

        } else {

            $lpane_list.items.add($input_box.text)
            $calculated_cost = 
                compute_rpane_member $input_box.text $lower_limit $upper_limit $lower_multiplicand $upper_multiplicand
            $rpane_list.items.add("$calculated_cost SEK")
        
        }      

        $input_box.text = $null
    }

}



function sum_btn() {
   # Calculate sum button clicked. Sum all objects in left pane, calculate net sum.
   # Calculate right pane sum with shipping and labour added.

    if ($lpane_list.items -ne $null) {

        $gross_sum = 
            compute_lpane_sum $lpane_list $lower_limit $upper_limit $lower_multiplicand $upper_multiplicand 

        $net_sum = 
            compute_rpane_sum $gross_sum $labour $shipping

        $gross_sum_box.text = $gross_sum
        $net_sum_box.text = $net_sum
        $sum_button.enabled = $false
        $add_cost.enabled = $false
        $rpane_list.items.add("------------------------`n")
        $rpane_list.items.add("Frakt: $shipping SEK")
        $rpane_list.items.add("Arbete: $labour SEK")

    }

}



function reset_app() {
    # Reset application for accepting new calculation.

    set_global_values
    set_rpane_values
    $rpane_list.items.clear()
    $lpane_list.items.clear()
    $net_sum_box.text = '0,00 SEK'
    $gross_sum_box.text = '0,00 SEK'
    $lpane_list.text = $null
    $sum_button.enabled = $true
    $add_cost.enabled = $true

}



function save_data($json) {
    <# Read data from input boxes in right gui pane, renderd on chalkboard
    and save values to JSON file. #>

    $valid_input = $true
    $state = get_state
    $color_mode = get_color_mode
    $all_rpane_fields = @(

        $labour_box, $ship_cost_box, 
        $upper_limit_box, $lower_limit_box, 
        $upper_multiplicand_box, $lower_multiplicand_box
    
    )
        
    switch ($color_mode) {      

        'bright' {$json.darkmode = 0}       
        'dark' {$json.darkmode = 1}

    }   

    switch ($rounding_on_checkbox.checked) {    

        $true {$json.rounding = 1}  
        $false {$json.rounding = 0} 

    }
      
    # Verify that ',' is not delimiting integers in the boxes. Replace with '.'
    foreach ($value in $all_rpane_fields) { 

        if ($value.text -notmatch '^[0-9.]*$') {   

            $valid_input = $false   
            user_prompt 'Error' 'save input error'

        }             

    }
    
    try {
    
        # Save object to JSON file, alert user and reset app to parse JSON file again
        if ($valid_input -eq $true) {

            $json.laststate = $state
            $json.$state.labour = $labour_box.text
            $json.$state.shipping = $ship_cost_box.text
            $json.$state.upper_limit = $upper_limit_box.text
            $json.$state.lower_limit = $lower_limit_box.text
            $json.$state.upper_multiplicand = $upper_multiplicand_box.text
            $json.$state.lower_multiplicand = $lower_multiplicand_box.text
            $json | convertto-json | out-file "$install_path\data.json"
            user_prompt 'Information' 'save'
        } 

    } catch {

        user_prompt 'Error' 'save'
        
    } finally {
    
        reset_app
    
    }

}



function set_clipboard() {
    <# Add contents from right pane listbox to clipboard, with added formatting and message phrases. 
    Users can paste this content in web browser or elsewhere. #>

    $phrase = "Hej, här kommer ditt kostnadsförslag. Vänligen återkom med ett beslut."
    $farewell = "MVH Advania Service & Support"
    try {

        if ($rpane_list.items) {
        
            set-clipboard ($null + $phrase + "`n")
            foreach ($i in $rpane_list.items) {
                
                foreach ($j in $i) {
                
                    if ($j -match '^[0-9]') {$j = "[KOMPONENTNAMN] $j"}
                    set-clipboard -append $j
                }

            } 

            set-clipboard -append ("`nTotalt: " + $net_sum_box.text)
            set-clipboard -append "`n$farewell"
            user_prompt 'Information' 'clipboard'
        }
    
    } catch {
    
        user_prompt 'Error' 'clipboard'
    }

}