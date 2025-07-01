object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DataSnap Server'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  TextHeight = 15
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 624
    Height = 29
    Caption = 'ToolBar1'
    TabOrder = 0
    ExplicitLeft = 248
    ExplicitTop = 224
    ExplicitWidth = 150
    object tsStart: TToolButton
      Left = 0
      Top = 0
      Caption = 'tsStart'
      ImageIndex = 0
      OnClick = tsStartClick
    end
    object tsStop: TToolButton
      Left = 23
      Top = 0
      Caption = 'tsStop'
      ImageIndex = 1
      OnClick = tsStopClick
    end
  end
  object eLogs: TMemo
    Left = 0
    Top = 29
    Width = 624
    Height = 412
    Align = alClient
    Lines.Strings = (
      'eLogs')
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
