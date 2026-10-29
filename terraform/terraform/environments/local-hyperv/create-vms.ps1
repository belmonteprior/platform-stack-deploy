$vmNames = @('master01', 'worker01')

# Fase 1: Limpieza exhaustiva previa
foreach ($vm in $vmNames) {
    if (Get-VM -Name $vm -ErrorAction SilentlyContinue) {
        Write-Host "Forzando apagado y eliminando VM existente: $vm"
        Stop-VM -Name $vm -TurnOff -Force -ErrorAction SilentlyContinue
        Remove-VM -Name $vm -Force -Confirm:$false -ErrorAction SilentlyContinue
    }

    $vhdPath = "C:\Hyper-V\Virtual Hard Disks\$vm.vhdx"
    if (Test-Path $vhdPath) {
        Write-Host "Borrando disco virtual VHDX anterior: $vhdPath"
        Remove-Item -Path $vhdPath -Force -ErrorAction SilentlyContinue
    }
}

Start-Sleep -Seconds 3

# Fase 2: Creación limpia con 1GB (sin arranque automático para evitar bloqueo de RAM)
foreach ($vm in $vmNames) {
    $vhdPath = "C:\Hyper-V\Virtual Hard Disks\$vm.vhdx"
    Write-Host "Creando maquina limpia con 1GB: $vm"
    New-VM -Name $vm -MemoryStartupBytes 1GB -Generation 2 -SwitchName 'Default Switch'
    New-VHD -Path $vhdPath -SizeBytes 40GB -Dynamic
    Add-VMHardDiskDrive -VMName $vm -Path $vhdPath
    Set-VMMemory -VMName $vm -DynamicMemoryEnabled $false
    Set-VMProcessor -VMName $vm -Count 2
}