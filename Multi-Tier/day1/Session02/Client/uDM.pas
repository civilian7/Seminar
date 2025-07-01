unit uDM;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Data.DBXDataSnap,
  Data.DBXCommon,
  Data.SqlExpr,

  IPPeerClient,

  Datasnap.DBClient,
  Datasnap.DSConnect;

type
  TDM = class(TDataModule)
    SQLConnection1: TSQLConnection;
    dpUser: TDSProviderConnection;
    cdsUser: TClientDataSet;
    cdsUserSEQ: TAutoIncField;
    cdsUserUSR_ID: TWideStringField;
    cdsUserUSR_PW: TWideStringField;
    cdsUserUSR_NM: TWideStringField;
    cdsUserUSR_LVL: TIntegerField;
    cdsUserLGN_CNT: TIntegerField;
    cdsUserLGN_FAIL_CNT: TIntegerField;
    cdsUserLST_LOGIN_DT: TDateTimeField;
    cdsUserLST_LOGIN_IP: TWideStringField;
    cdsUserLST_LOGOUT_DT: TDateTimeField;
    cdsUserUSE_YN: TWideStringField;
    cdsUserCRT_ID: TWideStringField;
    cdsUserCRT_DT: TSQLTimeStampField;
    cdsUserCRT_IP: TWideStringField;
    cdsUserMOD_ID: TWideStringField;
    cdsUserMOD_DT: TSQLTimeStampField;
    cdsUserMOD_IP: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    procedure Connect;
    procedure Disconnect;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin

end;

{ TDM }

procedure TDM.Connect;
begin
  SQLConnection1.Open;
end;

procedure TDM.Disconnect;
begin
  SQLConnection1.Close;
end;

end.
