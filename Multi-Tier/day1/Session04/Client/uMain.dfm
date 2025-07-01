object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DataSnap Client'
  ClientHeight = 572
  ClientWidth = 1051
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
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
    Width = 72
    Height = 15
    Caption = #51217#49549#48708#48128#48264#54840
  end
  object eUserID: TEdit
    Left = 96
    Top = 21
    Width = 505
    Height = 23
    TabOrder = 0
    Text = 'USER01'
  end
  object eLogs: TMemo
    Left = 16
    Top = 120
    Width = 585
    Height = 81
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnDisconnect: TButton
    Left = 505
    Top = 79
    Width = 96
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 2
    OnClick = btnDisconnectClick
  end
  object btnConnect: TButton
    Left = 400
    Top = 79
    Width = 99
    Height = 25
    Caption = 'Connect'
    TabOrder = 3
    OnClick = btnConnectClick
  end
  object ePassword: TEdit
    Left = 96
    Top = 50
    Width = 505
    Height = 23
    PasswordChar = '*'
    TabOrder = 4
    Text = 'P@55w0rd!@'
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = ClientDataSet1
    Left = 48
    Top = 232
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 296
  end
end
