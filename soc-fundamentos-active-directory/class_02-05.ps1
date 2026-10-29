# Open PowerShell:

powershell

# Forcing all policies

gpupdate /force

# Check the policies by category

auditpol /get /category:*

# Report of policies

gpresult /r

# event viewer for final validation

eventvwr.msc
