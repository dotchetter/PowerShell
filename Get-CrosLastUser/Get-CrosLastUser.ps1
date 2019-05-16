<# 
$author = Simon Olofsson
$date = 2019-04-03

This script will:

1. Query GAM to fetch all devices in the G Suite domain
2. Ask GAM to fetch device info for each device fetched
3. Parse the list of info, and only keep data of interest
4. Output a JSON file with the device serialnumber and last user

This script has the following prerequisites:

1. GAM is installed and authenticated on the local system
2. Write access to $home directory 
#>

param(
    [mandatory]$inFile,
    [mandatory]$outPath
)

# Current date in string format
$date = Get-Date -Format 'yyyy-MM-dd'

# Counter variable for progressbar
$count = 0

# Parse file containing device ID's
try {
    $devices = get-content $inFile
} catch {
    Throw "FileNotFound:: inFile"
}

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
            break
        }
    }
    if($sn -notin $output.keys){
        $output.add($sn, $user)
    }
    Write-Progress -activity "Working" -status “$count / $len” -PercentComplete (($count / $devices.count)*100)
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
$output | Out-File "$outPath\Get-CrosLastUser_$date.json"