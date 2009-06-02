" CHANGING COLOUR SCRIPT
" ------------------------------------------------------------------------------
" START
" ------------------------------------------------------------------------------

let s:oldhighlargA=""
let s:oldactontime=-9999

"debug
"let g:mytime=86399
"let g:mysensl=10000
"let g:mysensh=17000
"let g:myadjust=40

" main ModdedValue function, used to work out what if anything to offset the R,G,B
" component of the foreground for the highlight element
:function ModdedValue2(compvalue,actual,dangerpoint,sensl,sensh,adjust,debug)
:	if a:debug==1
:		return a:compvalue
:	endif
:	if exists("g:mysensl") && a:debug!=2
:		let sensl=g:mysensl
:	else
:		let sensl=a:sensl
:	endif
:	if exists("g:mysensh") && a:debug!=2
:		let sensh=g:mysensh
:	else
:		let sensh=a:sensh
:	endif
:	if exists("g:myadjust") && a:debug!=2
:		let adjust=g:myadjust
:	else
:		let adjust=a:adjust
:	endif
:	if exists("g:mydangerpoint") && a:debug!=2
:		let dangerpoint=g:mydangerpoint
:	else
:		let dangerpoint=a:dangerpoint
:	endif
:	if a:actual>=dangerpoint-sensl && a:actual<=dangerpoint+sensh
:		let whatdoyoucallit=(dangerpoint-a:actual)/130
:		if adjust<40
:			let steppa=0
:		else
:			let steppa=(dangerpoint-a:actual)/338
:			if steppa<0
:				let steppa=-steppa
:			endif
:			if steppa>40
:				let steppa=40
:			endif
:			let steppa=-steppa+40
:			let steppa=steppa*2
:		endif
:		if a:actual<=dangerpoint
:			let moddedvalue=a:compvalue-adjust-whatdoyoucallit-steppa
:		else
:			let moddedvalue=a:compvalue-adjust-steppa
:		endif
:	else
:		let moddedvalue=a:compvalue
:	endif
:	if moddedvalue<0
:		let moddedvalue=0
:	endif
:	if moddedvalue>255
:		let moddedvalue=255
:	endif
:	return moddedvalue
:endfunction

" works out a suitable offset for the cursor's colour if it's too near
" the 'danger' background colour
:function ModdedValue3(compvalue,actual,dangerpoint)
:	let diff=a:actual-a:dangerpoint
:	if diff<0
:		let diff=-diff
:	endif
:	if diff<8000
:		let moddedvalue=a:compvalue-128
:		if moddedvalue<0
:			let moddedvalue=0
:		endif
:	else
:		let moddedvalue=a:compvalue
:	endif
:	return moddedvalue
:endfunction

" does some offsetting on either the R,G, or B element of the background element 
" so as to avoid foreground looking fuzzy
:function ModdedValue4(compvalue,actual,dangerpoint,sensl,sensh,lolight,hilight,debug)
:	if a:debug==1
:		return a:compvalue
:	endif
:	if exists("g:mysensl") && a:debug!=2
:		let sensl=g:mysensl
:	else
:		let sensl=a:sensl
:	endif
:	if exists("g:mysensh") && a:debug!=2
:		let sensh=g:mysensh
:	else
:		let sensh=a:sensh
:	endif
:	if exists("g:mydangerpoint") && a:debug!=2
:		let dangerpoint=g:mydangerpoint
:	else
:		let dangerpoint=a:dangerpoint
:	endif
:	if a:lolight==99
:		let lolight=20
:	else
:		let lolight=a:lolight
:	endif
:	if a:hilight==99
:		let hilight=20
:	else
:		let hilight=a:hilight
:	endif
:	let moddedvalue=a:compvalue
:	if a:actual>=dangerpoint-sensl-7200 && a:actual<=dangerpoint-sensl
:		let moddedvalue=a:compvalue-lolight
:	endif
:	if a:actual>=dangerpoint+sensh && a:actual<=dangerpoint+sensh+7200
:		let moddedvalue=a:compvalue-lolight
:	endif
:	if a:actual>=(dangerpoint-sensl) && a:actual<=(dangerpoint+sensh) && hilight
:		let moddedvalue=moddedvalue+hilight
:	endif
:	if moddedvalue<0
:		let moddedvalue=0
:	endif
:	if moddedvalue>255
:		let moddedvalue=255
:	endif
:	return moddedvalue
:endfunction

