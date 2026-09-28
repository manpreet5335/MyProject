# Lab3-Working with ADDS using PoweShell

## Verify and Create Organizational Unit

Before creating any new Organizational Units, let's examine the OUs that are currently present on the server.
```ps
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -AutoSize
```
This command retrieves and displays all Organizational Units (OUs) present in Active Directory.

Next, create a new Organizational Unit (OU) in the domain using the following command.

```ps
New-ADOrganizationalUnit -Name "Department-IT" -Path "DC=manpreet,DC=powershell,DC=com"
```
You can also create nested Organizational Units (OUs) by specifying the appropriate parent OU in the -Path parameter.

## Verify and Create Users
Use the following Cmdlet to list the users
```ps
Get-ADUser -Filter * | Select-Object Name
```
This command displays all users that currently exist in Active Directory.

You can use the following cmdlet to create a new user.
```ps
New-ADuser -Name "User15" -Path "OU=Department-IT,DC=manpreet,DC=powershell,DC=com"`
 -UserPrincipalName "User15@manpreet.powershell.com"`
 -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)`
 -Enabled $true `
 -ChangePasswordAtLogon $true
 ```
Another example that defines additional user properties is shown below.
```ps
New-ADUser -Name "User6" -Path "OU=Department-IT,DC=manpreet,DC=powershell,DC=com" `
 -UserPrincipalName "User6@manpreet.powershell.com"`
 -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)`
 -City "Toronto" `
 -Country "CA" `
 -Department "IT" `
 -Enabled $true `
 -ChangePasswordAtLogon $true 
 ```
 In this example alongwith the other parameters the parameters like city and country is added.

 Use `Get-Help` to understand more options that can be set for New AD User.

Download the Users.csv and save it in a folder on your host machine.

 ## Copying a file to the remote-server
 On the host machine, enter the following commands.
 ```ps
 $session = New-PSSession 192.168.1.20 -credential manpreet.powershell.com\administrator
$copyParams = @{
    Path        = "C:\Users\kaur7062\PowerShell_Scripts\Users.csv"
    Destination = "C:\Users\Administrator\Documents\Users.csv"
    ToSession   = $session
}
Copy-Item @copyParams
```
This will copy the Users.csv file to the server. Make sure to update the content of file according to domain name on your server <manpreet.powershell.com> is to be replaced by <firstname.powershell.com> according to your lab.

Write a script named *AddNewUser.ps1*. It uses a custom object (using HashTable) to read the parameters from the csv file and then create the users according to it.
```ps
import-csv "C:\Users\Administrator\Documents\Users.csv" | ForEach-Object {
$NewUserParameters =@{
'GivenName'= $_.FirstName
'Surname' = $_.LastName
'Name' = $_.UserName
"UserPrincipalName" = $_.UserPrincipalName
"AccountPassword" = (ConvertTo-SecureString "p@33w0rd" -asPlainText -Force)
}
New-ADUser @NewUserParameters -PassThru | Enable-ADAccount
}
```
Now copy this script file to the server too using the Copy-Item
```ps
$session = New-PSSession 192.168.1.20 -credential manpreet.powershell.com\administrator
$copyParams = @{
    Path        = "C:\Users\kaur7062\PowerShell_Scripts\AddNewUser.ps1"
    Destination = "C:\Users\Administrator\Documents\AddNewUser.ps1"
    ToSession   = $session
}
Copy-Item @copyParams
```
Now, run the script on server by creating a remote session or logging to the remote-server and executing the script ./AddNewUser.ps1
```ps
./AddNewUser.ps1
```
Keep modifying the script to make it according to the shared template. 





