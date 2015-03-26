!include nsDialogs.nsh
!include FileFunc.nsh
!addplugindir "..\Win32\Release_ANSI" 

Page Custom MyPageCreate MyPageLeave
Page instfiles
Var PhpPath

Function MyPageLeave
${NSD_GetText} $PhpPath $0
${GetFileName} $0 $1
${IfNot} ${FileExists} $0
${OrIf} $1 != "php.exe"
    MessageBox mb_iconstop "You must locate php.exe to continue!"
    Abort
${Else}
    #php path is in $0, do something with it...
${EndIf}
FunctionEnd

Function MyPageComDlgSelectPHP
Pop $0
${NSD_GetText} $PhpPath $0
nsDialogs::SelectFileDialog open $0 "php.exe|php.exe"
Pop $0
${If} $0 != ""
    ${NSD_SetText} $PhpPath $0
${EndIf}
FunctionEnd

Function MyPageCreate
nsDialogs::Create 1018
Pop $0

${NSD_CreateText} 0 5u -25u 13u "$ProgramFiles\PHP\php.exe"
Pop $PhpPath

${NSD_CreateBrowseButton} -23u 4u 20u 15u "..."
Pop $0
${NSD_OnClick} $0 MyPageComDlgSelectPHP

nsDialogs::Show

FunctionEnd


Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File example1.nsi
SectionEnd ; end the section

Function .onInit
   InitPluginsDir
   ;Get the skin file to use
   File /oname=$PLUGINSDIR\Amakrits.vsf "..\Styles\Amakrits.vsf"
   ;Load the skin using the LoadVCLStyleA function
   NSISVCLStyles::LoadVCLStyle $PLUGINSDIR\Amakrits.vsf  
FunctionEnd