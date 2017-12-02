Get-AzureRmVMDscExtensionStatus -ResourceGroupName "lab9" -VMName "contosodc"

Get-AzureRmVMDscExtension -ResourceGroupName "lab9" -VMName "contosodc" | Select-Object -ExpandProperty Properties
