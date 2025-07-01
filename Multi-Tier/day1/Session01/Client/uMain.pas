unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,

  ClientModuleUnit1;

type
  TfrmMain = class(TForm)
    eParams: TEdit;
    btnEcho: TButton;
    btnReverse: TButton;
    eLogs: TMemo;
    btnDisconnect: TButton;
    btnConnect: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnEchoClick(Sender: TObject);
    procedure btnReverseClick(Sender: TObject);
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
  ClientModule1.SQLConnection1.Connected := True;
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
  ClientModule1.SQLConnection1.Connected := False;
end;

procedure TfrmMain.btnEchoClick(Sender: TObject);
begin
  var LText := eParams.Text;
  var LResult := ClientModule1.ServerMethods1Client.EchoString(LText);

  Log(LResult);
end;

procedure TfrmMain.btnReverseClick(Sender: TObject);
begin
  var LText := eParams.Text;
  var LResult := ClientModule1.ServerMethods1Client.ReverseString(LText);

  Log(LResult);
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
end;

procedure TfrmMain.TriggerDisconnect(Sender: TObject);
begin
  Log('연결이 끊어졌습니다');
end;

end.
