## Working with OUs

Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -AutoSize


New-ADOrganizationalUnit -Name "Department-IT" -Path "DC=manpreet,DC=powershell,DC=com"

## Working with Users
New-ADuser -Name "User15" -Path "OU=Department-IT,DC=manpreet,DC=powershell,DC=com"`
 -UserPrincipalName "User15@manpreet.powershell.com"`
 -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)`
 -Enabled $true `
 -ChangePasswordAtLogon $true

New-ADUser -Name "User6" -Path "OU=Department-IT,DC=manpreet,DC=powershell,DC=com" `
 -UserPrincipalName "User6@manpreet.powershell.com"`
 -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)`
 -City "Toronto" `
 -Country "CA" `
 -Department "IT" `
 -Enabled $true `
 -ChangePasswordAtLogon $true 


Get-ADUser -Filter 'Name -like "User*"'| Format-Table Name, DistinguishedName
Get-ADUser -Filter 'Name -like "User*"'|Select-Object Name

Get-ADUser User7 -Properties Department | Select-Object Name, Department

Get-ADUser -Filter  {Department -eq "IT"} -Properties City, Country | Select-Object Name, City, Country | Format-Table -AutoSize   





Get-ADGroup -Filter 'Name -like "*"'| Format-Table Name, DistinguishedName -AutoSize
#
Adding a New User



