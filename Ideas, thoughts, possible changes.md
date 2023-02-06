It has been suggested to use paru instead of yay as an AUR/pacman helper. I am considering this, however for now I will be retaining yay as my AUR helper, as it is my personal preference. 

I am considering providing the option to install paru instead of (or in addition to) yay. As the script creates .bashrc shortcuts, several of which are already based on yay, I won't be making this change yet. Feel free to simply replace instances of 'yay' with 'paru' in the script, which should be a simple search/replace, if you prefer paru.

I've been asked why I am including chaotic-aur. The simple answer is - simplicity and speed. Chaotic-aur makes installing many packages normally only available via AUR much, much easier and faster to install. Furthermore, I've had some packages I've tried to install directly from AUR, and the build has taken hours - compared to only a few minutes at worst via chaotic-aur.
I hope to modify the script shortly, to avoid needing to use an AUR helper (currently yay), for the benefit of the purists. We'll see how that goes. Again, as the script currently relies on yay for the core of its work, this may not happen any time soon.
