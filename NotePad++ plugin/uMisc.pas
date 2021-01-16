//**************************************************************************************************
//
// Unit uMisc
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
// The Original Code is  uMisc.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
//
// Portions created by Rodrigo Ruz V. are Copyright (C) 2014-2021 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************
unit uMisc;

interface

{.$DEFINE ENABLELOG}

uses
 Winapi.Windows,
 Vcl.Graphics,
 System.Rtti,
 System.Types;

type
  TSettings =class
  private
    FVclStyle: string;
  public
    property VclStyle: string read FVclStyle write FVclStyle;
  end;



  function  GetFileVersion(const FileName: string): string;
  function  IsAppRunning(const FileName: string): boolean;
  function  GetLocalAppDataFolder: string;
  function  GetTempDirectory: string;
  procedure MsgBox(const Msg: string);
  procedure CreateArrayBitmap(Width,Height:Word;Colors: Array of TColor;var bmp: TBitmap);
  function  GetSpecialFolder(const CSIDL: integer): string;
  function  IsUACEnabled: Boolean;
  procedure RunAsAdmin(const FileName, Params: string; hWnd: HWND = 0);
  function  CurrentUserIsAdmin: Boolean;
  function  GetModuleName: string;
  procedure GetAssocAppByExt(const FileName:string; var ExeName, FriendlyAppName: string);

  procedure ReadSettings(Settings: TSettings;const FileName: string);
  procedure WriteSettings(const Settings: TSettings;const FileName: string);
  function GetUNCNameEx(const lpLocalPath: string): string;
  function LocalPathToFileURL(const pszPath: string): string;
  function IsVistaOrLater: Boolean;

implementation

uses
  ActiveX,
  ShlObj,
  PsAPI,
  tlhelp32,
  ComObj,
  CommCtrl,
  StrUtils,
  ShellAPI,
  Classes,
  Dialogs,
  ShLwApi,
  System.UITypes,
  Registry,
  TypInfo,
  IOUtils,
  UxTheme,
  IniFiles,
  SysUtils;

Const
 SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
 SECURITY_BUILTIN_DOMAIN_RID = $00000020;
 DOMAIN_ALIAS_RID_ADMINS     = $00000220;
 DOMAIN_ALIAS_RID_USERS      = $00000221;
 DOMAIN_ALIAS_RID_GUESTS     = $00000222;
 DOMAIN_ALIAS_RID_POWER_USERS= $00000223;

type
  TAssocStr = (
  ASSOCSTR_COMMAND = 1,
  ASSOCSTR_EXECUTABLE,
  ASSOCSTR_FRIENDLYDOCNAME,
  ASSOCSTR_FRIENDLYAPPNAME,
  ASSOCSTR_NOOPEN,
  ASSOCSTR_SHELLNEWVALUE,
  ASSOCSTR_DDECOMMAND,
  ASSOCSTR_DDEIFEXEC,
  ASSOCSTR_DDEAPPLICATION,
  ASSOCSTR_DDETOPIC );

const
  AssocStrDisplaystrings: array [ASSOCSTR_COMMAND..ASSOCSTR_DDETOPIC]
  of string = (
  'ASSOCSTR_COMMAND',
  'ASSOCSTR_EXECUTABLE',
  'ASSOCSTR_FRIENDLYDOCNAME',
  'ASSOCSTR_FRIENDLYAPPNAME',
  'ASSOCSTR_NOOPEN',
  'ASSOCSTR_SHELLNEWVALUE',
  'ASSOCSTR_DDECOMMAND',
  'ASSOCSTR_DDEIFEXEC',
  'ASSOCSTR_DDEAPPLICATION',
  'ASSOCSTR_DDETOPIC' );



function IsVistaOrLater: Boolean;
begin
  Result:= (Win32MajorVersion >= 6);
end;


function CheckTokenMembership(TokenHandle: THandle; SidToCheck: PSID; var IsMember: BOOL): BOOL; stdcall; external advapi32;

function GetComputerName: string;
var
  nSize: Cardinal;
