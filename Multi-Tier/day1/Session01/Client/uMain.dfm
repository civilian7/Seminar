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
  object eParams: TEdit
    Left = 16
    Top = 24
    Width = 585
    Height = 23
    TabOrder = 0
  end
  object btnEcho: TButton
    Left = 232
    Top = 61
    Width = 99
    Height = 25
    Caption = 'Echo String'
    TabOrder = 1
    OnClick = btnEchoClick
  end
  object btnReverse: TButton
    Left = 337
    Top = 61
    Width = 96
    Height = 25
    Caption = 'Reverse String'
    TabOrder = 2
    OnClick = btnReverseClick
  end
  object eLogs: TMemo
    Left = 16
    Top = 103
    Width = 585
    Height = 330
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object btnDisconnect: TButton
    Left = 121
    Top = 61
    Width = 96
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 4
    OnClick = btnDisconnectClick
  end
  object btnConnect: TButton
    Left = 16
    Top = 61
    Width = 99
    Height = 25
    Caption = 'Connect'
    TabOrder = 5
    OnClick = btnConnectClick
  end
end
