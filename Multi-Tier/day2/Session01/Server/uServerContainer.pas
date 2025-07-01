unit uServerContainer;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Datasnap.DSTCPServerTransport,
  Datasnap.DSServer,
  Datasnap.DSCommonServer,
  Datasnap.DSAuth,
  Datasnap.DSNames,
  Datasnap.DSReflect,

  IPPeerServer,
  IPPeerAPI;
{$ENDREGION}

type
  TDynamicServerClass = class(TDSServerClass)
  private
    FPersistentClass: TPersistentClass;
  protected
    function  GetDSClass: TDSClass; override;
    procedure Preparing(const PrepareEventObject: TDSPrepareEventObject); override;
  public
    constructor Create(AOwner: TComponent; AServer: TDSServer; AClass: TPersistentClass; const ALifeCycle: string = TDSLifeCycle.Invocation); reintroduce; overload;
    destructor Destroy; override;

    property PersistentClass: TPersistentClass read FPersistentClass;
  end;

  TPrepareEvent = procedure(Sender: TObject; AResource: TDynamicServerClass; const PrepareEventObject: TDSPrepareEventObject) of object;

  TLogLevel = (
    llInfo,
    llDebug,
    llError,
    llFatal
  );
  TLogLevels = set of TLogLevel;

  TServerContainer = class(TDataModule)
  strict private
    class var
      FInstance: TServerContainer;

    class destructor Destroy;

    class function GetInstance: TServerContainer; static;
  private
    FResources: TDictionary<string, TDynamicServerClass>;
    FServer: TDSServer;
    FTCPTransport: TDSTCPServerTransport;

    FOnPrepare: TPrepareEvent;

    procedure AddResource(AResource: TDynamicServerClass);
    procedure DoPrepare(AResource: TDynamicServerClass; const PrepareEventObject: TDSPrepareEventObject);
    procedure RemoveResource(AResource: TDynamicServerClass);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RegisterResource(AClass: TPersistentClass; const ALifeCycle: string = TDSLifeCycle.Invocation);
    procedure Start(const AProc: TProc<Boolean> = nil);
    procedure Stop(const AProc: TProc = nil);

    class property Instance: TServerContainer read GetInstance;

    property Server: TDSServer read FServer;
    property TCPTRansport: TDSTCPServerTransport read FTCPTransport;

    property OnPrepare: TPrepareEvent read FOnPrepare write FOnPrepare;
  end;

implementation

{$R *.dfm}

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
  TServerContainer(Owner).RemoveResource(Self);

  inherited;
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

  FTCPTransport := TDSTCPServerTransport.Create(Self);
  FTCPTransport.Server := FServer;

  FResources := TDictionary<string, TDynamicServerClass>.Create;
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

procedure TServerContainer.AddResource(AResource: TDynamicServerClass);
begin

end;

procedure TServerContainer.DoPrepare(AResource: TDynamicServerClass; const PrepareEventObject: TDSPrepareEventObject);
begin
  if Assigned(FOnPrepare) then
    FOnPrepare(Self, AResource, PrepareEventObject);
end;

class function TServerContainer.GetInstance: TServerContainer;
begin
  if not Assigned(FInstance) then
    FInstance := TServerContainer.Create(nil);

  Result := FInstance;
end;

procedure TServerContainer.RegisterResource(AClass: TPersistentClass; const ALifeCycle: string = TDSLifeCycle.Invocation);
begin
  Assert(FServer.Started = false, '서버가 실행중일 때에는 서비스를 등록할 수 없습니다');

  TDynamicServerClass.Create(Self, FServer, AClass, ALifeCycle);
end;

procedure TServerContainer.RemoveResource(AResource: TDynamicServerClass);
begin

end;

procedure TServerContainer.Start(const AProc: TProc<Boolean>);
begin
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

{$ENDREGION}

end.
