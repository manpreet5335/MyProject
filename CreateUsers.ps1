# Define output file path
$FilePath = "C:\PowerShellScripts\Users.csv"

# Create an array of user objects
$Users = @(
    [PSCustomObject]@{firstName="John";   lastName="Doe";      userName="jdoe"      }
    [PSCustomObject]@{firstName="Jane";   lastName="Smith";    userName="jsmith"    }
    [PSCustomObject]@{firstName="Michael";lastName="Brown";    userName="mbrown"    }
    [PSCustomObject]@{firstName="Emily";  lastName="Davis";    userName="edavis"    }
    [PSCustomObject]@{firstName="David";  lastName="Wilson";   userName="dwilson"   }
    [PSCustomObject]@{firstName="Sarah";  lastName="Taylor";   userName="staylor"   }
    [PSCustomObject]@{firstName="Chris";  lastName="Anderson"; userName="canderson" }
    [PSCustomObject]@{firstName="Laura";  lastName="Thomas";   userName="lthomas"   }
    [PSCustomObject]@{firstName="Daniel"; lastName="White";    userName="dwhite"    }
    [PSCustomObject]@{firstName="Olivia"; lastName="Martin";   userName="omartin"   }
)

# Add userPrincipalName to each user
$UsersWithUPN = $Users | ForEach-Object {
    $_ | Add-Member -NotePropertyName "userPrincipalName" -NotePropertyValue ("{0}@manpreet.powershell.com" -f $_.userName) -Force
    $_
}

# Export to CSV
try {
    $UsersWithUPN | Export-Csv -Path $FilePath -NoTypeInformation -Encoding UTF8
    Write-Host "✅ '$FilePath' created successfully with $($UsersWithUPN.Count) entries."
}
catch {
    Write-Host "❌ Error creating file: $($_.Exception.Message)"
}
