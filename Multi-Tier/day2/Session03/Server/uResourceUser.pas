unit uResourceUser;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.NetEncoding,
  System.Hash,

  Datasnap.DSServer,
  Datasnap.DSAuth,

  uPacket,
  uServerMethods;
{$ENDREGION}

type
  {$METHODINFO ON}
  TUserResource = class(TServerDBResource)
  public
    function Login(AData: string): string;
    function Logout(AData: string): string;
    function UserList(AData: string): string;
  end;
  {$METHODINFO OFF}

implementation

uses
  uServerContainer;

{ TLoginResource }

function TUserResource.Login(AData: string): string;
begin
  MakeParams(AData);

  Data.S['username'] := '홍길동';
  Data.I['level'] := 90;

  Result := MakeResult;
end;

function TUserResource.Logout(AData: string): string;
begin
  MakeParams(AData);

  Result := MakeResult;
end;

function TUserResource.UserList(AData: string): string;
begin
  var LQuery := DBConnection.GetQuery;
  try
    LQuery.SQL.Text := '''
      SELECT
        *
      FROM
        USRS
    ''';
    LQuery.Open;

    Data.O['dataset'] := LQuery.ToJSON;

    Result := MakeResult;
  finally
    LQuery.Free;
  end;
end;

initialization
  TServerContainer.Instance.RegisterResource(TUserResource);
end.