begin
  nSize := MAX_COMPUTERNAME_LENGTH + 1;
  Result := StringOfChar(#0, nSize);
  Winapi.Windows.GetComputerName(PChar(Result), nSize);
  SetLength(Result, nSize);
end;

function GetUNCNameEx(const lpLocalPath: string): string;
begin
  if GetDriveType(PChar(Copy(lpLocalPath,1,3)))=DRIVE_REMOTE then
   Result:=ExpandUNCFileName(lpLocalPath)
  else
    Result := '\\' + GetComputerName + '\' + StringReplace(lpLocalPath,':','$', [rfReplaceAll]);
end;

function LocalPathToFileURL(const pszPath: string): string;
var
  pszUrl: string;
  pcchUrl: DWORD;
begin
  Result := '';
  pcchUrl := Length('file:///' + pszPath + #0);
  SetLength(pszUrl, pcchUrl);

  if UrlCreateFromPath(PChar(pszPath), PChar(pszUrl), @pcchUrl, 0) = S_OK then
    Result := pszUrl;
end;




procedure ReadSettings(Settings: TSettings;const FileName: string);
var
  iniFile: TIniFile;
  LCtx: TRttiContext;
  LProp: TRttiProperty;
  BooleanValue: Boolean;
  StringValue: string;
begin
  iniFile := TIniFile.Create(FileName);
  try
   LCtx:=TRttiContext.Create;
   try
    for LProp in LCtx.GetType(TypeInfo(TSettings)).GetProperties do
    if LProp.PropertyType.TypeKind=tkEnumeration then
    begin
      BooleanValue:= iniFile.ReadBool('Global', LProp.Name, True);
      LProp.SetValue(Settings, BooleanValue);
    end
    else
    if (LProp.PropertyType.TypeKind=tkString) or  (LProp.PropertyType.TypeKind=tkUString) then
    begin
      StringValue:= iniFile.ReadString('Global', LProp.Name, '');
      LProp.SetValue(Settings, StringValue);
    end;
   finally
     LCtx.Free;
   end;
  finally
    iniFile.Free;
  end;
end;

procedure WriteSettings(const Settings: TSettings;const FileName: string);
var
  iniFile: TIniFile;
  LCtx: TRttiContext;
  LProp: TRttiProperty;
  BooleanValue: Boolean;
  StringValue: string;
begin
  iniFile := TIniFile.Create(FileName);
  try
   LCtx:=TRttiContext.Create;
   try
    for LProp in LCtx.GetType(TypeInfo(TSettings)).GetProperties do
    if LProp.PropertyType.TypeKind=tkEnumeration then
    begin
       BooleanValue:= LProp.GetValue(Settings).AsBoolean;
       iniFile.WriteBool('Global', LProp.Name, BooleanValue);
    end
    else
    if (LProp.PropertyType.TypeKind=tkString) or  (LProp.PropertyType.TypeKind=tkUString) then
    begin
       StringValue:= LProp.GetValue(Settings).AsString;
       iniFile.WriteString('Global', LProp.Name, StringValue);
    end;
   finally
     LCtx.Free;
   end;
  finally
    iniFile.Free;
  end;
end;

procedure GetAssocAppByExt(const FileName:string; var ExeName, FriendlyAppName: string);
var
 pszOut: array [0..1024] of Char;
 pcchOut: DWord;
begin
  ExeName:='';
  FriendlyAppName:='';
  pcchOut := Sizeof(pszOut);
  ZeroMemory(@pszOut, SizeOf(pszOut));

  OleCheck( AssocQueryString(ASSOCF_NOTRUNCATE, ASSOCSTR(ASSOCSTR_EXECUTABLE), LPCWSTR(ExtractFileExt(FileName)), 'open', pszOut, @pcchOut));
  if pcchOut>0 then
   SetString(ExeName, PChar(@pszOut[0]), pcchOut-1);

  pcchOut := Sizeof(pszOut);
  ZeroMemory(@pszOut, SizeOf(pszOut));

  OleCheck( AssocQueryString(ASSOCF_NOTRUNCATE, ASSOCSTR(ASSOCSTR_FRIENDLYAPPNAME), LPCWSTR(ExtractFileExt(FileName)), 'open', pszOut, @pcchOut));
  if pcchOut>0 then
   SetString(FriendlyAppName, PChar(@pszOut[0]), pcchOut-1);
end;

function GetModuleName: string;
var
  lpFilename: array[0..MAX_PATH] of Char;
begin
  ZeroMemory(@lpFilename, SizeOf(lpFilename));
  GetModuleFileName(hInstance, lpFilename, MAX_PATH);
  Result := lpFilename;
end;

function IsUACEnabled: Boolean;
var
  LRegistry: TRegistry;
begin
  Result := False;
  if CheckWin32Version(6, 0) then
  begin
    LRegistry := TRegistry.Create;
    try
      LRegistry.RootKey := HKEY_LOCAL_MACHINE;
      if LRegistry.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System') then
        Exit(LRegistry.ValueExists('EnableLUA') and LRegistry.ReadBool('EnableLUA'));
    finally
      LRegistry.Free;
    end;
  end;
end;


function  UserInGroup(Group :DWORD): Boolean;
 var
  pIdentifierAuthority :TSIDIdentifierAuthority;
  pSid: Winapi.Windows.PSID;
  IsMember: BOOL;
 begin
  pIdentifierAuthority := SECURITY_NT_AUTHORITY;
  Result := AllocateAndInitializeSid(pIdentifierAuthority,2, SECURITY_BUILTIN_DOMAIN_RID, Group, 0, 0, 0, 0, 0, 0, pSid);
  try
    if Result then
      if not CheckTokenMembership(0, pSid, IsMember) then //passing 0 means which the function will be use the token of the calling thread.
         Result:= False
      else
         Result:=IsMember;
  finally
     FreeSid(pSid);
  end;
 end;

function  CurrentUserIsAdmin: Boolean;
begin
 Result:=UserInGroup(DOMAIN_ALIAS_RID_ADMINS);
end;

procedure RunAsAdmin(const FileName, Params: string; hWnd: HWND = 0);
var
  sei: TShellExecuteInfo;
begin
  ZeroMemory(@sei, SizeOf(sei));
  sei.cbSize := SizeOf(sei);
  sei.Wnd := hWnd;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  sei.lpVerb := 'runas';
  sei.lpFile := PChar(FileName);
  sei.lpParameters := PChar(Params);
  sei.nShow := SW_SHOWNORMAL;
  if not ShellExecuteEx(@sei) then
    RaiseLastOSError;
end;


function GetSpecialFolder(const CSIDL: integer): string;
var
  lpszPath: PWideChar;
begin
  lpszPath := StrAlloc(MAX_PATH);
  try
     ZeroMemory(lpszPath, MAX_PATH);
    if SHGetSpecialFolderPath(0, lpszPath, CSIDL, False)  then
      Result := lpszPath
    else
      Result := '';
  finally
    StrDispose(lpszPath);
  end;
end;

procedure MsgBox(const Msg: string);
begin
  MessageDlg(Msg, mtInformation, [mbOK], 0);
end;

function GetTempDirectory: string;
var
  lpBuffer: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @lpBuffer);
  Result := StrPas(lpBuffer);
end;

function GetLocalAppDataFolder: string;
const
  CSIDL_LOCAL_APPDATA = $001C;
var
  ppMalloc: IMalloc;
  ppidl:    PItemIdList;
begin
  ppidl := nil;
  try
    if SHGetMalloc(ppMalloc) = S_OK then
    begin
      SHGetSpecialFolderLocation(0, CSIDL_LOCAL_APPDATA, ppidl);
      SetLength(Result, MAX_PATH);
      if not SHGetPathFromIDList(ppidl, PChar(Result)) then
        RaiseLastOSError;
      SetLength(Result, lStrLen(PChar(Result)));
    end;
  finally
    if ppidl <> nil then
      ppMalloc.Free(ppidl);
  end;
end;


function ProcessFileName(dwProcessId: DWORD): string;
var
  hModule: Cardinal;
begin
  Result := '';
  hModule := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, dwProcessId);
  if hModule <> 0 then
    try
      SetLength(Result, MAX_PATH);
      if GetModuleFileNameEx(hModule, 0, PChar(Result), MAX_PATH) > 0 then
        SetLength(Result, StrLen(PChar(Result)))
      else
        Result := '';
    finally
      CloseHandle(hModule);
    end;
