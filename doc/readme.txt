HISTORY
=======

VERSION 1.1

BUGFIXES - Oops!! forgot to include some key variables, without which the script wouldn't
change colour as these helped it keep track of time. doh.

VERSION 1.0

INITIAL RELEASE.

====


NOTES
-----

Dear User,

This script has six functions:-

ModdedValue2()
ModdedValue5()
ModdedValue4()
ModdedValue3()
SetHighLight()
ExtraSetHighLight()

The code is included in the file:-

  changing-colour.vim

Basically these control the setting of various highlight elements. (*)

Just copy what's in this file exactly as-is into your vimrc script.

On ubuntu you use the command:

  sudo gedit /etc/vim/vimrc

Just replace /etc/vim/vimrc with what you have on your system. To find out where your
vimrc file is hiding is do:-

  sudo find / -name vimrc

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

