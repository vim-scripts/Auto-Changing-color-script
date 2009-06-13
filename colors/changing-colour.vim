" +-----------------------------------------------------------------------------+
" | CHANGING COLOUR SCRIPT                                                      |
" +-----------------------------------------------------------------------------+
" | START                                                                       |
" +-----------------------------------------------------------------------------+
" | REVISONS:                                                                   |
" | WED 27TH MAY 2009: o VER 1.00                                               |
" | MON 1ST JUN 2009:  o VER 1.1                                                |
" |                    . Put comment markers to ensure whole script include-oops|
" |                    . Corrected Question of element potential                |
" | TUE 2ND JUN 2009:  o VER 1.2                                                |
" |                    . Corrected Search element background was perm. yellow   |
" |                    . Considerably reduced clutter, shortened names, etc     |
" | TUE 2ND JUN 2009:  o VER 1.3                                                |
" |                    . added pretty frames around function descriptions       |
" |                    . created new entry for Directory element in grassy green|
" |                    . corrected bug: lo-lights not perfectly synch. wit. text|
" | WED 3RD JUN 2009:  o VER 1.4                                                |
" |                    . improve way bckgrnds. enhanced, corrected some mistakes|
" |         "          o VER 1.5                                                |
" |                    . removed duplicate htmlComment* pair                    |
" |                    . improved comment to a nice balanced-out grey           |
" | THU 4TH JUN 2009:  o VER 1.6                                                |
" |                    . brightened Constant and Identifier bgr. a tiny amount  |
" | THU 11TH JUN 2009: o VER 1.7                                                |
" |		       . corrected slightly glary Identifier at low light       |
" | FRI 12TH JUN 2009: o VER 1.8                                                |
" |		       . removed 'stopinsert' from au CursorHoldI               |
" |		         unintentionally left in                                |
" |		       . added comment to show how to remove invert effect      |
" | SAT 13TH JUN 2009  o VER 1.9                                                |
" |                    . made it very easy for you to set your own preferred    |
" |                      frequency for the script to change the colour          |
" |                    o VER 2.0                                                |
" |                    . made standard change freq. 1 min, not too often to     |
" |                      annoy but often enough to remind you of time is passing|
" +-----------------------------------------------------------------------------+

let s:oldhA=""
let s:oldactontime=-9999

"debug
"let g:mytime=40000
"let g:mysenDar=10000
"let g:mysenLig=24000
"let g:myadjust=64

" +------------------------------------------------------------------------------+
" | Main RGBEl function, used to work out amount to offset RGB value by to avoid |
" | it clashing with the background colour.                                      |
" | Return value is modified or otherwise value (not modified if no clash).      |
" +------------------------------------------------------------------------------+
:function RGBEl2(RGBEl,actBgr,dangerBgr,senDar,senLig,adjust,debug)
:	if a:debug==1
:		return a:RGBEl
:	endif
:	if exists("g:mysenDar") && a:debug!=2
:		let senDar=g:mysenDar
:	else
:		let senDar=a:senDar
:	endif
:	if exists("g:mysenLig") && a:debug!=2
:		let senLig=g:mysenLig
:	else
:		let senLig=a:senLig
:	endif
:	if exists("g:myadjust") && a:debug!=2
:		let adjust=g:myadjust
:	else
:		let adjust=a:adjust
:	endif
:	if exists("g:mydangerBgr") && a:debug!=2
:		let dangerBgr=g:mydangerBgr
:	else
:		let dangerBgr=a:dangerBgr
:	endif
:	if a:actBgr>=dangerBgr-senDar && a:actBgr<=dangerBgr+senLig
:		let whatdoyoucallit=(dangerBgr-a:actBgr)/130
:		if adjust<40
:			let steppa=0
:		else
:			let steppa=(dangerBgr-a:actBgr)/338
:			if steppa<0
:				let steppa=-steppa
:			endif
:			if steppa>40
:				let steppa=40
:			endif
:			let steppa=-steppa+40
:			let steppa=steppa*2
:		endif
:		if a:actBgr<=dangerBgr
:			let adjustedValue=a:RGBEl-adjust-whatdoyoucallit-steppa
:		else
:			let adjustedValue=a:RGBEl-adjust-steppa
:		endif
:	else
:		let adjustedValue=a:RGBEl
:	endif
:	if adjustedValue<0
:		let adjustedValue=0
:	endif
:	if adjustedValue>255
:		let adjustedValue=255
:	endif
:	return adjustedValue
:endfunction

