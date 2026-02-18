$hostnames = (Get-Content -Path "hostnames.txt") -split "," | ForEach-Object { $_.Trim() }
$results = @()

foreach ($hostname in $hostnames) {
    $reachable = Test-Connection -ComputerName $hostname -Count 2 -Quiet
    $results += [PSCustomObject]@{
        Hostname  = $hostname
        Status    = if ($reachable) { "Reachable" } else { "Unreachable" }
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
    $color = if ($reachable) { "Green" } else { "Red" }
    Write-Host "$hostname is $(if ($reachable) { 'REACHABLE' } else { 'UNREACHABLE' })" -ForegroundColor $color
}

$results | Export-Csv -Path "hostnames_ping_results.csv" -NoTypeInformation
Write-Host "`nResults saved to file."