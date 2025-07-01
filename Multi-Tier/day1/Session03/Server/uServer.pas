unit uServer;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Classes,

  Datasnap.DSCommonServer,
  Datasnap.DSSession,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,

  ServerContainerUnit1;

type
  TfrmMain = class(TForm)
    lbPort: TLabel;
    ePort: TEdit;
    btnStart: TButton;
    eLogs: TMemo;
    btnStop: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    procedure Log(const AMessage: string); overload;
    procedure Log(const AMessage: string; const AParams: array of const); overload;
    procedure TriggerConnect(DSConnectEventObject: TDSConnectEventObject);
    procedure TriggerDisconnect(DSConnectEventObject: TDSConnectEventObject);
    procedure TriggerStart(Sender: TObject; const AStarted: Boolean);
    procedure TriggerStop(Sender: TObject);
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

  // 서버 시작, 중지
  ServerContainer1.OnStart := TriggerStart;
  ServerContainer1.OnStop := TriggerStop;

  // 클라이언트
  ServerContainer1.DSServer1.OnConnect := TriggerConnect;
  ServerContainer1.DSServer1.OnDisconnect := TriggerDisconnect;
end;

destructor TfrmMain.Destroy;
begin
  ServerContainer1.Stop;

  inherited;
end;

procedure TfrmMain.Log(const AMessage: string; const AParams: array of const);
begin
  Log(Format(AMessage, AParams));
end;

procedure TfrmMain.Log(const AMessage: string);
begin
  TThread.Queue(
    nil,
    procedure
    begin
      eLogs.Lines.Add(Format('[%s] %s', [FormatDateTime('hh:nn:ss.zzz', Now), AMessage]));
    end
  );
end;

procedure TfrmMain.TriggerConnect(DSConnectEventObject: TDSConnectEventObject);
begin
  var LClientID := DSConnectEventObject.ChannelInfo.Id;
  var LProtocol := DSConnectEventObject.ChannelInfo.ClientInfo.Protocol;
  var LPeerIP := DSConnectEventObject.ChannelInfo.ClientInfo.IpAddress;
  var LPeerPort := DSConnectEventObject.ChannelInfo.ClientInfo.ClientPort;

  Log('Client Connected. ID: %d Protocol: %s IP: %s Port: %s', [LClientID, LProtocol, LPeerIP, LPeerPort]);

  TDSSessionManager.GetThreadSession.PutData('peer_ip', LPeerIP);
  TDSSessionManager.GetThreadSession.PutData('peer_port', LPeerPort);
end;

procedure TfrmMain.TriggerDisconnect(DSConnectEventObject: TDSConnectEventObject);
begin
  var LClientID := DSConnectEventObject.ChannelInfo.Id;
  var LProtocol := DSConnectEventObject.ChannelInfo.ClientInfo.Protocol;
  var LPeerIP := DSConnectEventObject.ChannelInfo.ClientInfo.IpAddress;
  var LPeerPort := DSConnectEventObject.ChannelInfo.ClientInfo.ClientPort;

  Log('Client Disconnected. ID: %d Protocol: %s IP: %s Port: %s', [LClientID, LProtocol, LPeerIP, LPeerPort]);
end;

procedure TfrmMain.TriggerStart(Sender: TObject; const AStarted: Boolean);
const
  BOOL_STR: array[Boolean] of string = ('실패', '성공');
begin
  Log('Server Started: %s', [BOOL_STR[AStarted]]);
end;

procedure TfrmMain.TriggerStop(Sender: TObject);
begin
  Log('Server Stopped');
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  ServerContainer1.Start(StrToIntDef(ePort.Text, 211));
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  ServerContainer1.Stop;
end;

end.
