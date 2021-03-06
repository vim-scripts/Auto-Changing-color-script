" vim:tags=changingColorTags:autochdir:
" +-----------------------------------------------------------------------------+
" | CHANGING COLOR SCRIPT                                                       |
" +-----------------------------------------------------------------------------+
" | Changes syntax highlight colors gradually every little while to reflect the |
" | passing by of the hour.  Note: this script needs the Timer script in order  |
" | to work properly, but Timer should be installed automatically if you use    |
" | :source %  as it comes included in the package.                             |
" +-----------------------------------------------------------------------------+
" | START                                                                       |
" +-----------------------------------------------------------------------------+
" | WED  25TH FEB 2015:  20.7                                                   |
" |                      Slight improvements to Constant esp. at high light     |
" |                      settings.                                              |
" | TUE  24TH FEB 2015:  20.6                                                   |
" |                      Further gave tweaks to Comment because there were      |
" |                      effects that were making it worse.  Cleaned it up.     |
" | TUE  24TH FEB 2015:  20.5                                                   |
" |                      Gave Comment a tweak at high brightness backgrounds    |
" |                      because it looked to much like Normal in this.         |
" | TUE  24TH FEB 2015:  20.4                                                   |
" |                      Gave Constant and Identifier a bit of a tweak at high  |
" |                      brightness background.  The green of Identifier also   |
" |                      looks nice and flouro at low light backgrounds.  You   |
" |                      can actually see the green still at light backgrounds. |
" | WED  11TH FEB 2015:  20.3                                                   |
" |                      I forgot the vital tags files, only really useful if   |
" |                      you wanna see help on it.  This does not affect the    |
" |                      scripts at all.  If you've previously installed it     |
" |                      just make sure you run :RmVimball changingColor        |
" |                      and just re-install it by loading changingColor.vba and|
" |                      doing :so %                                            |
" |                      That will get rid of any rubbish.                      |
" | TUE  10TH FEB 2015:  20.2                                                   |
" |                      Had a third look and decided about 33% should do it.   |
" |                      That is about 33% of the shades are no good.           |
" |                      That's roughly 1/3 so sounds about right.  They are    |
" |                      just to "in the grey area" to be clear highlight.      |
" |                      They need to be removed.                               |
" | TUE   3RD FEB 2015:  20.1                                                   |
" |                      Had a look at it and decided ~25% was still too low    |
" |                      and there were still some murky shades too difficult to|
" |                      see.  I didn't want to cut too much of the continuity  |
" |                      but I think 30% is a necessary step towards improvement|
" |                      20.0                                                   |
" |                      After careful consideration have decided that some of  |
" |                      the shades in my script are too difficult to see.      |
" |                      I was trying to have one smooth continuum between light|
" |                      and dark but the exact middle point is always making   |
" |                      me strain to read no matter what I do, and this looks  |
" |                      poor compared to other color schemes so I decided to   |
" |                      create a ramped "jump over" the exact mid-point.       |
" |                      You will still see constant changes but when it gets   |
" |                      to a certain mid point it will jump about 20% of the   |
" |                      murky shades to the next point after that.             |
" | WED   3RD DEC 2014:  19.3                                                   |
" |                      Tweaked visibility of Normal, edge case.  It appears   |
" |                      that due to a calibration issue I was having with my   |
" |                      monitor I'd got this wrong previously.  I had thought  |
" |                      that it was massively out but it was a "Power Saving"  |
" |                      feature of my EeePC that made it look hard to read.    |
" |                      Not generally applicable in most cases.  Fixed to be   |
" |                      similar to what it was in 19.0.                        |
" | TUE  18TH NOV 2014:  19.2                                                   |
" |                      Tweaked visibility of Normal, edge case.  Better now   |
" | FRI  14TH NOV 2014:  19.1                                                   |
" |                      Massive adjustment to fix visibility of Normal         |
" |                      added context help for Rgb2a()                         |
" |                      Now you can just press Ctrl-] over anywhere you see    |
" |                      Rgb2a() to jump straight to its definition.            |
" |                      From there you can get help on all its arguments.      |
" |                      This is finally starting to look damn good.            |
" | THU  30TH OCT 2014:  19.0                                                   |
" |                      Fix visibility of normal                               |
" |                      New! Some help available on SOME of the paremeters.    |
" |                      Try Rgb2a(..) all the paremters have help, hover over  |
" |                      and press Ctrl-].  Not all parameters are covered and  |
" |                      other functions are missing but please be patient  I   |
" |                      will eventually get around to better explanations      |
" | SAT  25TH OCT 2014:  18.1                                                   |
" |                      Bug fix.  Accidentally overwrote user's choice of      |
" |                      color scheme did not check if it was already set. Fixed|
" | THU  24TH APR 2014:  18.0                                                   |
" |                      Made time passing effect co-operate with when you      |
" |                      finish writing your changes vs. just browsing around   |
" |                      text without editing it.  This latter now uses the     |
" |                      more intuitively named 'permanent' color scheme.       |
" |                      If you want to change it the variable is called        |
" |                      g:permanentColorScheme.  Simply set that to the string |
" |                      equalling the name of your favorite color scheme in    |
" |                      your _vimrc, e.g. "koehler", or "morning".             |
" |                      e.g. let g:permanentColorScheme = "keohler"            |
" |                      Note: this used to be referred to unintuitively as     |
" |                      'g:changingColorStop' in previous versions of this     |
" |                      script.                                                |
" | TUE   2ND JUL 2013:  17.3                                                   |
" |                      Made sure this is the same version that includes the   |
" |                      user-settable g:changingColorStop variable checks      |
" |                      I had it inconsistently before.                        |
" |                      ...                                                    |
" | WED 27TH MAY 2009: o VER 1.00                                               |
" +-----------------------------------------------------------------------------+

