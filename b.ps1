# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Relaunch as administrator
    Write-Host "Kjører som Administrator..."
    #Start-Process PowerShell -ArgumentList "-File", ((Get-Location).Path + "\b.ps1") -Verb RunAs
    # Get the current directory to use it in the new PowerShell session
    #$currentDirectory = Get-Location

    # Command to start PowerShell as Administrator in the current directory
    #Start-Process PowerShell -ArgumentList "-NoExit", "-Command Set-Location '$currentDirectory'" -Verb RunAs

    # Get the current directory to use it in the new PowerShell session
    $currentDirectory = Get-Location

    # Specify the path to your batch file
    $batchFilePath = ".\a.bat"

    # Command to start PowerShell as Administrator, set the location, and run the batch file
    Start-Process PowerShell -ArgumentList "-NoExit", "-Command Set-Location '$currentDirectory'; & '$batchFilePath'" -Verb RunAs
} 
else 
{
    # Retrieve all volumes and filter out those without drive letters
    $volumes = Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq 'Fixed' }

    # Loop through each volume and check BitLocker status
    foreach ($volume in $volumes) {
        $mountPoint = $volume.DriveLetter + ":"
        try 
        {
            $bitlockerStatus = Get-BitLockerVolume -MountPoint $mountPoint
            if ($bitlockerStatus.ProtectionStatus -eq 'On') 
            {
                Write-Host "Drive: $mountPoint"
                Write-Host "Status: $($bitlockerStatus.ProtectionStatus)"
                Write-Host "Encryption Percentage: $($bitlockerStatus.EncryptionPercentage)%"

                # Retrieve the BitLocker recovery key
                $recoveryKeys = $bitlockerStatus.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' }
                foreach ($key in $recoveryKeys) 
                {
                    Write-Host "  Recovery Key: $($key.RecoveryPassword)"
                }
            } 
            else 
            {
                Write-Host "Drive: $mountPoint is not encrypted or BitLocker is not active."
            }
        } 
        catch 
        {
            Write-Host "Failed to retrieve BitLocker status for $mountPoint. Error: $_"
        }
    } #ferdig å traversere volumer
    
    Write-Host "Ferdig, knast en tast..."
    [Console]::ReadKey($true) | Out-Null
}
