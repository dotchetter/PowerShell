# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"
# Module purpose: Left pane GUI objects


# GUI form properties
$font = new-object system.drawing.font('segoe ui', 11)
$form = new-object system.windows.forms.form
$form.font = $font
$form.topmost = $true
$form.width = $bg_img.width + 15
$form.height = $bg_img.height + 30
$form.opacity = .99
$form.backgroundimage = $bg_img
$form.icon = $icon
$form.backgroundimagelayout = 'center'
$form.formborderstyle = 'fixedsingle'
$form.maximizebox = $false


# input price box
$input_box = new-object system.windows.forms.textbox
$input_box.autosize = $true
$input_box.top = 145
$input_box.left = 85
$input_box.width = 300


# 'add cost' button
$add_cost = new-object system.windows.forms.button
$add_cost.top = 180
$add_cost.left = 85
$add_cost.width = 300
$add_cost.height = 30
$add_cost.text = 'lägg till'


# reset application button
$reset = new-object system.windows.forms.button
$reset.top = 215
$reset.left = 85
$reset.width = 300
$reset.height = 30
$reset.text = 'nollställ'


# left pane incremental list with costs
$lpane_list = new-object system.windows.forms.listbox
$lpane_list.top = 300
$lpane_list.left = 86
$lpane_list.width = 145
$lpane_list.height = 300
$lpane_list.selectionmode = "multiextended"


# right pane incremental list with calculated costs
$rpane_list = new-object system.windows.forms.listbox
$rpane_list.top = 300
$rpane_list.left = 243
$rpane_list.width = 140
$rpane_list.height = 300
$rpane_list.selectionmode = "multiextended"


# calculate button
$sum_button = new-object system.windows.forms.button
$sum_button.top = 610
$sum_button.left = 84
$sum_button.width = 300
$sum_button.text = 'beräkna'
$sum_button.height = 30


# Left pane sum box, multiplied but not increased with freight or shipping
$gross_sum_box = new-object system.windows.forms.textbox
$gross_sum_box.top = 670
$gross_sum_box.left = 85
$gross_sum_box.width = 143
$gross_sum_box.height = 30
$gross_sum_box.autosize = $true
$gross_sum_box.multiline = $true
$gross_sum_box.readonly = $true
$gross_sum_box.text = '0.00'


# Right pane sum box, multiplied and freight + shipping added
$net_sum_box = new-object system.windows.forms.textbox
$net_sum_box.top = 670
$net_sum_box.left = 240
$net_sum_box.width = 143
$net_sum_box.height = 30
$net_sum_box.autosize = $true
$net_sum_box.multiline = $true
$net_sum_box.readonly = $true
$net_sum_box.text = '0.00'


# State tickbox (mac)
$state_checkbox_mac = new-object system.windows.forms.radiobutton
$state_checkbox_mac.location = '645, 520'
$state_checkbox_mac.size = '58, 20'
$state_checkbox_mac.text = "Mac"
$state_checkbox_mac.checked = $true
$state_checkbox_mac.backcolor = 'white'


# State tickbox (pc)
$state_checkbox_pc = new-object system.windows.forms.radiobutton
$state_checkbox_pc.location = '555, 520'
$state_checkbox_pc.size = '58, 20'
$state_checkbox_pc.text = "PC"
$state_checkbox_pc.checked = $false
$state_checkbox_pc.backcolor = 'white'


# -- render objects

$form.controls.add($input_box)
$form.controls.add($add_cost)
$form.controls.add($lpane_list)
$form.controls.add($rpane_list)
$form.controls.add($reset)
$form.controls.add($gross_sum_box)
$form.controls.add($sum_button)
$form.controls.add($net_sum_box)
$form.controls.add($state_checkbox_mac)
$form.controls.add($state_checkbox_pc)