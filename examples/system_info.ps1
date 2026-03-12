# 系统信息示例脚本
# 用法：./scripts/psctl.sh -f examples/system_info.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       Windows 系统信息" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 系统基本信息
Write-Host "[系统信息]" -ForegroundColor Green
$computerInfo = Get-ComputerInfo
Write-Host "  操作系统：$($computerInfo.WindowsProductName)"
Write-Host "  版本号：$($computerInfo.WindowsVersion)"
Write-Host "  系统目录：$($computerInfo.WindowsSystemDirectory)"
Write-Host ""

# CPU 信息
Write-Host "[CPU 信息]" -ForegroundColor Green
Get-CimInstance Win32_Processor | ForEach-Object {
    Write-Host "  名称：$($_.Name)"
    Write-Host "  核心数：$($_.NumberOfCores)"
    Write-Host "  逻辑处理器：$($_.NumberOfLogicalProcessors)"
}
Write-Host ""

# 内存信息
Write-Host "[内存信息]" -ForegroundColor Green
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "  总内存：$([math]::Round($os.TotalVisibleMemorySize / 1MB, 2)) GB"
Write-Host "  可用内存：$([math]::Round($os.FreePhysicalMemory / 1MB, 2)) GB"
Write-Host ""

# 磁盘信息
Write-Host "[磁盘信息]" -ForegroundColor Green
Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
    $freeGB = [math]::Round($_.FreeSpace / 1GB, 2)
    $totalGB = [math]::Round($_.Size / 1GB, 2)
    $percent = [math]::Round(($_.FreeSpace / $_.Size) * 100, 1)
    Write-Host "  $($_.DeviceID): $freeGB GB / $totalGB GB (可用 $percent%)"
}
Write-Host ""

# 网络信息
Write-Host "[网络信息]" -ForegroundColor Green
Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultRoute -ne $null } | ForEach-Object {
    Write-Host "  适配器：$($_.InterfaceAlias)"
    Write-Host "  IP 地址：$($_.IPv4Address.IPAddress)"
    Write-Host "  DNS: $($_.DNSServer.ServerAddresses -join ', ')"
}
Write-Host ""

# 运行时间
Write-Host "[运行时间]" -ForegroundColor Green
$os = Get-CimInstance Win32_OperatingSystem
$lastBoot = $os.LastBootUpTime
$uptime = (Get-Date) - $lastBoot
Write-Host "  启动时间：$lastBoot"
Write-Host "  运行时间：$($uptime.Days) 天 $($uptime.Hours) 小时 $($uptime.Minutes) 分钟"
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       完成" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