" +------------------------------------------------------------------------------+
" | The following static variable provide a way for the script to check if its   |
" | time that the muscle function should call vim's 'highlight' command to cause |
" | all the syntax elements colouring to change. A combination of this and       |
" | 'changefreq' (below) is used to determine final yes/no (it is time or not)   |
" +------------------------------------------------------------------------------+
let s:oldactontime=-9999

" +------------------------------------------------------------------------------+
" | This variable is used to control how often the script deems it's time to     |
" | 'progress' the colour (also see above). The higher the value the less often  |
" | it will do so, the lower the more often it will do so.  2880 is equivalnet   |
" | to every minute, 5760 every two minutes, 4320 is ~ every 1.5 minutes         |
" +------------------------------------------------------------------------------+
let g:changefreq=360

" +------------------------------------------------------------------------------+
" | The following variable is the size of the area below and above that zone that|
" | makes the text colour 'darken' to avoid clashing with the background. It     |
" | lasts around 2 minutes and during this time the text colour stays exactly    |
" | unmodified but the background is tweaked up or down to 'ease' visibility     |
" | while not drastically changing anything yet. This happens in that area known |
" | as the 'danger' area. The bigger this value the bigger that 'ease' period    |
" | is, with 7200 being around 2 minutes above and below 'danger' area.          |
" +------------------------------------------------------------------------------+
let g:easeArea=8200

"debug
"let g:mytime=16000
"let g:myhour=0

" +------------------------------------------------------------------------------+
" | Main Rgb function, used to work out amount to offset Rgb value by to avoid |
" | it clashing with the background colour.                                      |
" | Return value is modified or otherwise value (not modified if no clash).      |
" +------------------------------------------------------------------------------+
function Rgb2(Rgb, actBgr, dangerBgr, senDar, senLig, adjust)
	if a:actBgr>=a:dangerBgr-a:senDar && a:actBgr<=a:dangerBgr+a:senLig
		let whatdoyoucallit=a:dangerBgr-a:actBgr
		if whatdoyoucallit<0
			let whatdoyoucallit=-whatdoyoucallit
		endif
		let whatdoyoucallit=whatdoyoucallit/130
		if whatdoyoucallit>255
			let whatdoyoucallit=255
		endif
		let whatdoyoucallit=-whatdoyoucallit+255
		let whatdoyoucallit=whatdoyoucallit*a:adjust
		let whatdoyoucallit=whatdoyoucallit/800
		let whatdoyoucallit=whatdoyoucallit+65
		let adjustedValue=a:Rgb-whatdoyoucallit
	else
		let adjustedValue=a:Rgb
	endif
	if adjustedValue<0
		let adjustedValue=0
	endif
	if adjustedValue>255
		let adjustedValue=255
	endif
	return adjustedValue
endfunction

" takes a within range aMin,aMin outputs a mapped to rMin, rMin
function ScaleToRange(a,aMin,aMax,rMin,rMax)
	let aLocal=a:a-a:aMin
	let rangeA=a:aMax-a:aMin
	let rangeR=a:rMax-a:rMin
	let rangeA=rangeA*1000|let rangeR=rangeR*1000
	let divAR=rangeA/rangeR
	return aLocal/divAR+a:rMin
endfunction

" +------------------------------------------------------------------------------+
" | Main Rgb for Normal (like Rgb2 but brightens, not darkens - Normal is        |
" | a bit trickier because it is also where the general background is set        |
" | To see help on each paremeter, press Ctrl-].                 [General_Rgb2a] |
" +------------------------------------------------------------------------------+
function Rgb2a(rgb,actBgr,dngBgr,senDar,senLig,loadj,hiadj,lotail1,lotail2)
	let adjVal=a:rgb
	if a:actBgr>=a:dngBgr-a:senDar && a:actBgr<=a:dngBgr+a:senLig
		let adjVal+=ScaleToRange(a:actBgr,a:dngBgr-a:senDar,a:dngBgr+a:senLig,a:loadj,a:hiadj)
	endif
	if a:actBgr>=0 && a:actBgr<=a:dngBgr-a:senDar
		let adjVal+=ScaleToRange(a:actBgr,0,a:dngBgr-a:senDar,a:lotail1,a:lotail2)
	endif
	let adjVal-=g:whiteadd
	if adjVal<0
		let adjVal=0
	endif
	if adjVal>255
		let adjVal=255
	endif
	return adjVal
endfunction

" +------------------------------------------------------------------------------+
" | Special Rgb function for cases that needed special care. It provides       |
" | more control over the text's high or low lighting in the danger visibility   |
" | zone.                                                                        |
" +------------------------------------------------------------------------------+
function Rgb2b(Rgb,actBgr,dangerBgr,senDar,senLig,adjust1,adjust2,adjust3)
	if a:actBgr>=a:dangerBgr-a:senDar && a:actBgr<=a:dangerBgr+a:senLig
		let        progressFrom=a:dangerBgr-a:senDar
		let        progressLoHi=a:actBgr-progressFrom
		let            diffLoHi=(a:dangerBgr+a:senLig)-(a:dangerBgr-a:senDar)
		let     progressPerThou=progressLoHi/(diffLoHi/1000)
		if progressPerThou<500
			let adjustedAdjust=ScaleToRange(a:actBgr,a:dangerBgr-a:senDar,((a:dangerBgr-a:senDar)+(a:dangerBgr+a:senLig))/2,a:adjust1,a:adjust2)
		else
			let adjustedAdjust=ScaleToRange(a:actBgr,((a:dangerBgr-a:senDar)+(a:dangerBgr+a:senLig))/2,a:dangerBgr+a:senLig,a:adjust2,a:adjust3)
		endif
		let proximity=a:dangerBgr-a:actBgr
		if proximity<0
			let proximity=-proximity
		endif
		let proximity=proximity/130
		if proximity>255
			let proximity=255
		endif
		let proximity=-proximity+255
		let proximity=proximity*adjustedAdjust
		let proximity=proximity/800
		let proximity=proximity+65
		let adjustedValue=a:Rgb-proximity
	else
		let adjustedValue=a:Rgb
	endif
	let adjustedValue=adjustedValue-g:whiteadd
	if adjustedValue<0
		let adjustedValue=0
	endif
	if adjustedValue>255
		let adjustedValue=255
	endif
	return adjustedValue
