# Install dependencies and azure cmdlets
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Az -AllowClobber -Scope CurrentUser -Force
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# Restart powershell session after installs
powershell

# Login with my service principal credentials (CLI)
az login --service-principal -u args[0] -p args[1] --tenant args[2]

$resourceGroupName = "case2rg"
$storageAccountName = args[3]

$storageAccountKeys = az storage account keys list --account-name $storageAccountName --query '[0].value' -o tsv

Invoke-Expression -Command ("cmdkey /add: $($storageAccountName)" + ".file.core.windows.net " + `
    "/user:AZURE\$($storageAccountName) /pass:$($storageAccountKeys)")

Invoke-Expression -Command ("net use Z: \\$($storageAccountName)" + ".file.core.windows.net\fileshareping " + `
    "\fileshareping /persistent:Yes")

# Change directory, ping and save result in log
$vm2ip = az network public-ip list --query "[1].ipAddress"
Z:
ping $vm2ip > pinglog.txt


################################################
# AZ POWERSHELL implementation
#
# Failed attempt to log in using powershell
# $username = args[4]
# $password =ConvertTo-SecureString args[5] -AsPlainText -Force
# $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
#
#$storageAccountName = (Get-AzResource -ResourceGroupName $resourceGroupName -Name case2sac*).Name
#
#$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
#$storageAccountKeys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName
#
#Invoke-Expression -Command ("cmdkey /add:$([System.Uri]::new($storageAccount.Context.FileEndPoint).Host) " + `
#    "/user:AZURE\$($storageAccount.StorageAccountName) /pass:$($storageAccountKeys[0].Value)")
#Invoke-Expression -Command ("net use Z: \\$([System.Uri]::new($storageAccount.Context.FileEndPoint).Host)" + `
#    "\fileshareping /persistent:Yes")
#
# $vm2ip = (Get-AzPublicIpAddress -ResourceGroupName "case2rg" -Name vm2-ip).IpAddress
#
# Z:
# ping $vm2ip > pinglog.txt
#
###############################################
