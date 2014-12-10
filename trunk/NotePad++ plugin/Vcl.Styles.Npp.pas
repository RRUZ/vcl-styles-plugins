//**************************************************************************************************
//
// Unit Vcl.Styles.Npp
// unit for the VCL Styles Utils
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
// The Original Code is  Vcl.Styles.Npp.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
//
// Portions created by Rodrigo Ruz V. are Copyright (C) 2014 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************
unit Vcl.Styles.Npp;

interface

uses
  NppPlugin;

type
  TVCLStylesNppPlugin = class(TNppPlugin)
  public
    constructor Create;
    procedure ShowSettings;
    procedure ShowAbout;
    function GetVCLStylesNppConfigPath : string;
  end;

var
  Npp: TVCLStylesNppPlugin;

Procedure  Done;

implementation


uses
  uAbout,
  DDetours,
  System.Generics.Collections,
  System.SysUtils,
  System.Classes,
  {$IFDEF DEBUG}
  System.IOUtils,
  {$ENDIF}
  Winapi.Windows,
  Winapi.Messages,
  Winapi.CommDlg,
  Vcl.Themes,
  Vcl.Dialogs,
  Vcl.Styles.Npp.StyleHooks,
  Vcl.Styles.Utils.SysStyleHook,
  Vcl.Styles.Utils.Forms,
  Vcl.Styles.Utils.SysControls,
  Vcl.Styles.Utils.ComCtrls,
  Vcl.Styles.Utils.StdCtrls;

type
  TThemedNppControls = class
  private
  class var
    FHook_WH_CALLWNDPROC: HHook;
  protected
    class function HookActionCallBackWndProc(nCode: Integer; wParam: wParam;
      lParam: lParam): LRESULT; stdcall; static;
    procedure InstallHook;
    procedure RemoveHook;
  public
    constructor Create; overload;
    destructor Destroy; override;
  end;

var
  NppControlsList      : TObjectDictionary<HWND, TSysStyleHook>;
  ClassesList          : TStrings; //use a  TStrings to avoid the use of generics
  ThemedNppControls    : TThemedNppControls;

{ TThemedSysControls }
constructor TThemedNppControls.Create;
begin
  inherited;
  FHook_WH_CALLWNDPROC := 0;
  InstallHook;
  NppControlsList := TObjectDictionary<HWND, TSysStyleHook>.Create([doOwnsValues]);
  ClassesList := TStringList.Create;
end;

destructor TThemedNppControls.Destroy;
begin
  RemoveHook;
  NppControlsList.Free;
  ClassesList.Free;
  inherited;
end;

class function TThemedNppControls.HookActionCallBackWndProc(nCode: Integer;
  wParam: wParam; lParam: lParam): LRESULT;
var
  C: array [0 .. 256] of Char;
  sClassName : string;
begin
    Result := CallNextHookEx(FHook_WH_CALLWNDPROC, nCode, wParam, lParam);
    if (nCode < 0) then
     Exit;

    if (StyleServices.Enabled) and not (StyleServices.IsSystemStyle) then
    begin

      if ClassesList.IndexOfName(IntToStr(PCWPStruct(lParam)^.hwnd))=-1 then
      begin
        GetClassName(PCWPStruct(lParam)^.hwnd, C, 256);
        //Addlog('GetClassName ' + C);
        ClassesList.Add(Format('%d=%s',[PCWPStruct(lParam)^.hwnd, C]));
      end;

      if ClassesList.IndexOfName(IntToStr(PCWPStruct(lParam)^.hwnd))>=0 then
      begin
        sClassName:=ClassesList.Values[IntToStr(PCWPStruct(lParam)^.hwnd)]; //ClassesList[PCWPStruct(lParam)^.hwnd];


