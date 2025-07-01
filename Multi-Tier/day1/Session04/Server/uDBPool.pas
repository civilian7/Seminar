unit uDBPool;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.NetEncoding,
  System.JSON,

  Data.DB,

  FireDAC.Comp.UI,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Def,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.Param,
  FireDAC.DApt,
  FireDAC.Phys.MySQL,
  FireDAC.Comp.Client,
  FireDAC.Comp.Script;
{$ENDREGION}

type
  TDBQuery = class(TFDQuery)
  public
    function  ToJSON: string;
  end;

  TDBConnection = class(TFDConnection)
  public
    function  GetQuery: TDBQuery; overload;
    function  GetQuery(const ASQL: string): TDBQuery; overload;
  end;

  TDatabase = class sealed
  strict private
    const
      CONNECTION_NAME = 'datasnap_pooled_connection';

    class constructor Create;
    class destructor Destroy;
  public
    class function  GetConnection: TDBConnection; static;
  end;

implementation

{$REGION 'TDBQuery'}

function TDBQuery.ToJSON: string;
begin
  var LDatas := TJSONArray.Create;
  try
    while not EOF do
    begin
      var LData := TJSONObject.Create;
      for var i := 0 to Fields.Count-1 do
      begin
        var LFieldName := LowerCase(Fields[i].FieldName);
        case Fields[i].DataType of
        ftBoolean:
          LData.AddPair(LFieldName, Fields[i].AsBoolean);
        ftCurrency:
          LData.AddPair(LFieldName, Fields[i].AsCurrency);
        ftDateTime:
          LData.AddPair(LFieldName, Fields[i].AsDateTime);
        ftFloat:
          LData.AddPair(LFieldName, Fields[i].AsFloat);
        ftInteger:
          LData.AddPair(LFieldName, Fields[i].AsInteger);
        ftLargeint:
          LData.AddPair(LFieldName, Fields[i].AsLargeInt);
        ftString, ftWideString:
          LData.AddPair(LFieldName, Fields[i].AsString);
        end;
      end;

      LDatas.Add(LData);
      Next;
    end;

    Result := LDatas.ToJSON;
  finally
    LDatas.Free;
  end;
end;

{$ENDREGION}

{$REGION 'TDBConnection'}

function TDBConnection.GetQuery: TDBQuery;
begin
  Result := TDBQuery.Create(Self);
  Result.Connection := Self;
end;

function TDBConnection.GetQuery(const ASQL: string): TDBQuery;
begin
  Result := GetQuery;
  Result.SQL.Text := ASQL;
end;

{$ENDREGION}

{$REGION 'TDatabase'}

class constructor TDatabase.Create;
begin
  var LParams := TStringList.Create;
  try
    LParams.Add('Server=fullbit.duckdns.org');
    LParams.Add('Port=3306');
    LParams.Add('Database=datasnap');
    LParams.Add('User_Name=datasnap');
    LParams.Add('Password=P@55w0rd!@');
    LParams.Add('Pooled=True');
    LParams.Add('CharacterSet=Utf8');

    FDManager.AddConnectionDef(CONNECTION_NAME, 'MySQL', LParams);
  finally
    LParams.Free;
  end;
end;

class destructor TDatabase.Destroy;
begin
  FDManager.CloseConnectionDef(CONNECTION_NAME);
end;

class function TDatabase.GetConnection: TDBConnection;
begin
  Result := TDBConnection.Create(nil);
  Result.ConnectionDefName := CONNECTION_NAME;
  Result.Connected := True;
end;

{$ENDREGION}

end.