" +------------------------------------------------------------------------------+
" | RGBEl function for cursor to work out amount to offset RGB component to stop |
" | it from clashing with the background colour.                                 |
" | Return value is modified or otherwise value (not modified if no clash).      |
" +------------------------------------------------------------------------------+
:function RGBEl3(RGBEl,actBgr,dangerBgr)
:	let diff=a:actBgr-a:dangerBgr
:	if diff<0
:		let diff=-diff
:	endif
:	if diff<8000
:		let adjustedValue=a:RGBEl-128
:		if adjustedValue<0
:			let adjustedValue=0
:		endif
:	else
:		let adjustedValue=a:RGBEl
:	endif
:	return adjustedValue
:endfunction

" +------------------------------------------------------------------------------+
" | RGBEl function used to work out offsetting for RGB components pertaining to  |
" | a background, i.e. the bit that says guibg= of the vim highlight command.    |
" | Obviously background is different to foreground, so it's handled differently.|
" | You can tell the function what to do with the background if the RGB value    |
" | is *just* below the 'danger' general background, and above it. In each case  |
" | You can tell it to brighten it or darken the passed RGB value. (darkAdj,     |
" | lghtAdj params.) Positive values, (e.g. 40) add brightness, nagative         |
" | removes it. Special cases 99 and -99 adds does this in a 'default' measure.  |
" | You can also tell the function what to do if the RGB value is inside the     |
" | danger zone. (dangerZoneAdj) Use this if you find using the normal foreground|
" | modification in the text by itself doesn't quite cut it.                     |
" | (i.e. text still looks fuzzy even when a high 'adjust' param. value is used  |
" | with RGBEl2() - making it highly darkened, as darkened as you can get it, yet|
" | making no difference. Normally I found darkening the text when passing       |
" | 'danger' (where the background looks very similar to the text) was enough but|
" | in some cases even whacking it all the way down to black didn't improve it,  |
" | so I added this parameter 'dangerZoneAdj' to bring the background in to the  |
" | rescue, allowing you to shift it up or down slighty.                         |
" | Return value is either the up or down-shifted RGB background element if the  |
" | element falls just outside the 'danger' boundary, a shifted-up RGB element   |
" | if the value is fully inside the danger boundary (and you set dangerZoneAdj) |
" | or simply the same as you pass if the value you pass is outside the danger   |
" | zone AND the outer boundary ring of the 'danger zone'.                       |
" +------------------------------------------------------------------------------+
:function RGBEl4(RGBEl,actBgr,dangerBgr,senDar,senLig,darkAdj,lghtAdj,dangerZoneAdj,debug)
:	if a:debug==1
:		return a:RGBEl
:	endif
:	if exists("g:mysenDar") && a:debug!=2
:		let senDar=g:mysenDar
:	else
:		let senDar=a:senDar
:	endif
:	if exists("g:mysenLig") && a:debug!=2
:		let senLig=g:mysenLig
:	else
:		let senLig=a:senLig
:	endif
:	if exists("g:mydangerBgr") && a:debug!=2
:		let dangerBgr=g:mydangerBgr
:	else
:		let dangerBgr=a:dangerBgr
:	endif
:	let darkAdj=a:darkAdj
:	let lghtAdj=a:lghtAdj
:	if a:darkAdj==99
:		let darkAdj=11
:	endif
:	if a:darkAdj==-99
:		let darkAdj=-11
:	endif
:	if a:lghtAdj==99
:		let lghtAdj=11
:	endif
:	if a:lghtAdj==-99
:		let lghtAdj=-11
:	endif
:	let dangerZoneAdj=a:dangerZoneAdj
:	if a:dangerZoneAdj==99
:		let dangerZoneAdj=15
:	endif
:	if a:dangerZoneAdj==-99
:		let dangerZoneAdj=-15
:	endif
:	let adjustedValue=a:RGBEl
:	if a:actBgr>=dangerBgr-senDar-7200 && a:actBgr<dangerBgr-senDar
:		let adjustedValue=a:RGBEl+darkAdj
:	endif
:	if a:actBgr>dangerBgr+senLig && a:actBgr<=dangerBgr+senLig+7200
:		let adjustedValue=a:RGBEl+lghtAdj
:	endif
:	if a:actBgr>=(dangerBgr-senDar) && a:actBgr<=(dangerBgr+senLig) && dangerZoneAdj
:		let adjustedValue=adjustedValue+dangerZoneAdj
:	endif
:	if adjustedValue<0
:		let adjustedValue=0
:	endif
:	if adjustedValue>255
:		let adjustedValue=255
:	endif
:	return adjustedValue
:endfunction

