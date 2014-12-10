//**************************************************************************************************
//
// nppVCLStyles
// Notepad++ Plugin part of the VCL Styles Utils
// http://code.google.com/p/vcl-styles-utils/
//
// The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
// you may not use this file except in compliance with the License. You may obtain a copy of the
// License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
// ANY KIND, either express or implied. See the License for the specific language governing rights
// and limitations under the License.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
//
// Portions created by Rodrigo Ruz V. are Copyright (C) 2014 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************

library nppVCLStyles;

uses
  SysUtils,
  Classes,
  Types,
  Windows,
  Messages,
  nppplugin in 'lib\nppplugin.pas',
  SciSupport in 'lib\SciSupport.pas',
  NppForms in 'lib\NppForms.pas' {NppForm},
  NppDockingForms in 'lib\NppDockingForms.pas' {NppDockingForm},
  uAbout in 'uAbout.pas' {AboutForm},
  DDetours in '..\Common\delphi-detours-library\DDetours.pas',
  InstDecode in '..\Common\delphi-detours-library\InstDecode.pas',
  Vcl.Styles,
  Vcl.Themes,
  Vcl.Dialogs,
  Vcl.Styles.UxTheme in '..\Common\Vcl.Styles.UxTheme.pas',
  Vcl.Styles.Hooks in '..\Common\Vcl.Styles.Hooks.pas',
  Vcl.Styles.Utils.Graphics in '..\Common\Vcl.Styles.Utils.Graphics.pas',
  Vcl.Styles.Utils.ComCtrls in '..\Common\Vcl.Styles.Utils.ComCtrls.pas',
  Vcl.Styles.Utils.Forms in '..\Common\Vcl.Styles.Utils.Forms.pas',
  Vcl.Styles.Utils.Menus in '..\Common\Vcl.Styles.Utils.Menus.pas',
  Vcl.Styles.Utils.ScreenTips in '..\Common\Vcl.Styles.Utils.ScreenTips.pas',
  Vcl.Styles.Utils.StdCtrls in '..\Common\Vcl.Styles.Utils.StdCtrls.pas',
  Vcl.Styles.Utils.SysControls in '..\Common\Vcl.Styles.Utils.SysControls.pas',
  Vcl.Styles.Utils.SysStyleHook in '..\Common\Vcl.Styles.Utils.SysStyleHook.pas',
  Vcl.Styles.Npp in 'Vcl.Styles.Npp.pas',
  Vcl.Styles.Npp.StyleHooks in 'Vcl.Styles.Npp.StyleHooks.pas',
  uMisc in 'uMisc.pas';

{$R *.res}

//TODO
// Add support for MenuBar
// Hook dialogs  OK
// fix Language - > Define your language option - flicker
// fix Settings - > preferences- slow  first time
// fix Settings - > short cut mapper - slow, no themed
// Scintilla border

// When Edit has ES_MULTILINE style use memo like style hook (ex: about window)


// *************Features
// Settings
// edit styles with EQ
// disable skin elements (menu, classes)
// Add options to system menu (VCL Style selection, EQ, etc)
// tab close button
// shortcut manager slow, maybe disable hooking this window and child controls


//Scintilla or TabControl has artifacts on Npp init when not scrollbar is visible OK
//Scintilla Flicker  OK
//Scintilla scrollbar events   OK
//track mouse events       OK
//listbox not themed in preferences and style menu      OK
//docked window (ex: character panel) is not themed
//Switch to XE4  -  OK


//references
//http://www.brotherstone.co.uk/octopress/blog/2012/08/20/top-10-hints-for-writing-a-notepad-plus-plus-plugin/


function BeforeNppHookingControl(Info: PControlInfo): Boolean;
begin
  Exit(True);
end;


procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
                          Npp := TVCLStylesNppPlugin.Create;
                        end;
    DLL_PROCESS_DETACH:
                        begin
                          if (Assigned(Npp)) then Npp.Destroy;
                        end;
  end;
end;

procedure setInfo(NppData: TNppData); cdecl; export;
var
  VClStyleFile : string;
begin
  Npp.SetInfo(NppData);
  //The VCL Style must be load here, because on this point the
  //config path of npp can be retrieved and the npp controls are to shown yet.
  if not StyleServices.Available then exit;
  TSysStyleManager.OnBeforeHookingControl:=@BeforeNppHookingControl;
  TSysStyleManager.RegisterSysStyleHook('NotePad++', TSysDialogStyleHook);
  TSysStyleManager.UnRegisterSysStyleHook('Edit', TSysEditStyleHook);

  VClStyleFile:=Npp.GetVCLStylesNppConfigPath+'Styles\Carbon.vsf';
  if TStyleManager.IsValidStyle(VClStyleFile) then
   TStyleManager.SetStyle(TStyleManager.LoadFromFile(VClStyleFile))
  else
   ShowMessage(Format('The Style File %s is not valid',[VClStyleFile]));
end;

function getName(): nppPchar; cdecl; export;
begin
  Result := Npp.GetName;
end;

function getFuncsArray(var nFuncs:integer):Pointer;cdecl; export;
begin
  Result := Npp.GetFuncsArray(nFuncs);
end;

procedure beNotified(sn: PSCNotification); cdecl; export;
begin
  Npp.BeNotified(sn);
  if (sn^.nmhdr.code = NPPN_READY) then
  begin

  end
  else
  if (sn^.nmhdr.code = NPPN_SHUTDOWN) then
  begin
    TSysStyleManager.Enabled:=False;
    //TStyleManager.SetStyle('Windows');
    //Release VCL Styles
    //Release Hooks - disable syscontrols
  end;
end;

function messageProc(msg: Integer; _wParam: WPARAM; _lParam: LPARAM): LRESULT; cdecl; export;
var
  LMessage:TMessage;
begin
  LMessage.Msg := msg;
  LMessage.WParam := _wParam;
  LMessage.LParam := _lParam;
  LMessage.Result := 0;
  Npp.MessageProc(LMessage);
  Exit(LMessage.Result);
end;

{$IFDEF NPPUNICODE}
function isUnicode : Boolean; cdecl; export;
begin
  Exit(True);
end;
{$ENDIF}

exports
  setInfo, getName, getFuncsArray, beNotified, messageProc;
{$IFDEF NPPUNICODE}
exports
  isUnicode;
{$ENDIF}

begin
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
