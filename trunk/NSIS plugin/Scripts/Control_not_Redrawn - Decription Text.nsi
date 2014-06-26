;NSIS Modern User Interface
;Welcome/Finish Page Example Script
;Written by Joost Verburg

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !addplugindir "..\Win32\Release_ANSI" 
;--------------------------------
;General

  ;Name and file
  Name "Modern UI Test"
  OutFile "WelcomeFinish.exe"

  ;Default installation folder
  InstallDir "$LOCALAPPDATA\Modern UI Test"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\Modern UI Test" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel user

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

Function .oninit

InitPluginsDir
   File /oname=$PLUGINSDIR\gexngin.vsf "..\Styles\MetroBlack.vsf"
   ;Load the skin using the LoadVCLStyle function
   NSISVCLStyles::LoadVCLStyle $PLUGINSDIR\gexngin.vsf 

FunctionEnd   
  
;--------------------------------
;Installer Sections

Section "Dummy Section" SecDummy

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  ;Store installation folder
  WriteRegStr HKCU "Software\Modern UI Test" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section "Dummy Section" SecDummy1

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  ;Store installation folder
  WriteRegStr HKCU "Software\Modern UI Test" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd
Section "Dummy Section" SecDummy2

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  ;Store installation folder
  WriteRegStr HKCU "Software\Modern UI Test" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd
Section "Dummy Section" SecDummy3

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  ;Store installation folder
  WriteRegStr HKCU "Software\Modern UI Test" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd
Section "Dummy Section" SecDummy4

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  ;Store installation folder
  WriteRegStr HKCU "Software\Modern UI Test" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd
Section "Dummy Section" SecDummy5

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  ;Store installation folder
  WriteRegStr HKCU "Software\Modern UI Test" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd
Section "Dummy Section" SecDummy6

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  ;Store installation folder
  WriteRegStr HKCU "Software\Modern UI Test" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd
Section "Dummy Section" SecDummy7

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  ;Store installation folder
  WriteRegStr HKCU "Software\Modern UI Test" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd
Section "Dummy Section" SecDummy8

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  ;Store installation folder
  WriteRegStr HKCU "Software\Modern UI Test" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecDummy ${LANG_ENGLISH} "A test section."
  LangString DESC_SecDummy1 ${LANG_ENGLISH} "A test section."
  LangString DESC_SecDummy2 ${LANG_ENGLISH} "A test section."
  LangString DESC_SecDummy3 ${LANG_ENGLISH} "A test section."
  LangString DESC_SecDummy4 ${LANG_ENGLISH} "A test section."
  LangString DESC_SecDummy5 ${LANG_ENGLISH} "A test section."
  LangString DESC_SecDummy6 ${LANG_ENGLISH} "A test section."
  LangString DESC_SecDummy7 ${LANG_ENGLISH} "A test section."
  LangString DESC_SecDummy8 ${LANG_ENGLISH} "A test section."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy1} $(DESC_SecDummy1)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy2} $(DESC_SecDummy2)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy3} $(DESC_SecDummy3)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy4} $(DESC_SecDummy4)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy5} $(DESC_SecDummy5)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy6} $(DESC_SecDummy6)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy7} $(DESC_SecDummy7)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy8} $(DESC_SecDummy8)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;ADD YOUR OWN FILES HERE...

  Delete "$INSTDIR\Uninstall.exe"

  RMDir "$INSTDIR"

  DeleteRegKey /ifempty HKCU "Software\Modern UI Test"

SectionEnd