endfunction

" +------------------------------------------------------------------------------+
" | Rgb function for cursor to work out amount to offset Rgb component to stop |
" | it from clashing with the background colour.                                 |
" | Return value is modified or otherwise value (not modified if no clash).      |
" +------------------------------------------------------------------------------+
function Rgb3(Rgb,actBgr,dangerBgr,adj)
	let diff=a:actBgr-a:dangerBgr
	if diff<0
		let diff=-diff
	endif
	if diff<12000
		let adjustedValue=a:Rgb-a:adj
		if adjustedValue<0
			let adjustedValue=0
		endif
	else
		let adjustedValue=a:Rgb
	endif
	return adjustedValue
endfunction

" +------------------------------------------------------------------------------+
" | Rgb function used to work out offsetting for Rgb components pertaining to  |
" | a background, i.e. the bit that says guibg= of the vim highlight command.    |
" | Background is handled different to foreground so it needs another function.  |
" | You can tell this Rgb function what to do with the background if Rgb value |
" | is *just* below the 'danger' general background, and above it. In each case  |
" | you can tell it to brighten or darken the passed Rgb value. (darkAdj,        |
" | lghtAdj params.) Positive values, (e.g. 40) add brightness, nagative values  |
" | remove it. Special cases 99 and -99 adds does this in a 'default' measure.   |
" | You can also tell the function what to do if the Rgb value is right inside   |
" | the danger zone; not to be confused with darkAdj & lghtAdj that mean the     |
" | two end tips outside of the danger area. This bit is the danger area itself, |
" | the low-visisibility area, the 'danger zone'. (dangerZoneAdj) It works the   |
" | same, a positive value causes background to brighten, a negative to darken.  |
" | Like darkAdj & lghtAdj, you can also specify default 'brighten' or 'darken', |
" | 99 or -99 respectively, but if you're not happy with the default just fine   |
" | tune it exactly as you would like it to look exactly as you do with darkAdj  |
" | & lghtAdj. Use this if you find using the normal foreground text colour      |
" | modification by itself (Rgb2 function) doesn't cut it. Text still looks    |
" | blurry over a certain background colour even after you've adjusted the danger|
" | adjustment parameters available in Rgb2. Normally I found darkening text   |
" | with Rgb2 adjustment params makes the text 'visible' over danger zone but  |
" | in some cases it wasn't up to it, so I added this param: 'dangerZoneAdj'.    |
" | This allows you to 'fudge' the background colour up and down as desired until|
" | you're happy with the result.                                                |
" | Return value is either the up or down-shifted Rgb background element if the  |
" | element falls just outside the 'danger' boundary, a shifted-up Rgb element   |
" | if the value is fully inside the danger boundary (and you set dangerZoneAdj) |
" | or simply the same as you pass if the value you pass is outside the danger   |
" | zone AND the outer boundary ring of the 'danger zone'.                       |
" +------------------------------------------------------------------------------+
function Rgb4(Rgb,actBgr,dangerBgr,senDar,senLig,darkAdjLo,darkAdjHi,lghtAdjLo,lghtAdjHi,dangerZoneAdj)
	let darkAdjLo=a:darkAdjLo
	let darkAdjHi=a:darkAdjHi
	let lghtAdjLo=a:lghtAdjLo
	let lghtAdjHi=a:lghtAdjHi
	if a:darkAdjLo==99
	let darkAdjLo=11
	endif
	if a:darkAdjLo==-99
		let darkAdjLo=-11
	endif
	if a:darkAdjHi==99
		let darkAdjHi=11
	endif
	if a:darkAdjHi==-99
		let darkAdjHi=-11
	endif
	if a:lghtAdjLo==99
		let lghtAdjLo=11
	endif
	if a:lghtAdjLo==-99
		let lghtAdjLo=-11
	endif
	if a:lghtAdjHi==99
		let lghtAdjHi=11
	endif
	if a:lghtAdjHi==-99
		let lghtAdjHi=-11
	endif
	let dangerZoneAdj=a:dangerZoneAdj
	if a:dangerZoneAdj==99
		let dangerZoneAdj=15
	endif
	if a:dangerZoneAdj==-99
		let dangerZoneAdj=-15
	endif
	let adjustedValue=a:Rgb
	if a:actBgr>=a:dangerBgr-a:senDar-g:easeArea && a:actBgr<a:dangerBgr-a:senDar
		let adjustedValue=adjustedValue+ScaleToRange(a:actBgr,a:dangerBgr-a:senDar-g:easeArea,a:dangerBgr-a:senDar,lghtAdjLo,lghtAdjHi)
	endif
	if a:actBgr>a:dangerBgr+a:senLig && a:actBgr<=a:dangerBgr+a:senLig+g:easeArea
		let adjustedValue=adjustedValue+ScaleToRange(a:actBgr,a:dangerBgr+a:senLig,a:dangerBgr+a:senLig+g:easeArea,lghtAdjLo,lghtAdjHi)
	endif
	if a:actBgr>=(a:dangerBgr-a:senDar) && a:actBgr<=(a:dangerBgr+a:senLig) && dangerZoneAdj
		let adjustedValue=adjustedValue+dangerZoneAdj
	endif
	if adjustedValue<0
		let adjustedValue=0
	endif
	if adjustedValue>255
		let adjustedValue=255
	endif
	return adjustedValue
endfunction

