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
    function GetServerTime(AData: string): string;
  end;
  {$METHODINFO OFF}

implementation

uses
  uServerContainer;

{ TSystemResource }

function TSystemResource.GetServerTime(AData: string): string;
begin
  MakeParams(AData);

  Data.AddPair('time', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));

  Result := MakeResult;
end;

initialization
  TServerContainer.Instance.RegisterResource(TSystemResource);
end.
