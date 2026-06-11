<#
.SYNOPSIS
    Gets current FSMO role owners in an Active Directory domain.
.DESCRIPTION
    Script connects to the specified AD forest and domain, retrieves all five FSMO role holders:
    - Schema Master
    - Domain Naming Master
    - RID Master
    - PDC Emulator
    - Infrastructure Master
    Output can be saved to a variable or piped to other cmdlets.
.PARAMETER Domain
    Domain FQDN. If not specified, uses USERDNSDOMAIN environment variable.
.EXAMPLE
    .\Get-FSMORoles.ps1
    Determines FSMO roles in the user's current domain.
.EXAMPLE
    .\Get-FSMORoles.ps1 -Domain corp.contoso.com
    Checks roles in the specified domain.
.EXAMPLE
    $roles = .\Get-FSMORoles.ps1
    Saves the result to a variable for further processing.
.LINK
    Detailed article about FSMO role management:
    https://sysadmintips.ru/kak-proverit-i-uznat-roli-fsmo-v-active-directory.html
.NOTES
    Author: Vlad Gorin (vgorin-lab)
    License: MIT
    Requires: ActiveDirectory PowerShell module
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Domain = $env:USERDNSDOMAIN
)

# --- Constants and settings ---
$mySiteUrl = "https://sysadmintips.ru/kak-proverit-i-uznat-roli-fsmo-v-active-directory.html"
$ADModuleName = "ActiveDirectory"

# --- Check if domain is provided ---
if (-not $Domain) {
    Write-Error "Domain name is not specified and USERDNSDOMAIN environment variable is empty."
    exit 1
}

Write-Verbose "Target domain: $Domain"

# --- Load and verify ActiveDirectory module ---
if (-not (Get-Module -ListAvailable -Name $ADModuleName)) {
    Write-Error "Active Directory PowerShell module '$ADModuleName' is not installed. Please install RSAT-AD-PowerShell feature."
    exit 1
}

try {
    Import-Module $ADModuleName -ErrorAction Stop
    Write-Verbose "Module '$ADModuleName' imported successfully."
} catch {
    Write-Error "Failed to import Active Directory module: $_"
    exit 1
}

# --- Get AD objects ---
try {
    Write-Verbose "Getting AD forest for domain: $Domain"
    $forest = Get-ADForest -Identity $Domain -ErrorAction Stop

    Write-Verbose "Getting AD domain for domain: $Domain"
    $domain = Get-ADDomain -Identity $Domain -ErrorAction Stop
} catch {
    Write-Error "Failed to retrieve AD objects for domain '$Domain': $_"
    exit 1
}

# --- Collect roles ---
$roles = [PSCustomObject]@{
    SchemaMaster         = $forest.SchemaMaster
    DomainNamingMaster   = $forest.DomainNamingMaster
    RIDMaster            = $domain.RIDMaster
    PDCEmulator          = $domain.PDCEmulator
    InfrastructureMaster = $domain.InfrastructureMaster
}

# --- Output results ---
Write-Output "=== FSMO Roles Check ==="
Write-Output "Domain        : $Domain"
Write-Output "Schema Master : $($roles.SchemaMaster)"
Write-Output "Domain Naming : $($roles.DomainNamingMaster)"
Write-Output "RID Master    : $($roles.RIDMaster)"
Write-Output "PDC Emulator  : $($roles.PDCEmulator)"
Write-Output "Infrastructure: $($roles.InfrastructureMaster)"

# --- Warning if any role is missing ---
$missingRoles = @()
if (-not $roles.SchemaMaster) { $missingRoles += "Schema Master" }
if (-not $roles.DomainNamingMaster) { $missingRoles += "Domain Naming Master" }
if (-not $roles.RIDMaster) { $missingRoles += "RID Master" }
if (-not $roles.PDCEmulator) { $missingRoles += "PDC Emulator" }
if (-not $roles.InfrastructureMaster) { $missingRoles += "Infrastructure Master" }

if ($missingRoles.Count -gt 0) {
    Write-Warning "Some FSMO roles could not be retrieved: $($missingRoles -join ', ')"
}

Write-Output "`nFor more details visit: $mySiteUrl"

# --- Return object to pipeline ---
return $roles
