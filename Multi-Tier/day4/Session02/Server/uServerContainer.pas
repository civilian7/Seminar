unit uServerContainer;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.DateUtils,
  System.Rtti,

  Datasnap.DSTCPServerTransport,
  Datasnap.DSServer,
  Datasnap.DSCommonServer,
  Datasnap.DSAuth,
  Datasnap.DSNames,
  Datasnap.DSReflect,
  Datasnap.DSHTTPCommon,
  Datasnap.DSHTTP,
  Datasnap.DSSession,

  IPPeerServer,
  IPPeerAPI,

  DS.Json;
{$ENDREGION}

type
  ServiceAttribute = class(TCustomAttribute)
  private
    FName: string;
    FDescription: string;
  public
    constructor Create(const AName, ADescription: string);

    property Name: string read FName write FName;
    property Description: string read FDescription write FDescription;
  end;

  URIAttribute = class(TCustomAttribute)
  private
    FName: string;
    FDescription: string;
  public
    constructor Create(const AName, ADescription: string);

    property Name: string read FName write FName;
    property Description: string read FDescription write FDescription;
  end;

  TServerResource = class(TComponent)
  private
    FData: TJSONObject;
    FErrorCode: Integer;
    FErrorMessage: string;
    FParams: TJSONObject;

    function  GetErrorCode: Integer;
    function  GetErrorMessage: string;
    procedure SetErrorCode(const Value: Integer);
    procedure SetErrorMessage(const Value: string);
  protected
    procedure MakeParams(const AData: string); virtual;
    function  MakeResult(const ACompact: Boolean = True): string; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Data: TJSONObject read FData;
    property ErrorCode: Integer read GetErrorCode write SetErrorCode;
    property ErrorMessage: string read GetErrorMessage write SetErrorMessage;
    property Params: TJSONObject read FParams;
  end;

  TDynamicServerClass = class(TDSServerClass)
  private
    FPersistentClass: TPersistentClass;
  protected
    procedure CreateInstance(const CreateInstanceEventObject: TDSCreateInstanceEventObject); override;
    procedure DestroyInstance(const DestroyInstanceEventObject: TDSDestroyInstanceEventObject); override;
    function  GetDSClass: TDSClass; override;
    procedure Preparing(const PrepareEventObject: TDSPrepareEventObject); override;
  public
    constructor Create(AOwner: TComponent; AServer: TDSServer; AClass: TPersistentClass; const ALifeCycle: string = TDSLifeCycle.Invocation); reintroduce; overload;
    destructor Destroy; override;

    property PersistentClass: TPersistentClass read FPersistentClass;
  end;

  TLogLevel = (
    llInfo,
    llDebug,
    llError,
    llFatal
  );
  TLogLevels = set of TLogLevel;

  TServerTransport = (
    stTCPIP,
    stHTTP
  );
  TServerTransports = set of TServerTransport;

  TSessionData = class
  public
    ClientID: Integer;
    PeerIP: string;
    PeerPort: string;
    Protocol: string;
    ConnectedAt: TDateTime;
    Debugging: Boolean;
  end;

  TLogEvent = procedure(Sender: TObject; const AMessage: string; const ALogLevel: TLogLevel = llDebug) of object;
  TPrepareEvent = procedure(Sender: TObject; AResource: TDynamicServerClass; const PrepareEventObject: TDSPrepareEventObject) of object;

  TServerContainer = class(TComponent)
  strict private
    class var
      FInstance: TServerContainer;

    class destructor Destroy;

    class function GetInstance: TServerContainer; static;
  private
    FHttpTransport: TDSHTTPService;
    FLogLevels: TLogLevels;
    FResources: TList<TDynamicServerClass>;
    FServer: TDSServer;
    FServerTransports: TServerTransports;
    FTCPTransport: TDSTCPServerTransport;

    FOnLog: TLogEvent;
    FOnPrepare: TPrepareEvent;

    procedure DoCreateInstance(AResource: TDynamicServerClass; const CreateInstanceEventObject: TDSCreateInstanceEventObject); virtual;
    procedure DoDestroyInstance(AResource: TDynamicServerClass; const DestroyInstanceEventObject: TDSDestroyInstanceEventObject); virtual;
    procedure DoLog(const AMessage: string; const ALogLevel: TLogLevel = llDebug); overload;
    procedure DoLog(const AMessage: string; const AParams: array of const; const ALogLevel: TLogLevel = llDebug); overload;
    procedure DoPrepare(AResource: TDynamicServerClass; const PrepareEventObject: TDSPrepareEventObject);
    procedure TriggerConnect(DSConnectEventObject: TDSConnectEventObject);
    procedure TriggerDisconnect(DSConnectEventObject: TDSConnectEventObject);
    procedure TriggerError(DSErrorEventObject: TDSErrorEventObject);
  protected
    procedure CreateTransport; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure GetServiceList(AData: TJSONObject);
    procedure RegisterResource(AClass: TPersistentClass; const ALifeCycle: string = TDSLifeCycle.Invocation);
    procedure Start(const AProc: TProc<Boolean> = nil);
    procedure Stop(const AProc: TProc = nil);

    class property Instance: TServerContainer read GetInstance;

    property LogLevels: TLogLevels read FLogLevels write FLogLevels;
    property Resources: TList<TDynamicServerClass> read FResources;
    property Server: TDSServer read FServer;
    property ServerTransports: TServerTransports read FServerTransports write FServerTransports default [stTCPIP, stHTTP];
    property HttpTransport: TDSHTTPService read FHttpTransport;
    property TCPTRansport: TDSTCPServerTransport read FTCPTransport;

    property OnLog: TLogEvent read FOnLog write FOnLog;
    property OnPrepare: TPrepareEvent read FOnPrepare write FOnPrepare;
  end;

