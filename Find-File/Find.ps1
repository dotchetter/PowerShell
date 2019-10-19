<# 
$author = Simon Olofsson
$date = 2019-10-18 

.Description
 Simplified file search from the commandline. Returns full path for every found
 file object in search. 
.Parameter startDir
 The directory in which to traverse from. (Where to start the search)
.Parameter Name
 The name of the file you are looking for.
.Parameter Extension
 Get the output in a JSON array format
.Parameter Path
 If ToFile is specified, this is mandatory. Provide a path where you want the output file.
.Example
 # Run the script and get output in the console
 Get-Recentuser -PathToGam C:\Gam\gam.exe
.Example
 # Run the script and get output in a hashtable
 $foo = Get-Recentuser -PathToGam C:\Gam\gam.exe 
.Example
 # Run the script and get output as a local file
 Get-Recentuser -PathToGam C:\Gam\gam.exe -ToFile -Path $home\Documents
.Example
 # Run the script and mitigate 'UnmanagedUser' data with -Override
 Get-Recentuser -PathToGam C:\Gam\gam.exe -override
.Link 
 https://github.com/jay0lee/GAM  
#>
param(
    [Parameter(Position = 0)]
    [String]$Name,
    
    [Parameter(Position = 1)]
    [String]$startDir,
    
    [Parameter(Mandatory = $false)]
    [String]$Extension,
    
    [Parameter(Mandatory = $false)]
    [Switch]$toJson
)

if (-not $Name -and -not $Extension)
{
    Write-Warning "You must provide either file name or extension. Try Get Help | Find.ps1 for help."
    break
}
elseif (-not $startDir)
{
    $startDir = $PSScriptRoot
}


$foundFiles = @()

if ($Extension -or $Name)
{
    Write-Host "Searching $startDir structure..." -ForeGroundColor Yellow
}

if ($Extension) 
{    
    foreach ($Item in Get-ChildItem "$startDir" -Recurse -ErrorAction SilentlyContinue -Force)
    {
        if ($Item.Extension -match $Extension)
        {
            $foundFiles += $Item.FullName
        }
    }
}
elseif ($Name) 
{
    foreach ($Item in Get-ChildItem "$startDir\$Name" -Recurse -ErrorAction SilentlyContinue -Force) 
    {
        $foundFiles += $Item.FullName
    }
}


if ($foundFiles.Count -eq 0)
{
    $Output = @("No files found matching criteria")
}
else
{
    $Output = $foundFiles
}


if ($toJson)
{
    $Output | ConvertTo-Json
}
else 
{   
    Write-Host Found $Output.Count "item(s):" -ForeGroundColor Green
    for ($i = 0; $i -lt $Output.Count; $i++)
    {
        Write-Host $Output[$i] -ForeGroundColor Yellow
    }
}