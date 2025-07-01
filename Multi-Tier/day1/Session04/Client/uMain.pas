unit uMain;

interface

{$REGION 'USES'}
uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Classes,
  System.NetEncoding,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,

  ClientModuleUnit1, Data.DB, Datasnap.DBClient, Datasnap.Provider;
{$ENDREGION}

type
  TfrmMain = class(TForm)
    eUserID: TEdit;
    eLogs: TMemo;
    btnDisconnect: TButton;
    btnConnect: TButton;
    Label1: TLabel;
    ePassword: TEdit;
    Label2: TLabel;
    DataSetProvider1: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
  private
    procedure Log(const AMessage: string); overload;
    procedure Log(const AMessage: string; const AParams: array of const); overload;
    procedure TriggerConnect(Sender: TObject);
    procedure TriggerDisconnect(Sender: TObject);
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

  // 접속, 접속해지 이벤트 핸들러를 등록한다
  ClientModule1.SQLConnection1.AfterConnect := TriggerConnect;
  ClientModule1.SQLConnection1.AfterDisconnect := TriggerDisconnect;
end;

destructor TfrmMain.Destroy;
begin
  inherited;
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
  ClientModule1.Connect;
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
  ClientModule1.DisConnect;
end;

procedure TfrmMain.Log(const AMessage: string; const AParams: array of const);
begin
  Log(Format(AMessage, AParams));
end;

procedure TfrmMain.Log(const AMessage: string);
begin
  eLogs.Lines.Add(AMessage);
end;

procedure TfrmMain.TriggerConnect(Sender: TObject);
begin
  Log('연결되었습니다');

  var LUserID := eUserID.Text;
  var LPassword := ePassword.Text;
  var LMessage: string;

  var LResult := ClientModule1.UserService.Login(LUserID, LPassword);
  case LResult of
  0:
    begin
      Log('로그인 성공');
    end;
  1:
    begin
      LMessage := '아이디를 찾을 수 없습니다';
    end;
  2:
    begin
      LMessage := '비밀번호가 일치하지 않습니다';
    end;
  end;

  if LResult <> 0 then
  begin
    ClientModule1.Disconnect;
    Application.MessageBox(PChar(LMessage), '확인', MB_ICONEXCLAMATION or MB_OK);
  end;
end;

procedure TfrmMain.TriggerDisconnect(Sender: TObject);
begin
  Log('연결이 끊어졌습니다');
end;

end.
