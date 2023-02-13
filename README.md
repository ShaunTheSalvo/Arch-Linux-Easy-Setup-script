# Arch Linux Easy Setup script
A fairly simple and easily customisable shell script to automate some initial desktop setup after a clean installation of Arch Linux

(note: this is my first ever Github project - please be gentle! :) )

# IMPORTANT - Please read before trying the script

<b><i>This script does NOT install Arch Linux itself.</b></i> It is not a replacement for tools such as archinstall, and is not intended as such - at least not yet. Its purpose is to quickly and easily set up the system and install basic apps (eg web browser) <i>after</i> Arch Linux itself has been installed.

# Introduction

I have created a BASH script intended to be used immediately after a basic Arch installation, that automatically installs general applications (eg system tools like yay, web browser, office suite, some of my favourite Gnome extensions etc) and sets up links to my /home/common directory. It also sets up access to chaotic-aur and Systemback repositories.

The script offers a few choices before it starts installing stuff such as which browser you want to install, whether you want links to directories in /home/common created, and then you just sit back and relax while it does its magic. Then reboot ... and everything is all set up and configured, ready to rock and roll!

A friend of mine and myself both use Arch, but we have different preferences - he prefers Plasma desktop and Firefox browser, while I prefer Gnome desktop and Microsoft Edge. This was the inspiration for making the script interactive and allowing you to choose what you do and don't want installed.

So now - as a small contribution to the Arch community, here is my Arch Linux Easy Setup script, in the hope someone finds it useful. Feel free to customise/change it to suit your needs. Of course, make sure you read through the script first to ensure you understand what it does BEFORE executing it, and if you choose to use it, you do so entirely at your own risk. I am not responsible for any loss of data or damage to your computer etc., if you choose to use it. <i>If after reading the script, you don't understand what it does, please don't use it! You have been warned.</i> :)

# Usage
The script is intended to be used immediately after a fresh install of Arch Linux, with either Gnome or KDE/Plasma desktop installed. I would suggest downloading the script (```easy-setup.sh```) and saving it to a USB drive or similar before starting your Arch Linux installation.

The script will first ask if you want to install some handy BASH shortcuts into ```.bashrc```, then if you'd like to activate chaotic-aur and Systemback repos (Systemback is a very useful and powerful tool for backing up your system). Please review the script first so you can see what shortcuts it creates in ```.bashrc```.

Next, the script will ask if you'd like to link certain directories from your $HOME directory to directories in /home/common (and will create these as well if you choose). The benefit here is that data stored in this directory can be retained even if you delete your regular /home/user directory - just use the script to re-link the directories if needed. Please review the script first so you can see which directories it links. The linked directories are modified depending on if you choose to install Firefox or Microsoft Edge as your browser. The script also asks if you'd like to install sound driver firmware for HP/Omen PC's (my friend has one of these).

By default, the script installs default Microsoft fonts (eg Tahoma, Arial etc), printer support and HP printer drivers, NTFS and FAT file system support, LibreOffice, VLC (with DVD and CD audio support), Lutris (a gaming platform), Wine, basic Vulkan support for Intel graphics chips, and Mesa. It also installs a handy tool called Downgrade that allows you to easily install an older version of pacman packages, and add them to ignore-package to prevent the older version being upgraded when you next update your system (pacman -Syu). I use this for Mesa 32-bit libraries, for compatibility with certain games I run. The packages the script installs are easily changed to suit your particular preferences. Just change the package names in the "Install general software" section of the script.

If you choose to do so, the script installs some Gnome extensions that I like and find useful, as well as Nemo file manager. Otherwise, it will install Yakuake (drop-down terminal) - useful in the KDE/Plasma environment. Feel free to change this as you see fit.

Since we are replacing Nautilus with Nemo on Gnome desktop, the script also creates a desktop entry in ~/.config/autostart, to activate Nemo as the desktop icon handler. After rebooting, right-click the desktop and select Customize, and then select the desktop icons (Home, Computer, etc.) you want on your desktop. You can also change the grid spacing and a few other options.

<b>(Gnome only) Note:</b> at this point, adding desktop icons for network locations (eg Google Drive) works for the root folder of the network drive. However (on Google Drive at least; I haven't tested other network locations), attempting to link other folders or files from your Google Drive directly onto the desktop does not work. The link and icon will be created on the desktop, but clicking the icon to access the file will not work. If anyone has any idea how to fix this, please let me know!

Also, please note the script does not activate any of the Gnome extensions it installs - after rebooting, this is easily done through the Extensions app.

Finally, the script clears out all downloaded packages from the cache, and enables the CUPS systemd service (printing support), and asks if you'd like to reboot (recommended).

So - here it is. I truly hope some of you find it useful. Good luck. If you find any bugs or otherwise, or have any other comments, please let me know.
