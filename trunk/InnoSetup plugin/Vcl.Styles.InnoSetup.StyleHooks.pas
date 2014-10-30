//**************************************************************************************************
//
// Unit Vcl.Styles.InnoSetup.StyleHooks
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
// The Original Code is  Vcl.Styles.InnoSetup.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
//
// Portions created by Rodrigo Ruz V. are Copyright (C) 2013-2014 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************

unit Vcl.Styles.InnoSetup.StyleHooks;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.RichEdit,
  System.Classes,
  System.SysUtils,
  Vcl.Styles,
  Vcl.Themes,
  Vcl.Graphics,
  Vcl.Forms,
  Vcl.Styles.Utils.Forms,
  Vcl.Styles.Utils.SysStyleHook,
  Vcl.Styles.Utils.StdCtrls,
  Vcl.Styles.Utils.ComCtrls,
  Vcl.GraphUtil,
  Vcl.Controls;

type
  TRichEditViewerStyleHook = class(TSysScrollingStyleHook)
  private
    procedure EMSetBkgndColor(var Message: TMessage); message EM_SETBKGNDCOLOR;
    procedure EMSetCharFormat(var Message: TMessage); message EM_SETCHARFORMAT;
  protected
    function GetBorderSize: TRect; override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AHandle: THandle); override;
    Destructor Destroy; override;
  end;

  TPanelComponentStyleHook = class(TSysScrollingStyleHook)
  strict protected
    procedure PaintBackground(Canvas: TCanvas); override;
  public
    constructor Create(AHandle: THandle); override;
  end;

  TLabelComponentStyleHook = class(TSysStyleHook)
  strict protected
    procedure PaintBackground(Canvas: TCanvas); override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AHandle: THandle); override;
  end;

  TNewCheckListBoxStyleHook = class(TSysScrollingStyleHook)
  protected
    function GetBorderSize: TRect; override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AHandle: THandle); override;
    Destructor Destroy; override;
  end;

  TNewButtonStyleHook = class(TSysButtonStyleHook)
  protected
    function CheckIfParentBkGndPainted: Boolean; override;
  end;

  TNewMemoStyleHook = class(TSysMemoStyleHook)
  public
    constructor Create(AHandle: THandle); override;
  end;

  TWizardFormStyleHook = class(TSysDialogStyleHook)
  private
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
  public
    constructor Create(AHandle: THandle); override;
  end;

  TNewListBoxStyleHook = class(TSysListBoxStyleHook)
  public
    constructor Create(AHandle: THandle); override;
  end;

  TFolderTreeViewStyleHook = class(TSysTreeViewStyleHook)
  public
    constructor Create(AHandle: THandle); override;
  end;

implementation

uses
 Vcl.Styles.Utils.SysControls;

{ TRichEditViewerStyleHook }

constructor TRichEditViewerStyleHook.Create(AHandle: THandle);
begin
  inherited;
  HookedDirectly := True;
  OverridePaint := False;
  OverridePaintNC := True;
  OverrideFont := False;
end;

destructor TRichEditViewerStyleHook.Destroy;
begin
  inherited;
end;

procedure TRichEditViewerStyleHook.EMSetBkgndColor(var Message: TMessage);
begin
  Message.LParam := ColorToRGB(StyleServices.GetStyleColor(scEdit));
  Handled := False;
end;

procedure TRichEditViewerStyleHook.EMSetCharFormat(var Message: TMessage);
type
  PCharFormat2 = ^TCharFormat2;
const
  TextColor: array[Boolean] of TStyleFont = (sfEditBoxTextDisabled, sfEditBoxTextNormal);
  BkColor: array[Boolean] of TStyleColor = (scEditDisabled, scEdit);
var
  Format: PCharFormat2;
begin
  Format := PCharFormat2(Message.LParam);
  if (Format.dwMask and CFM_COLOR = CFM_COLOR) then
  begin
    Format.crTextColor := ColorToRGB(StyleServices.GetStyleFontColor(TextColor[SysControl.Enabled]));
    Format.crBackColor := ColorToRGB(StyleServices.GetStyleColor(BkColor[SysControl.Enabled]));
    Format.dwEffects := Format.dwEffects and not CFE_AUTOCOLOR;
  end;
  Handled := False;
end;


function TRichEditViewerStyleHook.GetBorderSize: TRect;
begin
  Result := inherited GetBorderSize;
  if (SysControl.HasBorder) then
      Result := Rect(2, 2, 2, 2);
end;

procedure TRichEditViewerStyleHook.WndProc(var Message: TMessage);
begin
  inherited;
end;

{ TNewCheckListBoxStyleHook }

constructor TNewCheckListBoxStyleHook.Create(AHandle: THandle);
begin
  inherited;
  HookedDirectly:=True;
  OverridePaint := False;
  OverridePaintNC := True;
  OverrideFont := False;
end;

