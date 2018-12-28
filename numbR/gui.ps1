
# load frameworks

[void][system.reflection.assembly]::loadwithpartialname("system.windows.forms") 
[void][system.reflection.assembly]::loadwithpartialname("microsoft.visualbasic")
add-type -AssemblyName PresentationCore,PresentationFramework
add-Type -name window -namespace console -memberdefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

# background image in form
$bg_img = [system.drawing.image]::fromfile("$env:userprofile\git\powershell\numbR\meta\bg_2.png")


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
$input_box.top = 150
$input_box.left = 75
$input_box.width = 300


# 'add cost' button
$add_cost = new-object system.windows.forms.button
$add_cost.top = 185
$add_cost.left = 75
$add_cost.width = 300
$add_cost.height = 30
$add_cost.text = 'lägg till'


# reset application button
$reset = new-object system.windows.forms.button
$reset.top = 218
$reset.left = 75
$reset.width = 300
$reset.height = 30
$reset.text = 'nollställ'


# incremental list with all objects
$all_cost_box = new-object system.windows.forms.listbox
$all_cost_box.top = 280
$all_cost_box.left = 75
$all_cost_box.width = 145
$all_cost_box.height = 300
$all_cost_box.selectionmode = "multiextended"


# incremental list with calculated objects
$all_calculated_box = new-object system.windows.forms.listbox
$all_calculated_box.top = 280
$all_calculated_box.left = 228
$all_calculated_box.width = 145
$all_calculated_box.height = 300
$all_calculated_box.selectionmode = "multiextended"


# calculate button
$sum_button = new-object system.windows.forms.button
$sum_button.top = 590
$sum_button.left = 74
$sum_button.width = 300
$sum_button.text = 'beräkna'
$sum_button.height = 30


# Left pane sum box
$sum_box = new-object system.windows.forms.textbox
$sum_box.top = 650
$sum_box.left = 75
$sum_box.width = 143
$sum_box.height = 30
$sum_box.autosize = $true
$sum_box.multiline = $true
$sum_box.readonly = $true


# Right pane sum box with miscellaneous (freight, shipping)
$misc_sum_box = new-object system.windows.forms.textbox
$misc_sum_box.top = 650
$misc_sum_box.left = 230
$misc_sum_box.width = 143
$misc_sum_box.height = 30
$misc_sum_box.autosize = $true
$misc_sum_box.multiline = $true
$misc_sum_box.readonly = $true


# state tickbox (mac)
$state_checkbox_mac = new-object system.windows.forms.radiobutton
$state_checkbox_mac.location = '75, 700'
$state_checkbox_mac.size = '58, 20'
$state_checkbox_mac.text = "Mac"
$state_checkbox_mac.checked = $true
$state_checkbox_mac.backcolor = 'white'


# state tickbox (pc)
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