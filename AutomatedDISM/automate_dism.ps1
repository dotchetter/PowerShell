# Softare purpose: Bootable image deployment environment

<# 
$author = 'Simon Olofsson'
2019-02-25 Advania Sverige AB
This source code is not for public use. Any attempts to modify,
reverse-engineer or otherwise tamper with this software is strictly
prohibited. 
#>


# load assemblies
[void][system.reflection.assembly]::loadwithpartialname("system.windows.forms")
add-type -AssemblyName PresentationCore,PresentationFramework
add-Type -name window -namespace console -memberdefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

# form loop object init
$form = new-object system.windows.forms.form
$form.autoscale = $true
$form.autosize = $true
$form.formborderstyle = "none"

# welcome page picture
$img = [system.drawing.image]::fromfile("x:\windows\System32\scripts\header1.png")
$form.startposition = [system.windows.forms.formstartposition]::centerscreen
$form.backgroundimage = $img
$form.backgroundimagelayout = 'center'
$form.width = ($img.width)
$form.height = ($img.height)

# HP 430 G5 button
$hp_430_btn = new-object system.windows.forms.button
$hp_430_btn.height = 50
$hp_430_btn.width = 300
$hp_430_btn.text = "HP 430 G5"
$hp_430_btn.enabled = $true
$hp_430_btn.left = ($img.width / 2.6)
$hp_430_btn.top = 300
$hp_430_btn.backcolor = $form.backcolor
$hp_430_btn.flatstyle = 'flat'
$hp_430_btn.backcolor = '40,40,40'
$hp_430_btn.forecolor = 'white'

# HP X360 11 G1 EE button
$hp_x360_btn = new-object system.windows.forms.button
$hp_x360_btn.height = 50
$hp_x360_btn.width = 300
$hp_x360_btn.text = "HP x360"
$hp_x360_btn.left = ($img.width / 2.6)
$hp_x360_btn.top = 400
$hp_x360_btn.backcolor = $form.backcolor
$hp_x360_btn.flatstyle = 'flat'
$hp_x360_btn.backcolor = '40,40,40'
$hp_x360_btn.forecolor = 'white'

# Create shell object to send keystrokes, used to switch active window during deployment
$shellobj = new-object -com "wscript.shell"

# render objects
$form.controls.addrange(@(
    $hp_430_btn,
    $hp_x360_btn
    )
)


# If the x360 is selected
$hp_x360_btn_click = {
    
    # Change wallpaper with updated prompt
    $img = [system.drawing.image]::fromfile("x:\windows\System32\scripts\header2.png")
    $form.backgroundimage = $img

    # Hide buttons after click
    $hp_430_btn.hide()
    $hp_x360_btn.hide()
    # Get the volume letter with the image files in a string variable
    [string]$letter = get_payloadletter
    
    # Partition the disk
    start-process -wait -windowstyle hidden "x:\windows\system32\scripts\diskpart_init.exe"
    $image = "$letter" + ":\HPProBookX360-JKPG.wim"
    
    # Deploy image on the system
    deploy_image $image
    
    # Call create_boot_files function
    create_boot_files
    
    done($error)
}

# If the hp 430 is selected
$hp_430_btn_click = {
    
    # Change wallpaper with updated prompt
    $img = [system.drawing.image]::fromfile("x:\windows\System32\scripts\header2.png")
    $form.backgroundimage = $img
    
    # Hide buttons after click
    $hp_430_btn.hide()
    $hp_x360_btn.hide()
    # Get the volume letter with the image files in a string variable
    [string]$letter = get_payloadletter
   
    # Partition the disk
    start-process -wait -windowstyle hidden "x:\windows\system32\scripts\diskpart_init.exe"
    $image = "$letter" + ":\HPProBook430G5-JKPG.wim"
    
    # Deploy image on the system
    deploy_image $image
    
    # Call create_boot_files function
    create_boot_files
    
    done($error)
}

# Add click listeners
$hp_430_btn.add_click($hp_430_btn_click)
$hp_x360_btn.add_click($hp_x360_btn_click)


function get_payloadletter() {
    # Return the volume letter where the image is located
    $letters = @()
    $volumes = get-volume
    
    # Build array with available driveletters
    foreach ($i in $volumes) {
        $letters += $i.driveletter
    }

    # Iterate and try to find the volume with images
    foreach ($i in $letters) {
        $path = $i + ":\id.dat"
        if (test-path $path) {
            return $i
        }
    }
}

function deploy_image($image) {
    # Deploy the image on the system
    expand-windowsimage -imagepath $image -applypath "w:\" -Index 1
    $shellobj.sendkeys("%{TAB}")
}

function create_boot_files() {
    # Create boot files on the local machine after image deployment
    try {
        bcdboot W:\Windows /S S: /f all
    } catch {
        user_prompt 'image'
    }
}

function done ($error) {
    if (-not $error) {
        [console]::beep(3000,100);[console]::beep(800,50)
        [console]::beep(3000,100);[console]::beep(800,50)
    } else {
        user_prompt 'image'
    }
    wpeutil shutdown
}

function user_prompt($trigger) {
    <# Handle errors or information and prompt user with messagebox. #>
    switch  ($trigger) {
        'image' {$msg_body =
            'Ett fel har uppstått med image distribution. Datorn kan inte anses' +
            'som leveransklar. Detta vet vi:' + "`n`n$error"
            }
        }
  
    [windows.forms.messagebox]::show("$msg_body", "Error",
    [windows.forms.messageboxbuttons]::Ok, [windows.forms.messageboxicon]::$type)
    $error.clear()
}

$form.showdialog() | out-null
