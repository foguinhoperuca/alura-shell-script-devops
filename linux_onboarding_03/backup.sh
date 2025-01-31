#|/bin/bash

echo "Which folder you wanna backup?"
read folder_bkp

cp -rv $folder_backup ~/backup
echo ""
echo "Dummy backup is done!"
