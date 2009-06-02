Dear User,

This script has six functions:-

RGBEl2()
RGBEl3()
RGBEl4()
RGBEl5()
SetHighLight()
ExtraSetHighLight()

The code is included in the file:-

  changing-colour.vim

Basically these control the setting of various highlight elements. (*)

Just paste this in as-is into your vimrc script. Replace everything you
had before between COLOUR SCRIPT START and COLOUR SCRIPT END if you had
already put the script in.

You could use the following to do this in Ubuntu.

  sudo gedit /etc/vim/vimrc

Then just open changing-colour.vim in another tab, do copy and paste.
That's it. This would work on my system. 

In case your vimrc file is not in /etc/vim do:-

  sudo find / -name vimrc

And use that instead.

Now next time you start GVIM and open any PHP or HTML file you
will see it in glorious gorgeous colours that visibly change over time.
Please report any problems to pablo@ezrider.co.uk.

Enjoy!

Oh, please give it a rating.

Thanks! :D
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

