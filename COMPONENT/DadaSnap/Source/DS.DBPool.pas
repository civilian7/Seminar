unit DS.DBPool;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.IniFiles,

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
  FireDAC.Comp.Script,

  DS.Json;
{$ENDREGION}

type
  TDBQuery = class(TFDQuery)
  public
    function  ToJSON: TJSONObject;
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
    class function GetConnection: TDBConnection; static; static;
    class function LoadFromFile(const AFileName: string): TStrings; static;
  end;

implementation

{$REGION 'TDBQuery'}

function TDBQuery.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  First;
  while not eof do
  begin
    var LRecord := TJSONObject.Create;
    for var i := 0 to Fields.Count-1 do
    begin
      var LFieldName := Fields[i].FieldName;

      case Fields[i].DataType of
      ftInteger:
        LRecord.I[LFieldName] := Fields[i].AsInteger;
      ftString, ftWideString:
        LRecord.S[LfieldName] := Fields[i].AsString;
      end;
    end;

    Result.A['dataset'].AddObject(LRecord);

    Next;
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

class function TDatabase.LoadFromFile(const AFileName: string): TStrings;
begin
  Result := TStringList.Create;
  var LIniFile := TIniFile.Create(AFileName);
  var LSection := TStringList.Create;
  try
    with LIniFile do
    begin
      ReadSection('settings', Result);
    end;
  finally
    LIniFile.Free;
  end;
end;

{$ENDREGION}

end.
