object LoginDialog: TLoginDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #47196#44536#51064
  ClientHeight = 202
  ClientWidth = 395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object lbUserID: TLabel
    Left = 16
    Top = 24
    Width = 75
    Height = 15
    Caption = #49324#50857#51088' '#50500#51060#46356
  end
  object lbPassword: TLabel
    Left = 16
    Top = 53
    Width = 48
    Height = 15
    Caption = #48708#48128#48264#54840
  end
  object lbStatus: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 181
    Width = 379
    Height = 15
    Margins.Left = 8
    Margins.Right = 8
    Margins.Bottom = 6
    Align = alBottom
    AutoSize = False
    ExplicitTop = 174
    ExplicitWidth = 377
  end
  object eUserID: TEdit
    Left = 104
    Top = 21
    Width = 281
    Height = 23
    MaxLength = 20
    TabOrder = 0
    TextHint = #49324#50857#51088' '#50500#51060#46356#47484' '#51077#47141#54616#49464#50836
  end
  object ePassword: TEdit
    Left = 104
    Top = 50
    Width = 281
    Height = 23
    MaxLength = 12
    PasswordChar = '*'
    TabOrder = 1
    TextHint = #48708#48128#48264#54840#47484' '#51077#47141#54616#49464#50836
  end
  object btnOk: TButton
    Left = 231
    Top = 136
    Width = 75
    Height = 25
    Caption = #54869#51064
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 312
    Top = 136
    Width = 75
    Height = 25
    Caption = #52712#49548
    ModalResult = 2
    TabOrder = 3
  end
  object eSaveUserID: TCheckBox
    Left = 104
    Top = 88
    Width = 137
    Height = 17
    Caption = #49324#50857#51088' '#50500#51060#46356#47484' '#51200#51109
    TabOrder = 4
  end
end