destructor TNewCheckListBoxStyleHook.Destroy;
begin

  inherited;
end;

function TNewCheckListBoxStyleHook.GetBorderSize: TRect;
begin
  Result := inherited GetBorderSize;
  if (SysControl.HasBorder) then
      Result := Rect(2, 2, 2, 2);
end;

procedure TNewCheckListBoxStyleHook.WndProc(var Message: TMessage);
begin
  inherited;
end;

{ TNewButtonStyleHook }

function TNewButtonStyleHook.CheckIfParentBkGndPainted: Boolean;
begin
  Result := True;
end;

{ TNewMemo }

constructor TNewMemoStyleHook.Create(AHandle: THandle);
begin
  inherited;
  HookedDirectly := True;
end;

{ TSetupForm }

constructor TWizardFormStyleHook.Create(AHandle: THandle);
begin
  inherited;
  HookedDirectly := True;
end;


procedure TWizardFormStyleHook.WMNCLButtonDown(var Message: TWMNCLButtonDown);
var
  P: TPoint;
begin
  Handled := False;
  if (not StyleServicesEnabled) or (not OverridePaintNC) then
    Exit;

  if OverridePaintNC then
  begin
    if (Message.HitTest = HTCLOSE) or (Message.HitTest = HTMAXBUTTON) or (Message.HitTest = HTMINBUTTON) or (Message.HitTest = HTHELP) then
    begin
      PressedButton := Message.HitTest;
      InvalidateNC;
      SetRedraw(False);
      Message.Result := CallDefaultProc(TMessage(Message));
      SetRedraw(True);
      PressedButton := 0;
      HotButton := 0;
      InvalidateNC;
      GetCursorPos(P);
      P := NormalizePoint(P);

      case Message.HitTest of
        HTCLOSE:
          if CloseButtonRect.Contains(P) then
              Close;
        HTMAXBUTTON:
          begin
            if MaxButtonRect.Contains(P) then
            begin
              if WindowState = wsMaximized then
                Restore
              else
                Maximize;
            end;
          end;
        HTMINBUTTON:
          if MinButtonRect.Contains(P) then
            Minimize;
        HTHELP:
          if HelpButtonRect.Contains(P) then
            Help;
      end;
    end
    else
    begin
      inherited;
      Handled := True;
      Exit;
    end;
    Handled := True;
  end;
end;

{ TNewListBox }

constructor TNewListBoxStyleHook.Create(AHandle: THandle);
begin
  inherited;
  HookedDirectly := True;
end;

{ TFolderTreeView }

constructor TFolderTreeViewStyleHook.Create(AHandle: THandle);
begin
  inherited;
  HookedDirectly := True;
end;


{ TPanelComponentStyleHook }

constructor TPanelComponentStyleHook.Create(AHandle: THandle);
begin
  inherited;
  OverrideEraseBkgnd := True;
  OverrideFont:=True;
  HookedDirectly := True;
end;

procedure TPanelComponentStyleHook.PaintBackground(Canvas: TCanvas);
begin
  Canvas.Brush.Color := StyleServices.GetStyleColor(scPanel);
  Canvas.FillRect(SysControl.ClientRect);
end;

{ TLabelComponentStyleHook }
constructor TLabelComponentStyleHook.Create(AHandle: THandle);
begin
  inherited;
  OverrideEraseBkgnd := True;
  OverrideFont:=True;
  //Addlog('TLabelComponentStyleHook.Create');
  SetTextColor(GetWindowDC(Handle), ColorToRGB(clWhite));
 // HookedDirectly := True;
end;

procedure TLabelComponentStyleHook.PaintBackground(Canvas: TCanvas);
begin
  Canvas.Brush.Color := StyleServices.GetStyleColor(scPanel);
  Canvas.FillRect(SysControl.ClientRect);
end;

procedure TLabelComponentStyleHook.WMPaint(var Message: TWMPaint);
begin
    //SetTextColor(TWMPaint(Message).DC, ColorToRGB(clWhite));
   //SetTextColor(TWMPaint(Message).DC, ColorToRGB(StyleServices.GetSystemColor(clWindowText)));
   Message.Result := CallDefaultProc(TMessage(Message));
   Handled := False;
end;



procedure TLabelComponentStyleHook.WndProc(var Message: TMessage);
//var
// LHDC : HDC;
begin
  //Addlog(WM_To_String(Message.Msg));
  inherited;
//  if Message.Msg=WM_SETFONT then
//  begin
//     //TWMSetFont(Message).
//    //  Message.WParam
//
//   //UpdateColors;
//     LHDC:=GetWindowDC(Handle);
//     Addlog('Handle '+IntToHex(Handle, 8)+' HDC '+IntToHex(LHDC, 8));
//
//
//     //Message.Result := CallDefaultProc(TMessage(Message));
//     //SetTextColor(GetWindowDC(Handle), ColorToRGB(clWhite));
//
//  end;
end;

end.
