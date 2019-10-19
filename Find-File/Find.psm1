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
 
.Parameter toJson
 Returns a JSON array with all matched items for the search.
 
.Parameter toBool
 Returns no other output than a Boolean to indicate whether one or more items were found.
 
.Example
 # Find all Python files for all subfolders below C:\Users
 find -Extension 'py' -startDir 'C:\Users'
 
.Example
 # Find all files and folders with 'this' as its name under C:\Users
 find -Name 'this' -startDir 'C:\Users'
 
.Example
 # Return whether any match was found on this search at all or not
 find -Name 'My Precious file' -startDir $home -toBool
 
.Example
 # Get all .dat files in CURRENT directory in a JSON array
 find -Extension 'dat' -toJson 
 
.Link 
 https://github.com/jay0lee/GAM  
#>

Function Find
{
    param(
        [Parameter(Position = 0)]
        [String]$Name,
        
        [Parameter(Position = 1)]
        [String]$startDir,
        
        [Parameter(Mandatory = $false)]
        [String]$Extension,
        
        [Parameter(Mandatory = $false)]
        [Switch]$toJson,

        [Parameter(Mandatory = $false)]
        [Switch]$toBool
    )
    if (-not $Name -and -not $Extension)
    {
        Write-Warning "You must provide either file name or extension. Try Get Help | Find.ps1 for help."
        break
    }
    elseif (-not $startDir)
    {
        $startDir = $PWD.Path
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
    
    $Output = $foundFiles
       
    if ($toJson)
    {
        $Output | ConvertTo-Json
    }
    elseif ($toBool)
    {
        if ($Output.Count -gt 0)
        {
            return $true    
        }
        return $false
    }
    else
    {   
        Write-Host Found $Output.Count "item(s):" -ForeGroundColor Yellow
        for ($i = 0; $i -lt $Output.Count; $i++)
        {
            Write-Host $Output[$i] -ForeGroundColor Green
        }
    }
}
Export-ModuleMember -Function * -Alias * -Variable *