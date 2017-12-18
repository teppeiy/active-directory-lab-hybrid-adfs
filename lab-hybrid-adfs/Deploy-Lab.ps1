$TemplateFile = "C:\Users\teppeiy\source\repos\active-directory-lab-hybrid-adfs\lab-hybrid-adfs\FullDeploy.json"
$TemplateParameterFile = "C:\Users\teppeiy\source\repos\active-directory-lab-hybrid-adfs\lab-hybrid-adfs\azuredeploy.parameters.json"

# Win2012 - Verified
$deploymentNumber = 5
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2012-R2-Datacenter" -adfsImageSKU "2012-R2-Datacenter" -adDomainMode "Win2012" -adForestMode "Win2012" -Verbose

# Win2012 - Verified
$deploymentNumber = 3
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -Verbose

# Win2012 - 
$deploymentNumber = 4
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2012-R2-Datacenter" -adfsImageSKU "2012-R2-Datacenter" -adDomainMode "Win2012" -adForestMode "Win2012" -Verbose


# Win2008R2
$deploymentNumber = 6
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2008-R2-SP1" -adfsImageSKU "2008-R2-SP1" -adDomainMode "Win2008R2" -adForestMode "Win2008R2" -Verbose


# Win2012 - 
$deploymentNumber = 7
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2012-R2-Datacenter" -adfsImageSKU "2012-R2-Datacenter" -adDomainMode "Win2008R2" -adForestMode "Win2008R2" -Verbose



# Win2008R2
$deploymentNumber = 3
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2008-R2-SP1" -adfsImageSKU "2008-R2-SP1" -adDomainMode "Win2008R2" -adForestMode "Win2008R2" -Verbose


# Win2008R2
$deploymentNumber = 8
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2008-R2-SP1" -adfsImageSKU "2008-R2-SP1" -adDomainMode "Win2008R2" -adForestMode "Win2008R2" -Verbose


# Win2012 - 
$deploymentNumber = 9
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2012-R2-Datacenter" -adfsImageSKU "2012-R2-Datacenter" -adDomainMode "Win2008R2" -adForestMode "Win2008R2" -Verbose


# Win2008R2
$deploymentNumber = 5
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2008-R2-SP1" -adfsImageSKU "2008-R2-SP1" -adDomainMode "Win2008R2" -adForestMode "Win2008R2" -Verbose



$TemplateFile = "C:\Users\teppeiy\source\repos\active-directory-lab-hybrid-adfs\lab-hybrid-adfs\FullDeploy.json"
$TemplateParameterFile = "C:\Users\teppeiy\source\repos\active-directory-lab-hybrid-adfs\lab-hybrid-adfs\azuredeploy.parameters.json"


# Win2012 - 
$deploymentNumber = 7
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2012-R2-Datacenter" -adfsImageSKU "2012-R2-Datacenter" -adDomainMode "Win2012" -adForestMode "Win2012" -Verbose

# Win2008R2
$deploymentNumber = 6
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2008-R2-SP1" -adfsImageSKU "2008-R2-SP1" -adDSCConfigurationFunction "DomainController2k8r2" -adfsDSCConfigurationFunction "ADFS2k8r2" -wapDSCConfigurationFunction "WAP2k8r2" -adDomainMode "Win2008R2" -adForestMode "Win2008R2" -Verbose




#New-AzureRmResourceGroup -Name "lab9" -Location "Southeast Asia"
#New-AzureRmResourceGroupDeployment -ResourceGroupName "lab9" -deploymentNumber 9 -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -Verbose

#adDomainMode/adForestMode "allowedValues": [ "2", "Win2003", "3", "Win2008", "4", "Win2008R2", "5", "Win2012", "6", "Win2012R2" ]
# Numbering and Win2003 will fail in DeployAD.ps1
#adImageSKU/adfsImageSKU "allowedValues": [ "2016-Datacenter", "2012-R2-Datacenter", "2008-R2-SP1" ]

# Win2008R2
$deploymentNumber = 4
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2008-R2-SP1" -adfsImageSKU "2008-R2-SP1" -adDomainMode "Win2008R2" -adForestMode "Win2008R2" -Verbose

# Win2012 - Verified
$deploymentNumber = 5
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2012-R2-Datacenter" -adfsImageSKU "2012-R2-Datacenter" -adDomainMode "Win2012" -adForestMode "Win2012" -Verbose

# Win2012R2
$deploymentNumber = 6
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2012-R2-Datacenter" -adfsImageSKU "2012-R2-Datacenter" -adDomainMode "Win2012R2" -adForestMode "Win2012R2" -Verbose

# Win2016
$deploymentNumber = 3
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2016-Datacenter" -adfsImageSKU "2016-Datacenter" -adDomainMode "Win2012R2" -adForestMode "Win2012R2" -Verbose


###########
$resourceGroup = "Forest-3"
$location = "southeastasia"
$vmName = "teppeiydc"
$storageName = "demostorage"
#Publish the configuration script into user storage
#Publish-AzureRmVMDscConfiguration -ConfigurationPath .\iisInstall.ps1 -ResourceGroupName $resourceGroup -StorageAccountName $storageName -force
#Set the VM to run the DSC configuration
Set-AzureRmVmDscExtension -Version 2.21 -ResourceGroupName $resourceGroup -VMName $vmName -ArchiveStorageAccountName $storageName -ArchiveBlobName iisInstall.ps1.zip -AutoUpdate:$true -ConfigurationName "IISInstall"
Set-AzureRmVMDscExtension -
##################


Get-AzureRmResourceGroup | Select ResourceGroupName

Remove-AzureRmResourceGroup -Name "Forest-6" -force

# Debug Script
$ResourceGroupName = "Forest-5"
$VMName = "TEPPEIYDC"
#while(1){
#Get-AzureRmVMDscExtensionStatus -ResourceGroupName $ResourceGroupName -VMName $VMName
#sleep(5)
#}
Get-AzureRmVMDscExtensionStatus -ResourceGroupName $ResourceGroupName -VMName $VMName

Get-AzureRmVMDscExtension -ResourceGroupName $ResourceGroupName -VMName $VMName | Select-Object -ExpandProperty Properties
