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
  uAbout in 'uAbout.pas',
  Vcl.Styles,
  Vcl.Themes,
  Vcl.Dialogs,
  KOLDetours in '..\Common\KOLDetours.pas',
  Vcl.Styles.Hooks in '..\Common\Vcl.Styles.Hooks.pas',
  Vcl.Styles.Utils.ComCtrls in '..\Common\Vcl.Styles.Utils.ComCtrls.pas',
  Vcl.Styles.Utils.Forms in '..\Common\Vcl.Styles.Utils.Forms.pas',
  Vcl.Styles.Utils.Menus in '..\Common\Vcl.Styles.Utils.Menus.pas',
  Vcl.Styles.Utils.ScreenTips in '..\Common\Vcl.Styles.Utils.ScreenTips.pas',
  Vcl.Styles.Utils.StdCtrls in '..\Common\Vcl.Styles.Utils.StdCtrls.pas',
  Vcl.Styles.Utils.SysControls in '..\Common\Vcl.Styles.Utils.SysControls.pas',
  Vcl.Styles.Utils.SysStyleHook in '..\Common\Vcl.Styles.Utils.SysStyleHook.pas',
  Vcl.Styles.Npp in 'Vcl.Styles.Npp.pas',
  Vcl.Styles.Npp.StyleHooks in 'Vcl.Styles.Npp.StyleHooks.pas';

{$R *.res}

//TODO
//Scintilla or TabControl has artifacts on Npp init when not scrollbar is visible
//Scintilla Flicker
//Scintilla scrollbar events
//track mouse events
//tab close button
//listbox not themed in preferences and style menu      OK
//docked window (ex: character panel) is not themed
//shortcut manager slow, maybe disable hooking this window and child controls

//When Edit has ES_MULTILINE style use memo like style hook (ex: about window)


//Switch to XE5  -

//Features
//  Settings
//  edit styles with EQ
//  disable skin elements (menu, classes)
//  Add options to system menu (VCL Style selection, EQ, etc)

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: ;
    DLL_PROCESS_DETACH:
                        begin
                          TSysStyleManager.Enabled:=False;
                          //TStyleManager.SetStyle('Windows');
                          if (Assigned(Npp)) then Npp.Destroy;
                          //Release VCL Styles
                          //Release Hooks - disable syscontrols
                        end;
  end;
end;

procedure setInfo(NppData: TNppData); cdecl; export;
begin
  Npp.SetInfo(NppData);
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
end;

function messageProc(msg: Integer; _wParam: WPARAM; _lParam: LPARAM): LRESULT; cdecl; export;
var xmsg:TMessage;
begin
  xmsg.Msg := msg;
  xmsg.WParam := _wParam;
  xmsg.LParam := _lParam;
  xmsg.Result := 0;
  Npp.MessageProc(xmsg);
  Result := xmsg.Result;
end;

{$IFDEF NPPUNICODE}
function isUnicode : Boolean; cdecl; export;
begin
  Result := true;
end;
{$ENDIF}

exports
  setInfo, getName, getFuncsArray, beNotified, messageProc;
{$IFDEF NPPUNICODE}
exports
  isUnicode;
{$ENDIF}


function BeforeNppHookingControl(Info: PControlInfo): Boolean;
begin
  Exit(True);
end;


var
  VClStyleFile : string;
begin
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);

  VClStyleFile:='C:\Program Files (x86)\Notepad++\plugins\Amakrits.vsf';
   if not StyleServices.Available then exit;

   TSysStyleManager.OnBeforeHookingControl:=@BeforeNppHookingControl;
   if TStyleManager.IsValidStyle(VClStyleFile) then
     TStyleManager.SetStyle(TStyleManager.LoadFromFile(VClStyleFile))
   else
     ShowMessage(Format('The Style File %s is not valid',[VClStyleFile]));

   TSysStyleManager.RegisterSysStyleHook('NotePad++', TSysDialogStyleHook);
   TSysStyleManager.UnRegisterSysStyleHook('Edit', TSysEditStyleHook);
end.