end;

function IsAppRunning(const FileName: string): boolean;
var
  hSnapshot: Cardinal;
  EntryParentProc: TProcessEntry32;
begin
  Result := False;
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if hSnapshot = INVALID_HANDLE_VALUE then
    exit;
  try
    EntryParentProc.dwSize := SizeOf(EntryParentProc);
    if Process32First(hSnapshot, EntryParentProc) then
      repeat
        if CompareText(ExtractFileName(FileName), EntryParentProc.szExeFile) = 0 then
          if CompareText(ProcessFileName(EntryParentProc.th32ProcessID),  FileName) = 0 then
          begin
            Result := True;
            break;
          end;
      until not Process32Next(hSnapshot, EntryParentProc);
  finally
    CloseHandle(hSnapshot);
  end;
end;



function GetFileVersion(const FileName: string): string;
var
  FSO: OleVariant;
begin
  FSO := CreateOleObject('Scripting.FileSystemObject');
  Result := FSO.GetFileVersion(FileName);
end;

procedure ExtractIconFile(Icon: TIcon; const Filename: string;IconType: Cardinal);
var
  FileInfo: TShFileInfo;
begin
  if FileExists(Filename) then
  begin
    FillChar(FileInfo, SizeOf(FileInfo), 0);
    SHGetFileInfo(PChar(Filename), 0, FileInfo, SizeOf(FileInfo),
      SHGFI_ICON or IconType);
    if FileInfo.hIcon <> 0 then
      Icon.Handle:=FileInfo.hIcon;
  end;
