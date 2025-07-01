unit uPacket;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.NetEncoding,
  System.Hash;

const
  CRLF = #13#10;

type
  IRequest = interface
    ['{F1C79F66-6CDB-46DE-A8C9-DE852319E315}']
    function  GetMethod: string;
    function  GetParams: TJSONObject;
    function  GetService: string;

    function  FullName: string;
    function  ToString: string;

    property Method: string read GetMethod;
    property Params: TJSONObject read GetParams;
    property Service: string read GetService;
  end;

  TRequest = class(TInterfacedObject, IRequest)
  private
    FMethod: string;
    FParams: TJSONObject;
    FService: string;

    function  GetMethod: string;
    function  GetParams: TJSONObject;
    function  GetService: string;
  public
    constructor Create(const AService, AMethod: string); virtual; overload;
    constructor Create(const AData: string); virtual; overload;
    destructor Destroy; override;

    function  FullName: string;
    function  ToString: string; override;

    property Method: string read GetMethod;
    property Params: TJSONObject read GetParams;
    property Service: string read GetService;
  end;

  IResponse = interface
    ['{CFD7AA0B-A58B-4062-90AC-66732B2B0749}']
    function GetContent: TJSONObject;
    function GetErrorCode: Integer;
    function GetErrorMessage: string;
    function GetMethod: string;
    function GetService: string;

    function ToString: string;

    property Content: TJSONObject read GetContent;
    property ErrorCode: Integer read GetErrorCode;
    property ErrorMessage: string read GetErrorMessage;
    property Method: string read GetMethod;
    property Service: string read GetService;
  end;

  TResponse = class(TInterfacedObject, IResponse)
  private
    FData: TJSONObject;
    FMethod: string;
    FService: string;

    function GetContent: TJSONObject;
    function GetErrorCode: Integer;
    function GetErrorMessage: string;
    function GetMethod: string;
    function GetService: string;
  public
    constructor Create(const AService, AMethod, AData: string); virtual;
    destructor Destroy; override;

    function ToString: string; override;

    property Content: TJSONObject read GetContent;
    property ErrorCode: Integer read GetErrorCode;
    property ErrorMessage: string read GetErrorMessage;
    property Method: string read GetMethod;
    property Service: string read GetService;
  end;

implementation

{$REGION 'TRequest'}

constructor TRequest.Create(const AService, AMethod: string);
begin
  FMethod := AMethod;
  FParams := TJSONObject.Create;
  FService := AService;
end;

constructor TRequest.Create(const AData: string);
begin

end;

destructor TRequest.Destroy;
begin
  FParams.Free;

  inherited;
end;

function TRequest.FullName: string;
begin
  Result := Format('T%sResource.%s', [FService, FMethod]);
end;

function TRequest.GetMethod: string;
begin
  Result := FMethod;
end;

function TRequest.GetParams: TJSONObject;
begin
  Result := FParams;
end;

function TRequest.GetService: string;
begin
  Result := FService;
end;

function TRequest.ToString: string;
begin
  Result :=
    'Service: ' + Service + CRLF +
    'Method: ' + Method + CRLF +
    'Params: ' + CRLF + Params.ToJSON;
end;

{$ENDREGION}

{$REGION 'TResponse'}

constructor TResponse.Create(const AService, AMethod, AData: string);
begin
  FService := AService;
  FMethod := AMethod;
  FData := TJSONObject.ParseJSONValue(AData) as TJSONObject;
end;

destructor TResponse.Destroy;
begin
  FData.Free;

  inherited;
end;

function TResponse.GetContent: TJSONObject;
begin
  Result := FData.GetValue('content') as TJSONObject;
end;

function TResponse.GetErrorCode: Integer;
begin
  Result := FData.GetValue<Integer>('result');
end;

function TResponse.GetErrorMessage: string;
begin
  Result := FData.GetValue<string>('message');
end;

function TResponse.GetMethod: string;
begin
  Result := FMethod;
end;

function TResponse.GetService: string;
begin
  Result := FService;
end;

function TResponse.ToString: string;
begin
  Result :=
    'Service: ' + Service + CRLF +
    'Method: ' + Method + CRLF +
    'ErrorCode: ' + ErrorCode.ToString + CRLF +
    'ErrorMessage: ' + ErrorMessage + CRLF +
    'Content: ' + CRLF + Content.ToJSON;
end;

{$ENDREGION}

end.
