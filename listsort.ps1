
# pedant - list sorting application
# source code for "pedant" - a list sorting app for name lists or lists of e-mail addresses.
# build #3.1.1
# using ps, visualbasic, windows forms
# developed by simon olofsson (dotchetter) 2018-09-04
# no warranty is issued for this software, source file being used nor the resulting outputfile in terms of data loss or modification. 
# if you do not accept the terms of this software, do not use the software.
# may the force be with you. 

[void][system.reflection.assembly]::loadwithpartialname("system.windows.forms") 
[void][system.reflection.assembly]::loadwithpartialname("microsoft.visualbasic")

# declaring window, button and other object variables:

$form = new-object system.windows.forms.form 
$fileselect = new-object system.windows.forms.button
$emailbutton = new-object system.windows.forms.button
$removemailbutton = new-object system.windows.forms.button
$gobutton = new-object system.windows.forms.button  
$textstr1 = new-object system.windows.forms.label
$textstr2 = new-object system.windows.forms.label
$textstr3 = new-object system.windows.forms.label
$textbox = new-object system.windows.forms.textbox
$selectedfilebox = new-object system.windows.forms.textbox
$selectedoutputfile = new-object system.windows.forms.textbox
$wshell = new-object -comobject wscript.shell
$destfilebutton = new-object system.windows.forms.button
$flushbutton = new-object system.windows.forms.button
$aboutbutton = new-object system.windows.forms.button
$beginningbutton = new-object system.windows.forms.button
$endingbutton = new-object system.windows.forms.button
$uniquecheckbox = new-object system.windows.forms.checkbox
$lowercasecheckbox = new-object system.windows.forms.checkbox

$global:trimstart = $null
$global:trimend = $null

## draw form:
function form {    

    $form.text = "Pedant v3.1.2" 
    $form.startposition = [system.windows.forms.formstartposition]::centerscreen
    $form.autosize = $true
    $form.height = 520
    $form.width = 250
    $form.autoscale = $true
    $form.autosize = $true
    $form.formborderstyle = "fixeddialog"
    $form.maximizebox = $false

    $textstr1.top = 35
    $textstr1.left = 59
    $textstr1.width = 200
    $textstr1.text = "Välj lista att behandla (.txt, .dat):" 

    $fileselect.text = "Bläddra"
    $fileselect.top = 65
    $fileselect.left = 40
    $fileselect.width = 200

    $selectedfilebox.top = 95
    $selectedfilebox.left = 40
    $selectedfilebox.width = 200
    $selectedfilebox.text = "               Du har inte valt något"
    $selectedfilebox.readonly = $true

    $textstr2.top = 135
    $textstr2.left = 40
    $textstr2.width = 230
    $textstr2.text = "Valfritt - lägg till/ta bort något på raderna:"

    $emailbutton.text = "Lägg till något" 
    $emailbutton.top = 160
    $emailbutton.left = 40
    $emailbutton.width = 100

    $removemailbutton.text = "Ta bort något"
    $removemailbutton.top = 160
    $removemailbutton.left = 142
    $removemailbutton.width = 98   

    $beginningbutton.text = "I början" 
    $beginningbutton.top = 192 
    $beginningbutton.left = 40
    $beginningbutton.width = 100
    $beginningbutton.enabled = $false     
    
    $endingbutton.text = "I slutet"
    $endingbutton.top = 192
    $endingbutton.left = 142
    $endingbutton.width = 98
    $endingbutton.enabled = $false

    $textbox.top = 220
    $textbox.left = 40
    $textbox.width = 200
    $textbox.readonly = $true
    $textbox.text = "                 Utgångsläge: Läge 1"

    $textstr3.top = 248
    $textstr3.left = 80
    $textstr3.width = 150
    $textstr3.text = "Välj destinationsmapp:"

    $destfilebutton.top = 268
    $destfilebutton.left = 40
    $destfilebutton.width = 200
    $destfilebutton.text = "Bläddra"

    $selectedoutputfile.top = 298
    $selectedoutputfile.left = 40
    $selectedoutputfile.width = 200
    $selectedoutputfile.text = "               Du har inte valt något"
    $selectedoutputfile.readonly = $true

    $gobutton.top = 338
    $gobutton.left = 40
    $gobutton.width = 200
    $gobutton.text = "Kör"
    $gobutton.enabled = $false

    $flushbutton.top = 368
    $flushbutton.left = 40
    $flushbutton.width = 200
    $flushbutton.text = "Nollställ"

    $aboutbutton.top = 398
    $aboutbutton.left = 40
    $aboutbutton.width = 200
    $aboutbutton.text = "Hjälp"


    $uniquecheckbox.top = 430
    $uniquecheckbox.left = 40
    $uniquecheckbox.text = "Unika värden"
    $uniquecheckbox.height = 30

    $lowercasecheckbox.top = 432
    $lowercasecheckbox.left = 175
    $lowercasecheckbox.text = "Gemener"

#draw objects on form

    $form.controls.add($lowercasecheckbox)
    $form.controls.add($uniquecheckbox)
    $form.controls.add($endingbutton)
    $form.controls.add($beginningbutton)
    $form.controls.add($flushbutton)
    $form.controls.add($selectedoutputfile)
    $form.controls.add($destfilebutton)
    $form.controls.add($textstr1)
    $form.controls.add($textstr2)
    $form.controls.add($textstr3)
    $form.controls.add($fileselect)
    $form.controls.add($emailbutton) 
    $form.controls.add($textbox)
    $form.controls.add($gobutton)
    $form.controls.add($selectedfilebox)
    $form.controls.add($removemailbutton)
    $form.controls.add($aboutbutton)

}

