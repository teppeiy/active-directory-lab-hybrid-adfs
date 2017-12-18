Configuration ADFS
{
    Param 
    ( 
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$AdminCreds,

        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    )

    $wmiDomain = Get-WmiObject Win32_NTDomain -Filter "DnsForestName = '$( (Get-WmiObject Win32_ComputerSystem).Domain)'"
    $shortDomain = $wmiDomain.DomainName

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    [System.Management.Automation.PSCredential]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${shortDomain}\$($AdminCreds.UserName)", $AdminCreds.Password)
        
    Node localhost
    {
        LocalConfigurationManager            
        {            
            DebugMode = 'All'
            ActionAfterReboot = 'ContinueConfiguration'            
            ConfigurationMode = 'ApplyOnly'            
            RebootNodeIfNeeded = $true
        }

        WindowsFeature installADFS  #install ADFS
        {
            Ensure = "Present"
            Name   = "ADFS-Federation"
        }

        Script SaveCert
        {
            SetScript  = {
				#install the certificate(s) that will be used for ADFS Service
                $cred=$using:DomainCreds
                $wmiDomain = $using:wmiDomain
                $DCName = $wmiDomain.DomainControllerName
                $PathToCert="$DCName\src\*.pfx"
                $CertFile = Get-ChildItem -Path $PathToCert
				for ($file=0; $file -lt $CertFile.Count; $file++)
				{
					$Subject   = $CertFile[$file].BaseName
					$CertPath  = $CertFile[$file].FullName
					$cert      = Import-PfxCertificate -Exportable -Password $cred.Password -CertStoreLocation cert:\localmachine\my -FilePath $CertPath
				}
            }

            GetScript =  { @{} }

            TestScript = { 
                $wmiDomain = $using:wmiDomain
                $DCName = $wmiDomain.DomainControllerName
                $PathToCert="$DCName\src\*.pfx"
                $File = Get-ChildItem -Path $PathToCert
                $Subject=$File.BaseName
                $cert = Get-ChildItem Cert:\LocalMachine\My | where {$_.Subject -eq "CN=$Subject"} -ErrorAction SilentlyContinue
                return ($cert -ine $null)   #if not null (if we have the cert) return true
            }
        }

        Script InstallAADConnect
        {
            SetScript = {
                $AADConnectDLUrl="https://download.microsoft.com/download/B/0/0/B00291D0-5A83-4DE7-86F5-980BC00DE05A/AzureADConnect.msi"
                $exe="$env:SystemRoot\system32\msiexec.exe"

                $tempfile = [System.IO.Path]::GetTempFileName()
                $folder = [System.IO.Path]::GetDirectoryName($tempfile)

                $webclient = New-Object System.Net.WebClient
                $webclient.DownloadFile($AADConnectDLUrl, $tempfile)

                Rename-Item -Path $tempfile -NewName "AzureADConnect.msi"
                $MSIPath = $folder + "\AzureADConnect.msi"

                Invoke-Expression "& `"$exe`" /i $MSIPath /qn /passive /forcerestart"
            }

            GetScript =  { @{} }
            TestScript = { 
                return Test-Path "$env:TEMP\AzureADConnect.msi" 
            }
            DependsOn  = '[Script]SaveCert','[WindowsFeature]installADFS'
        }

		        Script AddTools {
            SetScript  = {
                # Install AAD Tools
                #md c:\temp -ErrorAction Ignore
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

                #Install-Module -Name Azure -AllowClobber -Force
                #Install-Module -Name AzureRM -AllowClobber -Force

                Install-Module -Name MSOnline -Force

                Install-Module -Name AzureAD -Force

                Install-Module -Name AzureADPreview -Force
            }

            GetScript  = { @{} }
            TestScript = { 
                $key = Get-Module -Name MSOnline -ListAvailable
                return ($key -ine $null)
            }
            #Credential = $DomainCreds
            #PsDscRunAsCredential = $DomainCreds

            #DependsOn  = '[xADCSWebEnrollment]CertSrv'
        }
    }
}

Configuration ADFS2k8r2
{
    Param 
    ( 
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$AdminCreds,

        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    )

    $wmiDomain = Get-WmiObject Win32_NTDomain -Filter "DnsForestName = '$( (Get-WmiObject Win32_ComputerSystem).Domain)'"
    $shortDomain = $wmiDomain.DomainName

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    [System.Management.Automation.PSCredential]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${shortDomain}\$($AdminCreds.UserName)", $AdminCreds.Password)
        
    Node localhost
    {
        LocalConfigurationManager            
        {            
            DebugMode = 'All'
            ActionAfterReboot = 'ContinueConfiguration'            
            ConfigurationMode = 'ApplyOnly'            
            RebootNodeIfNeeded = $true
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
				$option = "/quiet"
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

        Script InstallAADConnect
        {
            SetScript = {
                $AADConnectDLUrl="https://download.microsoft.com/download/B/0/0/B00291D0-5A83-4DE7-86F5-980BC00DE05A/AzureADConnect.msi"
                $exe="$env:SystemRoot\system32\msiexec.exe"

                $tempfile = [System.IO.Path]::GetTempFileName()
                $folder = [System.IO.Path]::GetDirectoryName($tempfile)

                $webclient = New-Object System.Net.WebClient
                $webclient.DownloadFile($AADConnectDLUrl, $tempfile)

                Rename-Item -Path $tempfile -NewName "AzureADConnect.msi"
                $MSIPath = $folder + "\AzureADConnect.msi"

                Invoke-Expression "& `"$exe`" /i $MSIPath /qn /passive /forcerestart"
            }

            GetScript =  { @{} }
            TestScript = { 
                return Test-Path "$env:TEMP\AzureADConnect.msi" 
            }
            #DependsOn  = '[Script]SaveCert','[WindowsFeature]installADFS'
        }

		        Script AddTools {
            SetScript  = {
                # Install AAD Tools
                #md c:\temp -ErrorAction Ignore
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

                #Install-Module -Name Azure -AllowClobber -Force
                #Install-Module -Name AzureRM -AllowClobber -Force

                Install-Module -Name MSOnline -Force

                Install-Module -Name AzureAD -Force

                Install-Module -Name AzureADPreview -Force
            }

            GetScript  = { @{} }
            TestScript = { 
                $key = Get-Module -Name MSOnline -ListAvailable
                return ($key -ine $null)
            }
            #Credential = $DomainCreds
            #PsDscRunAsCredential = $DomainCreds

            #DependsOn  = '[xADCSWebEnrollment]CertSrv'
        }
    }
}

<#

ADFS2.0
https://msdn.microsoft.com/ja-jp/library/azure/dn151313.aspx

Download 2008R2
https://download.microsoft.com/download/F/3/D/F3D66A7E-C974-4A60-B7A5-382A61EB7BC6/RTW/W2K8R2/amd64/AdfsSetup.exe

#>