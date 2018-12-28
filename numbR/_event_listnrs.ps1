
# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"

# add cost to calculation
$add_cost_btn_click = {

    while ($input_box.text) {
    
        $input_box.text = $input_box.text.replace(',','.')
        if ($input_box.text.contains(';')) {
            foreach ($i in $input_box.text.split(';')) {
                $global:all_cost_sum += $i
                $all_cost_box.items.add($i)
                $self_product = compute $i $multi_x $multi_y           
                $all_calculated_box.items.add($self_product)
            }   
        } else {
            $all_cost_box.items.add($input_box.text)
            $self_product = compute $input_box.text $multi_x $multi_y           
            $all_calculated_box.items.add($self_product)
            $global:all_cost_sum += $input_box.text
        }

        $input_box.text = $null
    }
}


# reset application and enable disabled features
$reset_btn_click = {

    $all_calculated_box.items.clear()
    $all_cost_box.items.clear()
    $global:all_cost_sum = 0
    $misc_sum_box.text = $null
    $all_cost_box.text = $null
    $sum_box.text = $null
    $sum_button.enabled = $true
    $add_cost.enabled = $true

}


# calculate sum with function call and return to sum_box.text
$sum_btn_click = {

    $labour_cost = get_state($json)
    $cost_sum = compute $global:all_cost_sum $multi_x $multi_y
    $misc_sum = compute_misc $cost_sum $labour_cost $ship_cost
    
    $sum_box.text = $cost_sum
    $misc_sum_box.text = $misc_sum
    $sum_button.enabled = $false
    $add_cost.enabled = $false

    $all_calculated_box.items.add("----------------------------`n")
    $all_calculated_box.items.add("Frakt: $ship_cost Kr")
    $all_calculated_box.items.add("Arbete: $labour_cost Kr")

}