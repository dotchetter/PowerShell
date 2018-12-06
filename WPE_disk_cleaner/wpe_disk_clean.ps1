
# load frameworks
[void][system.reflection.assembly]::loadwithpartialname("system.windows.forms") 
[void][system.reflection.assembly]::loadwithpartialname("microsoft.visualbasic")
add-type -AssemblyName PresentationCore,PresentationFramework

# evaluate the resolution of the monitor for calculation of object placement
$monitor_height = get-wmiobject -Class Win32_DesktopMonitor | 
select-object ScreenHeight -ExpandProperty Screenheight
$monitor_width =  get-wmiobject -Class Win32_DesktopMonitor | 
select-object Screenwidth -ExpandProperty Screenwidth

# form loop object init
$form = new-object system.windows.forms.form 

# welcome page picture
$img = [system.drawing.image]::Fromfile('C:\Users\siolo001.CAPERIO\Git\PowerShell\WPE_disk_cleaner\header2.png')

$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Width = $img.Size.Width
$pictureBox.Height = $img.Size.Height
$pictureBox.Image = $img
$picturebox.left = ($monitor_width / 8) #- 600
$pictureBox.top = ($monitor_height / 8) #- 300
$form.controls.add($pictureBox)

# quit button 
$quit_btn = new-object system.windows.forms.button
$quit_btn_x = ($monitor_width / 2) + 175
$quit_btn_y = ($monitor_height / 2) + 280
$quit_btn.left = $quit_btn_x
$quit_btn.top = $quit_btn_y
$quit_btn.height = 100
$quit_btn.width = 300
$quit_btn.text = "Nej, avsluta"
$quit_btn.enabled = $true

# HDD clean button
$clean_btn = new-object system.windows.forms.button
$clean_btn_x = ($monitor_width / 2) - 505
$clean_btn_y = ($monitor_height / 2) + 280
$clean_btn.left = $clean_btn_x
$clean_btn.top = $clean_btn_y
$clean_btn.width = 300
$clean_btn.height = 100
$clean_btn.text = "Rensa hårddisken"
$clean_btn.enabled = $false


<# verifier checkbox - are you sure you want to quick erase?
this makes the quick erase button useable. #>
$verifier = new-object system.windows.forms.checkbox
$verifier.left = $clean_btn_x
$verifier.top = ($clean_btn_y + 120)
$verifier.text = "Ja, jag vill rensa hårddisken"
$verifier.width = 200

function done ($error) {

    if (-not $error) {
        $box_type = [system.windows.messageboxbutton]::Ok
        $box_icon = [system.windows.messageboximage]::Information
        $box_msg_body = "Rensningen är klar! Tryck OK för att stänga av datorn"
        $box_title = "Klar!"
        $msg_box = [system.windows.messagebox]::Show($box_msg_body,$box_title,$box_type,$box_icon)
    } else {
        $box_type = [system.windows.messageboxbutton]::Ok
        $box_icon = [system.windows.messageboximage]::Error
        $box_msg_body = "Ett fel har uppstått. Kontrollera att hårddisken
                        fungerar och att den är inkopplad ordentligt."
        $box_title = "Ett fel uppstod!"
        $msg_box = [system.windows.messagebox]::Show($box_msg_body,$box_title,$box_type,$box_icon)
    }
}
function form() {    
 
    $form.startposition = [system.windows.forms.formstartposition]::centerscreen
    $form.autosize = $true
    $form.autoscale = $true
    $form.autosize = $true
    $form.formborderstyle = "None"
    $form.MaximizeBox = $true
    $form.WindowState = "Maximized"
    $form.backcolor = 'white'
    $form.controls.add($clean_btn)
    $form.controls.add($verifier)
    $form.controls.add($quit_btn)
    
    #order objects
    $clean_btn.BringToFront()
    $quit_btn.BringToFront()
    $verifier.BringToFront()
}

# event listeners:
# tickbox for verification listener
$verifier_box_tick = {
    if ($verifier.checked -eq $true) {
        $clean_btn.enabled = $true
    } else {
        $clean_btn.enabled = $false
    }
}

# harddrive clean button listener 
$clean_btn_click = {    
    $disk = get-disk | where -filterscript {$_.bustype -ne "USB"}
    $disk = $disk.number
    clear-disk -number $disk -removedata -removeoem -confirm:$false
    done($error)
    stop-process -name "*powershell*"
    wpeutil shutdown
}       

# quit button listener
$quit_btn_click = {
    stop-process -name "*powershell*"
    wpeutil shutdown
}       

$clean_btn.add_click($clean_btn_click)
$quit_btn.add_click($quit_btn_click)
$verifier.add_click($verifier_box_tick)

# form loop
form
$form.showdialog()