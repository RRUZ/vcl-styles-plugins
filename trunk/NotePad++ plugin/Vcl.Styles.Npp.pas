//**************************************************************************************************
//
// Unit Vcl.Styles.Npp
// unit for the VCL Styles for Notepad++
// https://code.google.com/p/vcl-styles-plugins/
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
  uMisc,
  NppPlugin;

type
  TVCLStylesNppPlugin = class(TNppPlugin)
  private
    FSettings: TSettings;
    FSettingsFileName: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ShowSettings;
    procedure ShowAbout;
    function GetVCLStylesNppConfigPath : string;
    property Settings : TSettings read FSettings write FSettings;
    property SettingsFileName : string  read FSettingsFileName  write FSettingsFileName;
  end;

var
  Npp: TVCLStylesNppPlugin;

Procedure  Done;

implementation


uses
  uAbout,
  uSettings,
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
  class var ClassesList : TDictionary<HWND, string>;
  class var  FHook_WH_CALLWNDPROC: HHook;
  class var  FHook_WH_CBT: HHook;
  protected
    class function HookActionCallBackWndProc(nCode: Integer; wParam: wParam; lParam: lParam): LRESULT; stdcall; static;
    class function HookActionCallBackCBT(nCode: Integer; wParam: wParam; lParam: lParam): LRESULT; stdcall; static;
    procedure InstallHook_WH_CALLWNDPROC;
    procedure RemoveHook_WH_CALLWNDPROC;
    procedure InstallHook_WH_CBT;
    procedure RemoveHook_WH_CBT;
  public
    constructor Create; overload;
    destructor Destroy; override;
  end;

var
  NppControlsList      : TObjectDictionary<HWND, TSysStyleHook>;
  ThemedNppControls    : TThemedNppControls;

{ TThemedSysControls }
constructor TThemedNppControls.Create;
begin
  inherited;
  FHook_WH_CALLWNDPROC := 0;
  InstallHook_WH_CALLWNDPROC;
  InstallHook_WH_CBT;
  NppControlsList := TObjectDictionary<HWND, TSysStyleHook>.Create([doOwnsValues]);
  ClassesList :=  TDictionary<HWND, string>.Create;
end;

destructor TThemedNppControls.Destroy;
begin
  RemoveHook_WH_CALLWNDPROC;
  RemoveHook_WH_CBT;
  NppControlsList.Free;
  ClassesList.Free;
  inherited;
end;

class function TThemedNppControls.HookActionCallBackCBT(nCode: Integer; wParam: wParam; lParam: lParam): LRESULT;
var
 LHWND  : HWND;
 LClassName : string;
begin
   if (StyleServices.Enabled) and not (StyleServices.IsSystemStyle) then
   case nCode of
     HCBT_ACTIVATE:
     begin
       LHWND := HWND(wParam);
       if(LHWND>0) then
       begin
          LClassName:= GetWindowClassName(LHWND);
          if (LClassName<>'') and  (not TSysStyleManager.SysStyleHookList.ContainsKey(LHWND)) and SameText(LClassName,'#32770')  then
          begin
            TSysStyleManager.AddControlDirectly(LHWND, LClassName);
            InvalidateRect(LHWND, nil, False);
          end;
       end;
     end;
   end;
  Result := CallNextHookEx(TThemedNppControls.FHook_WH_CBT, nCode, wParam, lParam);
end;

class function TThemedNppControls.HookActionCallBackWndProc(nCode: Integer;
  wParam: wParam; lParam: lParam): LRESULT;
var
  LClassName : string;
begin
    Result := CallNextHookEx(FHook_WH_CALLWNDPROC, nCode, wParam, lParam);
    if (nCode < 0) then
     Exit;

    if (StyleServices.Enabled) and not (StyleServices.IsSystemStyle) then
    begin
      if not ClassesList.ContainsKey(PCWPStruct(lParam)^.hwnd) then
      begin
        LClassName:= GetWindowClassName(PCWPStruct(lParam)^.hwnd);
        ClassesList.Add(PCWPStruct(lParam)^.hwnd, LClassName);
      end;

      if ClassesList.ContainsKey(PCWPStruct(lParam)^.hwnd) then
      begin
        LClassName:=ClassesList[PCWPStruct(lParam)^.hwnd];


