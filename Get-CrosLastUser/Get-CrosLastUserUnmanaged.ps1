# Current date in string format
$date = Get-Date -Format 'yyyy-MM-dd'
# Counter variable for progressbar
$count = 0
# Parse file containing device ID's
$devices = get-content ".\UnmanagedDevices_to_query.dat"
# Length variable for progressbar
$len = $devices.count
# Hashtable to append to
$output = @{}
# Iterate through the list of device ID's and get data for every device
foreach ($i in $devices) {
    $q = gam info cros $i recentusers serialnumber
    foreach ($j in $q) {
        if ($j -match "  serialNumber:") {
            $sn = $j[16..$j.Length] -join ""
        }
    }
    foreach ($u in $q) {
        if ($u -match "email") {
            $user = $u[13..$u.Length] -join ""
            if ($user -ne 'UnmanagedUser') {
                break
            }
        }
    }
    if($sn -notin $output.keys){
        $output.add($sn, $user)
    }
    Write-Progress -activity "Working" -status "$count / $len" -PercentComplete (($count / $devices.count)*100)
    $count++
}
# Convert the hastable to JSON object
$output = $output | ConvertTo-JSON
# Assert output directory presence
$exists = Test-Path $home\desktop\Get-CrosLastUser
if ($exists -ne $true) {
    mkdir $home\desktop\Get-CrosLastUser
}
# Output a JSON file
$output | Out-File "$home\desktop\Get-CrosLastUser\UnmanagedUserCorrected.json"