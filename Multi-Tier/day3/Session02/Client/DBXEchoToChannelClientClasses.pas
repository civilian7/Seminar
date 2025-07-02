unit DBXEchoToChannelClientClasses;

interface

uses
  DBXCommon,
  DBXClient,
  DBXJSON,
  DSProxy,
  Classes,
  SysUtils,
  DB,
  SqlExpr,
  DBXDBReaders,
  DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminClient)
  private
    FEchoStringToChannelCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function EchoStringToChannel(AChannelName: string; AValue: string): Boolean;
  end;

implementation

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FreeAndNil(FEchoStringToChannelCommand);
  inherited;
end;

function TServerMethods1Client.EchoStringToChannel(AChannelName: string; AValue: string): Boolean;
begin
  if FEchoStringToChannelCommand = nil then
  begin
    FEchoStringToChannelCommand := FDBXConnection.CreateCommand;
    FEchoStringToChannelCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FEchoStringToChannelCommand.Text := 'TServerMethods1.EchoStringToChannel';
    FEchoStringToChannelCommand.Prepare;
  end;
  FEchoStringToChannelCommand.Parameters[0].Value.SetWideString(AChannelName);
  FEchoStringToChannelCommand.Parameters[1].Value.SetWideString(AValue);
  FEchoStringToChannelCommand.ExecuteUpdate;
  Result := FEchoStringToChannelCommand.Parameters[2].Value.GetBoolean;
end;

end.
