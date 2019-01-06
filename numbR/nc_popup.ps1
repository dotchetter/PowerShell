<# Separate module for application NumbR. 
module purpose: Popup form prompting user to enter name of 
new customer. The name is returned as string, and new JSON file 
is created with this name. #>

$inputprompt = new-object system.windows.forms.form
$inputprompt.text = 'Spara ny kund'
$inputprompt.size = '400,200'
$inputprompt.formborderstyle = 'fixedsingle'
$inputprompt.maximizebox = $false
$inputprompt.font = 'segoe ui, 11'
$inputprompt.backcolor = 'white'
$inputprompt.topmost = $true
$inputprompt.startposition = 'centerscreen'
$inputprompt.icon = $icon

$done_button = new-object system.windows.forms.button
$done_button.location = '120,120'
$done_button.size = '75,30'
$done_button.text = 'Spara'
$done_button.dialogresult = [system.windows.forms.dialogresult]::ok
$inputprompt.acceptbutton = $done_button

$cancel_button = new-object system.windows.forms.button
$cancel_button.location = '200,120'
$cancel_button.text = 'Avbryt'
$cancel_button.size = '75,30'
$cancel_button.dialogresult = [system.windows.forms.dialogresult]::cancel
$inputprompt.cancelbutton = $cancel_button

$text_label = new-object system.windows.forms.label
$text_label.location = '132,25'
$text_label.size = '200,20'
$text_label.backcolor = 'white'
$text_label.text = 'Vad heter kunden?'

$new_customer_input = new-object system.windows.forms.textbox
$new_customer_input.location = '65,70'
$new_customer_input.size = '260,20'


$inputprompt.controls.addrange(@(
    $done_button, $cancel_button,
    $text_label, $new_customer_input))

$inputprompt.add_shown({$text_label.select()})