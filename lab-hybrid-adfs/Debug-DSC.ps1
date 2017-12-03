while(1){
Get-AzureRmVMDscExtensionStatus -ResourceGroupName "lab9" -VMName "contosopx1"
sleep(5)
}

Get-AzureRmVMDscExtension -ResourceGroupName "lab9" -VMName "contosodc" | Select-Object -ExpandProperty Properties
