<#
.SYNOPSIS
    Quickly identifies which domain controllers hold the five FSMO roles.
.DESCRIPTION
    This script queries Active Directory to determine which domain controllers
    currently hold the five Flexible Single Master Operations (FSMO) roles:
    - Schema Master
    - Domain Naming Master
    - PDC Emulator
    - RID Master
    - Infrastructure Master
    
    Useful for troubleshooting, migrations, and routine AD health checks.
    
    Companion tool for sysadmintips.ru Active Directory guides.
.PARAMETER Domain
    The domain to query. Defaults to the current user's domain.
.EXAMPLE
    .\Get-FSMORoles.ps1
    
    Displays FSMO role holders for the current domain.
.EXAMPLE
    .\Get-FSMORoles.ps1 -Domain "contoso.com"
    
    Displays FSMO role holders for the specified domain.
.NOTES
    Author: Vlad Gorin
    Website: sysadmintips.ru
    GitHub: github.com/vgorin-lab
    Requires: Active Directory PowerShell module (RSAT-AD-PowerShell)
.LINK
    https://sysadmintips.ru/kak-proverit-i-uznat-roli-fsmo-v-active-directory.html
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$Domain = $env:USERDNSDOMAIN
)

#Requires -Modules ActiveDirectory

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " Active Directory FSMO Roles Check" -ForegroundColor Cyan
Write-Host " Author: Vlad Gorin | sysadmintips.ru" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

try {
    Write-Host "Querying domain: $Domain" -ForegroundColor Gray
    Write-Host "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n" -ForegroundColor Gray
    
    # Get forest-level FSMO roles
    $forest = Get-ADForest -Identity $Domain -ErrorAction Stop
    
    # Get domain-level FSMO roles
    $domainObj = Get-ADDomain -Identity $Domain -ErrorAction Stop
    
    Write-Host "--- Forest-Level FSMO Roles ---" -ForegroundColor Yellow
    Write-Host "Schema Master:        " -NoNewline
    Write-Host "$($forest.SchemaMaster)" -ForegroundColor Green
    Write-Host "  → Manages updates to the AD schema" -ForegroundColor DarkGray
    
    Write-Host "Domain Naming Master: " -NoNewline
    Write-Host "$($forest.DomainNamingMaster)" -ForegroundColor Green
    Write-Host "  → Controls addition/removal of domains in forest" -ForegroundColor DarkGray
    
    Write-Host "`n--- Domain-Level FSMO Roles ---" -ForegroundColor Yellow
    Write-Host "PDC Emulator:         " -NoNewline
    Write-Host "$($domainObj.PDCEmulator)" -ForegroundColor Green
    Write-Host "  → Time sync, password changes, Group Policy updates" -ForegroundColor DarkGray
    
    Write-Host "RID Master:           " -NoNewline
    Write-Host "$($domainObj.RIDMaster)" -ForegroundColor Green
    Write-Host "  → Allocates RID pools for security principals" -ForegroundColor DarkGray
    
    Write-Host "Infrastructure Master: " -NoNewline
    Write-Host "$($domainObj.InfrastructureMaster)" -ForegroundColor Green
    Write-Host "  → Updates cross-domain references" -ForegroundColor DarkGray
    
    # Check if all roles are on the same DC (potential risk)
    $allRoles = @(
        $forest.SchemaMaster,
        $forest.DomainNamingMaster,
        $domainObj.PDCEmulator,
        $domainObj.RIDMaster,
        $domainObj.InfrastructureMaster
    )
    
    $uniqueDCs = $allRoles | Sort-Object -Unique
    
    Write-Host "`n--- Analysis ---" -ForegroundColor Yellow
    if ($uniqueDCs.Count -eq 1) {
        Write-Host "⚠ WARNING: All FSMO roles are on a single DC: $($uniqueDCs[0])" -ForegroundColor Red
        Write-Host "  Consider distributing roles for better fault tolerance." -ForegroundColor DarkGray
    } else {
        Write-Host "✓ FSMO roles distributed across $($uniqueDCs.Count) domain controllers" -ForegroundColor Green
        Write-Host "  DCs holding roles: $($uniqueDCs -join ', ')" -ForegroundColor DarkGray
    }
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host " For detailed FSMO management guide:" -ForegroundColor Cyan
    Write-Host " https://sysadmintips.ru/kak-proverit-i-uznat-roli-fsmo-v-active-directory.html" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
} catch {
    Write-Host "`n❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure you have:" -ForegroundColor Yellow
    Write-Host "  1. Active Directory PowerShell module installed" -ForegroundColor Yellow
    Write-Host "  2. Appropriate permissions to query AD" -ForegroundColor Yellow
    Write-Host "  3. Network connectivity to domain controllers`n" -ForegroundColor Yellow
}