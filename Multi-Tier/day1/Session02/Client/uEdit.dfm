object frmEditUser: TfrmEditUser
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #49324#50857#51088' '#49688#51221
  ClientHeight = 188
  ClientWidth = 602
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 75
    Height = 15
    Caption = #49324#50857#51088' '#50500#51060#46356
  end
  object Label2: TLabel
    Left = 24
    Top = 53
    Width = 24
    Height = 15
    Caption = #49457#47749
  end
  object Label3: TLabel
    Left = 24
    Top = 82
    Width = 75
    Height = 15
    Caption = #51217#49549' '#48708#48128#48264#54840
  end
  object Label4: TLabel
    Left = 24
    Top = 111
    Width = 63
    Height = 15
    Caption = #49324#50857#51088' '#46321#44553
  end
  object eUserID: TDBEdit
    Left = 120
    Top = 21
    Width = 465
    Height = 23
    DataField = 'USR_ID'
    DataSource = DataSource1
    TabOrder = 0
  end
  object eUserName: TDBEdit
    Left = 120
    Top = 50
    Width = 465
    Height = 23
    DataField = 'USR_NM'
    DataSource = DataSource1
    TabOrder = 1
  end
  object eUserPassword: TDBEdit
    Left = 120
    Top = 79
    Width = 465
    Height = 23
    DataField = 'USR_PW'
    DataSource = DataSource1
    TabOrder = 2
  end
  object eUserLevel: TDBEdit
    Left = 120
    Top = 108
    Width = 465
    Height = 23
    DataField = 'USR_LVL'
    DataSource = DataSource1
    TabOrder = 3
  end
  object btnOk: TButton
    Left = 429
    Top = 152
    Width = 75
    Height = 25
    Caption = #51200#51109
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 510
    Top = 152
    Width = 75
    Height = 25
    Caption = #52712#49548
    ModalResult = 2
    TabOrder = 5
  end
  object DataSource1: TDataSource
    DataSet = DM.cdsUser
    Left = 16
    Top = 144
  end
end