" +------------------------------------------------------------------------------+
" | Like REGEl4 but adding an additional control for fine-tuning the background  |
" | at various ranges (instead of one flat rate.)                                |
" +------------------------------------------------------------------------------+
function Rgb4a(Rgb,actBgr,dangerBgr,senDar,senLig,darkAdjLo,darkAdjHi,lghtAdjLo,lghtAdjHi,dangerZoneAdj1,dangerZoneAdj2,ligdown1,ligdown2,ligup1,ligup2)
	let darkAdjLo=a:darkAdjLo
	let darkAdjHi=a:darkAdjHi
	let lghtAdjLo=a:lghtAdjLo
	let lghtAdjHi=a:lghtAdjHi
	if a:darkAdjLo==99
		let darkAdjLo=11
	endif
	if a:darkAdjLo==-99
		let darkAdjLo=-11
	endif
	if a:darkAdjHi==99
		let darkAdjHi=11
	endif
	if a:darkAdjHi==-99
		let darkAdjHi=-11
	endif
	if a:lghtAdjLo==99
		let lghtAdjLo=11
	endif
	if a:lghtAdjLo==-99
		let lghtAdjLo=-11
	endif
	if a:lghtAdjHi==99
		let lghtAdjHi=11
	endif
	if a:lghtAdjHi==-99
		let lghtAdjHi=-11
	endif
	let dangerZoneAdj1=a:dangerZoneAdj1
	if a:dangerZoneAdj1==99
		let dangerZoneAdj1=15
	endif
	if a:dangerZoneAdj1==-99
		let dangerZoneAdj1=-15
	endif
	let dangerZoneAdj2=a:dangerZoneAdj2
	if a:dangerZoneAdj2==99
		let dangerZoneAdj2=15
	endif
	if a:dangerZoneAdj2==-99
		let dangerZoneAdj2=-15
	endif
	let adjustedValue=a:Rgb
	if a:actBgr>=a:dangerBgr-a:senDar-g:easeArea && a:actBgr<a:dangerBgr-a:senDar
		let adjustedValue=adjustedValue+ScaleToRange(a:actBgr,a:dangerBgr-a:senDar-g:easeArea,a:dangerBgr-a:senDar,darkAdjLo,darkAdjHi)
	endif
	if a:actBgr>=0 && a:actBgr<a:dangerBgr-a:senDar-g:easeArea
		let adjustedValue=adjustedValue+ScaleToRange(a:actBgr,0,a:dangerBgr-a:senDar-g:easeArea,a:ligdown1,a:ligdown2)
	endif
	if a:actBgr>a:dangerBgr+a:senLig && a:actBgr<=a:dangerBgr+a:senLig+g:easeArea
		let adjustedValue=adjustedValue+ScaleToRange(a:actBgr,a:dangerBgr+a:senLig,a:dangerBgr+a:senLig+g:easeArea,lghtAdjLo,lghtAdjHi)
	endif
	if a:actBgr>a:dangerBgr+a:senLig+g:easeArea && a:actBgr<=86400
		let adjustedValue=adjustedValue+ScaleToRange(a:actBgr,a:dangerBgr+a:senLig+g:easeArea,86400,a:ligup1,a:ligup2)
	endif
	if a:actBgr>=(a:dangerBgr-a:senDar) && a:actBgr<=(a:dangerBgr+a:senLig) && (dangerZoneAdj1 || dangerZoneAdj2)
		let adjustedValue=adjustedValue+ScaleToRange(a:actBgr,a:dangerBgr-a:senDar,a:dangerBgr+a:senLig,dangerZoneAdj1,dangerZoneAdj2)
	endif
	if adjustedValue<0
		let adjustedValue=0
	endif
	if adjustedValue>255
		let adjustedValue=255
	endif
	return adjustedValue
endfunction

" +------------------------------------------------------------------------------+
" | Special case of Rgb function used particularly for the Normal highlight    |
" | element which obviously needs to be stronger because it's background cannot  |
" | be 'shifted' in bad visibility cases because Normal also happens to be the   |
" | the general background vim uses.                                             |
" +------------------------------------------------------------------------------+
function Rgb5(Rgb,actBgr,dangerBgr,senDar,senLig)
	if a:actBgr>=a:dangerBgr-a:senDar && a:actBgr<=a:dangerBgr+a:senLig
		let adjustedValue=255
	else
		let adjustedValue=a:Rgb
	endif
	if a:actBgr>=(a:dangerBgr+a:senLig)-21000 && a:actBgr<=a:dangerBgr+a:senLig
		let adjustedValue=0
	endif
	if adjustedValue<0
		let adjustedValue=0
	endif
	if adjustedValue>255
		let adjustedValue=255
	endif
	return adjustedValue
endfunction 

" +------------------------------------------------------------------------------+
" | This is a simple cut-off function disallowing values <0 and >255             |
" +------------------------------------------------------------------------------+
function Rgb6(Rgb)
	let result=a:Rgb
	if a:Rgb<0
		let result=0
	endif
	if a:Rgb>255
		let result=255
	endif
	return result
endfunction

" +----------------------------------------+
" | try to increase the low contrast areas |
" +----------------------------------------+
function UpTheGamma(todaysec)
	let result = a:todaysec
	if result>=43199
		let result = result * 0.666
		let result = result + 28857
	else
		let result = result * 0.666
	endif
	let result = float2nr(result)
	return result
endfunction