" +------------------------------------------------------------------------------+
" | Special case of RGBEl function used particularly for the Normal highlight    |
" | element which obviously needs to be stronger because it's background cannot  |
" | be 'shifted' in bad visibility cases because Normal also happens to be the   |
" | the general background vim uses.                                             |
" +------------------------------------------------------------------------------+
:function RGBEl5(RGBEl,actBgr,dangerBgr,senDar,senLig,debug)
:	if a:debug==1
:		return a:RGBEl
:	endif
:	if exists("g:mysenDar") && a:debug!=2
:		let senDar=g:mysenDar
:	else
:		let senDar=a:senDar
:	endif
:	if exists("g:mysenLig") && a:debug!=2
:		let senLig=g:mysenLig
:	else
:		let senLig=a:senLig
:	endif
:	if exists("g:mydangerBgr") && a:debug!=2
:		let dangerBgr=g:mydangerBgr
:	else
:		let dangerBgr=a:dangerBgr
:	endif
:	if a:actBgr>=dangerBgr-senDar && a:actBgr<=dangerBgr+senLig
:		let adjustedValue=255
:	else
:		let adjustedValue=a:RGBEl
:	endif
:	if a:actBgr>=(dangerBgr+senLig)-21000 && a:actBgr<=dangerBgr+senLig
:		let adjustedValue=0
:	endif
:	if adjustedValue<0
:		let adjustedValue=0
:	endif
:	if adjustedValue>255
:		let adjustedValue=255
:	endif
:	return adjustedValue
:endfunction 

" +------------------------------------------------------------------------------+
" | This variable allows highlight to be inverted, i.e higher time = darker      |
" +------------------------------------------------------------------------------+
let highLowLightToggle=0

" +------------------------------------------------------------------------------+
" | This variable is used to control how often the script deems it's time to     |
" | 'progress' the colour. The higher the less often it will do so, the lower    |
" | the more.  A value of 480 is equivalent to every 20 seconds. (86400, the     |
" | total number of seconds in a day, squeezed down to one hours for this        |
" | script, divided by 60 and then by 3 .. so it's like one hour divided by 60   |
" | and then by 3 = 20 seconds. Obviously if you wanted the colour to change     |
" | every minute then you'd do 86400 divided by 60. Remember the 86400 is the    |
" | number of seconds in a day mapped down to one hour. I know this is weird but |
" | it's because the script originally was designed to change colours over the   |
" | whole day but this seemed to take too long to be interesting so I 'secretly' |
" | started using the progress through only the hour but then multiplied-up this |
" | number so it behaved to the rest of the script like it was still working in  |
" | 'the day') Obviously you could play with this number until you find one that |
" | works for you. E.g. every thirty seconds=720 (86400/60/2). Every two minutes=|
" | 2880 (86400/30). Every 2.5 minutes=3600 (86400/24). Every 1 minute=1440      |
" | (86400/60).                                                                  |
" +------------------------------------------------------------------------------+
let g:changefreq=1440