# browse for inputfile -button
$fileselect_click = {

function get-filename($initialdirectory) {

    [system.reflection.assembly]::loadwithpartialname("system.windows.forms") | out-null
    
    $openfiledialog = new-object system.windows.forms.openfiledialog
    $openfiledialog.initialdirectory = $initialdirectory
    $openfiledialog.filter = "textfil (*.txt)| *.txt|dat-fil (*.dat)| *.dat"
    $openfiledialog.showdialog() | out-null
    $openfiledialog.filename
   
    }

    $global:inputfile = get-filename "$env:userprofile"
    $global:inputdata = get-content $global:inputfile | foreach {$_.trimend()} | where {$_ -ne ""}
    $selectedfilebox.text = $global:inputfile
}
$fileselect.add_click($fileselect_click)
 
# add something to the list -button
$emailbutton_click = {

    $global:removetext = $null
    $global:enteredtext =
        
    [microsoft.visualbasic.interaction]::inputbox( 
    "Ange något du vill ska läggas till för varje rad i listan.`n`n##Läge 1##`n`nOm du anger något och sedan kör Pedant, kommer sorteringen ske i Läge 1 och det du anger kommer då läggas till på slutet av varje rad. Se 'Hjälp' för detaljer.`n`n## Läge 4 ##`n`nDet du anger här kommer läggas till i listan antingen i början eller i slutet för varje rad beroende på vad du har valt.`n`nInga andra åtgärder vidtas automatiskt.`n`nOm du vill utföra en kombination av ändringar på en fil,`nkör Pedant igen på den behandlade filen med nya val.`n`n", "Pedant - Lägg till något i listan", "",  
    $form.left + 50, $form.top + 50        
    )     
    if($global:enteredtext.length -gt 0) {

        $global:addsomething = $true
        $global:removesomething = $false
        $beginningbutton.enabled = $true
        $endingbutton.enabled = $true
        $textbox.text = "Läge 2: ''$global:enteredtext'' läggs till"
        $global:domain = $global:enteredtext
    }
} 
$emailbutton.add_click($emailbutton_click)

