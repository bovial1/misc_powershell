param(
    [Parameter(Mandatory = $true)]
    [string] $storageaccountkey,
    [Parameter(Mandatory = $true)]
    [string] $storageaccountname
)
$end = Get-Date
$start = $end.AddYears(-1) 

$context = New-AzStorageContext -StorageAccountName $storageaccountname -StorageAccountKey $storageaccountkey 

while ($start -ne $end) {
  $start.ToString("yyyy-MM-dd")
  $start = $start.AddDays(1)
  $filename = "./avd/" + $start.ToString('yyyy-MM') + "/" + $start.ToString('yyyy-MM-dd') + ".csv"
  New-Item $filename -Force -Confirm:$False
  $serviceid = "AZAVD11111111"
  $poolname = "test-pool"
  $daysyd = $start.ToString("yyyy-MM-dd")
  $subscriptionid = "11111111-1111-1111-1111-111111111111"
  $resourcegroup = "test-rg"
  $resourceid = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test-rg/providers/Microsoft.DesktopVirtualization/hostpools/test-pool"
  $connections = 9
  $outarr = @()
  for ($i=1; $i -le 4; $i++) {
    $obj = [PSCustomObject] @{ServiceId = $serviceid; UserName = "user0$i@test.local"; PoolName = $poolname; DaySyd = $daysyd; SubscriptionId = $subscriptionid; ResourceGroup = $resourcegroup; ResourceId = $resourceid; Connections = $connections}
    $outarr += $obj
  }
  $outarr | Export-Csv -Path $filename -Confirm:$False
  Set-AzStorageBlobContent -File $filename -Blob $filename.Substring(2) -Container "azure-billing" -Context $context -Force
} 
