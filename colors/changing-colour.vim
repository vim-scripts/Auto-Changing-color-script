" CHANGING COLOUR SCRIPT
" -------------------------------------------------------------------------------
" START
" -------------------------------------------------------------------------------
" REVISONS:
"   WED 27TH MAY 2009: o VER 1.00
"   MON 1ST JUN 2009:  o VER 1.1
"                      . Put comment markers to ensure whole script include (oops)
"                      . Corrected Question of element potential 
"   TUE 2ND JUN 2009:  o VER 1.2
"                      . Corrected Search element background was perm. yellow
"                      . Considerably reduced clutter, shortened names, etc
" -------------------------------------------------------------------------------

let s:oldhA=""
let s:oldactontime=-9999

"debug
"let g:mytime=86399
"let g:mysensl=10000
"let g:mysensh=17000
"let g:myadjust=40

" main RGBEl function, used to work out what if anything to offset the R,G,B
" component of the foreground for the highlight element
:function RGBEl2(compvalue,actual,dangerpoint,sensl,sensh,adjust,debug)
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
:function RGBEl3(compvalue,actual,dangerpoint)
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
:function RGBEl4(compvalue,actual,dangerpoint,sensl,sensh,lolight,hilight,debug)
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
:function RGBEl5(compvalue,actual,dangerpoint,sensl,sensh,debug)
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

" this variable allows highlight to be inverted, i.e higher time = darker
let highLowLightToggle=0

" muscle function, calls vim highlight command for each element
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
" start of backgrounds
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
:" end of backgrounds
:	let adj1	=RGBEl2((-todaysec+86400)/338/4+160,					todaysec,50000,10000,16000,54,2)
:	let adj2	=RGBEl2((-todaysec+86400)/338/4+76,					todaysec,50000,10000,16000,54,2)
:	let adj3	=RGBEl2((-todaysec+86400)/338/4+23,					todaysec,50000,10000,16000,54,2)
:	let adj4	=RGBEl4(adjBG1,								todaysec,50000,10000,16000,99,99,2)
:	let adj5	=RGBEl4(adjBG1,								todaysec,50000,10000,16000,99,99,2)
:	let adj6	=RGBEl4(adjBG2,								todaysec,50000,10000,16000,99,99,2)
:	let hB=printf("highlight Statement guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let adjBG5=(todaysec<43200)?todaysec/338/2:todaysec/450+63
:	let hB1=printf("highlight VertSplit guifg=#%02x%02x%02x",				adjBG3,adjBG3,adjBG5)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+110,					todaysec,56000,10000,22000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+64,					todaysec,56000,10000,22000,40,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2,						todaysec,56000,10000,22000,40,2)
:       let hB2=printf("highlight LineNr guifg=#%02x%02x%02x",					adj1,adj2,adj3)  
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+76,					todaysec,46500,14000,17000,39,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+20,					todaysec,46500,14000,17000,39,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,46500,14000,17000,30,40,2)
:	let adj5=	RGBEl4(adjBG2,								todaysec,46500,14000,17000,30,40,2)
:	let hC=printf("highlight Constant guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj2,adj4,adj4,adj5)
:	let adj1=	RGBEl5((-todaysec+86400)/338/2+110,					todaysec,50000,27000,29000,2)
:	let adj2=	RGBEl5((-todaysec+86400)/338/2+64,					todaysec,50000,27000,29000,2)
:	let adj3=	RGBEl5((-todaysec+86400)/338/2,						todaysec,50000,27000,29000,2)
:	let hD=printf("highlight Normal guifg=#%02x%02x%02x gui=NONE",				adj1,adj2,adj3)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+58,					todaysec,57000,10000,24000,64,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+127,					todaysec,57000,10000,24000,64,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2,						todaysec,57000,10000,24000,64,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,57000,10000,24000,99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,57000,10000,24000,99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,57000,10000,24000,99,99,2)
:	let hE=printf("highlight Identifier guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6) 
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+100,					todaysec,43000,10000,16000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,43000,10000,16000,40,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+140,					todaysec,43000,10000,16000,40,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,43000,10000,16000,99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,43000,10000,16000,99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,43000,10000,16000,99,99,2)
:	let hF=printf("highlight PreProc guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x",	adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/4+192,					todaysec,60500,14000,19000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/4+100,					todaysec,60500,14000,19000,40,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/4+160,					todaysec,60500,14000,19000,40,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,60500,14000,19000,99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,60500,14000,19000,99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,60500,14000,19000,99,99,2)
:	let hG=printf("highlight Special guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x",	adj1,adj2,adj3,adj4,adj5,adj6) 
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+120,					todaysec,47000,3000,14000,64,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+10,					todaysec,47000,3000,14000,64,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+80,					todaysec,47000,3000,14000,64,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,47000,3000,14000,99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,47000,3000,14000,99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,47000,3000,14000,99,99,2)
:       let hH=printf("highlight Title guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6) 
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+50,					todaysec,56000,12000,29000,80,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+130,					todaysec,56000,12000,29000,80,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,56000,12000,29000,80,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,56000,12000,29000,99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,56000,12000,29000,99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,56000,12000,29000,99,99,2)
:	let hI=printf("highlight Comment guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let hI1=printf("highlight htmlComment guifg=#%02x%02x%02x",				adj1,adj2,adj3)
:	let hI2=printf("highlight htmlCommentPart guifg=#%02x%02x%02x",				adj1,adj2,adj3)
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
:	let adj4=	RGBEl4(adjBG1,								todaysec,44000,10000,26000,99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,44000,10000,26000,99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,44000,10000,26000,99,99,2)
:	let hQ=printf("highlight htmlLink guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+50,					todaysec,44000,10000,26000,40,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+130,					todaysec,44000,10000,26000,40,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,44000,10000,26000,40,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,44000,10000,26000,99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,44000,10000,26000,99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,44000,10000,26000,99,99,2)
:	let hR=printf("highlight htmlComment guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let hR1=printf("highlight htmlCommentPart guifg=#%02x%02x%02x guibg=#%02x%02x%02x",	adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+220,					todaysec,77000,10000,26000,70,2)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+220,					todaysec,77000,10000,26000,70,2)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,77000,10000,26000,70,2)
:	let adj4=	RGBEl4(adjBG1,								todaysec,77000,10000,26000,99,99,2)
:	let adj5=	RGBEl4(adjBG1,								todaysec,77000,10000,26000,99,99,2)
:	let adj6=	RGBEl4(adjBG2,								todaysec,77000,10000,26000,99,99,2)
:	let hS=printf("highlight Question guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let hS1=printf("highlight MoreMsg guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	if todaysec/450!=s:oldactontime/450 || exists("g:mytime")
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
:		execute hS1
:	endif
:	redraw
:	let s:oldhA=hA
:	if todaysec>=69120 || todaysec<=17280
:	echo strftime("%c")
:	endif
:endfunction       

" wrapper function takes handles 'invert' variable, used when causing 'invert' effect
" if you didn't like that effect you could modify this function to always use 0
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

