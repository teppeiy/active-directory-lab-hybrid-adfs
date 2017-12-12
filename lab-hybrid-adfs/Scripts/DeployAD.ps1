param (
    [string]$domain = "consoto.com",
    [string]$password = "P@ssw0rd1",
	[string]$DomainMode = "Win2012",
	[string]$ForestMode =  "Win2012",
	<# https://technet.microsoft.com/en-us/library/hh974720%28v=wps.630%29.aspx?f=255&MSPPError=-2147217396
	 -- Windows Server 2003: 2 or Win2003
     -- Windows Server 2008: 3 or Win2008
     -- Windows Server 2008 R2: 4 or Win2008R2
     -- Windows Server 2012: 5 or Win2012
     -- Windows Server 2012 R2: 6 or Win2012R2
	#>
	[string]$adImageSKU = "2012-R2-Datacenter"
	#"allowedValues": [ "2016-Datacenter", "2012-R2-Datacenter", "2008-R2-SP1" ]
)

#$ErrorActionPreference = "Stop"
$ErrorActionPreference = "Continue"

$completeFile="c:\temp\prereqsComplete"
if (!(Test-Path -Path "c:\temp")) {
    md "c:\temp"
}

$step=1
if (!(Test-Path -Path "$($completeFile)$step")) {
    # Shortcuts
	<#
	if (!(Test-Path -Path "c:\AADLab")) {
		md "c:\AADLab" -ErrorAction Ignore
	}
	#>

	$WshShell = New-Object -comObject WScript.Shell
	$dt="C:\Users\Public\Desktop\"
	$ieicon="%ProgramFiles%\Internet Explorer\iexplore.exe, 0"

	$links = @(
		@{site="http://connect.microsoft.com/site1164";name="Azure AD Connect Home";icon=$ieicon},
		@{site="https://docs.microsoft.com/en-us/azure/active-directory/connect/active-directory-aadconnect";name="Azure AD Docs";icon=$ieicon},
		@{site="http://connect.microsoft.com/site1164/Downloads/DownloadDetails.aspx?DownloadID=59185";name="Download Azure AD Powershell";icon=$ieicon},
		@{site="%windir%\system32\WindowsPowerShell\v1.0\PowerShell_ISE.exe";name="PowerShell ISE";icon="%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell_ise.exe, 0"},
		@{site="%SystemRoot%\system32\dsa.msc";name="AD Users and Computers";icon="%SystemRoot%\system32\dsadmin.dll, 0"},
		@{site="%SystemRoot%\system32\domain.msc";name="AD Domains and Trusts";icon="%SystemRoot%\system32\domadmin.dll, 0"},
		@{site="%SystemRoot%\system32\dnsmgmt.msc";name="DNS";icon="%SystemRoot%\system32\dnsmgr.dll, 0"},
		@{site="%windir%\system32\services.msc";name="Services";icon="%windir%\system32\filemgmt.dll, 0"},
		@{site="c:\AADLab";name="AAD Lab Files";icon="%windir%\explorer.exe, 13"}
	)

	foreach($link in $links){
		$Shortcut = $WshShell.CreateShortcut("$($dt)$($link.name).lnk")
		$Shortcut.TargetPath = $link.site
		$Shortcut.IconLocation = $link.icon
		$Shortcut.Save()
	}

    #record that we got this far
    New-Item -ItemType file "$($completeFile)$step"
	$log = "$($completeFile).log"
	New-Item -ItemType File $log
}

$step=2
if (!(Test-Path -Path "$($completeFile)$step")) {
    $smPassword = (ConvertTo-SecureString $password -AsPlainText -Force)

	if($adImageSKU -eq "2008-R2-SP1"){# Win2008R2
		"In 2008-R2-SP1 path: $adImageSKU" >> $log
		$loc = Get-Location
		$unattendedFile = "unattended.txt"
		"Creating $unattendedFile in $loc" >> $log

		$netbiosName = $domain.Split(".")[0]
		New-item -ItemType File "$unattendedFile" -Force
		"[DCInstall]" >> $unattendedFile
		"ReplicaOrNewDomain=Domain" >> $unattendedFile
		"NewDomain=Forest" >> $unattendedFile
		"NewDomainDNSName=$domain" >> $unattendedFile
		"ForestLevel=4" >> $unattendedFile
		"DomainNetbiosName=$netbiosName" >> $unattendedFile
		"DomainLevel=4" >> $unattendedFile
		"InstallDNS=Yes" >> $unattendedFile
		"ConfirmGc=Yes" >> $unattendedFile
		"CreateDNSDelegation=No" >> $unattendedFile
		"SafeModeAdminPassword=$smPassword" >> $unattendedFile

		"Unattended file created" >> $log
		"Promoting DC" >> $log

		& dcpromo /unattend:$unattendedFile

		"Promo completed" >> $log
	}
	else{ # Win2012 or above
		#Install AD, reconfig network
		New-Item -ItemType file "$($completeFile)not2008r2"
		Install-WindowsFeature -Name "AD-Domain-Services" `
							   -IncludeManagementTools `
							   -IncludeAllSubFeature 

		Install-ADDSForest -DomainName $domain `
						   -DomainMode $DomainMode `
						   -ForestMode $ForestMode `
						   -Force `
						   -SafeModeAdministratorPassword $smPassword 
	}

    #record that we got this far
    New-Item -ItemType file "$($completeFile)$step"
}

$step=3
if (!(Test-Path -Path "$($completeFile)$step")) {
    $Dns = "127.0.0.1"
    $IPType = "IPv4"

	if($adImageSKU -eq "2008-R2-SP1"){# Win2008R2
		"Network config for 2008-R2-SP1" >> $log
	}
	else{ # Win2012 or above
		"Network config for Win2012 or above" >> $log
		# Retrieve the network adapter that you want to configure
		$adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
		$cfg = ($adapter | Get-NetIPConfiguration)
		$IP = $cfg.IPv4Address.IPAddress
		$Gateway = $cfg.IPv4DefaultGateway.NextHop
		$MaskBits = $cfg.IPv4Address.PrefixLength

		# Remove any existing IP, gateway from our ipv4 adapter
		If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
			$adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
		}

		If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
			$adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
		}
	}
    #record that we got this far
    New-Item -ItemType file "$($completeFile)$step"
}

$step=4
if (!(Test-Path -Path "$($completeFile)$step")) {
    # Configure the IP address and default gateway
    $adapter | New-NetIPAddress `
        -AddressFamily $IPType `
        -IPAddress $IP `
        -PrefixLength $MaskBits `
        -DefaultGateway $Gateway

    # Configure the DNS client server IP addresses
    $adapter | Set-DnsClientServerAddress -ServerAddresses $DNS

    #record that we got this far
    New-Item -ItemType file "$($completeFile)$step"
}

$step=5
if (!(Test-Path -Path "$($completeFile)$step")) {
    # Install Tools
    
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
	Install-Module -Name MSOnline -Force
	Install-Module -Name AzureAD -Force
	Install-Module -Name AzureADPreview -AllowClobber -Force

    #record that we got this far
    New-Item -ItemType file "$($completeFile)$step"

}
