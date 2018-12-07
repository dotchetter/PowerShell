
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


# form loop object init
$form = new-object system.windows.forms.form
$form.width = 1280
$form.height = 768
$form.startposition = [system.windows.forms.formstartposition]::centerscreen
$form.autoscale = $true
$form.autosize = $true
$form.formborderstyle = "None"
$form.backcolor = 'white'


# welcome page picture
$img = [system.drawing.image]::Fromfile("$env:windir\System32\script\header2.png")

$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.width = 1280
$pictureBox.height = 768
$picturebox.left = 0
$picturebox.top = 0
$pictureBox.Image = $img
$form.controls.add($pictureBox)

# quit button 
$quit_btn = new-object system.windows.forms.button
$quit_btn.height = 100
$quit_btn.width = 300
$quit_btn.text = "Nej, avsluta"
$quit_btn.enabled = $true
$quit_btn.left = 700
$quit_btn.top = 530
$quit_btn.backcolor = "Lavender"
$quit_btn.font = "calibri"

# HDD clean button
$clean_btn = new-object system.windows.forms.button
$clean_btn.height = 100
$clean_btn.width = 300
$clean_btn.text = "Rensa hårddisken"
$clean_btn.enabled = $false
$clean_btn.left = 260 
$clean_btn.top = 530
$clean_btn.font = "calibri"


<# verifier checkbox - are you sure you want to quick erase?
this makes the quick erase button useable. #>
$verifier = new-object system.windows.forms.checkbox
$verifier.left = 260
$verifier.top = 650
$verifier.text = "Jag är säker"
$verifier.width = 250
$verifier.font = "calibri"

# done prompt
$ok_box_type = [system.windows.messageboxbutton]::Ok
$info_box_icon = [system.windows.messageboximage]::Information
$done_box_msg_body = "Rensningen är klar! Tryck OK för att stänga av datorn"
$done_box_title = "Klar!"

# error prompt
$error_box_type = [system.windows.messageboxbutton]::Error
$error_box_icon = [system.windows.messageboximage]::Error
$error_err_1 = "Ett fel har uppstått."
$error_err_2 = "Kontrollera att hårddisken fungerar och att den är inkopplad ordentligt."
$error_box_msg_body = ($err_1 + $err_2)
$error_box_title = "Ett fel uppstod!"

# working - prompt
$working_prompt = new-object system.windows.forms.label
$working_prompt.width = 500
$working_prompt.left = 520
$working_prompt.top = 680
$working_prompt.text = "Rensning pågår. Detta tar bara några sekunder..."
$working_prompt.Font = "calibri"
$working_prompt.Hide()

# render objects
$form.controls.add($clean_btn)
$form.controls.add($verifier)
$form.controls.add($quit_btn)
$form.controls.add($working_prompt)

# order objects
$working_prompt.bringtofront()
$clean_btn.bringtofront()
$quit_btn.bringtofront()
$verifier.bringtofront()

function done ($error) {

    if (-not $error) {
        $msg_box = [system.windows.messagebox]::Show($done_box_msg_body,$done_box_title,$ok_box_type,$info_box_icon)
    } else {
        $msg_box = [system.windows.messagebox]::Show($error_box_msg_body,$error_box_title,$error_box_type,$error_box_icon)
        $error > \err.l
    }
}

# event listeners:
# tickbox for verification listener
$verifier_box_tick = {
    if ($verifier.checked -eq $true) {
        $clean_btn.enabled = $true
        $clean_btn.backcolor = "lavender"
    } else {
        $clean_btn.enabled = $false
        $clean_btn.backcolor = "white"
    }
}

# harddrive clean button listener 
$clean_btn_click = {
    $clean_btn.enabled = $false
    $quit_btn.enabled = $false
    $clean_btn.backcolor = "white"
    $quit_btn.backcolor = "white"
    $working_prompt.show()
    $disk = get-disk | where -filterscript {$_.bustype -ne "USB"}
    $disk = $disk.number
    $clean_scr_pth = "$env:windir\System32\script\diskpart.dat"
    
    # generate diskpart script for physical disk detected
    {select disk $disk
    clean
    create par primary
    format quick fs ntfs
    clean
    exit} > "x:\windws\System32\script\diskpart.dat"
    start-process "cmd.exe" -argumentlist "/c diskpart.exe /s x:\windws\System32\script\diskpart.dat" -windowstyle hidden -wait
    done($error)
    wpeutil shutdown
}       

# quit button listener
$quit_btn_click = {
    wpeutil shutdown
}       

$clean_btn.add_click($clean_btn_click)
$quit_btn.add_click($quit_btn_click)
$verifier.add_click($verifier_box_tick)


# hide console window

function hideconsole
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0) #0 hide
}

# form loop
hideconsole
$null = $form.showdialog()