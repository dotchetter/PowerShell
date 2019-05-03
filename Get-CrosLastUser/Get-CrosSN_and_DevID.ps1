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

# Counter variable for progressbar
$count = 0

# Parse file containing device ID's
$devices = get-content "C:\Users\siolo001.CAPERIO\Desktop\KSAB\Assign devices\UnmanagedDevices_to_query.dat"

# Length variable for progressbar
$len = $devices.count

# Hashtable to append to
$output = @{}

# Iterate through the list of device ID's and get data for every device
foreach ($i in $devices) {
    $q = gam info cros $i serialnumber
    foreach ($j in $q) {
        if ($j -match "  serialNumber:") {
            $sn = $j[16..$j.Length] -join ""
        }
    }
    if($sn -notin $output.keys){
        $output.add($sn, $i)
    }
    Write-Progress -activity "Working" -status “$count / $len” -PercentComplete (($count / $devices.count)*100)
    $count++
}

# Convert the hastable to JSON object
$output = $output | ConvertTo-JSON

# Output a JSON file
$output | Out-File "C:\Users\siolo001.CAPERIO\Desktop\KSAB\Assign devices\UmnanagedSn_DevID.json"