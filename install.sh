
#pvcreate -y /dev/sda2
#vgcreate os_vg /dev/sda2
#lvcreate -n swap_vol os_vg -L 2G
#lvcreate -l 100%FREE -n root_vol os_vg

1 root@archiso ~ # cat arch_install.yml                                                                                                                                                   :(
---
- hosts: localhost
  tasks:
    - shell: echo "hello world"
root@archiso ~ # ansible-playbook -i "localhost," -c local arch_install.yml


install git ansible

echo ", 250M, 82" | sfdisk --force /dev/sda
echo ", ," | sfdisk -a --force /dev/sda
mkswap /dev/sda1
swapon /dev/sda1
mkfs.ext4 -F /dev/sda2
mount /dev/sda2 /mnt
pacstrap /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab
sed -i 's/\#en_US\.UTF-8/en_US\.UTF-8/; s/\#ru_RU/ru_RU/'  /mnt/etc/locale.gen
arch-chroot /mnt locale-gen 
echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf
#arch-chroot /mnt export LANG=en_US.UTF-8
arch-chroot /mnt  ln -s /usr/share/zoneinfo/America/Vancouver /etc/localtime
arch-chroot /mnt hwclock --systohc --utc
echo "neptune" > /mnt/etc/hostname
sed -i 's/^\#\[multilib\]/[multilib]/;  /\[multilib\]/{n;s/^#Include/Include/}' /mnt/etc/pacman.conf
sed -i '$a\ \n[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/$arch' /mnt/etc/pacman.conf
arch-chroot /mnt pacman -Sy 
echo -e "parol\nparol" | arch-chroot /mnt passwd root
arch-chroot /mnt useradd -m -g users -G wheel,storage,power -s /bin/bash sbobylev
echo -e "password\npassword" | arch-chroot /mnt passwd sbobylev
arch-chroot /mnt pacman -S --noconfirm --noprogressbar sudo grub bash-completion os-prober vim openssh xorg-server lightdm xorg-server-utils xorg-xinit xorg-twm xorg-xclock xterm mesa xf86-input-synaptics netctl dialog terminus-font
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /mnt/etc/sudoers   
arch-chroot /mnt grub-install --target=i386-pc --recheck /dev/sda
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
arch-chroot /mnt pacman -S --noconfirm --noprogressbar virtualbox-guest-utils virtualbox-guest-modules virtualbox-guest-modules-lts virtualbox-guest-dkms
echo -e "vboxguest\nvboxsf\nvboxvideo" >> /mnt/etc/modules-load.d/virtualbox.conf
arch-chroot /mnt systemctl enable vboxservice.service
arch-chroot /mnt  pacman -S --noconfirm --noprogressbar mate mate-extra lightdm
arch-chroot /mnt systemctl enable dhcpcd.service
arch-chroot /mnt systemctl enable sshd.service
arch-chroot /mnt systemctl enable lightdm.service 


enable dhcp 
install gdm



