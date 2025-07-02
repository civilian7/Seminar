unit uResourceSystem;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,

  Datasnap.DSServer,
  Datasnap.DSAuth,
  Datasnap.DSSession,

  JsonDataObjects,
  uPacket,
  uServerMethods;
{$ENDREGION}

type
  {$METHODINFO ON}
  TSystemResource = class(TServerResource)
  public
    function GetMyIP(AData: string): string;
    function ServerTime(AData: string): string;
  end;
  {$METHODINFO OFF}

implementation

uses
  uServerContainer;

{ TSystemResource }

function TSystemResource.GetMyIP(AData: string): string;
begin
  var LSession := TDSSessionManager.GetThreadSession.GetObject('session');
  if Assigned(LSession) then
    Data.S['ip'] := TSessionData(LSession).PeerIP
  else
    Data.S['ip'] := '';

  Result := MakeResult();
end;

function TSystemResource.ServerTime(AData: string): string;
begin
  Data.D['servertime'] := Now();

  Result := MakeResult;
end;

initialization
  TServerContainer.Instance.RegisterResource(TSystemResource);
end.