" +------------------------------------------------------------------------------+
" | Muscle function, calls vim highlight command for each element based on the   |
" | time into the current hour.                                                  |
" +------------------------------------------------------------------------------+
:function SetHighLight(nightorday)
:	let todaysec=((localtime()%(60*60)))*24
:	if exists("g:mytime")
:		let todaysec=g:mytime
:	else
: 		if a:nightorday==1
:			let todaysec=-todaysec+86400
:		else
:			let todaysec=todaysec
:		endif
:		if (localtime()/60/60%2==1)
:			let todaysec=-todaysec+86400
:		else
:			let todaysec=todaysec
:		endif
:	endif
:	let adjBG1=(todaysec<43200)?todaysec/450:(todaysec-43200)/271+96
:	let adjBG2=(todaysec<43200)?todaysec/338:(todaysec-43200)/676+127
:	let adjBG3=(adjBG1-32>=32)?adjBG1-32:32
:	let adjBG4=(adjBG1-32>=32)?adjBG1-32:32
:       let hA=printf("highlight Normal guibg=#%02x%02x%02x",					adjBG1,adjBG1,adjBG2)
:       let hA1=printf("highlight Folded guibg=#%02x%02x%02x guifg=#%02x%02x%02x",		adjBG1,adjBG1,adjBG4,adjBG1,adjBG1,adjBG4)
:       let hA2=printf("highlight CursorLine guibg=#%02x%02x%02x",				adjBG3,adjBG3,adjBG1) 
:       let hA3=printf("highlight NonText guibg=#%02x%02x%02x guifg=#%02x%02x%02x",		adjBG3,adjBG1,adjBG1,adjBG3,adjBG1,adjBG1)  
:       let hA4=printf("highlight LineNr guibg=#%02x%02x%02x",					adjBG1,adjBG3,adjBG1)
:       let hA5=printf("highlight Search guibg=#%02x%02x%02x",					adjBG3,adjBG3,adjBG1) 
:	let adj1=	RGBEl2(adjBG1,								todaysec,86399,4000,1,40,2)
:	let adj2=	RGBEl2(adjBG1+30,							todaysec,86399,4000,1,40,2)
:	let adj3=	RGBEl2(adjBG2,								todaysec,86399,4000,1,40,2)
:	let hA6=printf("highlight DiffAdd guibg=#%02x%02x%02x",					adj1,adj2,adj3)
:	let adj1=	RGBEl2(adjBG1+30,							todaysec,86399,4000,1,40,2)
:	let adj2=	RGBEl2(adjBG1,								todaysec,86399,4000,1,40,2)
:	let adj3=	RGBEl2(adjBG2,								todaysec,86399,4000,1,40,2)
:	let hA7=printf("highlight DiffDelete guibg=#%02x%02x%02x",				adj1,adj2,adj3)
:	let adj1=	RGBEl2(adjBG1+30,							todaysec,86399,4000,1,40,2)
:	let adj2=	RGBEl2(adjBG1+30,							todaysec,86399,4000,1,40,2)
:	let adj3=	RGBEl2(adjBG2,								todaysec,86399,4000,1,40,2)
:	let hA8=printf("highlight DiffChange guibg=#%02x%02x%02x",				adj1,adj2,adj3)
:	let adj1=	RGBEl2(adjBG1,								todaysec,86399,4000,1,40,2)
:	let adj2=	RGBEl2(adjBG1,								todaysec,86399,4000,1,40,2)
:	let adj3=	RGBEl2(adjBG2+30,							todaysec,86399,4000,1,40,2)
:	let hA9=printf("highlight DiffText guibg=#%02x%02x%02x",				adj1,adj2,adj3)
:	let adj1	=RGBEl2((-todaysec+86400)/338/4+160,					todaysec,50000,10000,16000,54,2)
:	let adj2	=RGBEl2((-todaysec+86400)/338/4+76,					todaysec,50000,10000,16000,54,2)
:	let adj3	=RGBEl2((-todaysec+86400)/338/4+23,					todaysec,50000,10000,16000,54,2)
:	let adj4	=RGBEl4(adjBG1,								todaysec,50000,10000,16000,-99,99,0,2)
:	let adj5	=RGBEl4(adjBG1,								todaysec,50000,10000,16000,-99,99,0,2)
:	let adj6	=RGBEl4(adjBG2,								todaysec,50000,10000,16000,-99,99,0,2)
:	let hB=printf("highlight Statement guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let adjBG5=(todaysec<43200)?todaysec/338/2:todaysec/450+63
:	let hB1=printf("highlight VertSplit guifg=#%02x%02x%02x",				adjBG3,adjBG3,adjBG5)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+110,					todaysec,56000,10000,22000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+64,					todaysec,56000,10000,22000,40,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2,						todaysec,56000,10000,22000,40,2)
:       let hB2=printf("highlight LineNr guifg=#%02x%02x%02x",					adj1,adj2,adj3)  
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+76,					todaysec,46500,14000,25000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+20,					todaysec,46500,14000,25000,40,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,46500,14000,25000,-99,99,19,2)
:	let adj5=	RGBEl4(adjBG2,								todaysec,46500,14000,25000,-99,99,19,2)
:	let hC=printf("highlight Constant guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj2,adj4,adj4,adj5)
:	let adj1=	RGBEl5((-todaysec+86400)/338/2+110,					todaysec,50000,27000,29000,2)
:	let adj2=	RGBEl5((-todaysec+86400)/338/2+64,					todaysec,50000,27000,29000,2)
:	let adj3=	RGBEl5((-todaysec+86400)/338/2,						todaysec,50000,27000,29000,2)
:	let hD=printf("highlight Normal guifg=#%02x%02x%02x gui=NONE",				adj1,adj2,adj3)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+58,					todaysec,57000,10000,24000,64,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+127,					todaysec,57000,10000,24000,64,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2,						todaysec,57000,10000,24000,64,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,57000,10000,24000,-3,-99,3,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,57000,10000,24000,-3,-99,3,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,57000,10000,24000,-3,-99,3,2)
:	let hE=printf("highlight Identifier guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6) 
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+100,					todaysec,43000,5000,16000,39,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,43000,5000,16000,39,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+140,					todaysec,43000,5000,16000,39,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,43000,5000,16000,-99,99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,43000,5000,16000,-99,99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,43000,5000,16000,-99,99,99,2)
:	let hF=printf("highlight PreProc guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x",	adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/4+192,					todaysec,60500,14000,19000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/4+100,					todaysec,60500,14000,19000,40,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/4+160,					todaysec,60500,14000,19000,40,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,60500,14000,19000,-99,-99,0,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,60500,14000,19000,-99,-99,0,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,60500,14000,19000,-99,-99,0,2)
:	let hG=printf("highlight Special guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x",	adj1,adj2,adj3,adj4,adj5,adj6) 
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+120,					todaysec,47000,3000,14000,64,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+10,					todaysec,47000,3000,14000,64,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+80,					todaysec,47000,3000,14000,64,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,47000,3000,14000,-99,-99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,47000,3000,14000,-99,-99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,47000,3000,14000,-99,-99,99,2)
:       let hH=printf("highlight Title guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6) 
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+60,					todaysec,50000,10000,13000,5,0)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+60,					todaysec,50000,10000,13000,5,0)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+60,					todaysec,50000,10000,13000,5,0)
:	let adj4=	RGBEl4(adjBG1,								todaysec,50000,10000,13000,-99,-99,99,0)
:	let adj5=	RGBEl4(adjBG1,								todaysec,50000,10000,13000,-99,-99,99,0)
:	let adj6=	RGBEl4(adjBG2,								todaysec,50000,10000,13000,-99,-99,99,0)
:	let hI=printf("highlight Comment guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let hI1=printf("highlight htmlComment guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let hI2=printf("highlight htmlCommentPart guifg=#%02x%02x%02x guibg=#%02x%02x%02x",	adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2(todaysec/338+70,							todaysec,99999,0,0,0,2)
:	let adj2=	RGBEl2(todaysec/338+30,							todaysec,99999,0,0,0,2)
:	let adj3=	RGBEl2(todaysec/338-100,						todaysec,99999,0,0,0,2)
:	let adj4=	RGBEl2((-todaysec+86400)/338/2+70,					todaysec,37000,27000,20000,40,2)
:	let adj5=	RGBEl2((-todaysec+86400)/338/2+60,					todaysec,37000,27000,20000,40,2)
:	let adj6=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,37000,27000,20000,40,2)
:	let hJ=printf("highlight StatusLine guibg=#%02x%02x%02x guifg=#%02x%02x%02x gui=bold",	adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2(todaysec/338+70,							todaysec,99999,0,0,0,2)
:	let adj2=	RGBEl2(todaysec/338+60,							todaysec,99999,0,0,0,2)
:	let adj3=	RGBEl2(todaysec/338-100,						todaysec,99999,0,0,0,2)
:	let adj4=	RGBEl2((-todaysec+86400)/338/2+70,					todaysec,14000,12000,29000,40,2)
:	let adj5=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,14000,12000,29000,40,2)
:	let adj6=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,14000,12000,29000,40,2)
:	let hK=printf("highlight StatusLineNC guibg=#%02x%02x%02x guifg=#%02x%02x%02x gui=bold",adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2,						todaysec,37000,27000,20000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+20,					todaysec,37000,27000,20000,40,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+80,					todaysec,37000,27000,20000,40,2)
:	let adjBG6=(adjBG5-32>=0)?adjBG5-32:0
:	let hM=printf("highlight PMenu guibg=#%02x%02x%02x",					adjBG6,adjBG6,adjBG6)
:	let hN="highlight PMenuSel guibg=Yellow guifg=Blue"
:	let adj1=	RGBEl2(adjBG1+50,							todaysec,86399,4000,1,40,2)
:	let adj2=	RGBEl2(adjBG1+40,							todaysec,86399,4000,1,40,2)
:	let adj3=	RGBEl2(adjBG2,								todaysec,86399,4000,1,40,2)
:	let hL=printf("highlight Visual guibg=#%02x%02x%02x",					adj1,adj2,adj3)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+150,					todaysec,60000,8000,13000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+120,					todaysec,60000,8000,13000,40,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,60000,8000,13000,40,2)
:	let hO=printf("highlight Type guifg=#%02x%02x%02x",					adj1,adj2,adj3)
:	let adj1=RGBEl3(255,todaysec,85000)
:	let adj2=RGBEl3(0,todaysec,85000)
:	let hP=printf("highlight Cursor guibg=#%02x%02x%02x",					adj1,adj1,adj2)
:	let hP1=printf("highlight MatchParen guibg=#%02x%02x%02x",				adj1,adj1,adj2)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+100,					todaysec,44000,10000,26000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,44000,10000,26000,40,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+180,					todaysec,44000,10000,26000,40,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,44000,10000,26000,-99,-99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,44000,10000,26000,-99,-99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,44000,10000,26000,-99,-99,99,2)
:	let hQ=printf("highlight htmlLink guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+220,					todaysec,77000,10000,26000,70,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+220,					todaysec,77000,10000,26000,70,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,77000,10000,26000,70,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,77000,10000,26000,-99,-99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,77000,10000,26000,-99,-99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,77000,10000,26000,-99,-99,99,2)
:	let hR=printf("highlight Question guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let hR1=printf("highlight MoreMsg guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+100,					todaysec,63000,27000,7000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+160,					todaysec,63000,27000,7000,40,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,63000,27000,7000,40,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,63000,27000,7000,-99,-99,0,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,63000,27000,7000,-99,-99,0,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,63000,27000,7000,-99,-99,0,2)
:	let hS=printf("highlight Directory guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	if todaysec/g:changefreq!=s:oldactontime/g:changefreq || exists("g:mytime")
:		let s:oldactontime=todaysec
:		execute hA
:		execute hA1
:		execute hA2
:		execute hA3
:		execute hA4
:		execute hA5
:		execute hA6
:		execute hA7
:		execute hA8
:		execute hA9
:		execute hB
:		execute hB1
:		execute hB2
:		execute hC
:		execute hD
:		execute hE
:		execute hF
:		execute hG
:		execute hH
:		execute hI
:		execute hI1
:		execute hI2
:		execute hJ
:		execute hK
:		execute hL
:		execute hM
:		execute hN
:		execute hO
:		execute hP
:		execute hP1
:		execute hQ
:		execute hR
:		execute hR1
:		execute hS
:	endif
:	redraw
:	let s:oldhA=hA
:	if todaysec>=69120 || todaysec<=17280
:	echo strftime("%c")
:	endif
:endfunction       

" +------------------------------------------------------------------------------+
" | Wrapper function takes into account 'invert' global variable, used when      |
" | doing 'invert' colours behave light-dark instead of dark-light.              |
" | If you thought this effect was annoying you could you could modify this      |
" | function so it always calls muscle function with 0.                          |
" +------------------------------------------------------------------------------+
:function ExtraSetHighLight()
:	if g:highLowLightToggle==0
:		call SetHighLight(0)
:	else
:		call SetHighLight(1)
:	endif
:endfunction

au CursorHold * call ExtraSetHighLight()
au CursorHoldI * call ExtraSetHighLight()

" +------------------------------------------------------------------------------+
" | The following lines provide a invert when you go into and out of insert      |
" | mode. If you don't like this effect, just comment these two lines out!       |
" +------------------------------------------------------------------------------+
au InsertEnter * let g:highLowLightToggle=1 | call ExtraSetHighLight()
au InsertLeave * let g:highLowLightToggle=0 | call ExtraSetHighLight()

" +-----------------------------------------------------------------------------+
" | END                                                                         |
" +-----------------------------------------------------------------------------+
" | CHANGING COLOUR SCRIPT                                                      |
" +-----------------------------------------------------------------------------+

