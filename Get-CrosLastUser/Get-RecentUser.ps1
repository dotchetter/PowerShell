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

<#
.Synopsis
 Return most recent user with a Chrome OS device in Google G suite by using GAM
 and parsing output piped to stdout.

.Description
 This module returns data parsed from output by GAM (https://github.com/jay0lee/GAM).
 The objective is to create metadata with a correlation between a CrOS (Chrome OS) 
 device and its latest logged on user. This data can be used later to bind a user
 entity with devices based on usage. The bias being that one presumes that the latest
 user owns the device, which is not a guarantee and this should be acknowledged before
 using this data to bind users in a production environment such as a business system.
 Sometimes these machines may have a non-managed user as its most recent user. This 
 causes the device to register a "UnmanagedUser" in the output from this script. 
 This can be mitigated by using the -Override switch. 

.Parameter PathToGam
 The full path to the gam binary you want to use.

.Parameter Override
 Mitigate the 'UnmanagedUser' scenario where a device has one or more unmanaged
 Google users as the recent user. Iterate further down the list of users on a device, 
 if the recent most user is  unmanaged. Keep on iterating until a managed user appears, 
 and select the recent most managed user that can be found for given device. 

.Parameter ToFile
 Get the output in JSON format

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
 
 
#>

[CmdletBinding(DefaultParametersetName='None')] 
param( 
    [Parameter(Position=0,Mandatory = $true)] [string]$PathToGAM, 
    [Parameter(Position=1,Mandatory = $false)] [switch]$Override,
    [Parameter(ParameterSetName = 'Extra',Mandatory = $false)][switch]$ToFile,      
    [Parameter(ParameterSetName = 'Extra',Mandatory = $true)][string]$Path
)


function Get-DeviceID ($gampath) {
    <# Return array with all deviceIDs gathered 
    by GAM Query. #>
    
    # Use GAM to build array of all CrOS devices in the entire domain.
    # Truncate the first index in array containing 'deviceId' string
    try {
        [array]$_crOS = & $gampath print cros
        $_crOS = $_crOS[1..$_crOS.Length]
    } catch [Exception]{
        throw 'BuildDeviceIDArrayFailed'
    }
    return $_crOS
}


function Get-RecentUser ($gampath, $deviceID, $override = $false) {
    <# Return a hashtable with the most recent user for every device ID
    in argument. Optional argument "override" will if true, keep iterating
    through the list of users if the first occurence happens to be 
    'Unmanaged User'. The value for each key, represented by a device 
    SN, contains an array with 2 indices; RecentUser email string and 
    Device ID string for the serial number. #>

    [int32]$cnt = 0
    [int32]$len = $deviceID.Count
    [Hashtable]$export = @{}
    [Array]$exportArr = @()
    # Iterate through the list of device ID's and get data
    foreach ($id in $deviceID) {

        $cnt ++
        $_DeviceObjRepr = @{}
        $_preTime = [DateTimeOffset]::Now.ToUnixTimeSeconds()

        # Get output from GAM
        $query = & $gampath info cros $id recentusers serialnumber
        
        # Iterate through the string output from this command to find serialnumber
        foreach ($i in $query) {
            if ($i -match "  serialNumber:") {
                $sn = $i[16..$i.Length] -Join ""
            }
        }
        
        # Iterate through the string output from this command to find most recent user
        if ($override -eq $true) {
            foreach ($user in $query) {
                if ($user -match "email") {
                    $recentUser = $user[13..$user.Length] -Join ""
                    if ($recentUser -ne 'UnmanagedUser') {break}
                }
            }
        } else {
        # If override is false, select the first email / user string encountered
            foreach ($user in $query) {
                if ($user -match "email") {
                    $recentUser = $user[13..$user.Length] -Join ""
                    break
                }
            }
        }
    
        # Add the serialnumber with recent user to the iterating hashtable
        if ($recentUser -notin $_DeviceObjRepr.Keys) {
            $_DeviceObjRepr.Add($sn, $recentUser)
        }

        # Add the object representation hashtable to the array
        $exportArr += @($_DeviceObjRepr)

        # Write progress to screen with estimated time remaining
        [double]$_percent = (($cnt / $deviceID.Count) * 100)
        [string]$_activity = "Pairing SN with recent user"
        [double]$_postTime = ([DateTimeOffset]::Now.ToUnixTimeSeconds() - $_preTime)
        [double]$_etr = ($_postTime * ($deviceID.Count - $cnt))
        [string]$_status = "$cnt of $len. Estimated $_etr seconds remaining"

        Write-Progress -Activity $_activity -Status $_status -PercentComplete $_percent
    }
        # Add the array to the value for this device ID in the main hashtable
        $export.Add('RecentUsers', $exportArr)

    return $export
}


if (Test-Path $PathToGAM) {
    # Get Device ID's for the entre G Suite 
    try {
        $_idList = Get-DeviceID $PathToGAM
        $_recentUsers = Get-RecentUser $PathToGAM $_idList $Override
    } catch {
        Write-Host "`nAn error occured! $error" -f Red
    }

    if ($_recentUsers -and $ToFile) {
        $_recentUsers | ConvertTo-Json | Out-file "$Path\RecentUsers.json"
        Write-Host "`nOutput file generated: ($Path\RecentUsers.json)" -f Green
    } else {
        return $_recentUsers
        Write-Progress
    }
} else {
    Write-Host "`nError: Expected gam.exe, got ($PathToGAM)" -f Red
}