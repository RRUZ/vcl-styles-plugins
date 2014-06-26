!include MUI.nsh
!include LogicLib.nsh
!include nsDialogs.nsh
!include WinMessages.nsh
!include FileFunc.nsh
  !addplugindir "..\Win32\Release_ANSI" 

; handle variables
Var hCtl_temp2
Var hCtl_temp2_Label1
Var hCtl_temp2_Button1
Var hCtl_temp2_Button3
Var hCtl_temp2_Button2
Var hCtl_temp2_TextBox1




Name "nsDialogs Welcome"
OutFile "ControlsNotRedrawing.exe"


BrandingText "Background Issue persists with - ListBox, DropBox and stuff"

Page custom fnc_temp2_Show

!insertmacro MUI_LANGUAGE English

Function .onInit

	InitPluginsDir
	File /oname=$PLUGINSDIR\welcome.bmp "${NSISDIR}\Contrib\Graphics\Wizard\orange-nsis.bmp"

	;Get the skin file to use
   File /oname=$PLUGINSDIR\AmethystKamri.vsf "..\Styles\MetroBlack.vsf"
   ;Load the skin using the LoadVCLStyle function
   NSISVCLStyles::LoadVCLStyle $PLUGINSDIR\AmethystKamri.vsf 
FunctionEnd


; dialog create function
Function fnc_temp2_Create
  
  ; === temp2 (type: Dialog) ===
  nsDialogs::Create 1018
  Pop $hCtl_temp2
  ${If} $hCtl_temp2 == error
    Abort
  ${EndIf}
  !insertmacro MUI_HEADER_TEXT "Dialog title..." "Dialog subtitle..."
  
  ; === Label1 (type: Label) ===
  ${NSD_CreateLabel} 14u 24u 152u 12u "Some Text Waiting to be Changed (Click ->)"
  Pop $hCtl_temp2_Label1
  
  ; === Button1 (type: Button) ===
  ${NSD_CreateButton} 183u 21u 73u 13u "Click2Change"
  Pop $hCtl_temp2_Button1
  ${NSD_OnClick} $hCtl_temp2_Button1 LabelUP
  
  ; === Button2 (type: Button) ===
  ${NSD_CreateButton} 183u 66u 73u 13u "Click2Change"
  Pop $hCtl_temp2_Button2
  ${NSD_OnClick} $hCtl_temp2_Button2 TextBoxUP
  
   ; === Button2 (type: Button) ===
  ${NSD_CreateButton} 120u 100u 150u 13u "Open a SelectFileDialog (Redraws)"
  Pop $hCtl_temp2_Button3
  ${NSD_OnClick} $hCtl_temp2_Button3 Random
  
  ; === TextBox1 (type: Text) ===
  ${NSD_CreateText} 14u 68u 152u 11u "Some Text in TextBox "
  Pop $hCtl_temp2_TextBox1
  
FunctionEnd


Function Random

	nsDialogs::SelectFileDialog open "" "All Images|*.jpg;*.jpeg;*.png;*.bmp;*.tiff|JPEG Files|*.jpg;*.jpeg|PNG Files|*.png|BMP Files|*.bmp|TIFF|*.tiff"
	Pop $0

FunctionEnd

Function LabelUP

	SendMessage $hCtl_temp2_Label1 ${WM_SETTEXT} 0 "STR:Some Dummy Text has been inserted..........."

FunctionEnd

Function TextBoxUP

	${NSD_SetText} $hCtl_temp2_TextBox1 "This seems to work though" 

FunctionEnd


; dialog show function
Function fnc_temp2_Show
  Call fnc_temp2_Create
  nsDialogs::Show $hCtl_temp2
FunctionEnd

Section
SectionEnd
