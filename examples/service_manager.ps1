# 服务管理示例脚本
# 用法：./scripts/psctl.sh -f examples/service_manager.ps1 [status|start|stop] [service_name]

param(
    [string]$Action = "status",
    [string]$ServiceName = ""
)

function Show-Services {
    param(
        [string]$Status = "Running",
        [int]$TopCount = 15
    )
    
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "       Windows 服务 ($Status)" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    Get-Service | Where-Object { $_.Status -eq $Status } | 
        Sort-Object DisplayName | 
        Select-Object -First $TopCount | 
        Format-Table -AutoSize Name, DisplayName, Status
}

switch ($Action.ToLower()) {
    "status" {
        if ($ServiceName) {
            Write-Host "服务状态：$ServiceName" -ForegroundColor Green
            Get-Service -Name $ServiceName -ErrorAction SilentlyContinue | 
                Format-List Name, DisplayName, Status, StartType
        } else {
            Show-Services -Status "Running"
            Write-Host ""
            Show-Services -Status "Stopped"
        }
    }
    
    "start" {
        if (-not $ServiceName) {
            Write-Host "错误：请指定服务名称" -ForegroundColor Red
            exit 1
        }
        Write-Host "启动服务：$ServiceName" -ForegroundColor Yellow
        Start-Service -Name $ServiceName -Verbose
        Write-Host "完成" -ForegroundColor Green
    }
    
    "stop" {
        if (-not $ServiceName) {
            Write-Host "错误：请指定服务名称" -ForegroundColor Red
            exit 1
        }
        Write-Host "停止服务：$ServiceName" -ForegroundColor Yellow
        Stop-Service -Name $ServiceName -Force -Verbose
        Write-Host "完成" -ForegroundColor Green
    }
    
    default {
        Write-Host "用法：$0 [status|start|stop] [service_name]" -ForegroundColor Red
        Write-Host "示例：" -ForegroundColor Yellow
        Write-Host "  $0 status              # 查看所有服务"
        Write-Host "  $0 status spooler      # 查看 spooler 服务"
        Write-Host "  $0 start spooler       # 启动 spooler 服务"
        Write-Host "  $0 stop spooler        # 停止 spooler 服务"
        exit 1
    }
}
