
import-module activedirectory
# Creating array of, in this case, physicalDeliveryOfficeName attributes in the entire SearchBase
function fetch {param($scope)

    [array]$pdoarray = get-aduser -filter * -searchbase $scope -properties physicaldeliveryofficename |
    select-object -expandproperty physicaldeliveryofficename
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
             <filter>(&amp;(objectCategory=person)(objectClass=user)(mail=*DOMAIN.COM*)(physicalDeliveryOfficeName=$data))</filter>
            </search>
"@
    }
    return $datblk   
}

function main {
    
    [string]$sbase = 'OU=,DC=,DC='
    [string]$output = ""
    [array]$pdo_export = fetch($sbase)
    $output = builder($pdo_export)
    if ($output) {$output > $env:userprofile\desktop\attribute_export.dat}
    else {
        'Something happened when getting the data and it could not be retrieved.' > $env:userprofile\desktop\error.dat
    }
}

main