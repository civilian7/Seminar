object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DataSnap Server'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lbPort: TLabel
    Left = 8
    Top = 24
    Width = 39
    Height = 15
    Caption = #54252#53944'(&P)'
  end
  object ePort: TEdit
    Left = 72
    Top = 21
    Width = 121
    Height = 23
    TabOrder = 0
    Text = '211'
  end
  object btnStart: TButton
    Left = 199
    Top = 20
    Width = 75
    Height = 25
    Caption = #49884#51089
    TabOrder = 1
    OnClick = btnStartClick
  end
  object eLogs: TMemo
    Left = 8
    Top = 61
    Width = 608
    Height = 372
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object btnStop: TButton
    Left = 280
    Top = 20
    Width = 75
    Height = 25
    Caption = #51473#51648
    TabOrder = 3
    OnClick = btnStopClick
  end
end
