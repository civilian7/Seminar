unit ClientModuleUnit1;

interface

uses
  System.SysUtils,
  System.Classes,

  Data.DB,
  Data.DBXDataSnap,
  Data.DBXCommon,
  Data.SqlExpr,

  IPPeerClient,

  ClientClassesUnit1;

type
  TClientModule1 = class(TDataModule)
    SQLConnection1: TSQLConnection;
  private
    FInstanceOwner: Boolean;
    FUserService: TServerMethods1Client;

    function  GetServerMethods1Client: TServerMethods1Client;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;

    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property UserService: TServerMethods1Client read GetServerMethods1Client write FUserService;
  end;

var
  ClientModule1: TClientModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TClientModule1.Create(AOwner: TComponent);
begin
  inherited;

  FInstanceOwner := True;
end;

destructor TClientModule1.Destroy;
begin
  FUserService.Free;

  inherited;
end;

procedure TClientModule1.Connect;
begin
  SQLConnection1.Connected := True;
end;

procedure TClientModule1.Disconnect;
begin
  SQLConnection1.Connected := False;
end;

function TClientModule1.GetServerMethods1Client: TServerMethods1Client;
begin
  if FUserService = nil then
  begin
    SQLConnection1.Open;
    FUserService := TServerMethods1Client.Create(SQLConnection1.DBXConnection, FInstanceOwner);
  end;
  Result := FUserService;
end;

end.
