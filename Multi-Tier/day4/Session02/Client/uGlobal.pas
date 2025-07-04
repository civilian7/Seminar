unit uGlobal;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,

  uLog;

type
  TGlobal = class sealed
  strict private
    class var
      FServerIP: string;
      FServerPort: Integer;
      FSaveUserID: Boolean;
      FUserID: string;
    class constructor Create;
    class destructor Destroy;
  public
    /// <summary>
    ///   서버 아이피주소
    /// </summary>
    class property ServerIP: string read FServerIP write FServerIP;
    class property ServerPort: Integer read FServerPort write FserverPort;
    class property SaveUserID: Boolean read FSaveUserID write FSaveUserID;
    class property UserID: string read FUserID write FUserID;
  end;

implementation

{ TGlobal }

class constructor TGlobal.Create;
begin
  TLogManager.Instance.Log('설정값을 읽습니다');

  var LIniFile := ChangeFileExt(ParamStr(0), '.ini');
  with TIniFile.Create(LIniFile) do
  begin
    FServerIP := ReadString('SERVER', 'IP', '127.0.0.1');
    FServerPort := ReadInteger('SERVER', 'PORT', 211);

    FSaveUserID := ReadBool('USER', 'SAVEID', False);
    if FSaveUserID then
      FUserID := ReadString('USER', 'USERID', '')
    else
      FUserID := '';

    Free;
  end;
end;

class destructor TGlobal.Destroy;
begin
  with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
  begin
    WriteString('SERVER', 'IP', FServerIP);
    WriteInteger('SERVER', 'PORT', FServerPort);

    WriteBool('USER', 'SAVEID', FSaveUserID);
    if FSaveUserID then
      WriteString('USER', 'USERID', FUserID);

    Free;
  end;
end;

end.
