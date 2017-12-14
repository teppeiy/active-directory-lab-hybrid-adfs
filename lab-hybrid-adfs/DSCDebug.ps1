Get-ExecutionPolicy

Start-DscConfiguration -Path "C:\Packages\Plugins\Microsoft.Powershell.DSC\2.73.0.0\DSCWork\adDSC.0\"

Test-DscConfiguration -Detailed 
Test-DscConfiguration -Detailed | select -ExpandProperty ResourcesNotInDesiredState
Test-DscConfiguration -Detailed | select -ExpandProperty ResourcesInDesiredState

Get-DscResource

Get-DscConfigurationStatus -All | select Status, Error, ResourcesNotInDesiredState, ResourcesInDesiredState


$DscStatus = Get-DscConfigurationStatus -All
foreach($s in $DscStatus){

if(-not [String]::IsNullOrEmpty($s.Error)){
$s.ResourcesNotInDesiredState | Select StartDate, ResourceId -ExpandProperty Error >> "$env:homepath\desktop\dsclog.txt"
}
}

Get-DscLocalConfigurationManager

Get-DscConfiguration

Restore-DscConfiguration
Update-DscConfiguration

