Dear User,

This script is built of seven functions:-

ModdedValue2()
ModdedValue5()
ModdedValue4()
ModdedValue3()
ModdedValue()
SetHighLight()
ExtraSetHighLight()

The code is included in the file:-

  paste-near-end-pref-near-other-lines-beginning-au.vim

Basically these control the setting of various highlight elements. (*)

Just copy these lines *exactly* as they are written in the file to your vimrc script.
It probably better if you do it near the beginning. Also if you need to remove them
you know where they are. There's seven functions. Just delete them if anything screws up.

On ubuntu you use the command:

  sudo gedit /etc/vim/vimrc

Just replace /etc/vim/vimrc with what you have on your system. To find out where your
vimrc file is hiding is do:-

  sudo find / -name vimrc

Once you copied these lines to the vimrc file you will have the body of the colour
changing behaviour there, but it's unlikely anything will happen (although I said
above "if anything screws up"), because they are useless lines until you tell vim to
start using them.

This is the purpose of the lines in the file:-

  paste-near-end-pref-near-other-lines-beginning-au

Just put these lines where you have any lines that start:

:au ......

or if not just near the end. It's more for clarity. Au lines change the way vim
behaves so later if you want to change this it's good to have a single reference
point so you can easily see what's going on.

That's it. Once you save, next time you load GVIM and open a PHP or HTML file you
will see it in gorgeous high-clarity colour changing based on the time you're 
into the hour and then gradually back the next the hour.

Enjoy!

Oh, if you like this script please rate it!! :D

Also, if you have any problems please contact me on pablo@ezrider.co.uk. Thanks!! :D

Regards,
Paul.

--

Notes:
======

*  It works based on the time of day. 

   For example, near the beginning of hour 1 the colours will be based on black background,
   but by the end of hour 1 they will have transitioned smoothly to be based on a light-
   background. By the end of hour 2 they will be once again back to being based on a black
   background, and so on.

   The script is based on the vim function localtime() with which it works out where it is in the hour.

   Additionally the time and date is output on the command line 12 minutes before and after each hour.

   All these functions are in the file:-