//        if SameText(sClassName,'NotePad++') then
//        begin
//           if (PCWPStruct(lParam)^.message=WM_NCCALCSIZE) and not (NppControlsList.ContainsKey(PCWPStruct(lParam)^.hwnd)) then
//               NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TMainWndNppStyleHook.Create(PCWPStruct(lParam)^.hwnd));
//        end
//        else
        if SameText(sClassName,'msctls_statusbar32') then
        begin
           if not TSysStyleManager.SysStyleHookList.ContainsKey(PCWPStruct(lParam)^.hwnd) then  // avoid double registration
           if (PCWPStruct(lParam)^.message=WM_NCCALCSIZE) and not (NppControlsList.ContainsKey(PCWPStruct(lParam)^.hwnd)) then
               NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TSysStatusBarStyleHook.Create(PCWPStruct(lParam)^.hwnd));
        end
        else
        if SameText(sClassName,'Scintilla') then
        begin
           if not TSysStyleManager.SysStyleHookList.ContainsKey(PCWPStruct(lParam)^.hwnd) then  // avoid double registration
           if (PCWPStruct(lParam)^.message=WM_NCCALCSIZE) and not (NppControlsList.ContainsKey(PCWPStruct(lParam)^.hwnd)) then
               NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TScintillaStyleHook.Create(PCWPStruct(lParam)^.hwnd));
        end
        else
        if SameText(sClassName,'SysTabControl32') then
        begin
           if not TSysStyleManager.SysStyleHookList.ContainsKey(PCWPStruct(lParam)^.hwnd) then  // avoid double registration
           if (PCWPStruct(lParam)^.message=WM_NCCALCSIZE) and not (NppControlsList.ContainsKey(PCWPStruct(lParam)^.hwnd)) then
               NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TSysTabControlStyleHook.Create(PCWPStruct(lParam)^.hwnd));
        end
        else
        if SameText(sClassName,'Edit') then
        begin
           if not TSysStyleManager.SysStyleHookList.ContainsKey(PCWPStruct(lParam)^.hwnd) then  // avoid double registration
           if (PCWPStruct(lParam)^.message=WM_NCCALCSIZE) and not (NppControlsList.ContainsKey(PCWPStruct(lParam)^.hwnd)) then
           begin
                 NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TSysEditStyleHook.Create(PCWPStruct(lParam)^.hwnd))
//               if (GetWindowLong(PCWPStruct(lParam)^.hwnd, GWL_STYLE) and ES_MULTILINE = 0) then
//                 NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TSysEditStyleHook.Create(PCWPStruct(lParam)^.hwnd))
//               else
//                 NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TSysMemoStyleHook.Create(PCWPStruct(lParam)^.hwnd));
           end;
        end


      end;
    end;
end;

procedure TThemedNppControls.InstallHook;
begin
  FHook_WH_CALLWNDPROC := SetWindowsHookEx(WH_CALLWNDPROC, @TThemedNppControls.HookActionCallBackWndProc, 0, GetCurrentThreadId);
end;

procedure TThemedNppControls.RemoveHook;
begin
  if FHook_WH_CALLWNDPROC <> 0 then
    UnhookWindowsHookEx(FHook_WH_CALLWNDPROC);
end;

Procedure  Done;
begin
if Assigned(ThemedNppControls) then
  begin
    ThemedNppControls.Free;
    ThemedNppControls:=nil;
  end;
end;

{ TVCLStylesNppPlugin }

procedure _FuncAbout; cdecl;
begin
  Npp.ShowAbout;
end;

procedure _FuncSettings; cdecl;
begin
  Npp.ShowSettings;
end;

constructor TVCLStylesNppPlugin.Create;
begin
  inherited;
  self.PluginName := 'VCL Styles for Notepad++';
  AddFuncItem('Settings', _FuncSettings);
  AddFuncItem('About', _FuncAbout);
end;

procedure TVCLStylesNppPlugin.ShowSettings;
begin
end;

function TVCLStylesNppPlugin.GetVCLStylesNppConfigPath: string;
begin
  Result:=IncludeTrailingPathDelimiter(self.GetPluginsConfigDir)+'VCLStylesNpp\';
  if not DirectoryExists(Result) then
   ForceDirectories(Result);
end;

procedure TVCLStylesNppPlugin.ShowAbout;
var
  a: TAboutForm;
begin
  a := TAboutForm.Create(self);
  a.ShowModal;
  a.Free;
end;

const
  commdlg32 = 'comdlg32.dll';

var
 TrampolineGetOpenFileName  : function (var OpenFile: TOpenFilename): Bool; stdcall;

function DialogHook(Wnd: HWnd; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT_PTR; stdcall;
begin
  Exit(0);
end;

function DetourGetOpenFileName(var OpenFile: TOpenFilename): Bool; stdcall;
begin
  if (OpenFile.Flags and  OFN_EXPLORER <> 0)  then
  begin
    OpenFile.lpfnHook := @DialogHook;
    OpenFile.Flags    := OpenFile.Flags or OFN_ENABLEHOOK;
  end;
 Exit(TrampolineGetOpenFileName(OpenFile));
end;

procedure HookFileDialogs;
begin
  @TrampolineGetOpenFileName :=  InterceptCreate(commdlg32, 'GetOpenFileNameW', @DetourGetOpenFileName);
end;

procedure UnHookFileDialogs;
begin
  InterceptRemove(@TrampolineGetOpenFileName);
end;

initialization
  ThemedNppControls:=nil;
  if StyleServices.Available then
   ThemedNppControls := TThemedNppControls.Create;
  HookFileDialogs;
finalization
   UnHookFileDialogs;
   Done;
end.
