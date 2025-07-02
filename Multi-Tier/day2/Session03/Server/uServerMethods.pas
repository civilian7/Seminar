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
  uDBPool;
{$ENDREGION}

type
  TServerResource = class(TComponent)
  private
    FData: TJSONObject;
    FErrorCode: Integer;
    FErrorMessage: string;
    FParams: TJSONObject;

    function  GetErrorCode: Integer;
    function  GetErrorMessage: string;
    procedure SetErrorCode(const Value: Integer);
    procedure SetErrorMessage(const Value: string);
  protected
    procedure MakeParams(const AData: string); virtual;
    function  MakeResult(const ACompact: Boolean = True): string; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Data: TJSONObject read FData;
    property ErrorCode: Integer read GetErrorCode write SetErrorCode;
    property ErrorMessage: string read GetErrorMessage write SetErrorMessage;
    property Params: TJSONObject read FParams;
  end;

  TServerDBResource = class(TServerResource)
  private
    FDBConnection: TDBConnection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DBConnection: TDBConnection read FDBConnection;
  end;

implementation

uses
  uServerContainer;

{ TServerResource }

constructor TServerResource.Create(AOwner: TComponent);
begin
  inherited;

  FData := TJSONObject.Create;
  FErrorCode := 0;
  FErrorMessage := '';
end;

destructor TServerResource.Destroy;
begin
  if Assigned(FParams) then
    FParams.Free;

  inherited;
end;

function TServerResource.GetErrorCode: Integer;
begin
  Result := FErrorCode;
end;

function TServerResource.GetErrorMessage: string;
begin
  Result := FErrorMessage
end;

procedure TServerResource.MakeParams(const AData: string);
begin
  if (AData <> '') then
    FParams := TJSONObject.Parse(AData) as TJSONObject
  else
    FParams := TJSONObject.Create;
end;

function TServerResource.MakeResult(const ACompact: Boolean): string;
begin
  var LResult := TJSONObject.Create;
  try
    LResult.I['result'] := FErrorCode;
    LResult.S['message'] := FErrorMessage;
    LResult.O['content'] := FData;

    Result := LResult.ToJSON(ACompact);
  finally
    LResult.Free;
  end;
end;

procedure TServerResource.SetErrorCode(const Value: Integer);
begin
  FErrorCode := Value;
end;

procedure TServerResource.SetErrorMessage(const Value: string);
begin
  FErrorMessage := Value;
end;

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