implementation

{ TServerResource }

constructor TServerResource.Create(AOwner: TComponent);
begin
  inherited;

  FData := TJSONObject.Create;
  FErrorCode := 0;
  FErrorMessage := '';
end;

destructor TServerResource.Destroy;
begin
  if Assigned(FParams) then
    FParams.Free;

  inherited;
end;

function TServerResource.GetErrorCode: Integer;
begin
  Result := FErrorCode;
end;

function TServerResource.GetErrorMessage: string;
begin
  Result := FErrorMessage
end;

procedure TServerResource.MakeParams(const AData: string);
begin
  if (AData <> '') then
    FParams := TJSONObject.Parse(AData) as TJSONObject
  else
    FParams := TJSONObject.Create;
end;

function TServerResource.MakeResult(const ACompact: Boolean): string;
begin
  var LResult := TJSONObject.Create;
  try
    LResult.I['result'] := FErrorCode;
    LResult.S['message'] := FErrorMessage;
    LResult.O['content'] := FData;

    Result := LResult.ToJSON(ACompact);
  finally
    LResult.Free;
  end;
end;

procedure TServerResource.SetErrorCode(const Value: Integer);
begin
  FErrorCode := Value;
end;

procedure TServerResource.SetErrorMessage(const Value: string);
begin
  FErrorMessage := Value;
end;

{$REGION 'TDynamicServerClass'}

constructor TDynamicServerClass.Create(AOwner: TComponent; AServer: TDSServer; AClass: TPersistentClass; const ALifeCycle: string);
begin
  inherited Create(AOwner);

  FPersistentClass := AClass;

  Self.Server := AServer;
  Self.LifeCycle := ALifeCycle;
end;

destructor TDynamicServerClass.Destroy;
begin
  inherited;
end;

procedure TDynamicServerClass.CreateInstance(
  const CreateInstanceEventObject: TDSCreateInstanceEventObject);
begin
  inherited;

  TServerContainer(Owner).DoCreateInstance(Self, CreateInstanceEventObject);
end;

procedure TDynamicServerClass.DestroyInstance(
  const DestroyInstanceEventObject: TDSDestroyInstanceEventObject);
