object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 517
  ClientWidth = 857
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Memo1: TMemo
    Left = 40
    Top = 80
    Width = 401
    Height = 257
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 40
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 120
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 200
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 3
    OnClick = Button3Click
  end
end
