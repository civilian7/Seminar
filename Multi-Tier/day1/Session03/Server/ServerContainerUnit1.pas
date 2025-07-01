unit ServerContainerUnit1;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,

  Data.DB,

  Datasnap.DSCommonServer,
  Datasnap.DSServer,
  Datasnap.DSTCPServerTransport,
  Datasnap.DSAuth,

  IPPeerServer,
  IPPeerAPI,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;
{$ENDREGION}

type
  TStartEvent = procedure(Sender: TObject; const AStarted: Boolean) of object;

  TServerContainer1 = class(TDataModule)
    DSServer1: TDSServer;
    DSTCPServerTransport1: TDSTCPServerTransport;
    UserService: TDSServerClass;
    procedure UserServiceGetClass(DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
  private
    FOnStart: TStartEvent;
    FOnStop: TNotifyEvent;

    procedure DoStart(const AStarted: Boolean);
    procedure DoStop;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start(const APort: Integer);
    procedure Stop;

    property OnStart: TStartEvent read FOnStart write FOnStart;
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
  end;

var
  ServerContainer1: TServerContainer1;

implementation

{$R *.dfm}

uses
  ServerMethodsUnit1;

constructor TServerContainer1.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TServerContainer1.Destroy;
begin

  inherited;
end;

procedure TServerContainer1.DoStart(const AStarted: Boolean);
begin
  if Assigned(FOnStart) then
    FOnStart(Self, AStarted);
end;

procedure TServerContainer1.DoStop;
begin
  if Assigned(FOnStop) then
    FOnStop(Self);
end;

procedure TServerContainer1.UserServiceGetClass(DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := ServerMethodsUnit1.TUserService;
end;

procedure TServerContainer1.Start(const APort: Integer);
begin
  DSTCPServerTransport1.Port := APort;
  DSServer1.Start;

  DoStart(DSServer1.Started);
end;

procedure TServerContainer1.Stop;
begin
  DSServer1.Stop;
  DoStop;
end;

initialization
  ServerContainer1 := TServerContainer1.Create(nil);
finalization
  ServerContainer1.Free;
end.
