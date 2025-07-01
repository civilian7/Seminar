unit ServerMethodsUnit1;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,

  Data.DB,

  Datasnap.DBClient,
  Datasnap.DSServer,
  Datasnap.DSAuth,
  Datasnap.DSSession,
  Datasnap.Provider,

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
  FireDAC.Comp.Client,

  uDBPool;
{$ENDREGION}

type
  TDBComponent = class(TComponent)
  private
    FDBConnection: TDBConnection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DBConnection: TDBConnection read FDBConnection;
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

{ TDBComponent }

constructor TDBComponent.Create(AOwner: TComponent);
begin
  inherited;

  FDBConnection := TDatabase.GetConnection;
end;

destructor TDBComponent.Destroy;
begin
  FDBConnection.Free;

  inherited;
end;

{ TUserService }

function TUserService.Login(AUserID, APassword: string): Integer;
const
  SQL = '''
    SELECT
      USR_ID
      , USR_PW
    FROM
      USRS
    WHERE
      USR_ID = :USR_ID
    LIMIT 1
    ''';
begin
  with DBConnection.GetQuery(SQL) do
  begin
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
  end;

  // 로그인 결과를 테이블에 저장한다
  UpdateLoginFail(AUserID, Result);
end;

procedure TUserService.Logout(AUserID: string);
const
  SQL = '''
    UPDATE
      USRS
    SET
      LST_LOGOUT_DT = CURRENT_TIMESTAMP()
    WHERE
      USR_ID = :USR_ID
  ''';
begin
  with DBConnection.GetQuery(SQL) do
  begin
    Params.ParamByName('USR_ID').AsString := AUserID;

    ExecSQL;
  end;
end;

procedure TUserService.UpdateLoginFail(const AUserID: string; const ALoginResult: Integer);
const
  SQL = '''
    UPDATE
      USRS
    SET
      LGN_FAIL_CNT = LGN_FAIL_CNT + 1
      , LST_LOGIN_DT = CURRENT_TIMESTAMP()
      , LST_LOGIN_IP = :IP
    WHERE
      USR_ID = :USR_ID
  ''';
begin
  var LPeerIP := TDSSessionManager.GetThreadSession.GetData('peer_ip');
  with DBConnection.GetQuery(SQL) do
  begin
    Params.ParamByName('IP').AsString := LPeerIP;
    Params.ParamByName('USR_ID').AsString := AUserID;

    ExecSQL;
  end;
end;

procedure TUserService.UpdateLoginSuccess(const AUserID: string);
const
  SQL = '''
    UPDATE
      USRS
    SET
      LGN_CNT = LGN_CNT + 1
      , LST_LOGIN_DT = CURRENT_TIMESTAMP()
      , LST_LOGIN_IP = :IP
    WHERE
      USR_ID = :USR_ID
  ''';
begin
  var LPeerIP := TDSSessionManager.GetThreadSession.GetData('peer_ip');
  with DBConnection.GetQuery(SQL) do
  begin
    Params.ParamByName('IP').AsString := LPeerIP;
    Params.ParamByName('USR_ID').AsString := AUserID;

    ExecSQL;
  end;
end;

end.
