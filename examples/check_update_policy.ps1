# Check Windows Update Scheduled Policy
# Usage: ./scripts/psctl.sh -f examples/check_update_policy.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Windows Update Scheduled Policy" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Group Policy Configuration
Write-Host "[Group Policy]" -ForegroundColor Yellow
$auPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$au = Get-ItemProperty -Path $auPath -ErrorAction SilentlyContinue

if ($au) {
    Write-Host "  Registry Path: $auPath"
    Write-Host "  NoAutoUpdate: $($au.NoAutoUpdate)"
    Write-Host "  AUOptions: $($au.AUOptions)"
    Write-Host "  ScheduledInstallDay: $($au.ScheduledInstallDay)"
    Write-Host "  ScheduledInstallTime: $($au.ScheduledInstallTime)"
} else {
    Write-Host "  Not configured (using default settings)"
}
Write-Host ""

# Check Windows Update Service Status
Write-Host "[Windows Update Service]" -ForegroundColor Yellow
$wuauserv = Get-Service -Name wuauserv -ErrorAction SilentlyContinue
if ($wuauserv) {
    Write-Host "  Service Name: $($wuauserv.Name)"
    Write-Host "  Display Name: $($wuauserv.DisplayName)"
    Write-Host "  Status: $($wuauserv.Status)"
    Write-Host "  Start Type: $($wuauserv.StartType)"
} else {
    Write-Host "  Service not found"
}
Write-Host ""

# Explain AUOptions values
Write-Host "[AUOptions Values]" -ForegroundColor Yellow
Write-Host "  2 = Notify before download"
Write-Host "  3 = Auto download and notify for install"
Write-Host "  4 = Auto download and schedule install (default)"
Write-Host "  5 = Allow local admin to select setting"
Write-Host ""

# Explain ScheduledInstallDay
Write-Host "[ScheduledInstallDay Values]" -ForegroundColor Yellow
Write-Host "  0 = Every day"
Write-Host "  1-7 = Sunday to Saturday"
Write-Host "  Empty = Not set"
Write-Host ""

# Explain ScheduledInstallTime
Write-Host "[ScheduledInstallTime Values]" -ForegroundColor Yellow
Write-Host "  0-23 = 24-hour format"
Write-Host "  Empty = Not set"
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
