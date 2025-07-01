object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DataSnap Client'
  ClientHeight = 607
  ClientWidth = 1087
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object DBGrid1: TDBGrid
    Left = 0
    Top = 57
    Width = 1087
    Height = 550
    Align = alClient
    DataSource = dsUser
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 1087
    Height = 57
    ButtonHeight = 54
    ButtonWidth = 55
    EdgeBorders = [ebBottom]
    Images = ImageList1
    Indent = 4
    ShowCaptions = True
    TabOrder = 1
    object tbRefresh: TToolButton
      Left = 4
      Top = 0
      Caption = #49352#47196#44256#52840
      ImageIndex = 0
      OnClick = tbRefreshClick
    end
    object ToolButton2: TToolButton
      Left = 59
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object tbInsert: TToolButton
      Left = 67
      Top = 0
      Caption = #46321#47197
      ImageIndex = 1
      OnClick = tbInsertClick
    end
    object tbEdit: TToolButton
      Left = 122
      Top = 0
      Caption = #49688#51221
      ImageIndex = 2
      OnClick = tbEditClick
    end
    object tbDelete: TToolButton
      Left = 177
      Top = 0
      Caption = #49325#51228
      ImageIndex = 3
      OnClick = tbDeleteClick
    end
  end
  object dsUser: TDataSource
    AutoEdit = False
    DataSet = DM.cdsUser
    Left = 64
    Top = 376
  end
  object ImageList1: TImageList
    Height = 32
    Width = 32
    Left = 64
    Top = 304
  end
end
