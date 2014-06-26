!include MUI.nsh
!include LogicLib.nsh
!include nsDialogs.nsh
!include WinMessages.nsh
!include FileFunc.nsh
!addplugindir "..\Win32\Release_ANSI" 
Var hCtl_temp
Var hCtl_temp_ListBox2
Var hCtl_temp_ListBox1
Var hCtl_temp_DropList1
Var hCtl_temp_Label34
Var hCtl_temp_Label3
Var hCtl_temp_Label2
Var hCtl_temp_Label1


Name "nsDialogs Welcome"
OutFile "ListBox_Background_Control_Issue.exe"


BrandingText "Background Issue persists with - ListBox, DropBox and stuff"

Page custom fnc_temp_Show

!insertmacro MUI_LANGUAGE English

Function .onInit

	InitPluginsDir
	File /oname=$PLUGINSDIR\welcome.bmp "${NSISDIR}\Contrib\Graphics\Wizard\orange-nsis.bmp"
    File /oname=$PLUGINSDIR\MetroBlack.vsf "..\..\Styles\MetroBlack.vsf"
    NSISVCLStyles::LoadVCLStyle $PLUGINSDIR\MetroBlack.vsf 
FunctionEnd

; dialog create function
Function fnc_temp_Create
  
  ; === temp (type: Dialog) ===
  nsDialogs::Create 1018
  Pop $hCtl_temp
  ${If} $hCtl_temp == error
    Abort
  ${EndIf}
  !insertmacro MUI_HEADER_TEXT "Dialog title..." "Dialog subtitle..."
  
  ; === ListBox2 (type: ListBox) ===
  ${NSD_CreateListBox} 102u 12u 74u 90u "RODRIGO"
  Pop $hCtl_temp_ListBox2
  ${NSD_LB_AddString} $hCtl_temp_ListBox2 "AAAA"
  ${NSD_LB_AddString} $hCtl_temp_ListBox2 "22"
  ${NSD_LB_AddString} $hCtl_temp_ListBox2 "XYZ"
  ${NSD_LB_AddString} $hCtl_temp_ListBox2 "12334"
  ${NSD_LB_AddString} $hCtl_temp_ListBox2 "HELLO"
  ${NSD_LB_AddString} $hCtl_temp_ListBox2 "RODRIGO"
  ${NSD_LB_SelectString} $hCtl_temp_ListBox2 "RODRIGO"
  
  ; === ListBox1 (type: ListBox) ===
  ${NSD_CreateListBox} 16u 12u 74u 90u "HELLO"
  Pop $hCtl_temp_ListBox1
  ${NSD_LB_AddString} $hCtl_temp_ListBox1 "AAAA"
  ${NSD_LB_AddString} $hCtl_temp_ListBox1 "22"
  ${NSD_LB_AddString} $hCtl_temp_ListBox1 "XYZ"
  ${NSD_LB_AddString} $hCtl_temp_ListBox1 "12334"
  ${NSD_LB_AddString} $hCtl_temp_ListBox1 "HELLO"
  ${NSD_LB_AddString} $hCtl_temp_ListBox1 "RODRIGO"
  ${NSD_LB_SelectString} $hCtl_temp_ListBox1 "HELLO"
  
  ; === DropList1 (type: DropList) ===
  ${NSD_CreateDropList} 180u 20u 79u 12u "AAAA"
  Pop $hCtl_temp_DropList1
  ${NSD_CB_AddString} $hCtl_temp_DropList1 "AAAA"
  ${NSD_CB_AddString} $hCtl_temp_DropList1 "22"
  ${NSD_CB_AddString} $hCtl_temp_DropList1 "XYZ"
  ${NSD_CB_AddString} $hCtl_temp_DropList1 "12334"
  ${NSD_CB_AddString} $hCtl_temp_DropList1 "HELLO"
  ${NSD_CB_AddString} $hCtl_temp_DropList1 "RODRIGO"
  ${NSD_CB_SelectString} $hCtl_temp_DropList1 "AAAA"
  
  ; === Label3 (type: Label) ===
  ${NSD_CreateLabel} 180u 12u 39u 7u "DropList"
  Pop $hCtl_temp_Label3
  
   ${NSD_CreateLabel} 180u 60u 100u 70u "Please have a look MetroBlack/any control BG on VclSkinTester."
  Pop $hCtl_temp_Label34 
  
  ; === Label2 (type: Label) ===
  ${NSD_CreateLabel} 102u 110u 66u 13u "ListBox 2"
  Pop $hCtl_temp_Label2
  
  ; === Label1 (type: Label) ===
  ${NSD_CreateLabel} 16u 110u 66u 13u "ListBox 1"
  Pop $hCtl_temp_Label1
  
FunctionEnd


; dialog show function
Function fnc_temp_Show
  Call fnc_temp_Create
  nsDialogs::Show $hCtl_temp
FunctionEnd

Section
SectionEnd
