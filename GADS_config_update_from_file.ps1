
# Creating array of, in this case, physicalDeliveryOfficeName attributes from an already exported textfile.
function fetch {param($scope)

    [array]$pdoarray = get-content 'filepath.txt' -encoding utf8
    if ($pdoarray) {return $pdoarray} 
    else {
        return 'Could not recieve any data from LDAP server. Check access and spelling.'}
}

# Building .xml data blocks for every attribute in $pdoarray
function builder {param($arg)

    [int]$priority = 0
    foreach ($data in $arg) {  
        $priority += 1
        $datblk += @"
            `n
            <search>
             <priority>$priority</priority>
             <suspended>false</suspended>
             <scope>SUBTREE</scope>
             <orgName>/ADM/$data</orgName>
             <filter>(&amp;(objectCategory=person)(objectClass=user)(mail=*katrineholm.se*)(physicalDeliveryOfficeName=$data))</filter>
            </search>
"@}
    return $datblk   
}

# exporting data from fetch, builder to string and printing to .dat file on current user desktop.
function main {
    
    [string]$output = ""
    [array]$pdo_export = fetch($sbase)
    $output = builder($pdo_export)

    if ($output) {$output > $env:userprofile\desktop\attribute_export.dat}
    else {
        'Something happened when getting the data and it could not be retrieved.' > $env:userprofile\desktop\error.dat
    }
}
main