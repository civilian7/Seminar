unit uResourceSystem;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,

  Datasnap.DSServer,
  Datasnap.DSAuth,
  Datasnap.DSSession,

  DS.Json,
  DS.Packet,

  uServerMethods,
  uServerContainer;
{$ENDREGION}

type
  {$METHODINFO ON}
  [Service('System', '시스템 관련 서비스')]
  TSystemResource = class(TServerResource)
  public
    [URI('GetMyIP', '접속자의 아이피주소를 리턴한다')]
    function GetMyIP(AData: string): string;
    [URI('ServerTime', '서버의 시간을 리턴한다')]
    function ServerTime(AData: string): string;
    function ServiceList(AData: string): string;
  end;
  {$METHODINFO OFF}

implementation

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

function TSystemResource.ServiceList(AData: string): string;
begin
  TServerContainer.Instance.GetServiceList(Data);
  Result := MakeResult;
end;

initialization
  TServerContainer.Instance.RegisterResource(TSystemResource);
end.
