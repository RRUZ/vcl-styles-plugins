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

Function FileRequest
Exch $0 ;title
Exch 4
Exch $R5 ;flag
Exch 3
Exch $R4 ;Save/Open
Exch 2
Exch $2 ;sort type 2
Exch
Exch $1 ;sort type 1
Push $3
Push $4
Push $5 ;type 1 / 1
Push $6 ;tupe 1 / 2
Push $7 ;type 2 / 1
Push $8 ;type 2 / 2
Push $9
Push $R0 ;len 1 / 1
Push $R1 ;len 1 / 2
Push $R2 ;len 2 / 1
Push $R3 ;len 2 / 2
 
StrCmp $R5 "" 0 +2
 StrCpy $R5 0xA01800
 
StrCpy $9 $0 ;title
 
StrCpy $3 0
loop1:
 IntOp $3 $3 - 1
  StrCpy $4 $2 1 $3
 StrCmp $4 "" error
 StrCmp $4 "|" 0 loop1
StrCpy $5 $2 $3
 IntOp $3 $3 + 1
StrCpy $6 $2 "" $3
 
StrCpy $3 0
loop2:
 IntOp $3 $3 - 1
  StrCpy $4 $1 1 $3
 StrCmp $4 "" error
 StrCmp $4 "|" 0 loop2
StrCpy $7 $1 $3
 IntOp $3 $3 + 1
StrCpy $8 $1 "" $3
 
StrLen $R0 $5
 IntOp $R0 $R0 + 1
StrLen $R1 $6
 IntOp $R1 $R1 + 1
StrLen $R2 $7
 IntOp $R2 $R2 + 1
StrLen $R3 $8
 IntOp $R3 $R3 + 1
 
 StrCpy $4 '(&l4, i, i 0, i, i 0, i 0, i 0, t, i ${NSIS_MAX_STRLEN}, t, i ${NSIS_MAX_STRLEN}, t, t, i, &i2, &i2, t, i 0, i 0, i 0) i'
 
 System::Call '*(&t$R0 "$5" , &t$R1 "$6", &t$R2 "$7", &t$R3 "$8", &i1 0) i.r0'
 
 System::Call '*$4(, $HWNDPARENT,, r0,,,,"",,"",, i 0, "$9", $R5,,,,,,) .r1'
 
 System::Call 'comdlg32::Get$R4FileNameA(i r1) i .r2'
 System::Call '*$1$4(,,,,,,,.r3)'
 System::Free $1
 System::Free $0
 
StrCmp $2 0 0 +2
error:
 StrCpy $3 error
StrCpy $0 $3
 
Pop $R3
Pop $R2
Pop $R1
Pop $R0
Pop $9
Pop $8
Pop $7
Pop $6
Pop $5
Pop $4
Pop $3
Pop $1
Pop $2
Pop $R4
Pop $R5
Exch $0
FunctionEnd

Function Random

	;nsDialogs::SelectFileDialog open "" "All Images|*.jpg;*.jpeg;*.png;*.bmp;*.tiff|JPEG Files|*.jpg;*.jpeg|PNG Files|*.png|BMP Files|*.bmp|TIFF|*.tiff"
	;Pop $0
;Push "0xA01800" ;flags (see below) separated by commas [,] ;OFN_EXPLORER 0x00080000 
Push "0x00000020"
Push "Open" ;use "Open" or "Save" - CaSe sensitive!
Push "Zip Files (*.zip)|*.zip" ;file type 1
Push "All Files (*.*)|*.*" ;file type 2
Push "Select Zip file to install" ;dialog title
 Call FileRequest
Pop $R0	

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