end;

procedure ExtractBitmapFile(Bmp: TBitmap; const Filename: string;IconType: Cardinal);
var
 Icon: TIcon;
begin
  Icon:=TIcon.Create;
  try
    ExtractIconFile(Icon, Filename, SHGFI_SMALLICON);
    Bmp.PixelFormat:=pf24bit;
    Bmp.Width := Icon.Width;
    Bmp.Height := Icon.Height;
    Bmp.Canvas.Draw(0, 0, Icon);
  finally
    Icon.Free;
  end;

end;


procedure ExtractBitmapFile32(Bmp: TBitmap; const Filename: string;IconType: Cardinal);
var
 Icon: TIcon;
begin
  Icon:=TIcon.Create;
  try
    ExtractIconFile(Icon, Filename, SHGFI_SMALLICON);
    Bmp.PixelFormat:=pf32bit;  {
    Bmp.Width := Icon.Width;
    Bmp.Height := Icon.Height;
    Bmp.Canvas.Draw(0, 0, Icon);
    }
    Bmp.Assign(Icon);
  finally
    Icon.Free;
  end;

end;

procedure CreateArrayBitmap(Width,Height:Word;Colors: Array of TColor;var bmp: TBitmap);
Var
 i: integer;
 w: integer;
begin
  bmp.PixelFormat:=pf24bit;
  bmp.Width:=Width;
  bmp.Height:=Height;
  bmp.Canvas.Brush.Color := clBlack;
  bmp.Canvas.FillRect(Rect(0,0, Width, Height));


  w :=(Width-2) div (High(Colors)+1);
  for i:=0 to High(Colors) do
  begin
   bmp.Canvas.Brush.Color := Colors[i];
   //bmp.Canvas.FillRect(Rect((w*i),0, w*(i+1), Height));
   bmp.Canvas.FillRect(Rect((w*i)+1,1, w*(i+1)+1, Height-1))
  end;
end;

procedure ShrinkImage32(const SourceBitmap, StretchedBitmap: TBitmap;
  Scale: Double);
var
  ScanLines: array of PByteArray;
  DestLine: PByteArray;
  CurrentLine: PByteArray;
  DestX, DestY: Integer;
  DestA, DestR, DestB, DestG: Integer;
  SourceYStart, SourceXStart: Integer;
  SourceYEnd, SourceXEnd: Integer;
  AvgX, AvgY: Integer;
  ActualX: Integer;
  PixelsUsed: Integer;
  DestWidth, DestHeight: Integer;
begin
  DestWidth := StretchedBitmap.Width;
  DestHeight := StretchedBitmap.Height;
  SetLength(ScanLines, SourceBitmap.Height);
  for DestY := 0 to DestHeight - 1 do
  begin
    SourceYStart := Round(DestY / Scale);
    SourceYEnd := Round((DestY + 1) / Scale) - 1;

    if SourceYEnd >= SourceBitmap.Height then
      SourceYEnd := SourceBitmap.Height - 1;

    { Grab the destination pixels }
    DestLine := StretchedBitmap.ScanLine[DestY];
    for DestX := 0 to DestWidth - 1 do
    begin
      { Calculate the RGB value at this destination pixel }
      SourceXStart := Round(DestX / Scale);
      SourceXEnd := Round((DestX + 1) / Scale) - 1;

      DestR := 0;
      DestB := 0;
      DestG := 0;
      DestA := 0;

      PixelsUsed := 0;
      if SourceXEnd >= SourceBitmap.Width then
        SourceXEnd := SourceBitmap.Width - 1;
      for AvgY := SourceYStart to SourceYEnd do
      begin
        if ScanLines[AvgY] = nil then
          ScanLines[AvgY] := SourceBitmap.ScanLine[AvgY];
        CurrentLine := ScanLines[AvgY];
        for AvgX := SourceXStart to SourceXEnd do
        begin
          ActualX := AvgX*4; { 4 bytes per pixel }
          DestR := DestR + CurrentLine[ActualX];
          DestB := DestB + CurrentLine[ActualX+1];
          DestG := DestG + CurrentLine[ActualX+2];
          DestA := DestA + CurrentLine[ActualX+3];
          Inc(PixelsUsed);
        end;
      end;

      { pf32bit = 4 bytes per pixel }
      ActualX := DestX*4;
      DestLine[ActualX] := Round(DestR / PixelsUsed);
      DestLine[ActualX+1] := Round(DestB / PixelsUsed);
      DestLine[ActualX+2] := Round(DestG / PixelsUsed);
      DestLine[ActualX+3] := Round(DestA / PixelsUsed);
    end;
  end;
