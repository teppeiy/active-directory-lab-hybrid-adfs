New-AzureRmResourceGroup -Name "lab9" -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName "lab9" -deploymentNumber 9 -TemplateFile ".\FullDeploy.json" -TemplateParameterFile ".\azuredeploy.parameters.json" -Verbose

New-AzureRmResourceGroup -Name "lab8" -Location "Southeast Asia"
New-AzureRmResourceGroupDeployment -ResourceGroupName "lab8" -deploymentNumber 7 -adfsImageSKU "2008-R2-SP1" -TemplateFile ".\FullDeploy.json" -TemplateParameterFile ".\azuredeploy.parameters.json" -Verbose
