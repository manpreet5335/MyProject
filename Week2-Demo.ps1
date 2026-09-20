$a = ".dir", ".pdf", ".txt", ".docx", $null
$Last24Hours = (Get-Date).AddDays(-1)
Get-Date | Get-member
$LASTEXITCODE
$?
"Hello" -eq "hello"
$x = 30
if ($x -gt 20) {
    Write-Host "The value of x is greater than 20"
} else {
    Write-Host "The value of x is less than or equal to 20"
}