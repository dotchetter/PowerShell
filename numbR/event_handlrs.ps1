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

    $gross_sum = 
        compute_lpane_sum $lpane_list $lower_limit $upper_limit $lower_multiplicand $upper_multiplicand

    $net_sum = 
        compute_rpane_sum $gross_sum $labour $shipping
    
    # set gui values after function calls
    $gross_sum_box.text = $gross_sum
    $net_sum_box.text = $net_sum
    $sum_button.enabled = $false
    $add_cost.enabled = $false
    $rpane_list.items.add("----------------------`n")
    $rpane_list.items.add("Frakt: $shipping Kr")
    $rpane_list.items.add("Arbete: $labour Kr")

}