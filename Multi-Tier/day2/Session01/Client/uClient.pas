unit uClient;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.NetEncoding,
  System.Hash,

  Data.DB,
  Data.DBXCommon,
  Data.DBXClient,
  Data.DBXDataSnap,
  Data.DBXJSON,
  Data.SqlExpr,
  Data.DBXDBReaders,
  Data.DBXCDSReaders,
  Data.DBXJSONReflect,

  IPPeerClient,

  Datasnap.DSProxy,

  uPacket;
{$ENDREGION}

type
  TClient = class(TDSAdminClient)
  private
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;

    procedure Call(ARequest: IRequest; out AResponse: IResponse);
  end;

  TUserInfo = class
  private
    FUserID: string;
    FUserName: string;
    FPassword: string;
    FLevel: Integer;
  public
    constructor Create;

    procedure Clear;

    property UserID: string read FUserID write FUserID;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property Level: Integer read Flevel write FLevel;
  end;

  TLogLevel = (
   llInfo,
   llDebug,
   llError,
   llFatal
  );
  TLogLevels = set of TLogLevel;

  TLogEvent = procedure(Sender: TObject; const AMessage: string; const ALogLevel: TLogLevel) of object;

  TClientModule = class(TDataModule)
    Connection: TSQLConnection;
  private
    FClient: TClient;
    FLogLevels: TLogLevels;
    FUserInfo: TUserInfo;

    FOnLog: TLogEvent;

    function  GetClient: TClient;
  protected
    procedure DoLog(const AMessage: string; const ALoglevel: TLoglevel);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect(const AProc: TProc<Boolean> = nil);
    procedure Disconnect(const AProc: TProc = nil);
    procedure Execute(ARequest: IRequest; out AResponse: IResponse; const AProc: TProc<IResponse> = nil);
    procedure Log(const AMessage: string; const ALogLevel: TLogLevel = llDebug); overload;
    procedure Log(const AMessage: string; const AParams: array of const; const ALogLevel: TLogLevel = llDebug); overload;
    procedure LogIn(const AProc: TProc<IResponse> = nil); overload;
    procedure LogIn(const AUserID, APassword: string; const AProc: TProc<IResponse> = nil); overload;
    procedure Logout(const AProc: TProc<IResponse> = nil);

    property Client: TClient read GetClient write FClient;
    property LogLevels: TLogLevels read FLogLevels write FLogLevels;
    property UserInfo: TUserInfo read FUserInfo;

    property OnLog: TLogEvent read FOnLog write FOnLog;
  end;

var
  ClientModule: TClientModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{$REGION 'TClient'}

constructor TClient.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

constructor TClient.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

destructor TClient.Destroy;
begin
  inherited;
end;

procedure TClient.Call(ARequest: IRequest; out AResponse: IResponse);
begin
  // DXCommand 생성
  var LCommand := FDBXConnection.CreateCommand;
  try
    try
      LCommand.CommandType := TDBXCommandTypes.DSServerMethod;
      LCommand.Text := ARequest.FullName;
      LCommand.Prepare;

      // 입력 파라메터
      LCommand.Parameters[0].Value.SetWideString(ARequest.Params.ToJSON);
      LCommand.ExecuteUpdate;

      // 리턴값
      var LResult := LCommand.Parameters[1].Value.GetWideString;

      AResponse := TResponse.Create(ARequest.Service, ARequest.Method, LResult);
    except
    end;
  finally
    LCommand.Free;
  end;
end;

{$ENDREGION}

{$REGION 'TUserInfo'}

constructor TUserInfo.Create;
begin
  Clear;
end;

procedure TUserInfo.Clear;
begin
  FUserID := '';
  FUserName := '';
  FPassword := '';
  FLevel := 0;
end;

{$ENDREGION}

{$REGION 'TClientModule'}

constructor TClientModule.Create(AOwner: TComponent);
begin
  inherited;

  {$IFDEF DEBUG}
  FLogLevels := [llInfo, llDebug, llError, llFatal];
  {$ELSE}
  FLogLevels := [llError, llFatal];
  {$ENDIF}
  FUserInfo := TUserInfo.Create;
end;

destructor TClientModule.Destroy;
begin
  FClient.Free;
  FUserInfo.Free;

  inherited;
end;

procedure TClientModule.Connect(const AProc: TProc<Boolean>);
begin
  try
    Connection.Connected := True;
    if Assigned(AProc) then
      AProc(Connection.Connected);
  except

  end;
end;

procedure TClientModule.Disconnect(const AProc: TProc);
begin
  try
    Connection.Connected := False;
    if Assigned(AProc) then
      AProc();
  except

  end;
end;

procedure TClientModule.DoLog(const AMessage: string; const ALoglevel: TLoglevel);
begin
  if Assigned(FOnLog) then
    FOnLog(Self, AMessage, ALogLevel);
end;

procedure TClientModule.Execute(ARequest: IRequest; out AResponse: IResponse; const AProc: TProc<IResponse>);
begin
  Client.Call(ARequest, AResponse);
  if Assigned(AProc) then
    AProc(AResponse);
end;

function TClientModule.GetClient: TClient;
begin
  if FClient = nil then
  begin
    Connection.Open;
    FClient := TClient.Create(Connection.DBXConnection, True);
  end;

  Result := FClient;
end;

procedure TClientModule.Log(const AMessage: string; const ALogLevel: TLogLevel);
begin
  DoLog(AMessage, ALogLevel);
end;

procedure TClientModule.Log(const AMessage: string; const AParams: array of const; const ALogLevel: TLogLevel);
begin
  Log(Format(AMessage, AParams), ALogLevel);
end;

procedure TClientModule.LogIn(const AUserID, APassword: string; const AProc: TProc<IResponse>);
begin
  FUserInfo.UserID := AUserID;
  FUserInfo.Password := APassword;

  Login(AProc);
end;

procedure TClientModule.LogIn(const AProc: TProc<IResponse>);
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  LRequest := TRequest.Create('User', 'Login');

  LRequest.Params.AddPair('id', FUserInfo.UserID);
  LRequest.Params.AddPair('password', THashSHA2.GetHashString(FUserInfo.Password));

  Client.Call(LRequest, LResponse);

  if Assigned(AProc) then
    AProc(LResponse);
end;

procedure TClientModule.Logout(const AProc: TProc<IResponse>);
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  LRequest := TRequest.Create('User', 'Logout');

  LRequest.Params.AddPair('id', FUserInfo.UserID);

  Client.Call(LRequest, LResponse);

  if Assigned(AProc) then
    AProc(LResponse);
end;

{$ENDREGION}

end.
