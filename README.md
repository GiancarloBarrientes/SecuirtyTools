# SecurityTools
This will hold various tools that are security purposed

# LogMessageAnalyzer.ps1
This is a tool to grab the last x amount(Line 28 controls this with the "-newest") of security events when ran on a local machine. This will spit out logs based on their messages and csv's will be created in C:\SecLogsZone. This can be replaced with any message you set that are within a set parameter you specify. Log lines 44-63 show how to do this. 
Creations of csv's and file locations are in lines 75-80