# remove something from the list -button
$removemailbutton_click = {

    $global:domain = $null
    $global:removetext = 
  
    [microsoft.visualbasic.interaction]::inputbox(
    "Ange vad du vill radera i varje rad i listan `n`n## Läge 3 ##`n`nI detta läge raderas det du anger ÖVERALLT i listan. Utöver det byts [punkt] ut till [mellanslag] automatiskt. Detta för att kunna skapa en`nnamnlista av till exempel e-post listor.`n`nVill du endast ta bort alla [punkt] eller [mellanslag] ur listan? Skriv i så fall en punkt eller ett mellanslag nedan.`n`n## Läge 4 ##`n`nI detta läge raderas endast det du anger antingen i början eller i slutet för varje rad beroende på vad du har valt. Inga andra åtgärder vidtas automatiskt.`n`nVIKTIGT! Detta läge är skiftlägeskänsligt vilket innebär att du måste ange stor bokstav, eller liten bokstav beroende på vad du vill ta bort.`n`nOm du vill utföra en kombination`nav ändringar på en fil, kör Pedant igen på den behandlade filen med nya val.`n`n", "Pedant - Ta bort något ur listan", "",
    $form.left + 50, $form.top + 50
    )
    if ($global:removetext.length -gt 0) {
        
        $global:addsomething = $false
        $global:removesomething = $true
        $beginningbutton.enabled = $true
        $endingbutton.enabled = $true
        
            if (-not $global.gobutton.text -eq "Utför Nollställning") {
                $global:gobutton.enabled = $true
            }
            $textbox.text = "Läge 3: Alla ''$global:removetext'' raderas"
    }
    
    if ($global:removetext -eq ".") {
        $global:removetext = "\."
        $textbox.text = "Läge 3: Punkter ersätts med mellanslag"
    }
        else {
            if ($global:removetext -eq " ") {
                $textbox.text = "Läge 3: Alla mellanslag raderas"
        }
    }
}
$removemailbutton.add_click($removemailbutton_click)

# beginningbutton
# button clicked if user wants to append the first character of every iterated string

$beginningbutton_click = {

    $global:trimstart = $true
    if ($global:removesomething -eq $true) {
        $textbox.text = "Läge 4: ''$global:removetext'' raderas i början"
    }
    else {
        if ($global:addsomething -eq $true) {
        $textbox.text = "Läge 4: ''$global:enteredtext'' läggs till i början "
        }
    }
}
$beginningbutton.add_click($beginningbutton_click)

# ending button
# button clicked if user wants to append the last character of every iterated string 

$endingbutton_click = {
 
    $global:trimend = $true
    if ($global:removesomething -eq $true) {
        $textbox.text = "Läge 4: ''$global:removetext'' raderas i slutet"
    }
    else {
        if ($global:addsomething -eq $true) {
            $textbox.text = "Läge 4: ''$global:enteredtext'' läggs till i slutet"
        }
    }
}
$endingbutton.add_click($endingbutton_click)

#destination file browse button
$destfilebutton_click = {
    
    function get-foldername($initialdirectory) {
    [system.reflection.assembly]::loadwithpartialname("system.windows.forms") | out-null
    $openfolderdialog = new-object system.windows.forms.folderbrowserdialog
    $openfolderdialog.showdialog() | out-null
    return $openfolderdialog.selectedpath
    }
    $global:outputfile = get-foldername
    $selectedoutputfile.text = $global:outputfile
    if ($selectedoutputfile.length -gt 0 -and $selectedfilebox.length -gt 0) {
        $gobutton.enabled = $true
    }
}
$destfilebutton.add_click($destfilebutton_click)

# go button
# function will resize every row in the in put file to lower case letters. if the "remove text" option is set by user by entering a value, 
# the first if statement below will only perform certain replace actions as to create a namelist from a list of e-mail adresses. 

