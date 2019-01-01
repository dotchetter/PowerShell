# Developed for Advania Sverige AB by Simon Olofsson
# Module file for application "NumbR"
# Module purpose: Left pane GUI objects


# GUI form properties
$font = new-object system.drawing.font('segoe ui', 11)
$form = new-object system.windows.forms.form
$form.font = $font
$form.topmost = $true
$form.opacity = 99
$form.icon = $icon
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
$add_cost.text = 'Lägg till'



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
$sum_button.top = 215
$sum_button.left = 85
$sum_button.width = 300
$sum_button.text = 'Beräkna'
$sum_button.height = 30


# Left side sum box, multiplied but not increased with freight or shipping
$gross_sum_box = new-object system.windows.forms.textbox
$gross_sum_box.top = 690
$gross_sum_box.left = 85
$gross_sum_box.width = 143
$gross_sum_box.height = 30
$gross_sum_box.autosize = $true
$gross_sum_box.multiline = $true
$gross_sum_box.readonly = $true
$gross_sum_box.text = '0.00 Kr'


# Right side sum box, multiplied and freight + shipping added
$net_sum_box = new-object system.windows.forms.textbox
$net_sum_box.top = 690
$net_sum_box.left = 240
$net_sum_box.width = 143
$net_sum_box.height = 30
$net_sum_box.autosize = $true
$net_sum_box.multiline = $true
$net_sum_box.readonly = $true
$net_sum_box.text = '0.00 Kr'


# reset application button
$reset = new-object system.windows.forms.button
$reset.top = 625
$reset.left = 85
$reset.width = 300
$reset.height = 30
$reset.text = 'Nollställ'


# Copy right side listbox to clipboard button
$clipboard_button = new-object system.windows.forms.button
$clipboard_button.top = 590
$clipboard_button.left = 85
$clipboard_button.width = 300
$clipboard_button.height = 30
$clipboard_button.text = 'Kopiera till urklipp'


# -- render objects

$form.controls.addrange(@(

    $input_box,
    $add_cost,
    $lpane_list,
    $rpane_list,
    $reset,
    $gross_sum_box,
    $sum_button,
    $net_sum_box,
    $clipboard_button
    )
)