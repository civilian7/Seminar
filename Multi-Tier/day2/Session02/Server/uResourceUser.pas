unit uResourceUser;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.NetEncoding,
  System.Hash,
  System.JSON,

  Datasnap.DSServer,
  Datasnap.DSAuth,

  uPacket,
  uServerMethods;
{$ENDREGION}

type
  {$METHODINFO ON}
  TUserResource = class(TServerResouece)
  public
    function Login(AData: string): string;
    function Logout(AData: string): string;
  end;
  {$METHODINFO OFF}

implementation

uses
  uServerContainer;

{ TLoginResource }

function TUserResource.Login(AData: string): string;
begin
  MakeParams(AData);

  Data.AddPair('username', '홍길동');
  Data.AddPair('level', 90);

  Result := MakeResult;
end;

function TUserResource.Logout(AData: string): string;
begin
  MakeParams(AData);

  Result := MakeResult;
end;

initialization
  TServerContainer.Instance.RegisterResource(TUserResource);
end.
