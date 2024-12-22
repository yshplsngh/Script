## Fedora Scripts

- [encryption.sh](encryption.sh) - Decrypt and edit files using GPG


### How to use make script executable universally

- copy script to /bin without any extension
- make script executable
- ``` chmod +x /bin/encryption ```
- now you can run the script by typing ``` encryption <filename> ``` in the terminal from anywhere
- Incase of something goes wrong, you can access the original encrypted file from `/home/yshplsngh/.scbp`