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

If you want to funk-it-up a little why not try:-

  :set updatetime=1000

Or

  :set updatetime=350

If you really want it funky. This is normally set to 4000. 
It is the delay before VIM processes the 'CursorHold' auto commands.
In this script it's how long vim waits before it changes the colours,
if they are due to change. Normally 4 seconds feels quite sluggish
but setting it too low might create unwanted side-effects, i.g. it
is also how long vim wait before it updates the .swp file (scratch
file vim uses to recover the file you were editing in case your
computer crashes or there is a software fault.) If the file you are
editing is very large setting this too low might not be a good idea!

Note:-
The "auto" command is a powerful VIM feature that allows you to
programtically control the way VIM behaves. Using the powerful
vim scripting language you can hook-up all sorts of events to tell
VIM what happens when they happen, e.g. when a buffer is saved to
disk, a buffer is loaded, the cursor moves to another window,
the user hasn't moved the cursor for X number of milliseconds,...
simply type :help auto [RETURN] in vim and scroll down to section 5,
where you can see all of them.

Please report any problems to pablo@ezrider.co.uk.

Many thanks.

Enjoy!

Please give it a rating.

Thanks! :D
Paul.

--

Notes:
======

*  It works based on a two-hourly cycle. 

   For example, near the beginning of hour 1 the colours will be based on black background,
   but by the end of hour 1 they will have transitioned smoothly to be based on a light-
   background. By the end of hour 2 they will be once again back to being based on a black
   background, and so on.

   The script uses the vim function localtime().

   As an additional bonus the time and date is output on the command line during the 12 minute
   boundary around the hourly division.


