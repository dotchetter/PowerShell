# findf

#### Cmdlet for easier, faster-than-GUI and more responsive search for files or directories using the command line.

## About

I wrote **findf** in one night, because PowerShell. I just felt the need to create a new custom cmdlet that would let me search for files the way I like it; *in the terminal* - but still without the unnecessary line breaks, storage and editing information that comes with using **ls** or **Get-ChildItem** without a bunch of switches or piping. Ya know, sometimes you just want to find the file, or the **files** and be done with it.

I also realized the need for something that can be called by automation. What if you need to look over a volume every day and see if a certain file is still present that returns a bool? Or, maybe you need to do an inventory of all your .JPEG picture files on your computer but want to save the output in a serialized format, like JSON.

**findf** was the solution for this, where you can specify your query with a few easy command switches. 
It is so easy to use. For example, this command returns all .pdf files I have in my Documents folder:

```powershell
findf -Extension pdf -startDir $home\Documents
```

This command helped me locate nano.exe to create an environment variable for it. I had no Idea where it was, so I searched my entire C: volume for it, like this:

```powershell
cd \
findf nano.exe
```

... But I could just as well have wrtitten:

```
findf nano.exe -startDir C:\
```

This way you can export the path of every single .Mp4 file on a given volume to JSON:

```powershell
findf -Extension mp4 -startDir C:\ -toJson | Out-File .\MySongs.json
```



## Installation

**findf** is already a packed-and-done PowerShell module. To install it, follow these steps:

1. Create a folder on your desktop called **Findf**

2. download the .psm1 and psd1 files you see here, to the findf folder you just created

3. copy and paste this command in your PowerShell terminal:

   ```powershell
   Move-Item $home\desktop\Findf C:\Program Files\WindowsPowerShell\Modules
   ```

4. Close the terminal and re-open a new one. Try the command by typing **findf**. 

## Help

Help is included in the module, with exampes too. For help, type:

```powershell
Get-Help findf
```

For help with examples, type:

```powershell
Get-Help findf -examples
```

For the complete help, type:

```powershell
Get-Help findf -full
```

