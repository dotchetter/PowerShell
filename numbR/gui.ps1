
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


# global variables
$multi_x = 1.4
$multi_y = 1.2



# GUI form properties
$font = new-object system.drawing.font("calibri", 12)
$form = new-object system.windows.forms.form
$form.font = $font
$form.topmost = $true
$form.width = 800
$form.height = 800
$form.autosize = $true



# input price box
$input_box = new-object system.windows.forms.textbox
$input_box.autosize = $true
$input_box.top = 65
$input_box.left = 55
$input_box.width = 250



# 'add cost' button
$add_cost = new-object system.windows.forms.button
$add_cost.top = 100
$add_cost.left = 55
$add_cost.width = 250
$add_cost.height = 30
$add_cost.text = 'lägg till'



# reset application button
$reset = new-object system.windows.forms.button
$reset.top = 680
$reset.left = 55
$reset.width = 250
$reset.height = 30
$reset.text = 'nollställ'



# incremental box with all objects
$all_cost_box = new-object system.windows.forms.textbox
$all_cost_box.multiline = $true
$all_cost_box.readonly = $true
$all_cost_box.top = 160
$all_cost_box.left = 55
$all_cost_box.width = 250
$all_cost_box.height = 450
$all_cost_box.text = $null



# sum box
$sum_box = new-object system.windows.forms.textbox
$sum_box.autosize = $true
$sum_box.readonly = $true
$sum_box.top = 615
$sum_box.left = 55
$sum_box.width = 250



# sum button
$sum_button = new-object system.windows.forms.button
$sum_button.top = 645
$sum_button.left = 55
$sum_button.width = 250
$sum_button.text = 'beräkna'
$sum_button.height = 30



# -- render objects
$form.controls.add($input_box)
$form.controls.add($add_cost)
$form.controls.add($all_cost_box)
$form.controls.add($reset)
$form.controls.add($sum_box)
$form.controls.add($sum_button)