//        if SameText(sClassName,'NotePad++') then
//        begin
//           if (PCWPStruct(lParam)^.message=WM_NCCALCSIZE) and not (NppControlsList.ContainsKey(PCWPStruct(lParam)^.hwnd)) then
//               NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TMainWndNppStyleHook.Create(PCWPStruct(lParam)^.hwnd));
//        end
//        else
        if SameText(LClassName,'msctls_statusbar32') then
        begin
           if not TSysStyleManager.SysStyleHookList.ContainsKey(PCWPStruct(lParam)^.hwnd) then  // avoid double registration
           if (PCWPStruct(lParam)^.message=WM_NCCALCSIZE) and not (NppControlsList.ContainsKey(PCWPStruct(lParam)^.hwnd)) then
               NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TSysStatusBarStyleHook.Create(PCWPStruct(lParam)^.hwnd));
        end
        else
        if SameText(LClassName,'Scintilla') then
        begin
           if not TSysStyleManager.SysStyleHookList.ContainsKey(PCWPStruct(lParam)^.hwnd) then  // avoid double registration
           if (PCWPStruct(lParam)^.message=WM_NCCALCSIZE) and not (NppControlsList.ContainsKey(PCWPStruct(lParam)^.hwnd)) then
               NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TScintillaStyleHook.Create(PCWPStruct(lParam)^.hwnd));
        end
        else
        if SameText(LClassName,'SysTabControl32') then
        begin
           if not TSysStyleManager.SysStyleHookList.ContainsKey(PCWPStruct(lParam)^.hwnd) then  // avoid double registration
           if (PCWPStruct(lParam)^.message=WM_NCCALCSIZE) and not (NppControlsList.ContainsKey(PCWPStruct(lParam)^.hwnd)) then
               NppControlsList.Add(PCWPStruct(lParam)^.hwnd, TSysTabControlStyleHook.Create(PCWPStruct(lParam)^.hwnd));
        end
        else
        if SameText(LClassName,'Edit') then
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

procedure TThemedNppControls.InstallHook_WH_CALLWNDPROC;
begin
  FHook_WH_CALLWNDPROC := SetWindowsHookEx(WH_CALLWNDPROC, @TThemedNppControls.HookActionCallBackWndProc, 0, GetCurrentThreadId);
end;

procedure TThemedNppControls.InstallHook_WH_CBT;
begin
   FHook_WH_CBT := SetWindowsHookEx(WH_CBT, @TThemedNppControls.HookActionCallBackCBT, 0, GetCurrentThreadId);
end;

procedure TThemedNppControls.RemoveHook_WH_CALLWNDPROC;
begin
  if FHook_WH_CALLWNDPROC <> 0 then
    UnhookWindowsHookEx(FHook_WH_CALLWNDPROC);
end;

procedure TThemedNppControls.RemoveHook_WH_CBT;
begin
  if FHook_WH_CBT <> 0 then
    UnhookWindowsHookEx(FHook_WH_CBT);
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
  FSettings:=TSettings.Create;
end;

procedure TVCLStylesNppPlugin.ShowSettings;
var
  LForm: TSettingsForm;
begin
  LForm := TSettingsForm.Create(self);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;
destructor TVCLStylesNppPlugin.Destroy;
begin
  FSettings.Free;
  inherited;
end;

function TVCLStylesNppPlugin.GetVCLStylesNppConfigPath: string;
begin
  Result:=IncludeTrailingPathDelimiter(self.GetPluginsConfigDir)+'VCLStylesNpp\';
  if not DirectoryExists(Result) then
   ForceDirectories(Result);
end;

procedure TVCLStylesNppPlugin.ShowAbout;
var
  LForm: TAboutForm;
begin
  LForm := TAboutForm.Create(self);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
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
