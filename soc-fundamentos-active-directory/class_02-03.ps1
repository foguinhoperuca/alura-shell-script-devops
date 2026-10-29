# FGPP - Fine-Grained Password Policy

## Create
New-ADFineGrainedPasswordPolicy `
    -Name "PSO-Admins" `
    -Precedence 10 `
    -MinPasswordLength 16 `
    -PasswordHistoryCount 24 `
    -ComplexityEnabled $true `
    -LockoutThreshold 3 `
    -LockoutDuration "00:30:00" `
    -LockoutObservationWindow "00:30:00" `
    -MaxPasswordAge "90.00:00:00"

## Add to a group
Add-ADFineGrainedPasswordPolicySubject `
    -Identity "PSO-Admins" `
    -Subjects "Domain Admins"

# GPO diagnosis

gpresult /R                     # show all of user/computer
gpresult /H report.html         # show all with conflict and save it in a file
