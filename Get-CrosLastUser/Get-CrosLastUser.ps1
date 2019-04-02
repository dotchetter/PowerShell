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

# Current date in string format
$date = Get-Date -Format 'yyyy-MM-dd'
# Get all deviceID's in the domain in an array
$deviceList = gam print cros
# Shorten array, pop index 0 with 'deviceID' string
$deviceList = $deviceList[1..$deviceList.Length]
# Instanciate a mutable list object to add each device to
$deviceInfoList = New-Object 'collections.generic.list[string]'
# Instanciate a mutable list object to store the parsed data in
$data = New-Object 'collections.generic.list[string]'
# Instanciate a mutable list object to store serialnumbers found
$sn = New-Object 'collections.generic.list[string]'
# Instanciate a mutable list object to store user adresses found
$users = New-Object 'collections.generic.list[string]'
# Instanciate a hashmap to keep the final output data
$output = @{}

# Append a string with the info for each device in the list
foreach ($device in $deviceList) {
    $r = gam info cros $device
    $infostr += $r
}

# Split the appended string by the indicator that a new device starts
$infostr = $infostr -Split 'Cros Device'

# Iterate through the string and append the mutable list
foreach ($entry in $infostr) {
    $deviceInfoList.Add($entry)
}

# Parse indices in the list and append to respective arraylist
foreach ($i in $deviceInfoList) {
    if ($i -Match 'serialNumber') {
        $sn.Add($i)
    } elseif ($i -Match 'annotateduser') {
        $users.Add($i)
    }
}

# Add serialnumbers as key in the hashtable
for ($i = 0; $i -lt $sn.Count) {
    # Add indices from arrays to the hashtable but trim trivial information
    $s, $u = $sn[$i].Split(':')[1].TrimStart(' '), $users[$i].Split(':')[1].TrimStart(' ')
    $output.Add($s, $u)
    $i++
}

# Convert the hastable to JSON object
$output = $output | ConvertTo-JSON

# Assert output directory presence
$exists = Test-Path $home\desktop\Get-CrosLastUser
if ($exists -ne $true) {
    mkdir $home\desktop\Get-CrosLastUser
}

# Output a JSON file
$output | Out-File "$home\desktop\Get-CrosLastUser\$date.json"