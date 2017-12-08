Param(
    [string] $ProgramsToInstall = "programs.json"
)

function DownloadAndInstallMsi ($downloadUrl, $quietInstall) {
    $exe="c:\windows\system32\msiexec.exe"
    $tempfile = [System.IO.Path]::GetTempFileName()
    $folder = [System.IO.Path]::GetDirectoryName($tempfile)
    $webclient = New-Object System.Net.WebClient
    $webclient.DownloadFile($downloadUrl, $tempfile)
    $msiName = [System.IO.Path]::GetRandomFileName() + ".msi"
    Write-Output $msiName
    Rename-Item -Path $tempfile -NewName $msiName
    $MSIPath = $folder + "\" + $msiName
    if ($quietInstall){
        Write-Output "Silently Installing $downloadUrl"  
        $argumentlist = "/i " + $MSIPath + " /q"
    }
    else{
        Write-Output "Installing $downloadUrl"  
        $argumentlist = "/i " + $MSIPath
    }
    Start-Process -FilePath "C:\Windows\System32\msiexec.exe" -ArgumentList $argumentlist

    #add " /q" to the string after "/i" for a silent install - the icon will be placed on the desktop ready to proceed.
}

Function DownloadAndInstallExe
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $uri,
        [string]
        $option
    )
    #$LocalTempDir = $env:TEMPo
    $LocalTempDir = "C:\Downloads"
    md -Force $LocalTempDir

    $installer = (new-guid).toString() + ".exe"
    (new-object System.Net.WebClient).DownloadFile($uri, "$LocalTempDir\$installer")

    Write-Output "Executing: $LocalTempDir\$installer $option"
    & "$LocalTempDir\$installer" $option
    $Process2Monitor =  $installer
    Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$installer" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
}
Set-ExecutionPolicy Unrestricted -force
$programs = Get-content -Path $ProgramsToInstall | ConvertFrom-Json
Write-Output $programs

foreach($p in $programs.programs){
    Write-output "Downloading and Installing $p.name"
    if($p.extension -eq 'msi'){
        DownloadAndInstallMsi $p.uri $true
        }
        else{
    DownloadAndInstallExe $p.uri $p.option
 }}
