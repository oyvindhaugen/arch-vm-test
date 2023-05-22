timedatectl set-ntp true # sets the system clock to sync with network
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda # simulates input from keyboard to go through the formatting process
  g # create new gpt partition table
  n # new partition
  1 # partition number 1
    # default - start at beginning of disk 
  +550M # 100 MB EFI partition
  t # change the type of the partition
  1 # change it to an EFI partition
  n # new partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +8G  # 8 GB Swap partition
  t # change the type of the partition
  2 # select partition number 2
  19 # change it to a Linux swap partition
  n # new partition
  3 # partition number 3
    # default
    # default, rest of disk
  t # change type in case something went wrong
  3 # select partition number 3
  20 # change it to a Linux Filesystem partition
  w # write the changes to disk
EOF
mkfs.fat -F32 /dev/sda1 # format EFI partition
mkswap /dev/sda2 # format the swap partition to be a Linux Swap
swapon /dev/sda2 # turn on the Swap
mkfs.ext4 /dev/sda3 # format the filesystem to be an EXT4 Linux Filesystem
mount /dev/sda3 /mnt # mount the filesystem to the /mnt directory
mkdir /mnt/boot # make dir for EFI
mkdir /mnt/boot/efi # make dir for EFI
mount /dev/sda1 /mnt/boot/efi # mount the EFI partition to the EFI directory
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf # enables parallel downloads
pacstrap /mnt base base-devel linux linux-firmware # installs the base components of Linux
genfstab -U /mnt >> /mnt/etc/fstab # generates the fstab file with UUIDs
arch-chroot /mnt # enter the filesystem in the /mnt directory
ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime # sets the timezone
hwclock --systohc # syncs the hardware clock to the system clock
sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen # sets US English to be the default language
locale-gen # regenerates the locale file
echo "KEYMAP=no-latin1" >> /etc/vconsole.conf # sets the default keyboard layout
echo "arch-test" > /etc/hostname # sets the hostname for the OS
echo "127.0.0.1 localhost" > /etc/hosts # sets up localhost
echo "::1 localhost" >> /etc/hosts # sets up localhost
echo "127.0.0.1 arch-test.localdomain arch-test" >> /etc/hosts  # sets up localhost
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
# reboot # reboots the system
