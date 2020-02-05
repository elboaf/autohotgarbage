; this script attempts to mimic i3wm/unity (linux) in windows
; w/ some additional functionality specific to my workflow 
; unfortunately, some parameters are specific to my monitor resolution and may not work for you.

SetWinDelay,2
CoordMode,Mouse, Screen
return

; shift + alt + C - Close active window (sends Alt+F4)
+!c::
Send, !{F4}
return

; Alt + Leftclick + Drag - Move window. Maximized windows will return to maximized state after dragging and dropping
!LButton::
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinActivate, ahk_id %KDE_id%
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
if KDE_Win = 1
WinRestore, ahk_id %KDE_id%

WinGetPos,KDE_WinX1,KDE_WinY1,,,ahk_id %KDE_id%
Loop
{
    GetKeyState,KDE_Button,LButton,P ; Break if button has been released.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
    KDE_Y2 -= KDE_Y1
    KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
    KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
    WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Move the window to the new position.
}
return

!LButton up::
if KDE_Win = 1
WinMaximize, ahk_id %KDE_id%
return


; Alt + Rightclick + Drag - Resize a window. Maximized windows will become un-maximized.
!RButton::
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
WinActivate, ahk_id %KDE_id%
if KDE_Win = 1
WinRestore, ahk_id %KDE_id%
WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
   KDE_WinLeft := 1
Else
   KDE_WinLeft := -1
If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
   KDE_WinUp := 1
Else
   KDE_WinUp := -1
Loop
{
    GetKeyState,KDE_Button,RButton,P ; Break if button has been released.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
    WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
    KDE_Y2 -= KDE_Y1
    WinMove,ahk_id %KDE_id%,, KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X of resized window
                            , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y of resized window
                            , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W of resized window
                            , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H of resized window
    KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
    KDE_Y1 := (KDE_Y2 + KDE_Y1)
}
return

; Alt + Up arrow - Window under mouse curson will be sent to the back of z-index (same as Alt + Down arrow and Alt + Middle Click)
!Up::
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
Send, !{Esc}
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
return

; Alt + Down arrow - Window under mouse curson will be sent to the back of z-index (same as Alt + Up arrow and Alt + Middle Click)
!Down::
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
Send, !{Esc}
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
return

; Alt + T - Window under mouse curson will be sent to the back of z-index (same as Alt + Down arrow and Alt + Middle Click)
!t::
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
Send, !{Esc}
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
return

; Alt + N - Window under mouse curson will be sent to the back of z-index (same as Alt + Up arrow and Alt + Middle Click)
!n::
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
Send, !{Esc}
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
return


; Shift + Alt + Up arrow - Maximize focused window (Sends Super+Up)
!+Up::
Send, #{Up}
return

; Shift + Alt + Down arrow - Restore/Minimize focused window (If maximized then "restore" (un-maximize), if un-maximized then minimize) (Sends Super+Down)
!+Down::
Send, #{Down}
return


; Shift + Alt + N arrow - Maximize focused window (Sends Super+Up)
!+n::
Send, #{Up}
return

; Shift + Alt + T arrow - Restore/Minimize focused window (If maximized then "restore" (un-maximize), if un-maximized then minimize) (Sends Super+Down)
!+t::
Send, #{Down}
return


; Shift + Alt + Right - Moves window under mouse cursor to the screen to the right. Moves mouse cursor with it 
; (relies on hardcoded coordinate values specific to my workstation/monitor configuration)
!+Right::
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
MouseGetPos,posY
Sleep,10
If (posY <= -1)
MouseMove, 2210, 1250, 0
If (posY <= 4790 && posY >=0)
MouseMove, 6983, 1250, 0
Send, #+{Right}
return

; Shift + Alt + Left - Moves window under mouse cursor to the screen to the left. Moves mouse cursor with it 
; (relies on hardcoded coordinate values specific to my workstation/monitor configuration)
!+Left::
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
MouseGetPos,posY
Sleep,10
If (posY >= 0 && posY <=4790)
MouseMove, -1317, 1250, 0
If (posY >= 4790)
MouseMove, 2210, 1250, 0
Send, #+{Left}
return

; Shift + Alt + Right - Moves window under mouse cursor to the screen to the right. Moves mouse cursor with it 
; (relies on hardcoded coordinate values specific to my workstation/monitor configuration)
!+s::
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
MouseGetPos,posY
Sleep,10
If (posY <= -1)
MouseMove, 2210, 1250, 0
If (posY <= 4790 && posY >=0)
MouseMove, 6983, 1250, 0
Send, #+{Right}
return

; Shift + Alt + Left - Moves window under mouse cursor to the screen to the left. Moves mouse cursor with it 
; (relies on hardcoded coordinate values specific to my workstation/monitor configuration)
!+h::
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
MouseGetPos,posY
Sleep,10
If (posY >= 0 && posY <=4790)
MouseMove, -1317, 1250, 0
If (posY >= 4790)
MouseMove, 2210, 1250, 0
Send, #+{Left}
return



