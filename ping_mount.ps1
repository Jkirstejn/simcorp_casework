$resourceGroupName = "case2rg"
$storageAccountName = (Get-AzResource -ResourceGroupName $resourceGroupName -Name case2sac*).Name

$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
$storageAccountKeys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName

Invoke-Expression -Command ("cmdkey /add:$([System.Uri]::new($storageAccount.Context.FileEndPoint).Host) " + `
    "/user:AZURE\$($storageAccount.StorageAccountName) /pass:$($storageAccountKeys[0].Value)")

Invoke-Expression -Command ("net use Z: \\$([System.Uri]::new($storageAccount.Context.FileEndPoint).Host)" + `
    "\fileshareping /persistent:Yes")
    
# Change directory, ping and save result in log
$vm2ip = (Get-AzPublicIpAddress -ResourceGroupName "case2rg" -Name vm2-ip).IpAddress
Z:
ping $vm2ip > pinglog.txt
