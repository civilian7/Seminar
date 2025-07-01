unit ServerMethodsUnit1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Json,

  Data.DB,
  DataSnap.DBClient,
  DataSnap.DSProviderDataModuleAdapter,
  Datasnap.DSServer,
  Datasnap.DSAuth,
  Datasnap.Provider,

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

type
  TServerMethods1 = class(TDSServerModule)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    UserList: TDataSetProvider;
  private
  public
  end;

implementation

{$R *.dfm}

uses
  System.StrUtils;

end.
