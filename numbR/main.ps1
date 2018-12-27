# import modules

. ($psscriptroot + "\gui.ps1")
. ($psscriptroot + "\logic.ps1")

## button click listeners


# add cost to calculation
$add_cost_btn_click = {

    $input_box.text = $input_box.text.replace(',','.')
    if ($input_box.text.contains(';')) {
        foreach ($i in $input_box.text.split(';')) {
            $all_cost_box.text += "$i`r`n"
            $global:all_cost_sum += $i
        }
    } 
    else {
        $global:all_cost_sum += $input_box.text
        $all_cost_box.text += $input_box.text
        $all_cost_box.text += "`r`n"
    }
    $input_box.text = $null
}
    

# reset application and enable disabled features
$reset_btn_click = {

     $all_cost_box.text = $null
     $global:all_cost_sum = 0
     $all_cost_box.text = $null
     $sum_box.text = $null
     $sum_button.enabled = $true
     $add_cost.enabled = $true
}


# calculate sum with function call and return to sum_box.text
$sum_btn_click = {
 
    $sumint = compute $global:all_cost_sum $multi_x $multi_y
    $sum_box.text = $sumint
    $sum_button.enabled = $false
    $add_cost.enabled = $false
}


# click functionality for objects
$add_cost.add_click($add_cost_btn_click)
$reset.add_click($reset_btn_click)
$sum_button.add_click($sum_btn_click)



# form loop
hide_console
[system.windows.forms.application]::enablevisualstyles();
$null = $form.showdialog()
