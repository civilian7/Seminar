unit uResourceSystem;

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
  TSystemResource = class(TServerResouece)
  public
    function ServerTime(AData: string): string;
  end;
  {$METHODINFO OFF}

implementation

uses
  uServerContainer;

{ TSystemResource }

function TSystemResource.ServerTime(AData: string): string;
begin
  Data.AddPair('servertime', Now);

  Result := MakeResult;
end;

initialization
  TServerContainer.Instance.RegisterResource(TSystemResource);
end.
