echo "put $1" | sftp -o StrictHostKeyChecking=accept-new -o 'PubkeyAcceptedKeyTypes +ssh-rsa' -b - casftp.caepinstaller@casftp.blob.core.windows.net
if [ $? -eq 0 ]
then
    echo "File uploaded"
else
    echo "mkdir $1ERROR-UPLOAD" | sftp -o StrictHostKeyChecking=accept-new -o 'PubkeyAcceptedKeyTypes +ssh-rsa' -b - casftp.caepinstaller@casftp.blob.core.windows.net
fi