# Folder Redirection Permissions Setup

## Description
This PowerShell script configures permissions for folder redirection in an Active Directory environment. It ensures proper access control by resetting permissions, assigning necessary rights to system accounts, domain admins, and the designated redirection user group.

## Features
- Resets explicit permissions on the root folder.
- Grants **CREATOR OWNER**, **SYSTEM**, **Domain Admins**, and a specific **domain admin** full control.
- Applies specific access rights to the **folder redirection user group**.
- Disables inheritance to prevent permission conflicts.
- Recursively sets correct ownership for user subfolders.

---

## Usage Instructions

### 1. Modify Variables
Before running the script, update the following variables at the top of the script:

```powershell
$Domain = "CONTOSO"  # Your Active Directory domain (short name).
$Folder = 'E:\FOLDER REDIRECTS TEST'  # Root directory for folder redirections.
$RedirGroup = 'Folder Redirection Users'  # Security group of users who need to put data on the share.
$DomAdmin = 'administrator'  # Designated domain admin with full control.
```

### 2. Run the Script
Execute the script with administrative privileges:

```powershell
powershell -ExecutionPolicy Bypass -File .\FolderRedirectionPermissions.ps1
```

### 3. Verify Permissions
After execution, check permissions on the folder to ensure they were applied correctly.

---

## Requirements
- Windows Server with Active Directory.
- PowerShell (run as Administrator).
- Folder redirection setup in Group Policy.

---

## Notes
- This script **removes inheritance** on the folder, ensuring only the defined permissions apply.
- Be sure to test in a non-production environment before deploying.