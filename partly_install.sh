#before running: partition disk, format, and mount
mkdir /mnt/root
curl -L https://raw.githubusercontent.com/oyvindhaugen/arch-vm-test/main/install_newshell.sh -o /mnt/root/part2.sh
chmod +x /mnt/root/part2.sh
timedatectl set-ntp true # sets the system clock to sync with network
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf # enables parallel downloads
pacstrap /mnt base base-devel linux linux-firmware # installs the base components of Linux
genfstab -U /mnt >> /mnt/etc/fstab # generates the fstab file with UUIDs
arch-chroot /mnt /root/part2.sh # enter the filesystem in the /mnt directory
#look at /etc/hostname, hosts and /boot/grub/grub.cfg
