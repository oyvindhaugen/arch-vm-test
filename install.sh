curl -L https://raw.githubusercontent.com/oyvindhaugen/arch-vm-test/main/install_newshell.sh -o /mnt/root/part2.sh
chmod +x /mnt/root/part2.sh
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
arch-chroot /mnt /mnt/root/part2.sh # enter the filesystem in the /mnt directory
reboot # reboots the system
