object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DataSnap Client'
  ClientHeight = 621
  ClientWidth = 997
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  Menu = MainMenu1
  TextHeight = 15
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 997
    Height = 29
    ButtonHeight = 23
    ButtonWidth = 43
    ShowCaptions = True
    TabOrder = 0
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Action = acExit
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 602
    Width = 997
    Height = 19
    Panels = <>
    ExplicitLeft = 504
    ExplicitTop = 328
    ExplicitWidth = 0
  end
  object MainMenu1: TMainMenu
    Left = 48
    Top = 152
    object F1: TMenuItem
      Caption = #54028#51068'(&F)'
      object X1: TMenuItem
        Action = acExit
      end
    end
    object C1: TMenuItem
      Caption = #49324#50857#51088#44288#47532'(&C)'
      object L1: TMenuItem
        Caption = #49324#50857#51088' '#47532#49828#53944' '#51312#54924'(&L)'
      end
    end
  end
  object ActionList1: TActionList
    Left = 48
    Top = 224
    object acExit: TAction
      Caption = #45149#45236#44592
      Enabled = False
      ShortCut = 32856
      OnExecute = acExitExecute
    end
  end
end
