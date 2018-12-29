
# load frameworks

[void][system.reflection.assembly]::loadwithpartialname("system.windows.forms") 
[void][system.reflection.assembly]::loadwithpartialname("microsoft.visualbasic")
add-type -assemblyname presentationcore,presentationframework
add-Type -name window -namespace console -memberdefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

# background image in form
$bg_img = [system.drawing.image]::fromfile("$install_path\meta\bg_2.png")


# GUI form properties
$font = new-object system.drawing.font('calibri', 12)
$form = new-object system.windows.forms.form
$form.font = $font
$form.topmost = $true
$form.width = $bg_img.width + 20
$form.height = $bg_img.height + 40
$form.opacity = 99
$form.backgroundimage = $bg_img
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


# incremental list with all objects
$all_cost_box = new-object system.windows.forms.listbox
$all_cost_box.top = 300
$all_cost_box.left = 86
$all_cost_box.width = 145
$all_cost_box.height = 300
$all_cost_box.selectionmode = "multiextended"


# incremental list with calculated objects
$all_calculated_box = new-object system.windows.forms.listbox
$all_calculated_box.top = 300
$all_calculated_box.left = 243
$all_calculated_box.width = 140
$all_calculated_box.height = 300
$all_calculated_box.selectionmode = "multiextended"


# calculate button
$sum_button = new-object system.windows.forms.button
$sum_button.top = 610
$sum_button.left = 84
$sum_button.width = 300
$sum_button.text = 'beräkna'
$sum_button.height = 30


# Left pane sum box
$sum_box = new-object system.windows.forms.textbox
$sum_box.top = 670
$sum_box.left = 85
$sum_box.width = 143
$sum_box.height = 30
$sum_box.autosize = $true
$sum_box.multiline = $true
$sum_box.readonly = $true


# Right pane sum box with miscellaneous (freight, shipping)
$misc_sum_box = new-object system.windows.forms.textbox
$misc_sum_box.top = 670
$misc_sum_box.left = 240
$misc_sum_box.width = 143
$misc_sum_box.height = 30
$misc_sum_box.autosize = $true
$misc_sum_box.multiline = $true
$misc_sum_box.readonly = $true


# State tickbox (mac)
$state_checkbox_mac = new-object system.windows.forms.radiobutton
$state_checkbox_mac.location = '125, 720'
$state_checkbox_mac.size = '58, 20'
$state_checkbox_mac.text = "Mac"
$state_checkbox_mac.checked = $true
$state_checkbox_mac.backcolor = 'white'


# State tickbox (pc)
$state_checkbox_pc = new-object system.windows.forms.radiobutton
$state_checkbox_pc.location = '75, 720'
$state_checkbox_pc.size = '58, 20'
$state_checkbox_pc.text = "PC"
$state_checkbox_pc.checked = $false
$state_checkbox_pc.backcolor = 'white'


# -- render objects

$form.controls.add($input_box)
$form.controls.add($add_cost)
$form.controls.add($all_cost_box)
$form.controls.add($reset)
$form.controls.add($sum_box)
$form.controls.add($sum_button)
$form.controls.add($all_calculated_box)
$form.controls.add($misc_sum_box)
$form.controls.add($state_checkbox_mac)
$form.controls.add($state_checkbox_pc)