
function Find 
{
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $startDir,
        
        [Parameter(Mandatory = $false)]
        [String]
        $fileName,

        [Parameter(Mandatory = $false)]
        [System.ValueType]
        $Extension,

        [Parameter(Mandatory = $false)]
        [System.ValueType]
        $CreationTime,

        [Parameter(Mandatory = $false)]
        [System.ValueType]
        $LastEditedTime,

        [Parameter(Mandatory = $false)]
        [System.ValueType]
        $LastAccessTime,
    )

    $foundFiles = @()
    
    if ($Extension) 
    {
        foreach ($Item in Get-ChildItem "$startDir")
        {
            if ($Item.Extension -eq $Extension)
            {
                foundFiles += $Item
            }
        }
    }
    elseif ($fileName) 
    {
        foreach ($Item in Get-ChildItem "$startDir\$fileName" -Recurse -ErrorAction SilentlyContinue) 
        {
            $foundFiles += $Item
        }
    }

    $foundFiles
}