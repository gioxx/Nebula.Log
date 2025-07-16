# Nebula.Log

**Nebula.Log** is a lightweight and configurable logging module for PowerShell scripts.

![PowerShell Gallery](https://img.shields.io/powershellgallery/v/Nebula.Log?label=PowerShell%20Gallery)
![Downloads](https://img.shields.io/powershellgallery/dt/Nebula.Log?color=blue)

---

## ✨ Features

- Logging with levels: `INFO`, `SUCCESS`, `WARNING`, `DEBUG`, `ERROR`
- Output to both console and log file (you can also choose to output only on log file using `-WriteOnlyToFile` switch)
- Auto-archives log file if it exceeds 512 KB
- You can test the logging setup using `Test-ActivityLog` function ([read more](#-test-activitylog-in-detail))
- Includes alias `Log-Message` (to call `Write-Log` function)

---

## 📦 Installation

Install from the [PowerShell Gallery](https://www.powershellgallery.com/packages/Nebula.Log):

```powershell
Install-Module -Name Nebula.Log -Scope CurrentUser
```

---

## 🚀 Usage

Basic example (output to both console and log file):

```powershell
Write-Log -LogLocation "C:\Logs" -Message "Starting script ..." -Level "INFO" -WriteToFile
```

Basic example (output to log file only):

```powershell
Write-Log -LogLocation "C:\Logs" -Message "Starting script ..." -Level "INFO" -WriteToFile -WriteOnlyToFile
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

- `TryFix` (Switch, Optional)  
  If the `activity.log` file is not writable, the function tries to rename the old file and create a new one where new log messages can be written.

#### **Description**

`Test-ActivityLog` checks whether the specified log file exists and is writable by the current user. If the file doesn't exist or is not writable, it returns `"KO"` and writes an error. If everything is in order, it appends a test entry and returns `"OK"`. You can also use `TryFix` switch in case the file is not writable, to attempt an automatic _repair_.

This is useful for automated checks or pre-flight validations before starting logging operations.

#### **Example**

```powershell
Test-ActivityLog -LogLocation "C:\Logs"
```

Returns `"OK"` if `C:\Logs\activity.log` exists and is writable, otherwise `"KO"`.

```powershell
Test-ActivityLog -LogLocation "C:\Logs" -TryFix
```

Try renaming the old, damaged, non-writable file so that you can create a new one in which to keep track of new log messages.

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
