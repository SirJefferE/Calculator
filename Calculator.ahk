#NoTrayIcon
numStr := ""
numBackup := ""
numTotal := 0
numFloat := 0.0
flickerArray := []
SetWorkingDir, %A_ScriptDir%/Images
Menu, Tray, Icon, icon.ico

SetFormat, Float, 0.16
Gui, -Caption


;-------------Pictures-----------

Gui, Add, Picture, x0 y0, calcblank.png
Gui, Add, Picture, x20 y1 gtitleBar, title.png
Gui, Add, Picture, x242 y1 gbuttonDownsize, buttonDownsize.png
Gui, Add, Picture, x7 y79 gbuttonClear, buttonClear.png
Gui, Add, Picture, x61 y79 gbuttonCE, buttonCE.png
Gui, Add, Picture, x115 y79 gbuttonBack, buttonBack.png
Gui, Add, Picture, x7 y111 gbuttonMC, buttonMC.png
Gui, Add, Picture, x49 y111 gbutton7, button7.png
Gui, Add, Picture, x91 y111 gbutton8, button8.png
Gui, Add, Picture, x133 y111 gbutton9, button9.png
Gui, Add, Picture, x175 y111 gbuttonDiv, buttondiv.png
Gui, Add, Picture, x217 y111 gbuttonSqrt, buttonsqrt.png
Gui, Add, Picture, x7 y147 gbuttonMR, buttonMR.png
Gui, Add, Picture, x49 y147 gbutton4, button4.png
Gui, Add, Picture, x91 y147 gbutton5, button5.png
Gui, Add, Picture, x133 y147 gbutton6, button6.png
Gui, Add, Picture, x175 y147 gbuttonMult, buttonMult.png
Gui, Add, Picture, x217 y147 gbuttonPerc, buttonPerc.png
Gui, Add, Picture, x7 y183 gbuttonMS, buttonMS.png
Gui, Add, Picture, x49 y183 gbutton1, button1.png
Gui, Add, Picture, x91 y183 gbutton2, button2.png
Gui, Add, Picture, x133 y183 gbutton3, button3.png
Gui, Add, Picture, x175 y183 gbuttonSub, buttonSub.png
Gui, Add, Picture, x217 y183 gbuttonRecip, buttonRecip.png
Gui, Add, Picture, x7 y219 gbuttonMPlus, buttonMPlus.png
Gui, Add, Picture, x49 y219 gbutton0, button0.png
Gui, Add, Picture, x91 y219 gbuttonInvert, buttonInvert.png
Gui, Add, Picture, x133 y219 gbuttonPoint, buttonPoint.png
Gui, Add, Picture, x175 y219 gbuttonAdd, buttonAdd.png
Gui, Add, Picture, x217 y219 gbuttonEquals, buttonEquals.png

;----------------Other------------------
Gui, Color, White, White
Gui, Font, W1500 Q0 s11, MS Sans Serif
Gui, Add, Text, Right x53 y51 w185 vmainText, 0.
Gui, Add, Text, x205 y87 vmemSaved,
Gui, Show, w261 h269, Calculator
WinWaitActive, Calculator
calcID := WinActive("Calculator")
GroupAdd, calcID, ahk_id %calcID%
;SetTimer, test, 10

F1::Reload

;-----------functions--------

numDisplay(num)
{
    if (num = "")
        num = 0
    if num is integer
        num .= "."
    else if num is float
       num := RegExReplace(num, "\.\d+?\K0+$", "")
    GuiControl, Text, mainText, % num
}

funcButton(symb)
{
    global
    if (thisOperation)
    {
        if (numStr)
            gosub buttonEquals
        else
            Return
    }
    if (lastOperation)
    {
        lastOperation := ""
        lastNum := ""
        thisOperation := ""
    }
    thisOperation := symb
    numBackup := numStr
    numStr := ""
Return
}


;-----------labels----------


test:
tooltip STR %numStr% and BACKUP %numBackup%
Return

mouseCheck:
mouseGetPos, mPosX, mPosY
if (mPosX >= 241 and mPosX <= 259 and mPosY >= 1 and mPosY <= 19)
{
    if (!mToggle)
    {
        GuiControl,, buttonDownsize, buttonDownsize2.png
        mToggle := 1
    }
}
else
    if (mToggle)
    {
        GuiControl,, buttonDownsize, buttonDownsize.png
        mToggle := 0
    }
Return

buttonDownsize:
setTimer, mouseCheck, 20
minimiseCheck := 1
Return

titleBar:
CoordMode Mouse
mouseGetPos mPosX, mPosY
winGetPos, winX, winY,,A
mOffsetX := mPosX - winX
mOffsetY := mPosY - winY
Loop
{
    if (!GetKeyState("LButton", P))
        break
    mouseGetPos mPosX, mPosY
    WinMove, mPosX-mOffsetX, mPosY-mOffsetY
    sleep 50
}
Return

