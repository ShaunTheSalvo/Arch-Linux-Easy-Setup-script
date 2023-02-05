#!/bin/bash
clear; echo -e "Arch Easy Setup Script: v0.6 - 20230205" ; sleep 2

echo -e "\nDo you want to add bash shortcuts now (y/n)";read shortcuts
echo -e "\nDo you want to add Systemback and Chaotic-AUR repos, and install yay now (y/n)?";read repos
echo -e "\nDo you want to set up and link common directories now (y/n)?"; read common
echo -e "\nDo you want to use Firefox instead of Edge as your browser (y/n)?"; read browser

# Add bash shortcuts
if [[ $shortcuts == y* ]]; then
echo -e "alias ls='ls --color=auto -alh'\nalias install='yay -S'\nalias remove='yay -Rcns'\nalias update='yay -Syu'\nalias search='yay -Ss'\nalias showinst='yay -Qs'\nalias edit='featherpad'\nalias wipe='yes|yay -Scc >/dev/null ; rm -rf ~/.cache/yay ; history -c ; clear'\nalias updategrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'" >> /home/$USER/.bashrc
fi

if [[ $repos == y* ]]; then

# Add Systemback entries to pacman.conf
echo -e "\n\nAdding Systemback to pacman"
cp /etc/pacman.conf .
echo -e '\n[yuunix_aur]\nSigLevel = Optional TrustedOnly\nServer = https://shadichy.github.io/$repo/$arch' >> ./pacman.conf

# Add Chaotic-AUR entries to pacman.conf
echo -e "\nAdding chaotic-AUR to pacman"
sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com >> /dev/null
sudo pacman-key --lsign-key FBA220DFC880C036 >> /dev/null
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' >> /dev/null
echo -e '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' >> ./pacman.conf
sudo cp -r ./pacman.conf /etc; rm ./pacman.conf

# Install yay
sudo pacman -Sy --noconfirm yay
fi

# Common directories setup
if [[ $common == y* ]]; then

cd /home
sudo mkdir common
sudo chown $USER common
cd common
mkdir -p .cache/lutris .cache/wine .cache/winetricks .config/lutris .local/share/lutris Documents Downloads Games Music Pictures Public Templates Videos
	if ! [[ $browser == y* ]]; then
	mkdir -p .cache/Microsoft .cache/microsoft-edge .config/microsoft-edge
	else
	mkdir -p .cache/mozilla .mozilla
	fi

rm -rf /home/$USER/.cache/lutris /home/$USER/.cache/wine /home/$USER/.cache/winetricks /home/$USER/.config/lutris /home/$USER/.local/share/lutris
	if ! [[ $browser == y* ]]; then
	rm -rf /home/$USER/.cache/Microsoft /home/$USER/.cache/microsoft-edge /home/$USER/.config/microsoft-edge
	else
	rm -rf /home/$USER/.cache/mozilla /home/$USER/.mozilla
fi
cd /home/$USER
rm -rf Documents Downloads Games Music Pictures Public Templates Videos

cd /home/$USER/.cache
ln -s /home/common/.cache/lutris . ; ln -s /home/common/.cache/wine . ; ln -s /home/common/.cache/winetricks .
	if ! [[ $browser == y* ]]; then
	ln -s /home/common/.cache/Microsoft . ; ln -s /home/common/.cache/microsoft-edge .
	else
	ln -s /home/common/.cache/mozilla
fi

cd /home/$USER/.config
ln -s /home/common/.config/lutris .
	if ! [[ $browser == y* ]]; then
	ln -s /home/common/.config/microsoft-edge .
	else
	cd /home/$USER ; ln -s /home/common/.mozilla
	fi

cd /home/$USER/.local/share
ln -s /home/common/.local/share/lutris .

cd /home/$USER
ln -s /home/common/Documents ; ln -s /home/common/Downloads ; ln -s /home/common/Games ; ln -s /home/common/Music ; ln -s /home/common/Pictures ; ln -s /home/common/Public ; ln -s /home/common/Templates ; ln -s /home/common/Videos
fi


# Confirm options for proceeding
sleep 3 ; echo -e "\n\n\n\n\nBasic setup completed.\nPress ENTER now to continue installing general software (including browser), or CTRL-C to quit now:"; read
echo -e "\n\nWould you like to install Gnome extensions (y/n)?"; read gnome
echo -e "\n\nWould you like to install HP Omen sound driver firmware (y/n)?"; read omen


echo -e "\n\nInstalling general software"
yay -S --noconfirm ttf-ms-fonts hplip system-config-printer cups libreoffice-fresh vlc libdvdread libdvdcss libcdio downgrade lutris wine winetricks vulkan-icd-loader lib32-vulkan-icd-loader vulkan-intel lib32-vulkan-intel vkd3d lib32-vkd3d lib32-alsa-plugins lib32-libpulse lib32-openal mesa lib32-mesa systemback

echo -e "\n\nInstalling browser"
if [[ $browser == y* ]]; then
	yay -S --noconfirm firefox
	else
	yay -S --noconfirm microsoft-edge-stable-bin
fi

if [[ $omen == y* ]]; then
echo -e "\nInstalling Omen sound driver firmware"
yay -S --noconfirm sof-firmware
fi

# Install Gnome stuff
if [[ $gnome == y* ]]; then
echo "Installing Gnome stuff!"
yay -S --noconfirm gnome-shell-extension-arc-menu gnome-shell-extension-arch-update gnome-shell-extension-bing-wallpaper gnome-shell-extension-dash-to-panel-git gnome-shell-extension-ddterm appeditor-git nemo nemo-terminal gnome-themes-extra

# Autostart Nemo as desktop handler
echo -e "[Desktop Entry]\nType=Application\nExec=nemo-desktop\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=true\nName[en_US]=Nemo Desktop\nName=Nemo Desktop\nComment[en_US]=\nComment=" >> /home/$USER/.config/autostart/nemo-desktop.desktop
chmod +x /home/$USER/.config/autostart/nemo-desktop.desktop

# Remove Gnome fluff
sleep 3; echo -e "\n\n... and I'll just remove some Gnome fluff...\n" ; sleep 3
yay -R --noconfirm epiphany vim htop gnome-system-monitor gnome-photos gnome-maps gnome-logs gnome-font-viewer gnome-software gnome-clocks gnome-contacts gnome-characters gnome-backgrounds cheese nautilus

else

# Install Plasma stuff
echo "Installing Plasma stuff!"
yay -S --noconfirm yakuake kio-gdrive 
yay -R --noconfirm vim
fi

# Clean up and start the cups service
yes|yay -Scc >>/dev/null
sudo systemctl enable cups.service; sudo systemctl start cups.service


# Finish
sleep 2; echo -e "\n\nAll done! Do you want to reboot now (y/n)?"; read rebootnow
if [[ $rebootnow == y* ]]; then
reboot
fi
echo -e "\n\nOkay, have fun then!"