end;


procedure EnlargeImage32(const SourceBitmap, StretchedBitmap: TBitmap;
  Scale: Double);
var
  ScanLines: array of PByteArray;
  DestLine: PByteArray;
  CurrentLine: PByteArray;
  DestX, DestY: Integer;
  DestA, DestR, DestB, DestG: Double;
  SourceYStart, SourceXStart: Integer;
  SourceYPos: Integer;
  AvgX, AvgY: Integer;
  ActualX: Integer;
  { Use a 4 pixels for enlarging }
  XWeights, YWeights: array[0..1] of Double;
  PixelWeight: Double;
  DistFromStart: Double;
  DestWidth, DestHeight: Integer;
begin
  DestWidth := StretchedBitmap.Width;
  DestHeight := StretchedBitmap.Height;
  Scale := StretchedBitmap.Width / SourceBitmap.Width;
  SetLength(ScanLines, SourceBitmap.Height);
  for DestY := 0 to DestHeight - 1 do
  begin
    DistFromStart := DestY / Scale;
    SourceYStart := Round(DistFromSTart);
    YWeights[1] := DistFromStart - SourceYStart;
    if YWeights[1] < 0 then
      YWeights[1] := 0;
    YWeights[0] := 1 - YWeights[1];

    DestLine := StretchedBitmap.ScanLine[DestY];
    for DestX := 0 to DestWidth - 1 do
    begin
      { Calculate the RGB value at this destination pixel }
      DistFromStart := DestX / Scale;
      if DistFromStart > (SourceBitmap.Width - 1) then
        DistFromStart := SourceBitmap.Width - 1;
      SourceXStart := Round(DistFromStart);
      XWeights[1] := DistFromStart - SourceXStart;
      if XWeights[1] < 0 then
        XWeights[1] := 0;
      XWeights[0] := 1 - XWeights[1];

      { Average the four nearest pixels from the source mapped point }
      DestR := 0;
      DestB := 0;
      DestG := 0;
      DestA := 0;
      for AvgY := 0 to 1 do
      begin
        SourceYPos := SourceYStart + AvgY;
        if SourceYPos >= SourceBitmap.Height then
          SourceYPos := SourceBitmap.Height - 1;
        if ScanLines[SourceYPos] = nil then
          ScanLines[SourceYPos] := SourceBitmap.ScanLine[SourceYPos];
            CurrentLine := ScanLines[SourceYPos];

        for AvgX := 0 to 1 do
        begin
          if SourceXStart + AvgX >= SourceBitmap.Width then
            SourceXStart := SourceBitmap.Width - 1;

          ActualX := (SourceXStart + AvgX) * 4; { 4 bytes per pixel }

          { Calculate how heavy this pixel is based on how far away
            it is from the mapped pixel }
          PixelWeight := XWeights[AvgX] * YWeights[AvgY];
          DestR := DestR + CurrentLine[ActualX] * PixelWeight;
          DestB := DestB + CurrentLine[ActualX+1] * PixelWeight;
          DestG := DestG + CurrentLine[ActualX+2] * PixelWeight;
          DestA := DestA + CurrentLine[ActualX+3] * PixelWeight;
        end;
      end;

      ActualX := DestX * 4; { 4 bytes per pixel }
      DestLine[ActualX] := Round(DestR);
      DestLine[ActualX+1] := Round(DestB);
      DestLine[ActualX+2] := Round(DestG);
      DestLine[ActualX+3] := Round(DestA);
    end;
  end;
end;

procedure ScaleImage32(const SourceBitmap, ResizedBitmap: TBitmap;
  const ScaleAmount: Double);
var
  DestWidth, DestHeight: Integer;
begin
  DestWidth := Round(SourceBitmap.Width * ScaleAmount);
  DestHeight := Round(SourceBitmap.Height * ScaleAmount);
  SourceBitmap.PixelFormat := pf32bit;

  ResizedBitmap.Width := DestWidth;
  ResizedBitmap.Height := DestHeight;
  //ResizedBitmap.Canvas.Brush.Color := Vcl.Graphics.clNone;
  //ResizedBitmap.Canvas.FillRect(Rect(0, 0, DestWidth, DestHeight));
  ResizedBitmap.PixelFormat := pf32bit;

  if ResizedBitmap.Width < SourceBitmap.Width then
    ShrinkImage32(SourceBitmap, ResizedBitmap, ScaleAmount)
  else
    EnlargeImage32(SourceBitmap, ResizedBitmap, ScaleAmount);
end;


end.
