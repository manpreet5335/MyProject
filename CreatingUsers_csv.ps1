$session = New-PSSession 192.168.1.20 -credential manpreet.powershell.com\administrator
$copyParams = @{
    Path        = "C:\Users\kaur7062\PowerShell_Scripts\MultipleNewUser.ps1"
    Destination = "C:\Users\Administrator\Documents\MultipleNewUser.ps1"
    ToSession   = $session
}
Copy-Item @copyParams
