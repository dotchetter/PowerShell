foreach ($file in Get-ChildItem *.py)
{
    $content = Get-Content $file
    for ($row = 0; $row -lt $content.Count; $row++)
    {
        if ($content[$row].Trim() -match 'DEBUG')
        {
            $debugRow = ($row + 1)
            Write-Warning "DEBUG statement found in $file.Name, row $debugRow"
        }
    }
}