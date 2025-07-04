unit uServerMethods;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.NetEncoding,
  System.Hash,

  Datasnap.DSCommonServer,
  Datasnap.DSServer,
  Datasnap.DSAuth,
  Datasnap.DSReflect,
  Datasnap.DSNames,

  JsonDataObjects,

  uPacket,
  uDBPool,
  uServerContainer;

{$ENDREGION}

type
  TServerDBResource = class(TServerResource)
  private
    FDBConnection: TDBConnection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DBConnection: TDBConnection read FDBConnection;
  end;

implementation

{ TServerDBResource }

constructor TServerDBResource.Create(AOwner: TComponent);
begin
  inherited;

  FDBConnection := TDatabase.GetConnection;
end;

destructor TServerDBResource.Destroy;
begin
  FDBConnection.Free;

  inherited;
end;

end.
