//**************************************************************************************************
//
// Unit Vcl.Styles.Hooks
// unit for the VCL Styles for Notepad++
// https://github.com/RRUZ/vcl-styles-plugins
//
// The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
// you may not use this file except in compliance with the License. You may obtain a copy of the
// License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
// ANY KIND, either express or implied. See the License for the specific language governing rights
// and limitations under the License.
//
// The Original Code is Vcl.Styles.Hooks.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2013-2015 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************
unit Vcl.Styles.Hooks;

interface

implementation

{$DEFINE HOOK_UXTHEME}
{$DEFINE HOOK_TDateTimePicker}
{$DEFINE HOOK_TProgressBar}

uses
  ioutils,
  DDetours,
  System.SyncObjs,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Generics.Collections,
  System.StrUtils,
  WinApi.Windows,
  WinApi.Messages,
  Vcl.Graphics,
{$IFDEF HOOK_UXTHEME}
  Vcl.Styles.UxTheme,
{$ENDIF}
  Vcl.Styles.Utils.SysControls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Themes;

type
  TListStyleBrush = TObjectDictionary<Integer, TBrush>;

var
  VCLStylesBrush: TObjectDictionary<string, TListStyleBrush>;
  VCLStylesLock: TCriticalSection = nil;

  Trampoline_GetSysColor: function (nIndex: Integer): DWORD; stdcall =  nil;
  Trampoline_GetSysColorBrush: function (nIndex: Integer): HBRUSH; stdcall=  nil;
  Trampoline_DrawFrameControl: function (DC: HDC; Rect: PRect; uType, uState: UINT): BOOL; stdcall = nil;
  Trampoline_DrawEdge: function (hdc: HDC; var qrc: TRect; edge: UINT; grfFlags: UINT): BOOL; stdcall = nil;
  Trampoline_GetStockObject: function (Index: Integer): HGDIOBJ; stdcall = nil;
  Trampoline_FindResourceW: function (hModule: HMODULE; lpName, lpType: LPCWSTR): HRSRC; stdcall =nil;

//Custom version for npp, avoid wrong backround in images of toolbar.
function Detour_GetSysColor(nIndex: Integer): DWORD; stdcall;
begin
  if StyleServices.IsSystemStyle or not TSysStyleManager.Enabled  then
    Result:= Trampoline_GetSysColor(nIndex)
  else
  if nIndex= COLOR_WINDOW then
    Result:= DWORD(StyleServices.GetSystemColor(clWindow))
  else
  if nIndex= COLOR_WINDOWTEXT then
    Result:= DWORD(StyleServices.GetSystemColor(clWindowText))
  else
  if nIndex= COLOR_HIGHLIGHTTEXT then
    Result:= DWORD(StyleServices.GetSystemColor(clHighlightText))
  else
  if nIndex= COLOR_HIGHLIGHT then
    Result:= DWORD(StyleServices.GetSystemColor(clHighlight))
  else
  if nIndex= COLOR_HOTLIGHT then
    Result:= DWORD(StyleServices.GetSystemColor(clHighlight))
  else
  if nIndex<>COLOR_BTNFACE then
    Result:= DWORD(StyleServices.GetSystemColor(TColor(nIndex or Integer($FF000000))))
  else
     Result:= Trampoline_GetSysColor(nIndex);
    //Result:= DWORD(StyleServices.GetSystemColor(TColor(nIndex or Integer($FF000000))));
end;


function Detour_GetSysColorBrush(nIndex: Integer): HBRUSH; stdcall;
var
  LCurrentStyleBrush: TListStyleBrush;
  LBrush: TBrush;
