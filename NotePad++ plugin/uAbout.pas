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
  Dialogs, NppForms, StdCtrls, Vcl.ExtCtrls;

type
  TAboutForm = class(TNppForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
