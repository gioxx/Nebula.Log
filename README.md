# Nebula.Log

**Nebula.Log** is a lightweight and configurable logging module for PowerShell scripts.

![PowerShell Gallery](https://img.shields.io/powershellgallery/v/Nebula.Log?label=PowerShell%20Gallery)
![Downloads](https://img.shields.io/powershellgallery/dt/Nebula.Log?color=blue)

---

## ✨ Features

- Logging with levels: `INFO`, `SUCCESS`, `WARNING`, `DEBUG`, `ERROR`
- Output to both console and log file
- Auto-archives log file if it exceeds 512 KB
- Includes alias `Log-Message`

---

## 📦 Installation

Install from the [PowerShell Gallery](https://www.powershellgallery.com/packages/Nebula.Log):

```powershell
Install-Module -Name Nebula.Log -Scope CurrentUser
```

---

## 🚀 Usage

Basic example:

```powershell
Write-Log -LogLocation "C:\Logs" -Message "Starting script..." -Level "INFO" -WriteToFile
```

Testing the logging setup:

```powershell
Test-ActivityLog -LogLocation "C:\Logs"
```

---

## 🧪 Testing with Pester

```powershell
Invoke-Pester -Script .\Nebula.Log.Tests.ps1
```

---

## 🔧 Development

This module is part of the [Nebula](https://github.com/gioxx?tab=repositories&q=Nebula) PowerShell tools family.

Feel free to fork, improve and submit pull requests.

---

## 📄 License

Licensed under the [MIT License](https://opensource.org/licenses/MIT).
