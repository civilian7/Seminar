unit uMain;

interface

{$REGION 'USES'}
uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,
  System.NetEncoding,

  Data.DB,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg,

  DS.Packet,
  uClient, System.Actions, Vcl.ActnList, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Menus;
{$ENDREGION}

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    C1: TMenuItem;
    L1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    StatusBar1: TStatusBar;
    F1: TMenuItem;
    X1: TMenuItem;
    ActionList1: TActionList;
    acExit: TAction;
    procedure acExitExecute(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TfrmMain.Destroy;
begin
  inherited;
end;

procedure TfrmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

end.
