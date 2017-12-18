Configuration WAP
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost
    {
        LocalConfigurationManager            
        {            
            DebugMode = 'All'
            ActionAfterReboot = 'ContinueConfiguration'            
            ConfigurationMode = 'ApplyOnly'            
            RebootNodeIfNeeded = $true
        }

	    WindowsFeature WebAppProxy
        {
            Ensure = "Present"
            Name = "Web-Application-Proxy"
        }

        WindowsFeature Tools 
        {
            Ensure = "Present"
            Name = "RSAT-RemoteAccess"
            IncludeAllSubFeature = $true
        }

        WindowsFeature MoreTools 
        {
            Ensure = "Present"
            Name = "RSAT-AD-PowerShell"
            IncludeAllSubFeature = $true
        }

        WindowsFeature Telnet
        {
            Ensure = "Present"
            Name = "Telnet-Client"
        }
    }
}

Configuration WAP2k8r2
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost
    {
        LocalConfigurationManager            
        {            
            DebugMode = 'All'
            ActionAfterReboot = 'ContinueConfiguration'            
            ConfigurationMode = 'ApplyOnly'            
            RebootNodeIfNeeded = $true
        }


		<# need to fix this #>

		<#
	    WindowsFeature WebAppProxy
        {
            Ensure = "Present"
            Name = "Web-Application-Proxy"
        }
		#>

        WindowsFeature Tools 
        {
            Ensure = "Present"
            Name = "RSAT-RemoteAccess"
            IncludeAllSubFeature = $true
        }

        WindowsFeature MoreTools 
        {
            Ensure = "Present"
            Name = "RSAT-AD-PowerShell"
            IncludeAllSubFeature = $true
        }

        WindowsFeature Telnet
        {
            Ensure = "Present"
            Name = "Telnet-Client"
        }

		Script InstallADFS
		{
            SetScript = {
				Function Download-And-InstallExe {
					[CmdletBinding()]
					param
					(
						[Parameter(Mandatory = $true)]
						[string]
						$uri,
						[string]
						$option
					)
					$LocalTempDir = $env:TEMP
					$installer = (new-guid).toString() + ".exe"
					(new-object System.Net.WebClient).DownloadFile($uri, "$LocalTempDir\$installer"); & "$LocalTempDir\$installer" $option; $Process2Monitor = "installer"; Do { $ProcessesFound = Get-Process | ? {$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else {  } } Until (!$ProcessesFound)
				}

				$uri = "https://download.microsoft.com/download/F/3/D/F3D66A7E-C974-4A60-B7A5-382A61EB7BC6/RTW/W2K8R2/amd64/AdfsSetup.exe"
				$option = "/quiet /proxy"
				Download-And-InstallExe $uri $option
            }

            GetScript =  { @{} }
            TestScript = { 
                return Test-path "C:\Program Files\Active Directory Federation Services 2.0"
            }
		}

		Script ConfigureADFS{
			SetScript = {
				# Run setup wizard
				& "$env:ProgramFiles\Active Directory Federation Services 2.0\fsconfig.exe" CreateFarm /ServiceAccount "teppeiy.local\adfs_svc" /ServiceAccountPassword "P@ssw0rd!" /AutoCertRolloverEnabled
			}
			GetScript =  { @{} }
			TestScript = { 
				return Test-Path "$LocalTempDir\$installer" 
			}
			DependsOn  = '[Script]InstallADFS'
		}
    }
}
