# 🔧 AD FSMO Tools

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)

PowerShell script for checking FSMO (Flexible Single Master Operations) role holders in Microsoft Active Directory domains.

Quickly identify which domain controllers hold FSMO roles — critical for maintenance, disaster recovery, and troubleshooting domain replication issues.

## 🏷️ Keywords

FSMO Roles, FSMO Role Holders, PowerShell FSMO, Get FSMO Roles, FSMO Check, Domain Controller Roles, Schema Master, Domain Naming Master, RID Master, PDC Emulator, Infrastructure Master.

## 📖 Table of Contents

* [Features](#features)
* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [Quick Start](#quick-start)
* [Examples](#examples)
* [Documentation](#documentation)
* [License](#license)
* [Author](#author)

## ✨ Features

* Get all five FSMO role holders in one command
* Works with any domain in the forest
* Output can be saved to a variable or piped to other cmdlets
* Verbose mode for troubleshooting

## ⚙️ Prerequisites

* Windows PowerShell 5.1 or PowerShell 7+
* Active Directory PowerShell module (RSAT-AD-PowerShell)
* Domain user account (authenticated)

## 🚀 Installation

### Option 1: Clone the repository

```powershell
git clone https://github.com/vgorin-lab/ad-fsmo-tools.git
cd ad-fsmo-tools
```

### Option 2: Download the script directly

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/vgorin-lab/ad-fsmo-tools/main/Get-FSMORoles.ps1" -OutFile "Get-FSMORoles.ps1"
```

## ⚡ Quick Start

Run the script in your current domain:

```powershell
.\Get-FSMORoles.ps1
```

## 📚 Examples

### Check roles in a specific domain

```powershell
.\Get-FSMORoles.ps1 -Domain corp.contoso.com
```

### Save results to a variable

```powershell
$fsmo = .\Get-FSMORoles.ps1
$fsmo.PDCEmulator
```

### Run with verbose output

```powershell
.\Get-FSMORoles.ps1 -Verbose
```

### Sample output

```text
=== FSMO Roles Check ===
Domain        : contoso.com
Schema Master : DC01.contoso.com
Domain Naming : DC01.contoso.com
RID Master    : DC02.contoso.com
PDC Emulator  : DC02.contoso.com
Infrastructure: DC02.contoso.com
```

For more details visit:

https://sysadmintips.ru/kak-proverit-i-uznat-roli-fsmo-v-active-directory.html

## 🔗 Documentation

Detailed articles about FSMO role management:

* [How to check FSMO roles in Active Directory](https://sysadmintips.ru/kak-proverit-i-uznat-roli-fsmo-v-active-directory.html)
* [More sysadmin tips and tricks](https://sysadmintips.ru)

## 📄 License

Distributed under the MIT License. See LICENSE file for more information.

## 👤 Author

**Vlad Gorin** (vgorin-lab)
