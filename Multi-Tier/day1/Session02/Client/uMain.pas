unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DBXDataSnap, Data.DBXCommon,
  IPPeerClient, Datasnap.DBClient, Datasnap.DSConnect, Data.DB, Data.SqlExpr,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ToolWin, System.ImageList,
  Vcl.ImgList,

  uDM;

type
  TfrmMain = class(TForm)
    dsUser: TDataSource;
    DBGrid1: TDBGrid;
    ToolBar1: TToolBar;
    tbRefresh: TToolButton;
    ImageList1: TImageList;
    ToolButton2: TToolButton;
    tbInsert: TToolButton;
    tbEdit: TToolButton;
    tbDelete: TToolButton;
    procedure FormShow(Sender: TObject);
    procedure tbDeleteClick(Sender: TObject);
    procedure tbEditClick(Sender: TObject);
    procedure tbInsertClick(Sender: TObject);
    procedure tbRefreshClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uEdit;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  DM.Connect;
  DM.cdsUser.Open;
end;

procedure TfrmMain.tbDeleteClick(Sender: TObject);
begin
  var LResult := Application.MessageBox('삭제하시겠습니까?', '확인', MB_ICONEXCLAMATION or MB_YESNO);
  if LResult = ID_YES then
  begin
    DM.cdsUser.Delete;
    DM.cdsUser.ApplyUpdates(-1);
  end;
end;

procedure TfrmMain.tbEditClick(Sender: TObject);
begin
  DM.cdsuser.Edit;
  case TfrmEditUser.Execute of
  mrCancel:
    begin
      DM.cdsUser.Cancel;
    end;
  mrOk:
    begin
      DM.cdsuser.Post;
      DM.cdsUser.ApplyUpdates(-1);
    end;
  end;
end;

procedure TfrmMain.tbInsertClick(Sender: TObject);
begin
  dsUser.DataSet.Append;
  case TfrmEditUser.Execute of
  mrCancel:
    begin
      DM.cdsUser.Cancel;
    end;
  mrOk:
    begin
      DM.cdsuser.Post;
      if DM.cdsUser.ApplyUpdates(-1) = 0 then
        DM.cdsUser.Refresh;
    end;
  end;
end;

procedure TfrmMain.tbRefreshClick(Sender: TObject);
begin
  DM.cdsUser.Refresh;
end;

end.
