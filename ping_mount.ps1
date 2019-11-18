# Old command, with fixed storageaccount name
#cmdkey /add:case2sacg72lpnuun5ag.file.core.windows.net /user:Azure\case2sacg72lpnuun5ag /pass:6e0A7hfvJN1UJFS3Mh7W7vLkQehi8DiPrAI/Q++Mx3GhizxBs6gL9ib13cGem50WbIen9oFwySWw1LJMlfvCAA==
#net use Z: \\case2sacg72lpnuun5ag.file.core.windows.net\fileshareping /persistent:Yes

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
