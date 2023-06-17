;	*** environment configuration ***
;	#Requires AutoHotkey >=2.0+			;	Defines script as a v2 script
;	Persistent							;	for use with AHK version 2
#Requires AutoHotkey v1.1.33+ <2.0		;	Defines script as a v1 script
#Persistent								;	for use with AHK version 1
#NoEnv									;	this is automatic in AHK version 2
#SingleInstance Force
;	SetWorkingDir, %A_ScriptDir%
;	DetectHiddenWindows, On
;	SetTitleMatchMode, 2
;	SetBatchLines -1
;	#NoTrayIcon
;	#Warn All, OutputDebug

v_SelectionArray	:= []
v_FilesAvailable	:= "File 1|File 2|File 3|File 4|File 5|File 6|File 7"
v_MaxFilesAvailable := 0
Loop, Parse, v_FilesAvailable, |
		++v_MaxFilesAvailable		; when this loop is finished, variable should equal '7' in this instance

; ------------------------------------------------------------------------------

Gui, New
Gui, +AlwaysOnTop
Gui, Add, GroupBox,	 x20	 y20	w200	h215,										Select Files
Gui, Add, Radio,	 x30	 y40	 w50	 h20		gCheckSelection vSelectionMode,	all
Gui, Add, Radio,	 x90	 y40	 w50	 h20		gCheckSelection Checked,		none
Gui, Add, Radio,	x150	 y40	 w50	 h20		gCheckSelection,				invert
Gui, Add, ListBox,	 x30	 y70	w180	h155	8 	gFilesSelected 	vIsSelected,	%v_FilesAvailable%
Gui, Add, Button,	 x30	y240	 w45	 h25		gCancelGui,						Cancel
Gui, Add, Button,	x165	y240	 w45	 h25		gOpenSelectedFiles,				OPEN

Gui, Add, StatusBar,, 0 items selected !!
; SB_SetIcon("_icons_\CheckBox0234_128x.ico", 1)

Gui, Show, 					        w250    h300,										* FILES *

Return

; ------------------------------------------------------------------------------

FilesSelected:
	Gui, Submit, NoHide
	v_HowManyAreSelected := 0
	Loop, Parse, IsSelected, |
		{
			++v_HowManyAreSelected
		}
	SB_SetText("  " . v_HowManyAreSelected . " items selected !!")
Return

; ------------------------------------------------------------------------------

CheckSelection:
	Gui, Submit, NoHide
	If (SelectionMode = 1)									; select ALL
		{
			Loop, %v_MaxFilesAvailable%
				{
					GuiControl, Choose, ListBox1, %A_Index%	; select ALL by looping through 'list'
				}
;			PostMessage, 0x0185, 1, -1, ListBox1, A			; select ALL
			SB_SetText(v_MaxFilesAvailable . " items selected !!")
		}

	If (SelectionMode = 2)									; select NONE
		{
			GuiControl, Choose, ListBox1, 0					; select NONE
;			PostMessage, 0x0185, 0, -1, ListBox1, A			; select NONE
			SB_SetText("0 items selected !!")
		}

	If (SelectionMode = 3)									; INVERT selection
		{
			Gui, Submit, NoHide
			v_HowManyAreSelected := 0
			v_SelectionArray := StrSplit(IsSelected, "|")
			Loop, Parse, v_MaxFilesAvailable, |
				{
					If (v_SelectionArray[A_Index] = A_LoopField)	; this comparison is never 'true'
						{
;							if checked, then UNcheck it in the ListBox
							--v_HowManyAreSelected		; ??? I've no clue if this syntax would work opposite of '++'.
						} Else {
;							if UNchecked, then check it in the ListBox
							++v_HowManyAreSelected
						}
				}
			SB_SetText(v_HowManyAreSelected . " items selected !!")
		}
	Gui, Submit, NoHide
Return

; ------------------------------------------------------------------------------

OpenSelectedFiles:
	Gui, Submit, NoHide
	Loop, Parse, IsSelected, |
		Run, Notepad.exe %A_LoopField%
Return

; ------------------------------------------------------------------------------

F2::Reload				; for testing purposes only
Escape::				; numerous ways to exit this script...
GuiFilesGuiClose:
CancelGui:
	Gui, Destroy
	ExitApp
Return
