unit uResourceUser;

interface

{$REGION 'USES'}
uses
  System.SysUtils,
  System.Classes,
  System.NetEncoding,
  System.Hash,

  Datasnap.DSServer,
  Datasnap.DSAuth,

  uPacket,
  uServerMethods;
{$ENDREGION}

type
  {$METHODINFO ON}
  TUserResource = class(TServerDBResource)
  public
    function Login(AData: string): string;
    function Logout(AData: string): string;
    function UserList(AData: string): string;
  end;
  {$METHODINFO OFF}

implementation

uses
  uServerContainer;

{ TLoginResource }

function TUserResource.Login(AData: string): string;
begin
  MakeParams(AData);

  var LQuery := DBConnection.GetQuery;
  try
    LQuery.SQL.Text := '''
      SELECT
        USR_ID
        , USR_PW
        , USR_NM
        , USR_LVL
      FROM
        USRS
      WHERE
        USR_ID = :USR_ID
    ''';

    LQuery.Params.ParamByName('USR_ID').AsString := Params.S['usr_id'];
    LQuery.Open;

    if LQuery.RecordCount = 0 then
    begin
      // 사용자 아이디 없음
      ErrorCode := 1;
      ErrorMessage := '사용자 아이디를 찾을 수 없습니다';
    end
    else
    begin
      if SameText(LQuery.FieldByName('USR_PW').AsString, Params.S['usr_pw']) then
      begin
        // 로그인 정상
        Data.S['usr_nm'] := LQuery.FieldByName('USR_NM').AsString;
        Data.I['level'] := LQuery.FieldByName('USR_LVL').AsInteger;
      end
      else
      begin
        // 비번 불일치
        ErrorCode := 2;
        ErrorMessage := '비밀번호가 일치하지 않습니다';
      end;
    end;
  finally
    LQuery.Free;
  end;

  Result := MakeResult;
end;

function TUserResource.Logout(AData: string): string;
begin
  MakeParams(AData);

  Result := MakeResult;
end;

function TUserResource.UserList(AData: string): string;
begin
  MakeParams(AData);

  var LQuery := DBConnection.GetQuery;
  try
    LQuery.SQL.Text := '''
      SELECT
        *
      FROM
        USRS
      WHERE
        SEQ >= :SEQ
    ''';

    LQuery.Params.ParamByName('SEQ').AsInteger := Params.I['seq'];
    LQuery.Open;

    Data.O['dataset'] := LQuery.ToJSON;

    Result := MakeResult;
  finally
    LQuery.Free;
  end;
end;

initialization
  TServerContainer.Instance.RegisterResource(TUserResource);
end.
