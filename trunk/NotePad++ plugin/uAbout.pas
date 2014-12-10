//**************************************************************************************************
//
// Unit uAbout
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
// The Original Code is  uAbout.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
//
// Portions created by Rodrigo Ruz V. are Copyright (C) 2014 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************

unit uAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NppForms, StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TAboutForm = class(TNppForm)
    Button1: TButton;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Image2: TImage;
    LabelVersion: TLabel;
    LinkLabel1: TLinkLabel;
    LinkLabel2: TLinkLabel;
    procedure FormCreate(Sender: TObject);
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  ShellAPi,
  uMisc;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  inherited;
  LabelVersion.Caption    := Format('Version %s', [GetFileVersion(GetModuleName())]);
end;

procedure TAboutForm.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
   ShellAPI.ShellExecute(0, 'Open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

end.