; Alt + Left - Moves cursor to the screen to the left. Focuses the window that the mouse lands on.
; (relies on hardcoded coordinate values specific to my workstation/monitor configuration)
!Left::
MouseGetPos,posY
Sleep,10

If (posY >= 0 && posY <=4790)
MouseMove, -1317, 1250, 0
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%

If (posY >= 4790)
MouseMove, 2210, 1250, 0
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%

Return

; Alt + Right - Moves cursor to the screen to the right. Focuses the window that the mouse lands on.
; (relies on hardcoded coordinate values specific to my workstation/monitor configuration)
!Right::
MouseGetPos,posY
Sleep,10

If (posY <= -1)
MouseMove, 2210, 1250, 0
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%

If (posY <= 4790 && posY >=0)
MouseMove, 6983, 1250, 0
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%

Return


; Alt + H - Moves cursor to the screen to the left. Focuses the window that the mouse lands on.
; (relies on hardcoded coordinate values specific to my workstation/monitor configuration)
!h::
MouseGetPos,posY
Sleep,10

If (posY >= 0 && posY <=4790)
MouseMove, -1317, 1250, 0
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%

If (posY >= 4790)
MouseMove, 2210, 1250, 0
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%

Return

; Alt + S - Moves cursor to the screen to the right. Focuses the window that the mouse lands on.
; (relies on hardcoded coordinate values specific to my workstation/monitor configuration)
!s::
MouseGetPos,posY
Sleep,10

If (posY <= -1)
MouseMove, 2210, 1250, 0
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%

If (posY <= 4790 && posY >=0)
MouseMove, 6983, 1250, 0
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%

Return



; Alt + Wheel Down - Sends Ctrl + Tab (Cycles through tabs in firefox/chrome/sublimetext etc)
!WheelDown::
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
WinActivate, ahk_id %KDE_id%
Send, ^{Tab}
return

; Alt + Wheel Up - Sends Ctrl + Shift + Tab (Cycles (reverse order) through tabs in firefox/chrome/sublimetext etc)
!WheelUp::
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
WinActivate, ahk_id %KDE_id%
Send, ^+{Tab}
return

; Shift + Wheel Up - Sends "Home" keypress
+WheelUp::
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
WinActivate, ahk_id %KDE_id%
Send, {Home}
return

; Shift + Wheel Up - Sends "End" keypress
+WheelDown::
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
WinActivate, ahk_id %KDE_id%
Send, {End}
return

; Shift + Alt + Enter - opens siteconfig to the directory of a specific service request.
; Usage: copy a service request number to your clip board and then press Alt + Enter.
!+enter::
Run, open \\se3cdpcdsfs\Global\%Clipboard%
return

; Alt + Enter - opens siteconfig to the directory of a specific service request.
; Usage: copy a service request number to your clip board and then press Alt + Enter.
!enter::
Run, C:\Users\wahl\Downloads\cmder\Cmder.exe
return


; Ctrl + Alt + C - quick close a service request. 
; (relies on hardcoded coordinate values specific to my screen resolution and browser)
^!c::
Send, {Home}
Sleep, 500 ;UNRS
MouseClick, Left, 3310, 448, 1
Sleep, 500 ;UNRS
MouseClick, Left, 1408, 930, 1
Sleep, 500 ;UNRS
MouseClick, Left, 1343, 1078, 1
Sleep, 500 ;UNRS
MouseClick, Left, 3880, 1183, 1
Sleep, 500 ;UNRS
Send,func{Enter}
Sleep, 500 ;SpecialSleep
MouseClick, Left, 3868, 1263, 1
Sleep, 500 ;UNRS
Send,informational{Space}/{Space}tech{Enter}
return

; Middle Click - Paste (sends Ctrl + V after moving cursor to mouse-pointer location)
~MButton::
 	Send, {Click}
  	Send, ^v
return

; Alt + Middle Click - Window under mouse curson will be sent to the back of z-index (same as Alt + Up arrow and Alt + Down arrow)
!MButton::
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
Send, !{Esc}
MouseGetPos,,, WinUMID
WinActivate, ahk_id %WinUMID%
return


; Copy on doubleclick. 
; Copy on triple click 
; Copy text which is selected by clicking and dragging.
~LButton:: 

MouseGetPos x0, y0
   Loop
   {
     Sleep 20
     GetKeyState keystate, LButton
     IfEqual keystate, U, {
       MouseGetPos x, y
       break
     }
   }
   if (x-x0 > 5 or x-x0 < -5 or y-y0 > 5 or y-y0 < -5)
   {                             
      Send ^c
   }


 if (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < DllCall("GetDoubleClickTime"))            
      Sleep 20
      Send ^c

 if (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < DllCall("GetDoubleClickTime"))
 doubleclick := true

return

#If doubleclick
  ~LButton::
  doubleclick := false
  if (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < DllCall("GetDoubleClickTime"))
  {
      Send, ^c
  }
  return

#If
;Esc::ExitApp
return
