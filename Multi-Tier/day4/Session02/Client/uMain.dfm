object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DataSnap Client'
  ClientHeight = 441
  ClientWidth = 612
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Image1: TImage
    Left = 539
    Top = 21
    Width = 65
    Height = 65
    Stretch = True
  end
  object btnLogin: TButton
    Left = 232
    Top = 21
    Width = 99
    Height = 25
    Caption = #47196#44536#51064
    TabOrder = 0
    OnClick = btnLoginClick
  end
  object btnLogOut: TButton
    Left = 337
    Top = 21
    Width = 96
    Height = 25
    Caption = #47196#44536#50500#50883
    TabOrder = 1
    OnClick = btnLogOutClick
  end
  object eLogs: TMemo
    Left = 19
    Top = 92
    Width = 585
    Height = 341
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object btnDisconnect: TButton
    Left = 121
    Top = 21
    Width = 96
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 3
    OnClick = btnDisconnectClick
  end
  object btnConnect: TButton
    Left = 16
    Top = 21
    Width = 99
    Height = 25
    Caption = 'Connect'
    TabOrder = 4
    OnClick = btnConnectClick
  end
  object Button1: TButton
    Left = 440
    Top = 21
    Width = 75
    Height = 25
    Caption = #49436#48260#49884#44036
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 56
    Width = 99
    Height = 25
    Caption = #49324#50857#51088' '#47532#49828#53944
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 120
    Top = 56
    Width = 97
    Height = 25
    Caption = #49324#51652#48155#44592
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 232
    Top = 56
    Width = 99
    Height = 25
    Caption = #49436#48708#49828' '#47785#47197
    TabOrder = 8
    OnClick = Button4Click
  end
end
