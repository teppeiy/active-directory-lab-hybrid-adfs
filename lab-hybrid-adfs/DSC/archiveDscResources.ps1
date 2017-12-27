# https://docs.microsoft.com/en-us/powershell/module/azure/publish-azurevmdscconfiguration?view=azuresmps-4.0.0
param(
    [string] $workspacePath = "C:\Users\teppeiy\source\repos\active-directory-lab-hybrid-adfs\lab-hybrid-adfs"
)

<#
install-module -name xNetworking
install-module -name xSmbShare
install-module -name xAdcsDeployment
install-module -name xCertificate
#>

$configurationPath = "$workspacePath\DSC\adDSC\adDSCConfiguration.ps1"
$configurationArchivePath = "$workspacePath\DSC\adDSC.zip"

Publish-AzureVMDscConfiguration -ConfigurationPath $configurationPath -ConfigurationArchivePath $configurationArchivePath -Force


$configurationPath = "$workspacePath\DSC\adfsDSC\adfsDSCConfiguration.ps1"
$additionalPath = "$workspacePath\DSC\adfsDSC\wapDSCConfiguration.ps1"
$configurationArchivePath = "$workspacePath\DSC\adfsDSC.zip"

Publish-AzureVMDscConfiguration -ConfigurationPath $configurationPath -AdditionalPath $additionalPath -ConfigurationArchivePath $configurationArchivePath -Force
