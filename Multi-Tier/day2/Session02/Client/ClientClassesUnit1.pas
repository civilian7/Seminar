//
// Created by the DataSnap proxy generator.
// 2025-06-30 오후 2:30:25
//

unit ClientClassesUnit1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,

  Data.DB,
  Data.DBXCommon,
  Data.DBXClient,
  Data.DBXDataSnap,
  Data.DBXJSON,
  Data.SqlExpr,
  Data.DBXDBReaders,
  Data.DBXCDSReaders,
  Data.DBXJSONReflect,

  Datasnap.DSProxy;

type
  TClient = class(TDSAdminClient)
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;

    function Call(const AService, ACommand: string; const AParams: string = ''): string;
    function CallAsJSON(const AService, ACommand: string; const AParams: string = ''): TJSONObject;
  end;

implementation

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

function TClient.Call(const AService, ACommand: string; const AParams: string): string;
begin
  var LCommand := FDBXConnection.CreateCommand;
  LCommand.CommandType := TDBXCommandTypes.DSServerMethod;
  LCommand.Text := Format('%s.%s', [AService, ACommand]);
  LCommand.Prepare;

  LCommand.Parameters[0].Value.SetWideString(AParams);
  LCommand.ExecuteUpdate;
  Result := LCommand.Parameters[1].Value.GetWideString;
end;

function TClient.CallAsJSON(const AService, ACommand: string; const AParams: string): TJSONObject;
begin
  var LResult := Call(AService, ACommand, AParams);
  Result := TJSONObject.ParseJSONValue(LResult) as TJSONObject;
end;

end.
