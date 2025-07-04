object LoginDialog: TLoginDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'LoginDialog'
  ClientHeight = 197
  ClientWidth = 395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 75
    Height = 15
    Caption = #49324#50857#51088' '#50500#51060#46356
  end
  object Label2: TLabel
    Left = 16
    Top = 53
    Width = 48
    Height = 15
    Caption = #48708#48128#48264#54840
  end
  object lbStatus: TLabel
    Left = 8
    Top = 174
    Width = 377
    Height = 15
    AutoSize = False
  end
  object eUserID: TEdit
    Left = 96
    Top = 21
    Width = 289
    Height = 23
    MaxLength = 20
    TabOrder = 0
    TextHint = #49324#50857#51088' '#50500#51060#46356#47484' '#51077#47141#54616#49464#50836
  end
  object ePassword: TEdit
    Left = 96
    Top = 50
    Width = 289
    Height = 23
    MaxLength = 12
    PasswordChar = '*'
    TabOrder = 1
    TextHint = #48708#48128#48264#54840#47484' '#51077#47141#54616#49464#50836
  end
  object btnOk: TButton
    Left = 229
    Top = 104
    Width = 75
    Height = 25
    Caption = #54869#51064
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 310
    Top = 104
    Width = 75
    Height = 25
    Caption = #52712#49548
    ModalResult = 2
    TabOrder = 3
  end
end