begin
  inherited;

  TServerContainer(Owner).DoDestroyInstance(Self, DestroyInstanceEventObject);
end;

function TDynamicServerClass.GetDSClass: TDSClass;
begin
  Result := TDSClass.Create(FPersistentClass, False);
end;

procedure TDynamicServerClass.Preparing(const PrepareEventObject: TDSPrepareEventObject);
begin
  TServerContainer(Owner).DoPrepare(Self, PrepareEventObject);
end;

{$ENDREGION}

{$REGION 'TServerContainer'}

constructor TServerContainer.Create(AOwner: TComponent);
begin
  inherited;

  FServer := TDSServer.Create(Self);
  FServer.AutoStart := False;
  FServer.OnConnect := TriggerConnect;
  FServer.OnDisconnect := TriggerDisconnect;
  FServer.OnError := TriggerError;

  FServerTransports := [stTCPIP, stHTTP];

  FResources := TList<TDynamicServerClass>.Create;

{$IFDEF DEBUG}
  FLogLevels := [llInfo, llDebug, llError, llFatal];
{$ELSE}
  FLogLevels := [llError, llFatal];
{$ENDIF}
end;

destructor TServerContainer.Destroy;
begin
  Stop;

  FResources.Free;

  inherited;
end;

class destructor TServerContainer.Destroy;
begin
  if Assigned(FInstance) then
    FInstance.Free;
end;

procedure TServerContainer.CreateTransport;
begin
  // TCP/IP
  if (stTCPIP in FServerTransports) then
  begin
    if Assigned(FTCPTransport) then
      FreeAndNil(FTCPTransport);

    FTCPTransport := TDSTCPServerTransport.Create(Self);
    FTCPTransport.Port := 211;
    FTCPTransport.Server := FServer;
  end;

  // HTTP
  if (stHTTP in FServerTransports) then
  begin
    if Assigned(FHttpTransport) then
      FreeAndNil(FHttpTransport);

    FHttpTransport := TDSHTTPService.Create(Self);
    FHttpTransport.DSPort := FTCPTransport.Port;
    FHttpTransport.HttpPort := 8080;
    FHttpTransport.Server := FServer;
  end;
end;

procedure TServerContainer.DoCreateInstance(AResource: TDynamicServerClass;
  const CreateInstanceEventObject: TDSCreateInstanceEventObject);
begin
end;

procedure TServerContainer.DoDestroyInstance(AResource: TDynamicServerClass;
  const DestroyInstanceEventObject: TDSDestroyInstanceEventObject);
begin
end;

procedure TServerContainer.DoLog(const AMessage: string; const ALogLevel: TLogLevel);
begin
  if Assigned(FOnLog) then
    FOnLog(Self, AMessage, ALogLevel);
end;

procedure TServerContainer.DoLog(const AMessage: string; const AParams: array of const; const ALogLevel: TLogLevel);
begin
  DoLog(Format(AMessage, AParams), ALogLevel);
end;

procedure TServerContainer.DoPrepare(AResource: TDynamicServerClass; const PrepareEventObject: TDSPrepareEventObject);
begin
  var LClass := TDynamicServerClass(PrepareEventObject.ServerClass);
  DoLog('Server Resource: %s Prepare', [LClass.PersistentClass.ClassName]);

  if Assigned(FOnPrepare) then
    FOnPrepare(Self, AResource, PrepareEventObject);
end;

class function TServerContainer.GetInstance: TServerContainer;
begin
  if not Assigned(FInstance) then
    FInstance := TServerContainer.Create(nil);

  Result := FInstance;
end;

