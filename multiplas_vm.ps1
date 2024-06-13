# Parâmetros
$vmPrefix = "UbuntuVM"
$vmCount = 5
$vmMemory = 1GB
$vmCpuCount = 1
$isoPath = "C:\Users\Administrator\Downloads\ubuntu-22.04.4-live-server-amd64.iso"
$vSwitchName = "VT-WAN-1"
$vmPath = "C:\Hyper-V\VMs"

# Criação do diretório para as VMs se não existir
if (-Not (Test-Path $vmPath)) {
    New-Item -ItemType Directory -Path $vmPath
}

for ($i = 1; $i -le $vmCount; $i++) {
    $vmName = "$vmPrefix$i"
    $vmStoragePath = "$vmPath\$vmName"

    # Criação do diretório para o armazenamento da VM
    if (-Not (Test-Path $vmStoragePath)) {
        New-Item -ItemType Directory -Path $vmStoragePath
    }

    # Criação da VM
    New-VM -Name $vmName -MemoryStartupBytes $vmMemory -Generation 1 -NewVHDPath "$vmStoragePath\$vmName.vhdx" -NewVHDSizeBytes 20GB -Path $vmStoragePath

    # Configuração do vSwitch
    Connect-VMNetworkAdapter -VMName $vmName -SwitchName $vSwitchName

    # Configuração da CPU
    Set-VMProcessor -VMName $vmName -Count $vmCpuCount

    # Adição da ISO
    Add-VMDvdDrive -VMName $vmName -Path $isoPath

    # Configuração para inicializar a partir da ISO
    Set-VMFirmware -VMName $vmName -FirstBootDevice $(Get-VMDvdDrive -VMName $vmName)

    Write-Host "VM $vmName criada e configurada com sucesso."
}

Write-Host "Todas as VMs foram criadas e configuradas."
