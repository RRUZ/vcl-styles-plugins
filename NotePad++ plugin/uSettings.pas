//**************************************************************************************************
//
// Unit uSettings
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
// The Original Code is  uSettings.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
//
// Portions created by Rodrigo Ruz V. are Copyright (C) 2014-2021 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************


unit uSettings;

interface

uses
  Winapi.Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NppForms, StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.Styles.Ext;

type
  TSettingsForm = class(TNppForm)
    BtnOK: TButton;
    Label9: TLabel;
    ComboBoxVCLStyle: TComboBox;
    PanelPreview: TPanel;
    BtnCancel: TButton;
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxVCLStyleChange(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    FPreview:TVclStylesPreview;
    procedure  LoadStyles;
    procedure DrawSeletedVCLStyle;
    procedure RefreshStyle;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses

  Vcl.Themes,
  ShellAPi,
  Vcl.Styles.Npp,
  uMisc;

type
 TVclStylesPreviewClass = class(TVclStylesPreview);

procedure TSettingsForm.BtnCancelClick(Sender: TObject);
begin
  inherited;
  Close();
end;

procedure TSettingsForm.BtnOKClick(Sender: TObject);
begin
  inherited;
  if not SameText(ComboBoxVCLStyle.Text, TVCLStylesNppPlugin(Npp).Settings.VclStyle) then
  if MessageBox(Handle, 'Do you want apply the changes?'+sLineBreak+'Note: You must restart Notepad++ to get better results', 'Question', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    TVCLStylesNppPlugin(Npp).Settings.VclStyle:=ComboBoxVCLStyle.Text;
    WriteSettings(TVCLStylesNppPlugin(Npp).Settings, TVCLStylesNppPlugin(Npp).SettingsFileName);
    ReadSettings(TVCLStylesNppPlugin(Npp).Settings, TVCLStylesNppPlugin(Npp).SettingsFileName);
    TStyleManager.SetStyle(TVCLStylesNppPlugin(Npp).Settings.VclStyle);
    RefreshStyle;
  end;
end;

//function EnumChildProc(const hWindow: hWnd; const LParam: Winapi.Windows.LParam): boolean; stdcall;
//begin
//  InvalidateRect(hWindow, nil, False);
//  SendMessage(hWindow, WM_NCPAINT, 0, 0);
//  Result:= True;
//end;

procedure TSettingsForm.RefreshStyle;
begin
 //EnumChildWindows(Npp.NppData.NppHandle, @EnumChildProc, 0);
 ShowWindow(Npp.NppData.NppHandle, SW_MINIMIZE);
 ShowWindow(Npp.NppData.NppHandle, SW_RESTORE);
end;

procedure TSettingsForm.ComboBoxVCLStyleChange(Sender: TObject);
begin
  inherited;
  DrawSeletedVCLStyle;
end;

procedure TSettingsForm.DrawSeletedVCLStyle;
var
  StyleName: string;
  LStyle: TCustomStyleServices;
begin
   StyleName:=ComboBoxVCLStyle.Text;
   if (StyleName<>'') and (not SameText(StyleName, 'Windows')) then
   begin
     TStyleManager.StyleNames;//call DiscoverStyleResources
     LStyle:=TStyleManager.Style[StyleName];
     FPreview.Caption:=StyleName;
     FPreview.Style:=LStyle;
     TVclStylesPreviewClass(FPreview).Paint;
   end;
end;


procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  inherited;
  FPreview:=TVclStylesPreview.Create(Self);
  FPreview.Parent:=PanelPreview;
  FPreview.BoundsRect := PanelPreview.ClientRect;

  LoadStyles;
  ComboBoxVCLStyle.ItemIndex:=ComboBoxVCLStyle.Items.IndexOf(TVCLStylesNppPlugin(Npp).Settings.VCLStyle);
  DrawSeletedVCLStyle;
end;

procedure TSettingsForm.FormDestroy(Sender: TObject);
begin
  inherited;
  FPreview.Free;
end;

procedure TSettingsForm.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
   ShellAPI.ShellExecute(0, 'Open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

procedure TSettingsForm.LoadStyles;
var
  Style: string;
begin
  try
    ComboBoxVCLStyle.Items.BeginUpdate;
    ComboBoxVCLStyle.Items.Clear;
    for Style in TStyleManager.StyleNames do
      ComboBoxVCLStyle.Items.Add(Style);
  finally
    ComboBoxVCLStyle.Items.EndUpdate;
  end;
end;




end.
