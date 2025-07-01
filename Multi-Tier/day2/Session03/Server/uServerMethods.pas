unit uServerMethods;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.NetEncoding,
  System.Hash,

  Datasnap.DSCommonServer,
  Datasnap.DSServer,
  Datasnap.DSAuth,
  Datasnap.DSReflect,
  Datasnap.DSNames,

  JsonDataObjects,

  uPacket;
{$ENDREGION}

type
  TServerResouece = class(TComponent)
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

implementation

uses
  uServerContainer;

{ TServerResouece }

constructor TServerResouece.Create(AOwner: TComponent);
begin
  inherited;

  FData := TJSONObject.Create;
  FErrorCode := 0;
  FErrorMessage := '';
end;

destructor TServerResouece.Destroy;
begin
  if Assigned(FParams) then
    FParams.Free;

  inherited;
end;

function TServerResouece.GetErrorCode: Integer;
begin
  Result := FErrorCode;
end;

function TServerResouece.GetErrorMessage: string;
begin
  Result := FErrorMessage
end;

procedure TServerResouece.MakeParams(const AData: string);
begin
  if (AData <> '') then
    FParams := TJSONObject.Parse(AData) as TJSONObject
  else
    FParams := TJSONObject.Create;
end;

function TServerResouece.MakeResult(const ACompact: Boolean): string;
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

procedure TServerResouece.SetErrorCode(const Value: Integer);
begin
  FErrorCode := Value;
end;

procedure TServerResouece.SetErrorMessage(const Value: string);
begin
  FErrorMessage := Value;
end;

end.