procedure TServerContainer.GetServiceList(AData: TJSONObject);
begin
  for var i := 0 to FResources.Count-1 do
  begin
    var LClass := FResources[i].PersistentClass;
    var LContext := TRttiContext.Create;
    try
      var LType := LContext.GetType(LClass);
      for var LAttribute in LType.GetAttributes do
      begin
        if LAttribute is ServiceAttribute then
        begin
          var LDescription := AData.A['services'].AddObject;
          LDescription.S['name'] := ServiceAttribute(LAttribute).Name;
          LDescription.S['description'] := ServiceAttribute(LAttribute).Description;

          // 메소드에 대한 어트리뷰트 가져오기
          for var LMethod in LType.GetMethods do
          begin
            for var LMethodAttr in LMethod.GetAttributes do
            begin
              if LMethodAttr is URIAttribute then
              begin
                var LMethodDesc := LDescription.A['methods'].AddObject;
                LMethodDesc.S['name'] := URIAttribute(LMethodAttr).Name;
                LMethodDesc.S['description'] := URIAttribute(LMethodAttr).Description;
              end;
            end;
          end;
        end;
      end;
    finally
      LContext.Free;
    end;
  end;
end;

procedure TServerContainer.RegisterResource(AClass: TPersistentClass; const ALifeCycle: string = TDSLifeCycle.Invocation);
begin
  Assert(FServer.Started = false, '서버가 실행중일 때에는 서비스를 등록할 수 없습니다');

  FResources.Add(TDynamicServerClass.Create(Self, FServer, AClass, ALifeCycle));
end;

procedure TServerContainer.Start(const AProc: TProc<Boolean>);
begin
  CreateTransport();

  FServer.Start;
  if Assigned(AProc) then
    AProc(FServer.Started);
end;

procedure TServerContainer.Stop(const AProc: TProc);
begin
  FServer.Stop;
  if Assigned(AProc) then
    AProc();
end;

procedure TServerContainer.TriggerConnect(DSConnectEventObject: TDSConnectEventObject);
var
  LSession: TSessionData;
begin
  LSession := TSessionData.Create;
  LSession.ClientID := DSConnectEventObject.ChannelInfo.Id;
  LSession.PeerIP := DSConnectEventObject.ChannelInfo.ClientInfo.IpAddress;
  LSession.PeerPort := DSConnectEventObject.ChannelInfo.ClientInfo.ClientPort;
  LSession.Protocol := DSConnectEventObject.ChannelInfo.ClientInfo.Protocol;
  LSession.ConnectedAt := Now();

  TDSSessionManager.GetThreadSession.PutObject('session', LSession);

  DoLog('Client Connected > ID: %d, Peer: %s:%s, Protocol: %s', [
    LSession.ClientID, LSession.PeerIP, LSession.PeerPort, LSession.Protocol]);
end;

procedure TServerContainer.TriggerDisconnect(DSConnectEventObject: TDSConnectEventObject);
begin
  var LObject := TDSSessionManager.GetThreadSession.GetObject('session');
  if (LObject <> nil) then
  begin
    var LSession := TSessionData(LObject);
    LSession.ClientID := DSConnectEventObject.ChannelInfo.Id;
    LSession.PeerIP := DSConnectEventObject.ChannelInfo.ClientInfo.IpAddress;
    LSession.PeerPort := DSConnectEventObject.ChannelInfo.ClientInfo.ClientPort;
    LSession.Protocol := DSConnectEventObject.ChannelInfo.ClientInfo.Protocol;

    var LWorking := MilliSecondsBetween(Now, LSession.ConnectedAt);
    DoLog('Working Time(ms): %d', [LWorking]);
    DoLog('Client Disconnected > ID: %d, Peer: %s:%s, Protocol: %s', [
      LSession.ClientID, LSession.PeerIP, LSession.PeerPort, LSession.Protocol]);
  end;
end;

procedure TServerContainer.TriggerError(DSErrorEventObject: TDSErrorEventObject);
begin

end;

{$ENDREGION}

{ DescriptionAttribute }

constructor ServiceAttribute.Create(const AName, ADescription: string);
begin
  FName := AName;
  FDescription := ADescription;
end;

{ URIAttribute }

constructor URIAttribute.Create(const AName, ADescription: string);
begin
  FName := AName;
  FDescription := ADescription;
end;

end.
