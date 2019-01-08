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
$form.text = 'NumbR'


# Input price box
$input_box = new-object system.windows.forms.textbox
$input_box.autosize = $true
$input_box.top = 150
$input_box.left = 85
$input_box.width = 300


# 'Add cost' button
$add_cost = new-object system.windows.forms.button
$add_cost.top = 205
$add_cost.left = 85
$add_cost.width = 145
$add_cost.height = 30
$add_cost.text = 'L�gg till kostnad'
$add_cost.flatstyle = "flat"
$add_cost.flatappearance.bordersize = 0


# Calculate button
$sum_button = new-object system.windows.forms.button
$sum_button.top = 205
$sum_button.left = 245
$sum_button.width = 140
$sum_button.text = 'Summera'
$sum_button.height = 30
$sum_button.flatstyle = "Flat" 
$sum_button.flatappearance.bordersize = 0


# Left pane incremental list with costs
$lpane_list = new-object system.windows.forms.listbox
$lpane_list.top = 282
$lpane_list.left = 85
$lpane_list.width = 145
$lpane_list.height = 250
$lpane_list.selectionmode = "multiextended"


# Right pane incremental list with calculated costs
$rpane_list = new-object system.windows.forms.listbox
$rpane_list.top = 282
$rpane_list.left = 245
$rpane_list.width = 140
$rpane_list.height = 250
$rpane_list.selectionmode = "multiextended"


# Left side sum box, multiplied but not increased with freight or shipping
$gross_sum_box = new-object system.windows.forms.textbox
$gross_sum_box.top = 570
$gross_sum_box.left = 85
$gross_sum_box.width = 145
$gross_sum_box.height = 30
$gross_sum_box.autosize = $true
$gross_sum_box.multiline = $true
$gross_sum_box.readonly = $true
$gross_sum_box.text = '0.00 Kr'


# Right side sum box, multiplied and freight + shipping added
$net_sum_box = new-object system.windows.forms.textbox
$net_sum_box.top = 570
$net_sum_box.left = 245
$net_sum_box.width = 140
$net_sum_box.height = 30
$net_sum_box.autosize = $true
$net_sum_box.multiline = $true
$net_sum_box.readonly = $true
$net_sum_box.text = '0.00 Kr'


# Copy right side listbox to clipboard button
$clipboard_button = new-object system.windows.forms.button
$clipboard_button.top = 630
$clipboard_button.left = 85
$clipboard_button.width = 300
$clipboard_button.height = 30
$clipboard_button.text = 'Skapa kostnadsf�rslag'
$clipboard_button.flatstyle = "flat"
$clipboard_button.flatappearance.bordersize = 0


# Clipboard done prompt
$clipboard_done_prompt = new-object system.windows.forms.textbox
$clipboard_done_prompt.top = 665
$clipboard_done_prompt.left = 105
$clipboard_done_prompt.width = 255
$clipboard_done_prompt.text = 'Klistra in f�r att se ditt kostnadsf�rslag'
$clipboard_done_prompt.borderstyle = 'none'
$clipboard_done_prompt.hide()


# Reset application button
$reset = new-object system.windows.forms.button
$reset.top = 690
$reset.left = 85
$reset.width = 300
$reset.height = 30
$reset.text = 'T�m'
$reset.flatstyle = "flat"
$reset.flatappearance.bordersize = 0


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
    $clipboard_button,
    $clipboard_done_prompt
    )
)