# Modify to Define Needed Variables:

$Domain = "CONTOSO"  # Set this to the short domain name used in usernames (e.g., "CONTOSO\john", not the full domain name).
$Folder = 'E:\FOLDER REDIRECTS TEST'  # Set this to the root directory where folder redirections are stored (e.g., "E:\Folder Redirections").
$RedirGroup = 'Folder Redirection Users'  # Set this to the group name for folder redirections.
$DomAdmin = 'administrator'  # Set this to the username of the designated domain admin - This account will be granted full control over the folder.

# ------------------ DO NOT MODIFY BELOW THIS LINE ------------------------------------------

# Clear all Explicit Permissions on the main folder
ICACLS "$Folder" /reset

# Add CREATOR OWNER permission
ICACLS "$Folder" /grant "CREATOR OWNER:(OI)(CI)(IO)F"

# Add SYSTEM permission
ICACLS "$Folder" /grant "SYSTEM:(OI)(CI)F"

# Give Domain Admins Full Control
ICACLS "$Folder" /grant "$Domain\Domain Admins:(OI)(CI)F"

# Give Specific Domain Admin Full Control
ICACLS "$Folder" /grant "${Domain}\${DomAdmin}:(OI)(CI)F"

# Apply Create Folder/Append Data, List Folder/Read Data, Read Attributes, Traverse Folder/Execute File, Read permissions to this folder only
ICACLS "$Folder" /grant "${Domain}\${RedirGroup}:(AD,REA,RA,X,RC,RD,S)"

# Disable inheritance on the main folder to avoid permission conflicts
ICACLS "$Folder" /inheritance:r

# Fix permissions for subfolders
$SubFolders = Get-ChildItem -Path $Folder -Directory

foreach ($SubFolder in $SubFolders) {
    $UserName = $SubFolder.Name
    $UserAccount = "$Domain\$UserName"
    $SubFolderPath = "$Folder\$UserName"

    Write-Host "Granting full control to user: $UserAccount on folder: $SubFolderPath"

    # Grant full control to the specific user
    ICACLS "$SubFolderPath" /grant "${UserAccount}:(OI)(CI)F"
	
	# Ensure that inheritance is enabled so user's subfolders get the same permissions
    ICACLS "$SubFolderPath" /inheritance:e

    # Propagate permissions to all user's subfolders and files
    ICACLS "$SubFolderPath" /T /C /grant "${UserAccount}:(OI)(CI)F"
}

Write-Host "Folder redirection permissions have been updated."
