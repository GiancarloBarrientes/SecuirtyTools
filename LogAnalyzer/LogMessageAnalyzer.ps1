<#
Info/Instructions
This is a tool to grab the last x amount(Line 28 controls this with the "-newest") of security events when ran on a local machine.


This will spit out logs based on their messages and csv's will be created in C:\SecLogsZone. 


This can be replaced with any message you set that are within a set parameter you specify. Log lines 44-63 show how to do this.

Creations of csv's and file locations are in lines 75-80

Written By: Giancarlo Barrientes
#>


#Grabs Systems machine local name
$HostName = HOSTNAME.EXE
Write-Host $HostName

#Var arrays that holds the values to then be used to get out a csv file.
$LogHolderSec = @()
$LogHolderCredsManRD = @()
$LogHolderSpPrivAsgndLogon = @()
$LogHolderCryptoGraphicOp = @()
$LogHolderSucLogon = @()
#Grabs last 500 logs index numbers
$last500SecLogs = Get-EventLog -ComputerName $HostName -LogName Security -newest 500


Foreach ($logI in $last500SecLogs)
{
    #Keeps track of the log number
    Write-output $logI
    $LogIndex = ($logI)
    #Grabs the information Source, Timein, EntryType, and Message 
	$last500SecLogsSource = ($logI).Source
    $last500SecLogsTimeGenerated = ($logI).TimeGenerated
    $last500SecLogsEntryType = ($logI).EntryType
    $last500SecLogsMessage = ($logI).Message
   

    #Seperator csv file analyzed by message through Messages in logs 
    if($last500SecLogsMessage -like "Credential Manager credentials were read.*")
    {
        $LogHolderCredsManRD = $LogHolderCredsManRD + [PSCustomObject]@{LogIndex = $LogIndex; Source = $last500SecLogsSource; Time = $last500SecLogsTimeGenerated; EntryType = $last500SecLogsEntryType; Message = $last500SecLogsMessage; }
    }
    elseif($last500SecLogsMessage -like "Special privileges assigned to new logon.*")
    {
        $LogHolderSpPrivAsgndLogon = $LogHolderSpPrivAsgndLogon + [PSCustomObject]@{LogIndex = $LogIndex; Source = $last500SecLogsSource; Time = $last500SecLogsTimeGenerated; EntryType = $last500SecLogsEntryType; Message = $last500SecLogsMessage; }
    }
    elseif($last500SecLogsMessage -like "Cryptographic operation.*")
    {
        $LogHolderCryptoGraphicOp = $LogHolderCryptoGraphicOp + [PSCustomObject]@{LogIndex = $LogIndex; Source = $last500SecLogsSource; Time = $last500SecLogsTimeGenerated; EntryType = $last500SecLogsEntryType; Message = $last500SecLogsMessage; }
    }
    elseif($last500SecLogsMessage -like "An account was successfully logged on.*")
    {
        $LogHolderSucLogon = $LogHolderSucLogon + [PSCustomObject]@{LogIndex = $LogIndex; Source = $last500SecLogsSource; Time = $last500SecLogsTimeGenerated; EntryType = $last500SecLogsEntryType; Message = $last500SecLogsMessage; }
    }
    else
    {
        $LogHolderSec = $LogHolderSec + [PSCustomObject]@{LogIndex = $LogIndex; Source = $last500SecLogsSource; Time = $last500SecLogsTimeGenerated; EntryType = $last500SecLogsEntryType; Message = $last500SecLogsMessage; }
    }
}


$Folder = 'C:\SecLogsZone'
if (Test-Path -Path $Folder) {
    "C:\SecLogsZone Path exists!"
} else {
    "Path doesn't exist. Creating folder"
    mkdir C:\SecLogsZone
}

#Exportation of variables to csv files
$LogHolderCredsManRD | export-csv -Path "C:\SecLogsZone\SecurityCredsManRD.csv" -NoTypeInformation
$LogHolderSpPrivAsgndLogon | export-csv -Path "C:\SecLogsZone\SecuritySpPrivAsgndLogon.csv" -NoTypeInformation
$LogHolderCryptoGraphicOp | export-csv -Path "C:\SecLogsZone\SecurityCryptoGraphicOp.csv" -NoTypeInformation
$LogHolderSucLogon |  export-csv -Path "C:\SecLogsZone\SecuritySuccessLogins.csv" -NoTypeInformation
$LogHolderSec | export-csv -Path "C:\SecLogsZone\SecurityUncategorized.csv" -NoTypeInformation
