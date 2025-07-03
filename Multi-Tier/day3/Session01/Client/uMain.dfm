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
  object btnSendFile: TButton
    Left = 224
    Top = 8
    Width = 99
    Height = 25
    Caption = #54028#51068#51204#49569
    TabOrder = 0
    OnClick = btnSendFileClick
  end
  object eLogs: TMemo
    Left = 16
    Top = 136
    Width = 585
    Height = 297
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnDisconnect: TButton
    Left = 113
    Top = 8
    Width = 96
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 2
    OnClick = btnDisconnectClick
  end
  object btnConnect: TButton
    Left = 8
    Top = 8
    Width = 99
    Height = 25
    Caption = 'Connect'
    TabOrder = 3
    OnClick = btnConnectClick
  end
  object Button1: TButton
    Left = 329
    Top = 8
    Width = 75
    Height = 25
    Caption = #45796#50868#47196#46300
    TabOrder = 4
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 48
    Width = 585
    Height = 33
    Smooth = True
    Step = 1
    TabOrder = 5
  end
end
