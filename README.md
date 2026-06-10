# Active Directory FSMO Tools

PowerShell scripts for managing and auditing FSMO (Flexible Single Master Operations) roles in Active Directory environments.

## 📋 Overview

FSMO roles are critical components of Active Directory infrastructure. These tools help system administrators quickly identify which domain controllers hold specific FSMO roles and analyze their distribution across the infrastructure.

## 📜 Scripts

### `Get-FSMORoles.ps1`

Quickly identifies which domain controllers currently hold the five FSMO roles:

**Forest-Level Roles:**
- Schema Master
- Domain Naming Master

**Domain-Level Roles:**
- PDC Emulator
- RID Master
- Infrastructure Master

## 🚀 Usage

### Basic Usage
```powershell
.\Get-FSMORoles.ps1
