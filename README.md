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

### 🔍 `Test-ActivityLog` in detail

This function validates the availability and write capability of a specified activity log file.

#### **Syntax**

```powershell
Test-ActivityLog -LogLocation <String> [-LogFileName <String>]
```

#### **Parameters**

- `LogLocation` (String, **Required**)  
  The directory where the log file is expected to be located.

- `LogFileName` (String, Optional)  
  The name of the log file. Defaults to `activity.log` if not specified.

#### **Description**

`Test-ActivityLog` checks whether the specified log file exists and is writable by the current user. If the file doesn't exist or is not writable, it returns `"KO"` and writes an error. If everything is in order, it appends a test entry and returns `"OK"`.

This is useful for automated checks or pre-flight validations before starting logging operations.

#### **Example**

```powershell
Test-ActivityLog -LogLocation "C:\Logs"
```

Returns `"OK"` if `C:\Logs\activity.log` exists and is writable, otherwise `"KO"`.

---

## 🧪 Testing with Pester

```powershell
Invoke-Pester -Script .\Nebula.Log.Tests.ps1
```

---

## 🧽 How to clean up old module versions (optional)

When updating from previous versions, old files (such as unused `.psm1`, `.yml`, or `LICENSE` files) are not automatically deleted.  
If you want a completely clean setup, you can remove all previous versions manually:

```powershell
# Remove all installed versions of the module
Uninstall-Module -Name Nebula.Log -AllVersions -Force

# Reinstall the latest clean version
Install-Module -Name Nebula.Log -Scope CurrentUser -Force
```

ℹ️ This is entirely optional — PowerShell always uses the most recent version installed.

---

## 🔧 Development

This module is part of the [Nebula](https://github.com/gioxx?tab=repositories&q=Nebula) PowerShell tools family.

Feel free to fork, improve and submit pull requests.

---

## 📄 License

Licensed under the [MIT License](https://opensource.org/licenses/MIT).