begin
  VCLStylesLock.Enter;
  try
    if StyleServices.IsSystemStyle or not TSysStyleManager.Enabled  then
     Exit(Trampoline_GetSysColorBrush(nIndex))
    else
    begin
     if VCLStylesBrush.ContainsKey(StyleServices.Name) then
      LCurrentStyleBrush:=VCLStylesBrush.Items[StyleServices.Name]
     else
     begin
       VCLStylesBrush.Add(StyleServices.Name, TListStyleBrush.Create([doOwnsValues]));
       LCurrentStyleBrush:=VCLStylesBrush.Items[StyleServices.Name];
     end;

     if LCurrentStyleBrush.ContainsKey(nIndex) then
      Exit(LCurrentStyleBrush.Items[nIndex].Handle)
     else
     begin
       LBrush:=TBrush.Create;
       LCurrentStyleBrush.Add(nIndex, LBrush);
       LBrush.Color:= StyleServices.GetSystemColor(TColor(nIndex or Integer($FF000000)));
       //OutputDebugString(PChar(Format('nIndex %d Color %x RGB %x', [nIndex, LBrush.Color, ColorToRGB(LBrush.Color)])));
       Exit(LBrush.Handle);
     end;
    end;
  finally
    VCLStylesLock.Leave;
  end;
end;


procedure Addlog(const lpOutputString: string);
begin
  TFile.AppendAllText('C:\Program Files (x86)\Notepad++\plugins\nppvclstyles.log', Format('%s %s %s',[FormatDateTime('hh:nn:ss.zzz', Now), lpOutputString, sLineBreak]));
end;

function Detour_WinApi_DrawFrameControl(DC: HDC; Rect: PRect; uType, uState: UINT): BOOL; stdcall;
begin
 //Addlog(Format('Detour_WinApi_DrawFrameControl uType %d uState %d', [uType, uState]));
 Exit(Trampoline_DrawFrameControl(DC, Rect, uType, uState));
end;

function Detour_WinApi_DrawEdge(hdc: HDC; var qrc: TRect; edge: UINT; grfFlags: UINT): BOOL; stdcall;
begin
 //Addlog(Format('Detour_WinApi_DrawEdge edge %d grfFlags %d', [edge, grfFlags]));
 Exit(Trampoline_DrawEdge(hdc, qrc, edge, grfFlags));
end;

function Detour_GetStockObject(Index: Integer): HGDIOBJ; stdcall;
begin
 //Addlog(Format('GetStockObject Index %d', [index]));
 Exit(Trampoline_GetStockObject(Index));
end;


function  Detour_FindResourceW(hModule: HMODULE; lpName, lpType: LPCWSTR): HRSRC; stdcall;
begin
 //Addlog(Format('Detour_FindResourceW lpName %s lpType %s', [lpName, lptype]));
 Exit(Trampoline_FindResourceW(hModule, lpName, lpType));
end;


initialization
  VCLStylesLock := TCriticalSection.Create;
  VCLStylesBrush := TObjectDictionary<string, TListStyleBrush>.Create([doOwnsValues]);

 if StyleServices.Available then
 begin

   {$IFDEF  HOOK_TDateTimePicker}
   TCustomStyleEngine.RegisterStyleHook(TDateTimePicker, TStyleHook);
   {$ENDIF}
   {$IFDEF  HOOK_TProgressBar}
   TCustomStyleEngine.RegisterStyleHook(TProgressBar, TStyleHook);
   {$ENDIF}

   @Trampoline_GetSysColor :=  InterceptCreate(user32, 'GetSysColor', @Detour_GetSysColor);
   @Trampoline_GetSysColorBrush :=  InterceptCreate(user32, 'GetSysColorBrush', @Detour_GetSysColorBrush);
   @Trampoline_DrawFrameControl :=  InterceptCreate(user32, 'DrawFrameControl', @Detour_WinApi_DrawFrameControl);
   @Trampoline_DrawEdge :=  InterceptCreate(user32, 'DrawEdge', @Detour_WinApi_DrawEdge);
   @Trampoline_GetStockObject :=  InterceptCreate(gdi32, 'GetStockObject', @Detour_GetStockObject);
   @Trampoline_FindResourceW :=  InterceptCreate(kernel32, 'FindResourceW', @Detour_FindResourceW);
 end;

finalization
  InterceptRemove(@Trampoline_GetSysColor);
  InterceptRemove(@Trampoline_GetSysColorBrush);
  InterceptRemove(@Trampoline_DrawFrameControl);
  InterceptRemove(@Trampoline_DrawEdge);
  InterceptRemove(@Trampoline_GetStockObject);
  InterceptRemove(@Trampoline_FindResourceW);

  VCLStylesBrush.Free;
  VCLStylesLock.Free;
  VCLStylesLock := nil;
end.
