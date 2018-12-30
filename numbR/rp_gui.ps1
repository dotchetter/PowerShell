# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"
# Module purpose: Right pane GUI objects


<# input value to calculate from if cost is greater than or equal to
assigned value by user. Saved to JSON object. #>
$upper_limit_box = new-object system.windows.forms.textbox
$upper_limit_box.top = 219
$upper_limit_box.left = 610
$upper_limit_box.width = 40


<# input value to calculate from if cost is less than or equal to
 assigned value by user. Saved to JSON object.  #>
$lower_limit_box = new-object system.windows.forms.textbox
$lower_limit_box.top = 282
$lower_limit_box.left = 610
$lower_limit_box.width = 40


# input value to set as multiplicand if cost is 'greater than'
$upper_multiplicand_box = new-object system.windows.forms.textbox
$upper_multiplicand_box.top = 219
$upper_multiplicand_box.left = 790
$upper_multiplicand_box.width = 40


# input value to set as multiplicand if cost is 'lessthan'
$lower_multiplicand_box = new-object system.windows.forms.textbox
$lower_multiplicand_box.top = 282
$lower_multiplicand_box.left = 790
$lower_multiplicand_box.width = 40


# input value to set shipping cost
$ship_cost_box = new-object system.windows.forms.textbox
$ship_cost_box.top = 318
$ship_cost_box.left = 790
$ship_cost_box.width = 40


# input value to set labour cost for repair
$labour_box = new-object system.windows.forms.textbox
$labour_box.top = 354
$labour_box.left = 790
$labour_box.width = 40


# -- render objects
$form.controls.add($upper_limit_box)
$form.controls.add($lower_limit_box)
$form.controls.add($upper_multiplicand_box)
$form.controls.add($lower_multiplicand_box)
$form.controls.add($ship_cost_box)
$form.controls.add($labour_box)