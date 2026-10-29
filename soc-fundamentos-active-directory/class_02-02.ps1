# to list tickets of user and details
klist

# clean the cache
klist purge

# see actual TGT
klist tgt

# SPN of an account
setspn -L <conta>

# Found duplication in all domain
setspn -Q */*

# Search for kerberos delegation [uncontrained delegation | contrained delegation | resource-based constrained delegation (RBCD)]

Get-ADComputer -Filter {TrustedForDelegation -eq $true}