" +------------------------------------------------------------------------------+
" | Muscle function, calls vim highlight command for each element based on the   |
" | time into the current hour.                                                  |
" +------------------------------------------------------------------------------+
function SetHighLight(forceUpdate)
	let todaysec=(((localtime()+1800)%(60*60)))*24
	if exists("g:mytime")
		let todaysec=g:mytime
	endif
	if (!a:forceUpdate)
		if s:oldactontime/g:changefreq==todaysec/g:changefreq
			return
		endif
	endif
	let s:oldactontime=todaysec
	if todaysec<43199
		let todaysec=todaysec*2
		let dusk=0
	else
		let todaysec=-todaysec*2+172799
		let dusk=1
	endif
	let todaysec=UpTheGamma(todaysec)
	if exists("g:myhour")
		let myhour=g:myhour
	else
		let myhour=(localtime()/(60*60))%3
	endif
	if (myhour==0 && dusk==0)
		let adjBG1=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
		let adjBG1A=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
		let adjBG2=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
	endif
	if (myhour==0 && dusk==1)
		let adjBG1=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
		let adjBG1A=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
		let adjBG2=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
	endif
	if (myhour==1 && dusk==0)
		let adjBG1=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
		let adjBG1A=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
		let adjBG2=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
	endif
	if (myhour==1 && dusk==1)
		let adjBG1=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
		let adjBG1A=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
		let adjBG2=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
	endif
	if (myhour==2 && dusk==0)
		let adjBG1=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
		let adjBG1A=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
		let adjBG2=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
	endif
	if (myhour==2 && dusk==1)
		let adjBG1=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
		let adjBG1A=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
		let adjBG2=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
	endif
	let g:whiteadd=(todaysec-60000)/850
	if g:whiteadd>0
		let adjBG1=adjBG1+g:whiteadd
		if adjBG1>255
			let adjBG1=255
		endif
		let adjBG1A=adjBG1A+g:whiteadd
		if adjBG1A>255
			let adjBG1A=255
		endif
		let adjBG2=adjBG2+g:whiteadd
		if adjBG2>255
			let adjBG2=255
		endif
	else
		let g:whiteadd=0
	endif
	let temp1 = adjBG1-(g:whiteadd/3)
	let temp2 = adjBG1A-(g:whiteadd/3)
	let temp3 = adjBG2-(g:whiteadd/3)
	let adjBG3 = (todaysec>=18500)?temp1-ScaleToRange(adjBG1,54,255,4,17):adjBG1+ScaleToRange(adjBG1,0,54,32,12)
	let adjBG4 = (todaysec>=18500)?temp2-ScaleToRange(adjBG1A,54,255,4,17):adjBG1A+ScaleToRange(adjBG1A,0,54,32,26)
	let adjBG5a = (todaysec>=18500)?temp3-ScaleToRange(adjBG2,54,255,4,17):adjBG2+ScaleToRange(adjBG2,0,54,32,26)
	let highlCmdNormal = printf("highlight Normal guibg=#%02x%02x%02x", adjBG1,adjBG1A,adjBG2)
	let adj1 = Rgb2(adjBG1+40, todaysec, 80000, 5500, 6400, 60)
	let adj2 = Rgb2(adjBG1+40, todaysec, 80000, 5500, 6400, 60)
	let adj3 = Rgb2(adjBG1+40, todaysec, 80000, 5500, 6400, 60)
	let highlCmdFolded = printf("highlight Folded guibg=#%02x%02x%02x", adjBG3, adjBG4, adjBG5a)
	let highlCmdCursorColumn = printf("highlight CursorColumn guibg=#%02x%02x%02x", adjBG3, adjBG4, adjBG5a) 
	let highlCmdCursorLine = printf("highlight CursorLine guibg=#%02x%02x%02x", adjBG3,adjBG4,adjBG5a) 
	let highlCmdLineNr = printf("highlight LineNr guibg=#%02x%02x%02x", adjBG3, adjBG4, adjBG5a)
	let highlCmdFoldColumn = printf("highlight FoldColumn guibg=#%02x%02x%02x", adjBG3, adjBG4, adjBG5a)
	let adj1 = Rgb2(adjBG1,	todaysec, 86399, 4000, 1, 40)
	let adj2 = Rgb2(adjBG1A+30, todaysec,86399,4000,1,40)
	let adj3 = Rgb2(adjBG2,	todaysec,86399,4000,1,40)
	let highlCmdDiffAdd = printf("highlight DiffAdd guibg=#%02x%02x%02x", adj1, adj2, adj3)
	let adj1 = Rgb2(adjBG1+30, todaysec, 86399, 4000, 1, 40)
	let adj2 = Rgb2(adjBG1A, todaysec, 86399, 4000, 1, 40)
	let adj3 = Rgb2(adjBG2,	todaysec, 86399, 4000, 1, 40)
	let highlCmdDiffDelete = printf("highlight DiffDelete guibg=#%02x%02x%02x", adj1, adj2, adj3)
	let adj1 = Rgb2(adjBG1+30, todaysec, 86399, 4000, 1, 40)
	let adj2 = Rgb2(adjBG1A+30, todaysec, 86399,4000,1,40)
	let adj3 = Rgb2(adjBG2, todaysec, 86399, 4000, 1, 40)
	let highlCmdDiffChange = printf("highlight DiffChange guibg=#%02x%02x%02x", adj1,adj2,adj3)
	let adj1 = Rgb2(adjBG1,	todaysec, 86399, 4000, 1, 40)
	let adj2 = Rgb2(adjBG1A, todaysec, 86399, 4000, 1, 40)
	let adj3 = Rgb2(adjBG2+30, todaysec, 86399, 4000, 1, 40)
	let highlCmdDiffText = printf("highlight DiffText guibg=#%02x%02x%02x", adj1, adj2, adj3)
	let adj1 = Rgb2a((-todaysec+86400)/338/4+160, todaysec, 57000, 16000, 23000, -100, -42, 0, 12)
	let adj2 = Rgb2a((-todaysec+86400)/338/4+76, todaysec, 57000, 16000, 23000, -100, -42, 0, 12)
	let adj3 = Rgb2a((-todaysec+86400)/338/4+23, todaysec, 57000, 16000, 23000, -100, -42, 0, 12)
	let adj4 = Rgb4(adjBG1, todaysec, 57000, 16000, 15000, -4, -11, -2, 0, 0)
	let adj5 = Rgb4(adjBG1A, todaysec, 57000, 16000, 15000, -4, -11, -2, 0, 0)
	let adj6 = Rgb4(adjBG2, todaysec, 57000, 16000, 15000, -4, -11, -2, 0, 0)
	let highlCmdStatement = printf("highlight Statement guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6)
	let adjBG5 = (todaysec<43200)?todaysec/338/2:todaysec/450+63
	let highlCmdVertSplit = printf("highlight VertSplit guifg=#%02x%02x%02x", adjBG3, adjBG3, adjBG5)
	let adj1 = Rgb2((-todaysec+86400)/338/2+40, todaysec, 44000, 8000, 20000, 100)
	let adj2 = Rgb2((-todaysec+86400)/338/2+54, todaysec, 44000,8000,20000,100)
	let adj3 = Rgb2((-todaysec+86400)/338/2+80, todaysec, 44000, 8000, 20000, 100)
	let highlCmdLineNr2 = printf("highlight LineNr guifg=#%02x%02x%02x", adj1, adj2, adj3)  
	let highlCmdFoldColumn2 = printf("highlight FoldColumn guifg=#%02x%02x%02x", adj1, adj2, adj3)  
	let highlCmdFolded2 = printf("highlight Folded guifg=#%02x%02x%02x", adj1, adj2, adj3)  
	let adj1 = Rgb2a((-todaysec+86400)/220/2+27, todaysec, 52000, 17000, 5000, -140, -45, 0, 25)
	let adj2 = Rgb2a((-todaysec+86400)/220/2+110, todaysec, 52000, 17000, 5000, -140, -45, 0, 25)
	let adj4 = Rgb4a(adjBG1, todaysec, 57000, 22000, 14500, -26, -28, -3, -2, 8, 2, 25, -20, -4, -13)
	let adj5 = Rgb4a(adjBG1A, todaysec, 57000, 22000, 14500, -26, -28, -3, -2, 8, 2, 25, -20, -4, -13)
	let adj6 = Rgb4a(adjBG2, todaysec, 57000, 22000, 14500, -26, -28, -3, -2, 8, 2, 25, -20, -4, -13)
	let highlCmdConstant = printf("highlight Constant guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj1, adj2, adj4, adj5, adj6)
	let highlCmdNonText = printf("highlight NonText guibg=#%02x%02x%02x guifg=#%02x%02x%02x", adjBG3, adjBG1, adjBG1, adj1, adj1, adj2)  
	let highlCmdJavaScriptValue=printf("highlight JavaScriptValue guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj1, adj2, adj4, adj5, adj6)
"	let adj1 = Rgb2a((-todaysec+86400)/338/2+110, todaysec, 35000, 9600, 40000, -285, 30, 0, 17) --thought these 
"	let adj2 = Rgb2a((-todaysec+86400)/338/2+76, todaysec, 35000, 0100, 40000, -285, 30, 0, 17)  --make normal
"	let adj3 = Rgb2a((-todaysec+86400)/338/2, todaysec, 35000, 0100, 40000, -285, 30, 0, 17)     --too hard to see
	let adj1 = Rgb2a((-todaysec+86400)/338/2+110, todaysec, 55000, 11000, 20000, -420, 30, 0, 17)
	let adj2 = Rgb2a((-todaysec+86400)/338/2+98, todaysec, 55000, 11000, 20000, -420, 30, 0, 17)
	let adj3 = Rgb2a((-todaysec+86400)/338/2, todaysec, 55000, 11000, 20000, -420, 30, 0, 17)
	let adj4 = Rgb4(adjBG1-30, todaysec, 0, 0, 10000, 20, 20, 40, 20, 40)
	let adj5 = Rgb4(adjBG1A-10, todaysec, 0, 0, 10000, 20, 20, 40, 20, 40)
	let adj6 = Rgb4(adjBG2+10, todaysec, 0, 0, 10000, 20, 20, 40, 20, 40)
	let highlCmdNormal2 = printf("highlight Normal guifg=#%02x%02x%02x gui=NONE", adj1, adj2, adj3)
	let highlCmdSearch=printf("highlight Search guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6) 
	let adj4 = Rgb4(adjBG1, todaysec, 77000, 10000, 26000, -99, -99, -99, -99, 99)
	let adj5 = Rgb4(adjBG1A, todaysec, 77000,10000,26000,-99,-99,-99,-99,99)
	let adj6 = Rgb4(adjBG2, todaysec, 77000, 10000, 26000, -99, -99, -99, -99, 99)
	let highlCmdQuestion = printf("highlight Question guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6)
	let highlCmdMoreMsg=printf("highlight MoreMsg guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6)
	let adj4 = Rgb2(adjBG1+40, todaysec, 86399, 6000, 1, 30)
	let adj5 = Rgb2(adjBG1A+15, todaysec, 86399, 6000, 1, 30)
	let adj6 = Rgb2(adjBG2+10, todaysec, 86399, 6000, 1, 30)
	let highlCmdVisual = printf("highlight Visual guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6)
	let adj1 = Rgb2a((-todaysec+86400)/338/4+0, todaysec, 57000, 10000, 29399, -168, -60, -6, 33)
	let adj2 = Rgb2a((-todaysec+86400)/338/4+216, todaysec, 57000, 10000, 29399, -168, -60, -6, 33)
	let adj3 = Rgb2a((-todaysec+86400)/338/4, todaysec, 57000, 10000, 29399, -168, -60, -6, 33)
	let adj4 = Rgb4a(adjBG1, todaysec, 57000, 22000, 14500, -26, -28, -3, -2, 8, 2, 25, -20, -4, -13)
	let adj5 = Rgb4a(adjBG1A, todaysec, 57000, 22000, 14500, -26, -28, -3, -2, 8, 2, 25, -20, -4, -13)
	let adj6 = Rgb4a(adjBG2, todaysec, 57000, 22000, 14500, -26, -28, -3, -2, 8, 2, 25, -20, -4, -13)
	let highlCmdIdentifier = printf("highlight Identifier guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6) 
	let adj1 = Rgb2a((-todaysec+86400)/355/2+97, todaysec, 43000, 2000, 19000, -130, -75, 0, 30)
	let adj2 = Rgb2a((-todaysec+86400)/355/2+0, todaysec, 43000, 2000, 19000, -130, -75, 0, 30)
	let adj3 = Rgb2a((-todaysec+86400)/355/2+137, todaysec, 43000, 2000, 19000, -130, -75, 0, 30)
	let adj4 = Rgb4(adjBG1, todaysec, 43000, 2000, 19000, -99, -99, 0, 0, 0)
	let adj5 = Rgb4(adjBG1A, todaysec, 43000, 2000, 19000, -99, -99, 0, 0, 0)
	let adj6 = Rgb4(adjBG2,	 todaysec, 43000, 2000, 19000, -99, -99, 0, 0, 0)
	let highlCmdPreProc = printf("highlight PreProc guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x",	adj1,adj2,adj3,adj4,adj5,adj6)
	let adj1 = Rgb2a((-todaysec+86400)/600/4+187, todaysec, 57000, 10000, 23000, -156, -68, 0, 10)
	let adj2 = Rgb2a((-todaysec+86400)/600/4+95, todaysec, 57000, 10000, 23000, -156, -68, 0, 10)
	let adj3 = Rgb2a((-todaysec+86400)/600/4+155, todaysec, 57000, 10000, 23000, -156, -68, 0, 10)
	let adj4 = Rgb4(adjBG1, todaysec, 57000, 10000, 15000, -2, -5, -5, -2, 0)
	let adj5 = Rgb4(adjBG1A, todaysec, 57000, 10000, 15000, -2, -5, -5, -2, 0)
	let adj6 = Rgb4(adjBG2, todaysec, 57000, 10000, 15000, -2, -5, -5, -2, 0)
	let highlCmdSpecial = printf("highlight Special guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6) 
	let highlCmdJavaScriptParens = printf("highlight JavaScriptParens guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6) 
	let adj1 = Rgb2((-todaysec+86400)/338/2+120, todaysec, 47000, 3000, 14000, 64)
	let adj2 = Rgb2((-todaysec+86400)/338/2+10, todaysec, 47000, 3000, 14000, 64)
	let adj3 = Rgb2((-todaysec+86400)/338/2+80, todaysec, 47000, 3000, 14000, 64)
	let adj4 = Rgb4(adjBG1, todaysec, 47000, 3000, 14000, -99, -99, -99, -99, 99)
	let adj5 = Rgb4(adjBG1A, todaysec, 47000, 3000, 14000, -99, -99, -99, -99, 99)
	let adj6 = Rgb4(adjBG2, todaysec, 47000, 3000, 14000, -99, -99, -99, -99, 99)
	let highlCmdTitle = printf("highlight Title guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6) 
	let adj1 = Rgb2b((-todaysec+86400)/280/4+140, todaysec, 50000, 12000, 22000, 220, 140, -300)
	let adj2 = Rgb2b((-todaysec+86400)/280/4+140, todaysec, 50000, 12000, 22000, 220, 140, -300)
	let adj3 = Rgb2b((-todaysec+86400)/280/4+140, todaysec, 50000, 12000, 22000, 220, 140, -300)
	let highlCmdComment = printf("highlight Comment guifg=#%02x%02x%02x", adj1, adj2, adj3)
	let highlCmdhtmlComment = printf("highlight htmlComment guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6)
	let highlCmdhtmlCommentPart = printf("highlight htmlCommentPart guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6)
	let adj1 = Rgb6(todaysec/338+70)
	let adj2 = Rgb6(todaysec/338+30)
	let adj3 = Rgb6(todaysec/338-100)
	let adj4 = Rgb2a((-todaysec+86400)/338/2+70, todaysec, 35000, 15000, 14000, 60, 120, 0, 0)
	let adj5 = Rgb2a((-todaysec+86400)/338/2+60, todaysec, 35000, 15000, 14000, 60, 120, 0, 0)
	let adj6 = Rgb2a((-todaysec+86400)/338/2+0, todaysec, 35000, 15000, 14000, 60, 120, 0, 0)
	let highlCmdStatusLine = printf("highlight StatusLine guibg=#%02x%02x%02x guifg=#%02x%02x%02x gui=bold", adj1, adj2, adj3, adj4, adj5, adj6)
	let adj1 = Rgb6(todaysec/338+70)
	let adj2 = Rgb6(todaysec/338+60)
	let adj3 = Rgb6(todaysec/338-100)
	let adj4 = Rgb2a((-todaysec+86400)/338/2+70, todaysec, 20000, 10000, 14000, 40, 120, 0, 0)
	let adj5 = Rgb2a((-todaysec+86400)/338/2+0, todaysec, 20000, 10000, 14000, 40, 120, 0, 0)
	let adj6 = Rgb2a((-todaysec+86400)/338/2+0, todaysec, 20000, 10000, 14000, 40, 120, 0, 0)
	let highlCmdStatusLineNC = printf("highlight StatusLineNC guibg=#%02x%02x%02x guifg=#%02x%02x%02x gui=bold", adj1, adj2, adj3, adj4, adj5, adj6)
	let adj1 = Rgb2((-todaysec+86400)/338/2, todaysec, 37000, 27000, 20000, 40)
	let adj2 = Rgb2((-todaysec+86400)/338/2+20, todaysec, 37000, 27000, 20000, 40)
	let adj3 = Rgb2((-todaysec+86400)/338/2+80, todaysec, 37000, 27000, 20000, 40)
	let adjBG6 = (adjBG5-32>=0)?adjBG5-32:0
	let highlCmdPMenu = printf("highlight PMenu guibg=#%02x%02x%02x", adjBG3, adjBG3, adjBG1)
	let highlCmdPMenuSel = "highlight PMenuSel guibg=Yellow guifg=Blue"
	let adj1 = Rgb2a((-todaysec+86400)/338/2+150, todaysec, 60000, 11000, 13000, -90, -45, -50, -20)
	let adj2 = Rgb2a((-todaysec+86400)/338/2+120, todaysec, 60000, 11000, 13000, -90, -45, -50, -20)
	let adj3 = Rgb2a((-todaysec+86400)/338/2+0, todaysec, 60000, 11000, 13000, -90, -45, -50, -20)
	let highlCmdType = printf("highlight Type guifg=#%02x%02x%02x", adj1, adj2, adj3)
	let adj1 = Rgb3(255, todaysec, 80000, 0)
	let adj2 = Rgb3(255, todaysec, 80000, 255)
	let adj3 = Rgb3(0, todaysec, 80000, 0)
	let highlCmdCursor = printf("highlight Cursor guibg=#%02x%02x%02x", adj1, adj2, adj3)
	let highlCmdMatchParen = printf("highlight MatchParen guibg=#%02x%02x%02x", adj1, adj2, adj3)
	let adj1 = Rgb2((-todaysec+86400)/338/2+100, todaysec, 44000, 10000, 26000, 40)
	let adj2 = Rgb2((-todaysec+86400)/338/2+0, todaysec, 44000, 10000, 26000, 40)
	let adj3 = Rgb2((-todaysec+86400)/338/2+180, todaysec, 44000, 10000, 26000, 40)
	let adj4 = Rgb4(adjBG1,	todaysec, 44000, 10000, 26000, -99, -99, -99, -99, 99)
	let adj5 = Rgb4(adjBG1A, todaysec, 44000, 10000, 26000, -99, -99, -99, -99, 99)
	let adj6 = Rgb4(adjBG2, todaysec, 44000, 10000, 26000, -99, -99, -99, -99, 99)
	let highlCmdhtmlLink = printf("highlight htmlLink guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6)
	let adj1 = Rgb2((-todaysec+86400)/338/2+100, todaysec, 66000, 8000, 8000, 95)
	let adj2 = Rgb2((-todaysec+86400)/338/2+160, todaysec, 66000, 8000, 8000, 95)
	let adj3 = Rgb2((-todaysec+86400)/338/2+0, todaysec, 66000, 8000, 8000, 95)
	let adj4 = Rgb4(adjBG1,	todaysec, 66000, 8000, 8000, -5, -5, 10, 3, 5)
	let adj5 = Rgb4(adjBG1A, todaysec, 66000, 8000, 8000, -5, -5, 10, 3, 5)
	let adj6 = Rgb4(adjBG2,	todaysec, 66000, 8000, 8000, -5, -5, 10, 3, 5)
	let highlCmdDirectory = printf("highlight Directory guifg=#%02x%02x%02x guibg=#%02x%02x%02x", adj1, adj2, adj3, adj4, adj5, adj6)
	let total = highlCmdNormal . " | " . highlCmdFolded . " | " . highlCmdCursorColumn . " | " . highlCmdCursorLine . " | "
	let total .= highlCmdLineNr . " | " . highlCmdFoldColumn . " | " . highlCmdDiffAdd . " | " . highlCmdDiffDelete . " | "
	let total .= highlCmdDiffChange . " | " . highlCmdDiffText . " | " . highlCmdStatement . " | " . highlCmdVertSplit . " | "
	let total .= highlCmdLineNr2 . " | " . highlCmdFoldColumn2 . " | " . highlCmdFolded2 . " | " . highlCmdConstant . " | "
	let total .= highlCmdNonText . " | " . highlCmdJavaScriptValue . " | " . highlCmdNormal2 . " | " . highlCmdSearch . " | "
	let total .= highlCmdQuestion . " | "  . highlCmdMoreMsg . " | " . highlCmdVisual . " | " . highlCmdIdentifier . " | "
	let total .= highlCmdPreProc . " | " . highlCmdSpecial . " | " . highlCmdJavaScriptParens . " | " . highlCmdTitle . " | "
	let total .= highlCmdComment . " | " . highlCmdhtmlComment . " | " . highlCmdhtmlCommentPart . " | " . highlCmdStatusLine . " | "
	let total .= highlCmdStatusLineNC . " | " . highlCmdPMenu . " | " . highlCmdPMenuSel . " | " . highlCmdType . " | "
	let total .= highlCmdCursor . " | " . highlCmdMatchParen . " | " . highlCmdhtmlLink . " | " . highlCmdDirectory
	execute total
endfunction       

" name of permanent color scheme
" but check in case user already has one
if !exists("permanentColorScheme")
	let g:permanentColorScheme = "darkblue"
endif

" this prevents repeated calls to activate the permanent color scheme
let g:bIveSetTheNonMovingScheme = 0

func HandleTextChanged()
	if &modified == 1 && g:bIveSetTheNonMovingScheme == 0
		exe "colorscheme ".g:permanentColorScheme
		let g:bIveSetTheNonMovingScheme = 1
	endif
endfunction

func GetTheTimeEffectMoving()
	call SetHighLight(1)
	let g:bIveSetTheNonMovingScheme = 0
endfunc

au CursorHold * if &modified==0 | call SetHighLight(0) | endif
au CursorHoldI * if &modified==0 | call SetHighLight(0) | endif
au CursorMoved * call HandleTextChanged()
au CursorMovedI * call HandleTextChanged()
au BufWritePost * call GetTheTimeEffectMoving()
