# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"
# Module purpose: application button event handlers



function add_cost() {
<#  Handle button clicked where user wants to add costs to calculation.
    Parse textbox text for ';' and separate numbers. Call functions to perform
    math on each value.#>

    while ($input_box.text -match '^[0-9\;.,s]+$') {
        $input_box.text = $input_box.text.replace(',','.')
        if ($input_box.text.contains(';')) {
            foreach ($i in $input_box.text.split(';')) {
                $lpane_list.items.add($i)
                $calculated_cost = 
                    compute_rpane_member $i $lower_limit $upper_limit $lower_multiplicand $upper_multiplicand
                $rpane_list.items.add($calculated_cost)
            }   
        } else {
            $lpane_list.items.add($input_box.text)
            $calculated_cost = 
                compute_rpane_member $input_box.text $lower_limit $upper_limit $lower_multiplicand $upper_multiplicand
            $rpane_list.items.add($calculated_cost)
        }
        $input_box.text = $null
    }
}



function sum_btn() {
    if ($lpane_list.items -ne $null) {
        $gross_sum = 
            compute_lpane_sum $lpane_list $lower_limit $upper_limit $lower_multiplicand $upper_multiplicand 

        $net_sum = 
            compute_rpane_sum $gross_sum $labour $shipping
        $gross_sum_box.text = $gross_sum
        $net_sum_box.text = $net_sum
        $sum_button.enabled = $false
        $add_cost.enabled = $false
        $rpane_list.items.add("----------------------`n")
        $rpane_list.items.add("Frakt: $shipping Kr")
        $rpane_list.items.add("Arbete: $labour Kr")
    }
}



function reset_app() {
    # Reset application for accepting new calculation.

    set_global_values
    set_rpane_values
    $rpane_list.items.clear()
    $lpane_list.items.clear()
    $net_sum_box.text = '0,00 Kr'
    $gross_sum_box.text = '0,00 Kr'
    $lpane_list.text = $null
    $sum_button.enabled = $true
    $add_cost.enabled = $true
}



function save_data($json) {
    <# Read data from input boxes in right gui pane, renderd on chalkboard
    and save values to JSON file. #>

    $state = get_state
    $color_mode = get_color_mode

    $json.laststate = $state
    $json.$state.labour = $labour_box.text
    $json.$state.shipping = $ship_cost_box.text
    $json.$state.upper_limit = $upper_limit_box.text
    $json.$state.lower_limit = $lower_limit_box.text
    $json.$state.upper_multiplicand = $upper_multiplicand_box.text
    $json.$state.lower_multiplicand = $lower_multiplicand_box.text
    
    if ($color_mode -eq 'bright') {
        $json.darkmode = 0
    } else {
        $json.darkmode = 1
    }

    if ($rounding_on_checkbox.checked -eq $true) {
        $json.rounding = 1
    } else {
        $json.rounding = 0
    }

    $json | convertto-json | out-file "$env:userprofile\git\powershell\NumbR\data.json"
    
    [windows.forms.messagebox]::show("Inställningar för $state har sparats.", "", 
    [windows.forms.messageboxbuttons]::Ok, [windows.forms.messageboxicon]::information)
    
    reset_app

}