" offsets either the R,G or B for the foreground of a highlight if too near
" the 'dangerpoint' background shade. This function is specific for the
" 'Normal' highlight entry
:function ModdedValue5(compvalue,actual,dangerpoint,sensl,sensh,debug)
:	if a:debug==1
:		return a:compvalue
:	endif
:	if exists("g:mysensl") && a:debug!=2
:		let sensl=g:mysensl
:	else
:		let sensl=a:sensl
:	endif
:	if exists("g:mysensh") && a:debug!=2
:		let sensh=g:mysensh
:	else
:		let sensh=a:sensh
:	endif
:	if exists("g:mydangerpoint") && a:debug!=2
:		let dangerpoint=g:mydangerpoint
:	else
:		let dangerpoint=a:dangerpoint
:	endif
:	if a:actual>=dangerpoint-sensl && a:actual<=dangerpoint+sensh
:		let moddedvalue=255
:	else
:		let moddedvalue=a:compvalue
:	endif
:	if a:actual>=(dangerpoint+sensh)-21000 && a:actual<=dangerpoint+sensh
:		let moddedvalue=0
:	endif
:	if moddedvalue<0
:		let moddedvalue=0
:	endif
:	if moddedvalue>255
:		let moddedvalue=255
:	endif
:	return moddedvalue
:endfunction 

" this variable controls whether custom highlight should be inverted
let highLowLightToggle=0