$gobutton_click = {

    $global:namelist = $global:inputdata
    
    if ($uniquecheckbox.checked) {
        $global:namelist = $global:namelist | sort-Object -Unique
    }
    if ($lowercasecheckbox.checked -eq $true) {
        $global:namelist = $global:namelist.tolower()
    }

    # if user wants to remove text and not beginning or ending is defined
    if ($global:removetext.length -gt 0 -and $global:trimend -eq $false -and $global:trimstart -eq $false) {      
       
        foreach ($data in $global:namelist) {
       
            $data = $data -replace "\.", " "
            $data = $data -replace $global:removetext, ""
            $parsed = $parsed + $data + "`r`n"
        }
        $parsed > $global:outputfile\pedant.txt
        $data = $null
        $global:namelist = $null
        $wshell.popup("Filen finns här: $global:outputfile ",0,"Klar!",0x1)
    }
        # if user wants to remove text and in beginning is clicked:
        elseif ($global:removetext.length -gt 0 -and $global:trimstart -eq $true) {
            foreach ($data in $global:namelist) {
            
                $data = $data.trimstart($global:removetext)
                $parsed += $data + "`r`n"
            } 
            
            $parsed > $global:outputfile\pedant.txt
            $beginningbutton.enabled = $false
            $endingbutton.enabled = $false
            $wshell.popup("Filen finns här: $global:outputfile ",0,"Klar!",0x1)
        }
        # if user wants to remove something in the end of the file
        elseif ($global:removetext.length -gt 0 -and $global:trimend -eq $true) {
            foreach ($data in $global:namelist) {
                $data = $data.trimend($global:removetext)
                $parsed += $data + "`r`n"
            }
            
            $parsed > $global:outputfile\pedant.txt
            $beginningbutton.enabled = $false
            $endingbutton.enabled = $false
            $wshell.popup("Filen finns här: $global:outputfile ",0,"Klar!",0x1)
        }   
        # if user wants to add something in the beginning of the file
        elseif ($global:enteredtext.length -gt 0 -and $global:trimstart -eq $true) {
            foreach ($data in $global:namelist) {
            
                $data = $global:enteredtext + $data 
                $parsed += $data + "`r`n"
            }
            
            $parsed > $global:outputfile\pedant.txt
            $data = $null
            $gobutton.enabled = $false
            $gobutton.text = "Utför Nollställning"
            $beginningbutton.enabled = $false
            $endingbutton.enabled = $false
            $global:namelist = $null
            $wshell.popup("Filen finns här: $global:outputfile ",0,"Klar!",0x1)
        }
        # if user wants to add something in the end of the file
        elseif ($global:enteredtext.length -gt 0 -and $global:trimend -eq $true) {
            foreach ($data in $global:namelist) {
                $data = $data + $global:enteredtext 
                $parsed += $data + "`r`n"
            }

            $parsed > $global:outputfile\pedant.txt
            $data = $null
            $global:removetext = $null
            $global:domain = $null
            $beginningbutton.enabled = $false
            $endingbutton.enabled = $false
            $global:namelist = $null
            $wshell.popup("Filen finns här: $global:outputfile ",0,"Klar!",0x1)
    }
    else {
       # general function, sorts lists in mode 1 and 2
        foreach ($data in $global:namelist) {

            $data = $data -replace "ü","u"
            $data = $data -replace "ÿ","y"
            $data = $data -replace "ú","u"
            $data = $data -replace "ë","e"
            $data = $data -replace "ý","y"
            $data = $data -replace "è","e"
            $data = $data -replace "û","u"
            $data = $data -replace "ï","i"
            $data = $data -replace "å","a"
            $data = $data -replace "ä","a"
            $data = $data -replace "ö","o"
            $data = $data -replace "é","e"
            $data = $data -replace "è","e"
            $data = $data -replace "á","a"
            $data = $data -replace "ó","o"
            $data = $data -replace " ","."

            $parsed = $parsed + $data + $global:domain
            $parsed += "`r`n"
        }
            $parsed > $global:outputfile\pedant.txt
        
        $data = $null
        $global:namelist = $null
        $wshell.popup("Filen finns här: $global:outputfile ",0,"Klar!",0x1)
    }
    $global:inputfile = $null
    $gobutton.enabled = $false
    $fileselect.enabled = $false
    $gobutton.text = "Utför Nollställning"

}
$gobutton.add_click($gobutton_click)

