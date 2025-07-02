unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,
  System.NetEncoding,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg,

  uPacket,
  uClient;

type
  TfrmMain = class(TForm)
    btnLogin: TButton;
    btnLogOut: TButton;
    eLogs: TMemo;
    btnDisconnect: TButton;
    btnConnect: TButton;
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    Button3: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnLogOutClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
//  ClientModule1.SQLConnection1.AfterConnect := TriggerConnect;
//  ClientModule1.SQLConnection1.AfterDisconnect := TriggerDisconnect;
end;

destructor TfrmMain.Destroy;
begin
  inherited;
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
  ClientModule.Connect(
    procedure(ASuccess: Boolean)
    const
      STATES: array[Boolean] of string = ('연결실패', '연결성공');
    begin
      Log(STATES[ASuccess]);
    end
  );
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
  ClientModule.Disconnect(
    procedure
    begin
      Log('연결이 끊어졌습니다');
    end
  );
end;

procedure TfrmMain.btnLoginClick(Sender: TObject);
begin
  ClientModule.Login('user011', 'P@55w0rd!@',
    procedure(AResponse: IResponse)
    begin
      Log(AResponse.ToString);
    end
  );
end;

procedure TfrmMain.btnLogOutClick(Sender: TObject);
begin
  ClientModule.Logout;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  LRequest := TRequest.Create('System', 'ServerTime');
  ClientModule.Execute(LRequest, LResponse,
    procedure(AResponse: IResponse)
    begin
      var LDateTime: TDateTime := AResponse.Content.D['servertime'];
      Log('서버시간: %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', LDateTime)]);
    end
  );
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  LRequest := TRequest.Create('User', 'UserList');
  LRequest.Params.I['seq'] := 15;

  ClientModule.Execute(LRequest, LResponse,
    procedure(AResponse: IResponse)
    begin
      Log(AResponse.ToString);
    end
  );
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  LRequest := TRequest.Create('User', 'GetPicture');
  LRequest.Params.S['usr_id'] := 'user01';

  ClientModule.Execute(LRequest, LResponse,
    procedure(AResponse: IResponse)
    begin
      var LBuffer := TNetEncoding.Base64String.DecodeStringToBytes(AResponse.Content.S['image']);
      var LStream := TBytesStream.Create(LBuffer);
      try
        Image1.Picture.LoadFromStream(LStream);
      finally
        LStream.Free;
      end;
      Log(AResponse.ToString);
    end
  );
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
