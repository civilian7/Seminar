unit uResourceDB;

interface

uses
  System.SysUtils,
  System.Classes,

  Data.DB,

  DataSnap.DBClient,
  DataSnap.DSProviderDataModuleAdapter,
  Datasnap.DSServer,
  Datasnap.DSAuth,
  Datasnap.Provider,
  Datasnap.DataBkr,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.DatS,
  FireDAC.DApt,
  FireDAC.DApt.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,

  DS.DBPool,
  uServerMethods,
  uServerContainer;

type
  [Service('DB', '데이터베이스')]
  TDBResource = class(TDSServerModule)
    FDQuery1: TFDQuery;
    UserList: TDataSetProvider;
    FDConnection1: TFDConnection;
  private
    DBConnection: TDBConnection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TDBResource }

constructor TDBResource.Create(AOwner: TComponent);
begin
  inherited;

//  DBConnection := TDatabase.GetConnection;
//  FDQuery1.Connection := DBConnection;
  FDQuery1.SQL.Text := '''
    SELECT * FROM USES
  ''';
end;

destructor TDBResource.Destroy;
begin
//  DBConnection.Free;

  inherited;
end;

initialization
//  TServerContainer.Instance.RegisterResource(TDBResource);
end.
