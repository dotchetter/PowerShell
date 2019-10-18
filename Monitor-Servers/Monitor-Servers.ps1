<#  
.SYNOPSIS  
    Pings IP adresses and returns status codes for every
    failed ping. Can be used as a service, continously monitoring 
    a heartbeat ping to a server.

.DESCRIPTION  
    Use built-in Test-Connection cmdlet to ping any number 
    of passed IP addresses, using an array or JSON file. 

.NOTES  
    File Name  : Monitor-Servers.ps1  
    Author     : Simon Olofsson - dotchetter@protonmail.ch
    Requires   : PowerShell V2 CTP3
.LINK  
    https://github.com/dotchetter/Monitor-Servers
#>

Function Monitor-Servers {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]
        $IPAdress,
        
        [Parameter(Mandatory = $false)]
        [String]
        $LogFilePath,

        [Parameter(Mandatory = $false)]
        [Int32]
        $Delay
        
        [Parameter(Mandatory = $false)]
        [Bool]
        $NeverDie

        

        }
    )