# reset button
# this button refreshes every entry in the app, to start over on a new file. 
# the go button is disabled as per the entry variables $selectedfilebox and $selectedoutputfile are no longer declared. 
# names and entries are flushed, and textboxes revert to showing '          du har inte valt något'. 

$flushbutton_click = {

    $fileselect.enabled = $true
    $beginningbutton.enabled = $false 
    $endingbutton.enabled = $false
    $global:trimstart = $false
    $global:trimend = $false
    $gobutton.enabled = $false
    $global:domain = $null
    $global:namelist = $null
    $global:removetext = $null
    $global:outputfile = $null
    $selectedoutputfile.text = "               Du har inte valt något"
    $selectedfilebox.text = "               Du har inte valt något"
    $data = $null
    $global:enteredtext = $null
    $textbox.text = "                 Utgångsläge: Läge 1"
    $gobutton.text = "Kör"
}

$flushbutton.add_click($flushbutton_click)
$aboutbutton_click = {

    $wshell.popup("Pedant är en app för listsortering.`nPedant har 4 lägen. Det huvudsakliga syftet är att hantera långa listor`nmed antingen namn eller e-post adresser för att sedan formatera dem till önskat läge. Filen sparas i vald mapp vid namn ''pedant.txt'' och skrivs över om Pedant körs igen.`n`n ## Läge 1 ##`nLäge 1 är utgångsläget i pedant.`nPedant kommer återgå till läge 1 efter nollställning.`nExempelvis har man en lista som innehåller namn med formatet [förnamn efternamn].`nOm man sedan kör pedant sparas den nya filen med: `n`n- Icke ascii tecken (som å, ä, ö, ü, ¨y,) ersätts med (a, a, o, u,) osv. `n`n- Tecken med apostrof raderas och byts ut mot neutrala tecken`n- [mellanslag] ersätts med [punkt]`n- Listan byggs upp alfabetiskt i sorteringen. `n`** Exempel:`n Göran Åberg blir goran.aberg `n`n ## Läge 2 ##`nTryck på knappen ''lägg till något''. Pedant lägger till detta värdet på varje rad i hela listan. Listan kommer sorteras med samma regler som läge 1. `n`** exempel:`nVälj att lägga till @domain.com i pedant. Ürban Pålsson blir urban.palsson@domain.com`n`n## Läge 3 ##`nTryck på knappen ''ta bort något''.`nObs! Pedant kommer endast att byta ut [punkt] till [mellanslag] och radera det önskade värdet för varje rad.`nDetta läge är lämpligt om man vill skapa en ren namnlista av en lista med e-post adresser. `n`** Exempel:`n Välj att radera @test.se i pedant. namn.efternamn@test.se blir`nnamn efternamn`n`n## Läge 4 ##`nI läge 4 har du endast valt att radera, eller lägga till något i antingen början av varje rad, eller i slutet av varje rad. Inga andra förändringar sker med listan.`nOBS! 'Ta bort något' är skiftlägeskänsligt. Ange en stor eller liten bokstav beroende på vad du vill ta bort.`n`nOm Pedant:`n`nPedant är utvecklat i PowerShell 5.1 av Simon Olofsson för Advania Sverige. Mjukvaran omfattas inte av några garantier av vare sig behandlad data eller ursprunglig data. Buggar eller andra önskemål rapporteras till dotchetter@protonmail.ch`n`n2018-08 build 3.1.2",0,"Pedant - Hjälp",0x1)
}
$aboutbutton.add_click($aboutbutton_click)

form
$form.showdialog()

# flush variables
$data = $null
$global:namelist = $null
$global:removetext = $null