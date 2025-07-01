unit ServerMethodsUnit1;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,

  Datasnap.DSServer,
  Datasnap.DSAuth,
  Datasnap.DSSession,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;
{$ENDREGION}

type
  //
  // Database 커넥션을 갖는 컴포넌트
  //
  TDBComponent = class(TComponent)
  private
    FDBConnection: TFDConnection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function  GetQuery: TFDQuery; overload;
    function  GetQuery(const ASQL: string): TFDQuery; overload;

    property DBConnection: TFDConnection read FDBConnection;
  end;

  {$METHODINFO ON}
  TUserService = class(TDBComponent)
  strict private
    const
      SUCCESS           = 0;
      FAIL_ID_NOT_FOUND = 1;
      FAIL_PW_INVALID   = 2;
  private
    procedure UpdateLoginFail(const AUserID: string; const ALoginResult: Integer);
    procedure UpdateLoginSuccess(const AUserID: string);
  public
    function  Login(AUserID: string; APassword: string): Integer;
    procedure Logout(AUserID: string);
  end;
  {$METHODINFO OFF}

implementation

uses
  System.StrUtils;

{$REGION 'TDBComponent'}

constructor TDBComponent.Create(AOwner: TComponent);
begin
  inherited;

  FDBConnection := TFDConnection.Create(Self);

  // 데이터베이스 접속을 위한 정보 설정
  FDBConnection.Params.Add('Server=fullbit.duckdns.org');
  FDBConnection.Params.Add('Port=3306');
  FDBConnection.Params.Add('Database=datasnap');
  FDBConnection.Params.Add('User_Name=datasnap');
  FDBConnection.Params.Add('Password=P@55w0rd!@');
  FDBConnection.Params.Add('CharacterSet=Utf8');

  FDBConnection.DriverName := 'MySQL';
  FDBConnection.LoginPrompt := False;
end;

destructor TDBComponent.Destroy;
begin
  FDBConnection.Free;

  inherited;
end;

function TDBComponent.GetQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FDBConnection;
end;

function TDBComponent.GetQuery(const ASQL: string): TFDQuery;
begin
  Result := GetQuery;
  Result.SQL.Text := ASQL;
end;

{$ENDREGION}

{ TUserService }

function TUserService.Login(AUserID, APassword: string): Integer;
begin
  var LQuery := GetQuery;
  try
    with LQuery do
    begin
      SQL.Text := '''
      SELECT
        USR_ID
        , USR_PW
        , USR_NM
        , USR_LVL
      FROM
        USRS
      WHERE
        USR_ID = :USR_ID
      LIMIT 1
      ''';

      Params.ParamByName('USR_ID').AsString := AUserID;
      Open;

      if RecordCount = 0 then
        Result := FAIL_ID_NOT_FOUND
      else
      begin
        if SameText(APassword, FieldByName('USR_PW').AsString) then
        begin
          TDSSessionManager.GetThreadSession.PutData('authorized', 'Y');
          Result := SUCCESS;
        end
        else
          Result := FAIL_PW_INVALID;
      end;

      // 로그인 결과를 테이블에 저장한다
      UpdateLoginFail(AUserID, Result);
    end;
  finally
    LQuery.Free;
  end;
end;

procedure TUserService.Logout(AUserID: string);
begin
  var LQuery := GetQuery;
  try
    with LQuery do
    begin
      SQL.Text := '''
      UPDATE
        USRS
      SET
        LST_LOGOUT_DT = CURRENT_TIMESTAMP()
      WHERE
        USR_ID = :USR_ID
      ''';

      Params.ParamByName('USR_ID').AsString := AUserID;

      ExecSQL;
    end;
    TDSSessionManager.GetThreadSession.Close;
  finally
    LQuery.Free;
  end;
end;

procedure TUserService.UpdateLoginFail(const AUserID: string; const ALoginResult: Integer);
begin
  var LQuery := GetQuery;
  try
    with LQuery do
    begin
      SQL.Text := '''
      UPDATE
        USRS
      SET
        LGN_FAIL_CNT = LGN_FAIL_CNT + 1
        , LST_LOGIN_DT = CURRENT_TIMESTAMP()
        , LST_LOGIN_IP = :IP
      WHERE
        USR_ID = :USR_ID
      ''';

      var LPeerIP := TDSSessionManager.GetThreadSession.GetData('peer_ip');
      Params.ParamByName('IP').AsString := LPeerIP;
      Params.ParamByName('USR_ID').AsString := AUserID;
      ExecSQL;
    end;
  finally
    LQuery.Free;
  end;
end;

procedure TUserService.UpdateLoginSuccess(const AUserID: string);
begin
  var LQuery := GetQuery;
  try
    with LQuery do
    begin
      SQL.Text := '''
      UPDATE
        USRS
      SET
        LGN_CNT = LGN_CNT + 1
        , LST_LOGIN_DT = CURRENT_TIMESTAMP()
        , LST_LOGIN_IP = :IP
      WHERE
        USR_ID = :USR_ID
      ''';

      var LPeerIP := TDSSessionManager.GetThreadSession.GetData('peer_ip');
      Params.ParamByName('IP').AsString := LPeerIP;
      Params.ParamByName('USR_ID').AsString := AUserID;

      ExecSQL;
    end;
  finally
    LQuery.Free;
  end;
end;

end.
