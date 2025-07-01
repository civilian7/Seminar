unit ClientClassesUnit1;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.JSON,
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

  Datasnap.DSProxy;
{$ENDREGION}

type
  TServerMethods1Client = class(TDSAdminClient)
  private
    function  GetDBXCommand(const AServiceName, AMethodName: string): TDBXCommand;
  public
    function  Login(AUserID, APassword: string): Integer;
    procedure Logout(AUserID: string);
 end;

implementation

function TServerMethods1Client.GetDBXCommand(const AServiceName, AMethodName: string): TDBXCommand;
begin
  Result := FDBXConnection.CreateCommand;
  Result.CommandType := TDBXCommandTypes.DSServerMethod;
  Result.Text := 'T' + AServiceName + '.' + AMethodName;
  Result.Prepare;
end;

function TServerMethods1Client.Login(AUserID, APassword: string): Integer;
begin
  var LCommand := GetDBXCommand('UserService', 'Login');
  try
    // 접속 비밀번호는 SHA256으로 해쉬한다
    var LHash256 := THashSHA2.GetHashString(APassword);
    LCommand.Parameters[0].Value.SetWideString(AUserID);
    LCommand.Parameters[1].Value.SetWideString(LHash256);
    LCommand.ExecuteUpdate;

    Result := LCommand.Parameters[2].Value.GetInt32;
  finally
    LCommand.Free;
  end;
end;

procedure TServerMethods1Client.Logout(AUserID: string);
begin
  var LCommand := GetDBXCommand('UserService', 'Logout');
  try
    LCommand.Parameters[0].Value.SetWideString(AUserID);
    LCommand.ExecuteUpdate;
  finally
    LCommand.Free;
  end;
end;

end.
