#!/bin/bash
clear; echo -e "Arch Easy Setup Script: v0.7 - 20230212" ; sleep 2

echo -e "\nDo you want to add bash shortcuts now (y/n)";read shortcuts
echo -e "\nDo you want to add Systemback and Chaotic-AUR repos, and install yay now (y/n)?\n(NOTE: yay is required for software installation in this script)";read repos
echo -e "\nDo you want to set up and link common directories now (y/n)?"; read common
echo -e "\n\nWould you like to install minimal Gnome desktop (with extensions) (y/n)?"; read gnome
echo -e "\n\nWould you like to install Google Drive access support (y/n)?"; read gdrive
echo -e "\nDo you want to use Firefox instead of Microsoft Edge as your browser (y/n)?"; read browser
echo -e "\n\nWould you like to install HP Omen sound driver firmware (y/n)?"; read omen

# Add bash shortcuts
if [[ $shortcuts == y* ]]; then
echo -e "alias ls='ls --color=auto -alh'\nalias install='yay -S'\nalias remove='yay -Rcns'\nalias update='yay -Syu'\nalias search='yay -Ss'\nalias showinst='yay -Qs'\nalias edit='featherpad'\nalias wipe='yes|yay -Scc >/dev/null ; rm -rf ~/.cache/yay ; history -c ; clear'\nalias updategrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'" >> /home/$USER/.bashrc
fi

if [[ $repos == y* ]]; then

# Add Systemback entries to pacman.conf
echo -e "\n\nAdding Systemback to pacman.conf"
cp /etc/pacman.conf .
echo -e '\n[yuunix_aur]\nSigLevel = Optional TrustedOnly\nServer = https://shadichy.github.io/$repo/$arch' >> ./pacman.conf

# Add Chaotic-AUR entries to pacman.conf
echo -e "\nAdding chaotic-AUR to pacman.conf"
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

# Install minimal Gnome
if [[ $gnome == y* ]]; then
echo "Installing minimal Gnome DE"
yay -S --noconfirm gnome-shell gnome-terminal gnome-tweak-tool gnome-keyring gvfs-google gnome-control-center xdg-user-dirs gdm eog gnome-menus gnome-browser-connector gnome-screenshot gnome-shell-extensions gnome-tweaks nemo nemo-terminal gnome-themes-extra gnome-shell-extension-arc-menu gnome-shell-extension-arch-update gnome-shell-extension-bing-wallpaper gnome-shell-extension-dash-to-panel-git gnome-shell-extension-ddterm appeditor-git
sudo systemctl enable gdm

# Disable power-off and logout confirmation prompts (60 second timer)
gsettings set org.gnome.SessionManager poweroff-prompt false
gsettings set org.gnome.SessionManager logout-prompt false

# Autostart Nemo as desktop handler
mkdir -p /home/$USER/.config/autostart
echo -e "[Desktop Entry]\nType=Application\nExec=nemo-desktop\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=true\nName[en_US]=Nemo Desktop\nName=Nemo Desktop\nComment[en_US]=\nComment=" >> /home/$USER/.config/autostart/nemo-desktop.desktop
chmod +x /home/$USER/.config/autostart/nemo-desktop.desktop
fi

# Confirm options for proceeding
sleep 3 ; echo -e "\n\n\n\n\nBasic setup completed.\nPress ENTER now to continue installing general software (including browser), or CTRL-C to quit now:"; read

# Install general software
echo -e "\n\nInstalling general software"
yay -S --noconfirm ttf-ms-fonts hplip system-config-printer cups libreoffice-fresh vlc libdvdread libdvdcss libcdio downgrade lutris wine winetricks vulkan-icd-loader lib32-vulkan-icd-loader vulkan-intel lib32-vulkan-intel vkd3d lib32-vkd3d lib32-alsa-plugins lib32-libpulse lib32-openal mesa lib32-mesa ntfs-3g exfat-utils systemback

# Install browser
if [[ $browser == y* ]]; then
	echo -e "\n\nInstalling Firefox as default web browser"
	yay -S --noconfirm firefox
	else
	echo -e "\n\nInstalling Microsoft Edge as default web browser"
	yay -S --noconfirm microsoft-edge-stable-bin
fi

if [[ $omen == y* ]]; then
echo -e "\n\nInstalling HP Omen sound driver firmware"
yay -S --noconfirm sof-firmware
fi

# Install Plasma stuff
if [[ $gnome == n* ]]; then
	echo "\n\nInstalling Plasma stuff"
	yay -S --noconfirm yakuake 
	yay -R --noconfirm vim
fi

# Install Google Drive support
echo "\n\nInstalling Google Drive Support"
if [[ $gdrive == y* ]]; then
	if [[ $gnome == y* ]]; then
		yay -S --noconfirm gnome-keyring gvfs-google
		else
		yay -S --noconfirm kio-gdrive
		fi
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
