$TemplateFile = "C:\Users\teppeiy\source\repos\active-directory-lab-hybrid-adfs\lab-hybrid-adfs\FullDeploy.json"
$TemplateParameterFile = "C:\Users\teppeiy\source\repos\active-directory-lab-hybrid-adfs\lab-hybrid-adfs\azuredeploy.parameters.json"

#New-AzureRmResourceGroup -Name "lab9" -Location "Southeast Asia"
#New-AzureRmResourceGroupDeployment -ResourceGroupName "lab9" -deploymentNumber 9 -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -Verbose


$deploymentNumber = 5
$ResourceGroupName = "Forest-$deploymentNumber"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -deploymentNumber $deploymentNumber -adImageSKU "2008-R2-SP1" -adfsImageSKU "2008-R2-SP1" -Verbose


Remove-AzureRmResourceGroup -Name "Forest-3" -force