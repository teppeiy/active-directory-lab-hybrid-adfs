$TemplateFile = "C:\Users\teppeiy\source\repos\active-directory-lab-hybrid-adfs\lab-hybrid-adfs\FullDeploy.json"
$TemplateParameterFile = "C:\Users\teppeiy\source\repos\active-directory-lab-hybrid-adfs\lab-hybrid-adfs\azuredeploy.parameters.json"

#New-AzureRmResourceGroup -Name "lab9" -Location "Southeast Asia"
#New-AzureRmResourceGroupDeployment -ResourceGroupName "lab9" -deploymentNumber 9 -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -Verbose

#adDomainMode/adForestMode "allowedValues": [ "2", "Win2003", "3", "Win2008", "4", "Win2008R2", "5", "Win2012", "6", "Win2012R2" ]
#adImageSKU/adfsImageSKU "allowedValues": [ "2016-Datacenter", "2012-R2-Datacenter", "2008-R2-SP1" ]

# Win2008R2
$deploymentNumber = 4
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2008-R2-SP1" -adfsImageSKU "2008-R2-SP1" -adDomainMode "Win2008R2" -adForestMode "Win2008R2" -Verbose

# Win2012 - Verified
$deploymentNumber = 4
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile `
	-deploymentNumber $deploymentNumber -adImageSKU "2012-R2-Datacenter" -adfsImageSKU "2012-R2-Datacenter" -adDomainMode "Win2012" -adForestMode "Win2012" -Verbose

# Win2012R2
$deploymentNumber = 5
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
