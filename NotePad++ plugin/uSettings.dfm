inherited SettingsForm: TSettingsForm
  ActiveControl = BtnCancel
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 320
  ClientWidth = 402
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 408
  ExplicitHeight = 348
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 16
    Top = 14
    Width = 46
    Height = 13
    Caption = 'VCL Style'
  end
  object BtnOK: TButton
    Left = 8
    Top = 287
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = BtnOKClick
  end
  object ComboBoxVCLStyle: TComboBox
    Left = 16
    Top = 33
    Width = 234
    Height = 21
    Style = csDropDownList
    Sorted = True
    TabOrder = 1
    OnChange = ComboBoxVCLStyleChange
  end
  object PanelPreview: TPanel
    Left = 16
    Top = 60
    Width = 369
    Height = 213
    BevelOuter = bvNone
    TabOrder = 2
  end
  object BtnCancel: TButton
    Left = 89
    Top = 287
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = BtnCancelClick
  end
end
