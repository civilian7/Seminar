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
  System.Actions,
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
  Vcl.ActnList,
  Vcl.ComCtrls,
  Vcl.ToolWin,
  Vcl.Menus,

  DS.Packet,
  uGlobal,
  uClient;
{$ENDREGION}

type
  TFormClass = class of TForm;

  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    StatusBar1: TStatusBar;
    F1: TMenuItem;
    X1: TMenuItem;
    ActionList1: TActionList;
    acExit: TAction;
    acUserList: TAction;
  private
    procedure BuildMenu();
    procedure DoExecute(Sender: TObject);
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

  BuildMenu();
  StatusBar1.Panels[2].Text := TGlobal.UserID;
end;

destructor TfrmMain.Destroy;
begin
  inherited;
end;

type
  TMenuInfo = record
    Caption: string;
    Hint: string;
  end;

procedure TfrmMain.BuildMenu;
const
  MENUS: array[0..5] of TMenuInfo = (
    (Caption: '사용자 리스트1'; Hint: 'CM0001F01'),
    (Caption: '사용자 리스트2'; Hint: 'CM0001F02'),
    (Caption: '사용자 리스트3'; Hint: 'CM0001F02'),
    (Caption: '사용자 리스트4'; Hint: 'CM0001F02'),
    (Caption: '사용자 리스트5'; Hint: 'CM0001F02'),
    (Caption: '사용자 리스트6'; Hint: 'CM0001F06')
  );
begin
  // TODO: 서버에서 받아와야함
  var LMenu := TMenuItem.Create(MainMenu1);
  LMenu.Caption := '사용자관리(&U)';
  MainMenu1.Items.Add(LMenu);

  for var i := Low(MENUS) to High(MENUS) do
  begin
    var LSubMenu := TMenuItem.Create(MainMenu1);
    LSubMenu.Caption := MENUS[i].Caption;
    LSubMenu.Hint := MENUS[i].Hint;
    LSubMenu.OnClick := DoExecute;

    LMenu.Add(LSubMenu);
  end;
end;

procedure TfrmMain.DoExecute(Sender: TObject);
begin
  var LFormName := 'T' + TMenuItem(Sender).Hint;
  var LPersistentClass := FindClass(LFormName);

  if (LPersistentClass <> nil) then
    TFormClass(LPersistentClass).Create(Application)
  else
  begin
    ShowMessage(LFormName + '은(는) 등록되지 않았습니다');
  end;
end;

end.