" main muscle function, calls highlight with values for each element
" based on the number of minutes past the hour, uses ModdedValueX() functions
" to offset the colour in case the background clashes
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
:	let adjustsecBG1=(todaysec<43200)?todaysec/450:(todaysec-43200)/271+96
:	let adjustsecBG2=(todaysec<43200)?todaysec/338:(todaysec-43200)/676+127
" this adjust is used in CursorLine
:	let adjustsecBG3=(adjustsecBG1-32>=32)?adjustsecBG1-32:32
:	let adjustsecBG4=(adjustsecBG1-32>=32)?adjustsecBG1-32:32
:       let highlargA=printf("highlight Normal guibg=#%02x%02x%02x",adjustsecBG1,adjustsecBG1,adjustsecBG2)
:       let highlargA1=printf("highlight Folded guibg=#%02x%02x%02x guifg=#%02x%02x%02x",adjustsecBG1,adjustsecBG1,adjustsecBG4,adjustsecBG1,adjustsecBG1,adjustsecBG4)
:       let highlargA2=printf("highlight CursorLine guibg=#%02x%02x%02x",adjustsecBG3,adjustsecBG3,adjustsecBG1) 
:       let highlargA3=printf("highlight NonText guibg=#%02x%02x%02x guifg=#%02x%02x%02x",adjustsecBG3,adjustsecBG1,adjustsecBG1,adjustsecBG3,adjustsecBG1,adjustsecBG1)  
:       let highlargA4=printf("highlight LineNr guibg=#%02x%02x%02x",adjustsecBG1,adjustsecBG3,adjustsecBG1)
:	let adjustsec1=		ModdedValue2(adjustsecBG1,			todaysec,86399,4000,1,40,2)
:	let adjustsec2=		ModdedValue2(adjustsecBG1+30,			todaysec,86399,4000,1,40,2)
:	let adjustsec3=		ModdedValue2(adjustsecBG2,			todaysec,86399,4000,1,40,2)
:	let highlargA5=printf("highlight DiffAdd guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3)
:	let adjustsec1=		ModdedValue2(adjustsecBG1+30,			todaysec,86399,4000,1,40,2)
:	let adjustsec2=		ModdedValue2(adjustsecBG1,			todaysec,86399,4000,1,40,2)
:	let adjustsec3=		ModdedValue2(adjustsecBG2,			todaysec,86399,4000,1,40,2)
:	let highlargA6=printf("highlight DiffDelete guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3)
:	let adjustsec1=		ModdedValue2(adjustsecBG1+30,			todaysec,86399,4000,1,40,2)
:	let adjustsec2=		ModdedValue2(adjustsecBG1+30,			todaysec,86399,4000,1,40,2)
:	let adjustsec3=		ModdedValue2(adjustsecBG2,			todaysec,86399,4000,1,40,2)
:	let highlargA7=printf("highlight DiffChange guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3)
:	let adjustsec1=		ModdedValue2(adjustsecBG1,			todaysec,86399,4000,1,40,2)
:	let adjustsec2=		ModdedValue2(adjustsecBG1,			todaysec,86399,4000,1,40,2)
:	let adjustsec3=		ModdedValue2(adjustsecBG2+30,			todaysec,86399,4000,1,40,2)
:	let highlargA8=printf("highlight DiffText guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3)
:" end of backgrounds
:	let adjustsec1		=ModdedValue2((-todaysec+86400)/338/4+160,	todaysec,50000,10000,16000,54,2)
:	let adjustsec2		=ModdedValue2((-todaysec+86400)/338/4+76,	todaysec,50000,10000,16000,54,2)
:	let adjustsec3		=ModdedValue2((-todaysec+86400)/338/4+23,	todaysec,50000,10000,16000,54,2)
:	let adjustsec4		=ModdedValue4(adjustsecBG1,			todaysec,50000,10000,16000,99,99,2)
:	let adjustsec5		=ModdedValue4(adjustsecBG1,			todaysec,50000,10000,16000,99,99,2)
:	let adjustsec6		=ModdedValue4(adjustsecBG2,			todaysec,50000,10000,16000,99,99,2)
:	let highlargB=printf("highlight Statement guifg=#%02x%02x%02x guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6)
" this adjust is really the same as the first adjustsec but it was overwriten
:	let adjustsecBG5=(todaysec<43200)?todaysec/338/2:todaysec/450+63
:	let highlargB1=printf("highlight VertSplit guifg=#%02x%02x%02x",adjustsecBG3,adjustsecBG3,adjustsecBG5)
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2+110,	todaysec,56000,10000,22000,40,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+64,	todaysec,56000,10000,22000,40,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/2,		todaysec,56000,10000,22000,40,2)
:       let highlargB2=printf("highlight LineNr guifg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3)  
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2+76,		todaysec,46500,14000,17000,39,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+20,		todaysec,46500,14000,17000,39,2)
:	let adjustsec4=		ModdedValue4(adjustsecBG1,				todaysec,46500,14000,17000,30,40,2)
:	let adjustsec5=		ModdedValue4(adjustsecBG2,				todaysec,46500,14000,17000,30,40,2)
:	let highlargC=printf("highlight Constant guifg=#%02x%02x%02x guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec2,adjustsec4,adjustsec4,adjustsec5)
:	let adjustsec1=		ModdedValue5((-todaysec+86400)/338/2+110,		todaysec,50000,27000,29000,2)
:	let adjustsec2=		ModdedValue5((-todaysec+86400)/338/2+64,		todaysec,50000,27000,29000,2)
:	let adjustsec3=		ModdedValue5((-todaysec+86400)/338/2,			todaysec,50000,27000,29000,2)
:	let highlargD=printf("highlight Normal guifg=#%02x%02x%02x gui=NONE",adjustsec1,adjustsec2,adjustsec3)
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2+58,		todaysec,57000,10000,24000,64,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+127,		todaysec,57000,10000,24000,64,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/2,			todaysec,57000,10000,24000,64,2)
:	let adjustsec4=		ModdedValue4(adjustsecBG1,				todaysec,57000,10000,24000,99,99,2)
:	let adjustsec5=		ModdedValue4(adjustsecBG1,				todaysec,57000,10000,24000,99,99,2)
:	let adjustsec6=		ModdedValue4(adjustsecBG2,				todaysec,57000,10000,24000,99,99,2)
:	let highlargE=printf("highlight Identifier guifg=#%02x%02x%02x guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6) 
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2+100,		todaysec,43000,10000,16000,40,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+0,			todaysec,43000,10000,16000,40,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/2+140,		todaysec,43000,10000,16000,40,2)
:	let adjustsec4=		ModdedValue4(adjustsecBG1,				todaysec,43000,10000,16000,99,99,2)
:	let adjustsec5=		ModdedValue4(adjustsecBG1,				todaysec,43000,10000,16000,99,99,2)
:	let adjustsec6=		ModdedValue4(adjustsecBG2,				todaysec,43000,10000,16000,99,99,2)
:	let highlargF=printf("highlight PreProc guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6)
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/4+192,		todaysec,60500,14000,19000,40,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/4+100,		todaysec,60500,14000,19000,40,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/4+160,		todaysec,60500,14000,19000,40,2)
:	let adjustsec4=		ModdedValue4(adjustsecBG1,				todaysec,60500,14000,19000,99,99,2)
:	let adjustsec5=		ModdedValue4(adjustsecBG1,				todaysec,60500,14000,19000,99,99,2)
:	let adjustsec6=		ModdedValue4(adjustsecBG2,				todaysec,60500,14000,19000,99,99,2)
:	let highlargG=printf("highlight Special guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6) 
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2+120,		todaysec,47000,3000,14000,64,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+10,		todaysec,47000,3000,14000,64,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/2+80,		todaysec,47000,3000,14000,64,2)
:	let adjustsec4=		ModdedValue4(adjustsecBG1,				todaysec,47000,3000,14000,99,99,2)
:	let adjustsec5=		ModdedValue4(adjustsecBG1,				todaysec,47000,3000,14000,99,99,2)
:	let adjustsec6=		ModdedValue4(adjustsecBG2,				todaysec,47000,3000,14000,99,99,2)
:       let highlargH=printf("highlight Title guifg=#%02x%02x%02x guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6) 
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2+50,		todaysec,56000,12000,29000,80,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+130,		todaysec,56000,12000,29000,80,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/2+0,			todaysec,56000,12000,29000,80,2)
:	let adjustsec4=		ModdedValue4(adjustsecBG1,				todaysec,56000,12000,29000,99,99,2)
:	let adjustsec5=		ModdedValue4(adjustsecBG1,				todaysec,56000,12000,29000,99,99,2)
:	let adjustsec6=		ModdedValue4(adjustsecBG2,				todaysec,56000,12000,29000,99,99,2)
:	let highlargI=printf("highlight Comment guifg=#%02x%02x%02x guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6)
:	let highlargI1=printf("highlight htmlComment guifg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3)
:	let highlargI2=printf("highlight htmlCommentPart guifg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3)
:	let adjustsec1=		ModdedValue2(todaysec/338+70,			todaysec,99999,0,0,0,2)
:	let adjustsec2=		ModdedValue2(todaysec/338+30,			todaysec,99999,0,0,0,2)
:	let adjustsec3=		ModdedValue2(todaysec/338-100,			todaysec,99999,0,0,0,2)
:	let adjustsec4=		ModdedValue2((-todaysec+86400)/338/2+70,	todaysec,37000,27000,20000,40,2)
:	let adjustsec5=		ModdedValue2((-todaysec+86400)/338/2+60,	todaysec,37000,27000,20000,40,2)
:	let adjustsec6=		ModdedValue2((-todaysec+86400)/338/2+0,		todaysec,37000,27000,20000,40,2)
:	let highlargJ=printf("highlight StatusLine guibg=#%02x%02x%02x guifg=#%02x%02x%02x gui=bold",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6)
:	let adjustsec1=		ModdedValue2(todaysec/338+70,			todaysec,99999,0,0,0,2)
:	let adjustsec2=		ModdedValue2(todaysec/338+60,			todaysec,99999,0,0,0,2)
:	let adjustsec3=		ModdedValue2(todaysec/338-100,			todaysec,99999,0,0,0,2)
:	let adjustsec4=		ModdedValue2((-todaysec+86400)/338/2+70,	todaysec,14000,12000,29000,40,2)
:	let adjustsec5=		ModdedValue2((-todaysec+86400)/338/2+0,		todaysec,14000,12000,29000,40,2)
:	let adjustsec6=		ModdedValue2((-todaysec+86400)/338/2+0,		todaysec,14000,12000,29000,40,2)
:	let highlargK=printf("highlight StatusLineNC guibg=#%02x%02x%02x guifg=#%02x%02x%02x gui=bold",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6)
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2,		todaysec,37000,27000,20000,40,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+20,	todaysec,37000,27000,20000,40,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/2+80,	todaysec,37000,27000,20000,40,2)
:	let adjustsecBG6=(adjustsecBG5-32>=0)?adjustsecBG5-32:0
:	let highlargM=printf("highlight PMenu guibg=#%02x%02x%02x",adjustsecBG6,adjustsecBG6,adjustsecBG6)
:	let highlargN="highlight PMenuSel guibg=Yellow guifg=Blue"
:	let adjustsec1=		ModdedValue2(adjustsecBG1+50,			todaysec,86399,4000,1,40,2)
:	let adjustsec2=		ModdedValue2(adjustsecBG1+40,			todaysec,86399,4000,1,40,2)
:	let adjustsec3=		ModdedValue2(adjustsecBG2,			todaysec,86399,4000,1,40,2)
:	let highlargL=printf("highlight Visual guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3)
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2+150,	todaysec,60000,8000,13000,40,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+120,	todaysec,60000,8000,13000,40,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/2+0,		todaysec,60000,8000,13000,40,2)
:	let highlargO=printf("highlight Type guifg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3)
:	let adjustsec1=ModdedValue3(255,todaysec,85000)
:	let adjustsec2=ModdedValue3(0,todaysec,85000)
:	let highlargP=printf("highlight Cursor guibg=#%02x%02x%02x",		adjustsec1,adjustsec1,adjustsec2)
:	let highlargP1=printf("highlight MatchParen guibg=#%02x%02x%02x",	adjustsec1,adjustsec1,adjustsec2)
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2+100,	todaysec,44000,10000,26000,40,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+0,		todaysec,44000,10000,26000,40,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/2+180,	todaysec,44000,10000,26000,40,2)
:	let adjustsec4=		ModdedValue4(adjustsecBG1,			todaysec,44000,10000,26000,99,99,2)
:	let adjustsec5=		ModdedValue4(adjustsecBG1,			todaysec,44000,10000,26000,99,99,2)
:	let adjustsec6=		ModdedValue4(adjustsecBG2,			todaysec,44000,10000,26000,99,99,2)
:	let highlargQ=printf("highlight htmlLink guifg=#%02x%02x%02x guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6)
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2+50,	todaysec,44000,10000,26000,40,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+130,	todaysec,44000,10000,26000,40,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/2+0,		todaysec,44000,10000,26000,40,2)
:	let adjustsec4=		ModdedValue4(adjustsecBG1,			todaysec,44000,10000,26000,99,99,2)
:	let adjustsec5=		ModdedValue4(adjustsecBG1,			todaysec,44000,10000,26000,99,99,2)
:	let adjustsec6=		ModdedValue4(adjustsecBG2,			todaysec,44000,10000,26000,99,99,2)
:	let highlargR=printf("highlight htmlComment guifg=#%02x%02x%02x guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6)
:	let highlargR1=printf("highlight htmlCommentPart guifg=#%02x%02x%02x guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6)
:	let adjustsec1=		ModdedValue2((-todaysec+86400)/338/2+220,	todaysec,77000,10000,26000,70,2)
:	let adjustsec2=		ModdedValue2((-todaysec+86400)/338/2+220,	todaysec,77000,10000,26000,70,2)
:	let adjustsec3=		ModdedValue2((-todaysec+86400)/338/2+0,		todaysec,77000,10000,26000,70,2)
:	let adjustsec4=		ModdedValue4(adjustsecBG1,			todaysec,77000,10000,26000,99,99,2)
:	let adjustsec5=		ModdedValue4(adjustsecBG1,			todaysec,77000,10000,26000,99,99,2)
:	let adjustsec6=		ModdedValue4(adjustsecBG2,			todaysec,77000,10000,26000,99,99,2)
:	let highlargS=printf("highlight Question guifg=#%02x%02x%02x guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6)
:	let highlargS1=printf("highlight MoreMsg guifg=#%02x%02x%02x guibg=#%02x%02x%02x",adjustsec1,adjustsec2,adjustsec3,adjustsec4,adjustsec5,adjustsec6)
:	if todaysec/450!=s:oldactontime/450 || exists("g:mytime")
:		let s:oldactontime=todaysec
:		execute highlargA
:		execute highlargA1
:		execute highlargA2
:		execute highlargA3
:		execute highlargA4
:		execute highlargA5
:		execute highlargA6
:		execute highlargA7
:		execute highlargA8
:		execute highlargB
:		execute highlargB1
:		execute highlargB2
:		execute highlargC
:		execute highlargD
:		execute highlargE
:		execute highlargF
:		execute highlargG
:		execute highlargH
:		execute highlargI
:		execute highlargI1
:		execute highlargI2
:		execute highlargJ
:		execute highlargK
:		execute highlargL
:		execute highlargM
:		execute highlargN
:		execute highlargO
:		execute highlargP
:		execute highlargP1
:		execute highlargQ
:		execute highlargR
:		execute highlargR1
:		execute highlargS
:		execute highlargS1
:	endif
:	redraw
:	let s:oldhighlargA=highlargA
:	if todaysec>=69120 || todaysec<=17280
:	echo strftime("%c")
:	endif
:endfunction       

:function ExtraSetHighLight()
:	if g:highLowLightToggle==0
:		call SetHighLight(0)
:	else
:		call SetHighLight(1)
:	endif
:endfunction

au CursorHold * call ExtraSetHighLight()
au CursorHoldI * call ExtraSetHighLight() 
au InsertEnter * let g:highLowLightToggle=1 | call ExtraSetHighLight()
au InsertLeave * let g:highLowLightToggle=0 | call ExtraSetHighLight()

" CHANGING COLOUR SCRIPT
" ------------------------------------------------------------------------------
" END
" ------------------------------------------------------------------------------


