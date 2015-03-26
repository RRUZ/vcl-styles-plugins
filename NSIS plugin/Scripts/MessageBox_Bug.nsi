!include "Sections.nsh"
!addplugindir "..\Win32\Release_ANSI" 

;--------------------------------

Name "MessageBox"
OutFile "MessageBox.exe"
RequestExecutionLevel user


; Sections

Function .onInit

	InitPluginsDir
    File /oname=$PLUGINSDIR\Amakrits.vsf "..\Styles\Amakrits.vsf"
	NSISVCLStyles::LoadVCLStyle $PLUGINSDIR\Amakrits.vsf

FunctionEnd

Section !Required
MessageBox MB_OK "Hi there!"
SectionEnd