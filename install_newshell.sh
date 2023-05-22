ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime # sets the timezone
hwclock --systohc # syncs the hardware clock to the system clock
sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen # sets US English to be the default language
locale-gen # regenerates the locale file
echo 'KEYMAP=no-latin1' >> /etc/vconsole.conf # sets the default keyboard layout
echo 'arch-test' > /etc/hostname # sets the hostname for the OS
echo '127.0.0.1 localhost' > /etc/hosts # sets up localhost
echo '::1 localhost' >> /etc/hosts # sets up localhost
echo '127.0.0.1 arch-test.localdomain arch-test' >> /etc/hosts  # sets up localhost
pacman -S --noconfirm networkmanager # installs networkmanager with --noconfirm to force install it
systemctl enable NetworkManager # enable networkmanager
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | passwd # set the password of the root user to 'root'
    root # sets the password to 'root'
    root # confirm
EOF
pacman -S --noconfirm grub efibootmgr # installs grub and efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi # installs grub as the bootloader
grub-mkconfig -o /boot/grub/grub.cfg # makes the config file for grub
exit # exit out of the filesystem