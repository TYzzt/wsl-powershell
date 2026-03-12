# 进程监控示例脚本
# 用法：./scripts/psctl.sh -f examples/process_monitor.ps1

param(
    [int]$TopCount = 10
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       进程监控 (Top $TopCount)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 按 CPU 使用率排序
Write-Host "[CPU 使用率 Top $TopCount]" -ForegroundColor Yellow
Get-Process | Sort-Object CPU -Descending | Select-Object -First $TopCount | 
    Format-Table -AutoSize Name, Id, @{Label="CPU(s)";Expression={[math]::Round($_.CPU, 2)}}, WorkingSet

# 按内存使用排序
Write-Host ""
Write-Host "[内存使用 Top $TopCount]" -ForegroundColor Yellow
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First $TopCount | 
    Format-Table -AutoSize Name, Id, @{Label="Mem(MB)";Expression={[math]::Round($_.WorkingSet / 1MB, 2)}}

# 按句柄数排序
Write-Host ""
Write-Host "[句柄数 Top $TopCount]" -ForegroundColor Yellow
Get-Process | Sort-Object Handles -Descending | Select-Object -First $TopCount | 
    Format-Table -AutoSize Name, Id, Handles

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       完成" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