;----------------BLUE BUTTONS-------------------

button0:
button1:
button2:
button3:
button4:
button5:
button6:
button7:
button8:
button9:
thisNum := "" SubStr(A_ThisLabel, 0)
buttonNumber:
GuiControl,, % "button" thisNum, buttonPressed.png
if (lastOperation)
    gosub buttonClear
numStr .= thisNum
numDisplay(numStr)
sleep 20
GuiControl,, % "button" thisNum, % "button" thisNum ".png"
Return

buttonInvert:
Return

buttonPoint:
if (inStr(numStr, "."))
    Return
thisNum := "."
goto buttonNumber
Return

;-----------------RED BUTTONS-------------------

buttonClear:
lastOperation := ""
lastNum := ""
numStr := ""
numBackup := ""
numToggle := 0
numDisplay("0")
Return

buttonCE:
numStr := ""
numDisplay(0)
Return
buttonBack:
numStr := SubStr(numStr, 1, -1)
numDisplay(numStr)
Return

buttonAdd:
funcButton("add")
Return

buttonSub:
funcButton("sub")
Return

buttonMult:
funcButton("mult")
Return

numpadDiv::
buttonDiv:
funcButton("div")
Return

buttonEquals:
if (lastOperation and lastOperation != "tealButton")
{
    thisOperation := lastOperation
    numStr := lastNum
}
lastNum := numStr
if (inStr(numStr, ".") or inStr(numBackup, "."))
    myDec := StrLen(RegExReplace(numStr, ".*?\.", "")) >= StrLen(RegExReplace(numBackup, ".*?\.", "")) ? StrLen(RegExReplace(numStr, ".*?\.", "")) : StrLen(RegExReplace(numBackup, ".*?\.", ""))
Switch thisOperation
{
    case "add":
        numBackup := numBackup + numStr
        if numBackup is float
            numBackup := format("{:.11f}", numBackup)
    case "sub":
        numBackup := numBackup - numStr
        if numBackup is float
            numBackup := format("{:.11f}", numBackup)
    case "mult":
        numBackup := numBackup * numStr
        if numBackup is float
            numBackup := format("{:.11f}", numBackup)
    case "div":
        numBackup := numBackup / numStr
        if numBackup is float
            numBackup := format("{:.11f}", numBackup)
    Default:
        numBackup := numStr
        thisOperation := "Reset"
}
lastOperation := thisOperation
numStr := numBackup
thisOperation := ""
numDisplay(numStr)
Return


;---------------PURPLE BUTTONS-------------------

buttonMC:
numMemory := ""
guiControl, Text, memSaved,
Return
buttonMR:
numStr := numMemory
if (numStr)
    numDisplay(numStr)
else
    numDisplay(0)
Return
buttonMS:
numMemory := numStr
if (numMemory + 0)
    guiControl, Text, memSaved, M
Return

buttonMPlus:
numMemory += numStr
if (numMemory + 0)
    guiControl, Text, memSaved, M
Return

;-------------Teal buttons--------------

buttonSqrt:
numStr := Round(Sqrt(numStr), 12)
numDisplay(numStr)

Return

buttonPerc:
if (!numBackup)
{
    numStr := ""
    numDisplay (0)
}
else
{
    numStr := numBackup * (numStr/100)
    numDisplay(numStr)
    lastOperation := "tealButton"
}
Return

buttonRecip:
    numStr := 1/numStr
    numDisplay(numStr)
    lastOperation := "tealButton"
Return



;------------------Hotkeys----------------
#ifWinActive ahk_group calcID

^l::goto buttonMC
^r::goto buttonMR
^m::goto buttonMS
^p::goto buttonMPlus
numpadDot::goto buttonPoint
numpadAdd::goto buttonAdd
numpadSub::goto buttonSub
+8::goto numpadMult
numpadMult::goto numpadMult
/::goto numpadDiv
numpadEnter::goto buttonEquals
Enter::goto buttonEquals
BackSpace::goto buttonBack
+2::goto buttonSqrt

1::
2::
3::
4::
5::
6::
7::
8::
9::
0::
Numpad1::
Numpad2::
Numpad3::
Numpad4::
Numpad5::
Numpad6::
Numpad7::
Numpad8::
Numpad9::
Numpad0::
thisNum := "" SubStr(A_ThisHotkey, 0)
goto buttonNumber
Return



GuiClose:
ExitApp
Return
Escape::ExitApp

#if (minimiseCheck)
Lbutton Up::
minimiseCheck := 0
setTimer, mouseCheck, Off
if (mToggle)
{
    GuiControl,, buttonDownsize, buttonDownsize.png
    mToggle := 0
    WinMinimize, A
}
Return
#if