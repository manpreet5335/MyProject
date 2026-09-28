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
    
    
    
    
    
    
    
    
    