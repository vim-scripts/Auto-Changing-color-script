au CursorHold * call ExtraSetHighLight()
au CursorHoldI * call ExtraSetHighLight() 
au InsertEnter * let g:highLowLightToggle=1 | call ExtraSetHighLight()
au InsertLeave * let g:highLowLightToggle=0 | call ExtraSetHighLight()

