<powershell>

Import-Module Carbon 

stop-service IapsNDeliusInterfaceWinService
stop-service IMIapsInterfaceWinService

$adminUser = (Get-SSMParameterValue -Name ${user_ssm_path}).Parameters.Value
$adminPassword = (Get-SSMParameterValue -Name ${password_ssm_path} -WithDecryption $true).Parameters.Value

$adminCreds = New-Credential -UserName "$adminUser" -Password "$adminPassword"
Install-User -Credential $adminCreds

Add-GroupMember -Name Administrators -Member $adminUser

$ComputerName = "${host_name}"
[System.Environment]::SetEnvironmentVariable("ExternalDomain", "${external_domain}",[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("ExternalDomain", "${external_domain}", [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable("ExternalDomain", "${external_domain}", [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("InternalDomain", "${internal_domain}",[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("InternalDomain", "${internal_domain}", [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable("InternalDomain", "${internal_domain}", [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("PSNProxy", "${psn_proxy_endpoint}",[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PSNProxy", "${psn_proxy_endpoint}", [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable("PSNProxy", "${psn_proxy_endpoint}", [System.EnvironmentVariableTarget]::User)

Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname" 
Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname" 

New-PSDrive -name HKU -PSProvider "Registry" -Root "HKEY_USERS"

Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername" -name "Computername" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\ActiveComputername" -name "Computername" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname" -value  $ComputerName
Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "AltDefaultDomainName" -value $ComputerName
Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "DefaultDomainName" -value $ComputerName

# Resize system drive if overridden from ami value
$MaxSize = (Get-PartitionSupportedSize -DriveLetter C).sizeMax
Resize-Partition -DriveLetter C -Size $MaxSize

# Set timezone
tzutil /s 'GMT Standard Time' 

stop-service IapsNDeliusInterfaceWinService
stop-service IMIapsInterfaceWinService

# Run all scripts that apply runtime config
$runtimeconfig = 'C:\Setup\RunTimeConfig'
Get-ChildItem $runtimeconfig -Filter *.ps1 | 
    Foreach-Object {
        stop-service IapsNDeliusInterfaceWinService
        stop-service IMIapsInterfaceWinService
        & $runtimeconfig\$_
    }

Write-output '-----------------------------------------------------------------'
Write-output 'Now restoring latest Config backup for this environment from S3..'
& C:\Setup\RestoreLatestIAPSConfig.ps1
Write-output '-----------------------------------------------------------------'

Write-output '-----------------------------------------------------------------'
write-output 'Stopping IAPS Windows Services'
Write-output '-----------------------------------------------------------------'
stop-service IapsNDeliusInterfaceWinService
stop-service IMIapsInterfaceWinService

#====================================================================
# we need to restart the instance at least once otherwise the WMI 
# won't work as we've changed computername
#====================================================================
 $restartsfile = "C:\setup\computer-restarts.txt"
If (Test-Path -Path $restartsfile ) { 
    Write-Output "Writing file $restartsfile for 1st time"
    Write-Output "$(Get-Date) - instance has already performed 1st restart." | Out-File $restartsfile -append
}
else {
    Write-Output 'File does not exist so we have not restarted yet'
    Write-Output "$(Get-Date) - instance 1st restart." | Out-File $restartsfile -append
    Restart-Computer -Force
}

</powershell>
<persist>true</persist>