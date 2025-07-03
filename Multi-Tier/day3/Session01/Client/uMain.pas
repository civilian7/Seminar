unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,
  System.JSON,
  System.Math,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,

  ClientModuleUnit1, Vcl.ComCtrls;

type
  TfrmMain = class(TForm)
    btnSendFile: TButton;
    eLogs: TMemo;
    btnDisconnect: TButton;
    btnConnect: TButton;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnSendFileClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure Log(const AMessage: string); overload;
    procedure Log(const AMessage: string; const AParams: array of const); overload;
    procedure TriggerConnect(Sender: TObject);
    procedure TriggerDisconnect(Sender: TObject);
    procedure UploadFile(const AFileName: string);
    procedure DownloadFile(const ARemoteFileName, ALocalFileName: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  // 접속, 접속해지 이벤트 핸들러를 등록한다
  ClientModule1.SQLConnection1.AfterConnect := TriggerConnect;
  ClientModule1.SQLConnection1.AfterDisconnect := TriggerDisconnect;
end;

destructor TfrmMain.Destroy;
begin
  inherited;
end;

procedure TfrmMain.DownloadFile(const ARemoteFileName, ALocalFileName: string);
var
  FileInfo: TJSONObject;
  TotalChunks, ChunkIndex: Integer;
  FileSize: Int64;
  ChunkStream: TStream;
  LocalFileStream: TFileStream;
  JsonValue: TJSONValue;
begin
  // 1. 파일 정보 조회
  FileInfo := ClientModule1.ServerMethods1Client.GetFileInfo(ARemoteFileName);
  if not Assigned(FileInfo) then
  begin
    ShowMessage('파일을 찾을 수 없습니다.');
    Exit;
  end;

  try
    JsonValue := FileInfo.GetValue('FileSize');
    if Assigned(JsonValue) then
      FileSize := JsonValue.AsType<Int64>
    else
      Exit;

    JsonValue := FileInfo.GetValue('TotalChunks');
    if Assigned(JsonValue) then
      TotalChunks := JsonValue.AsType<Integer>
    else
      Exit;

    // 2. 로컬 파일 생성
    LocalFileStream := TFileStream.Create(ALocalFileName, fmCreate);
    try
      // 3. 프로그레스 바 초기화
      ProgressBar1.Max := TotalChunks;
      ProgressBar1.Position := 0;

      // 4. 청크별로 다운로드
      for ChunkIndex := 0 to TotalChunks - 1 do
      begin
        ChunkStream := ClientModule1.ServerMethods1Client.DownloadFileChunk(
          ARemoteFileName, ChunkIndex);

        if Assigned(ChunkStream) then
        try
          ChunkStream.Position := 0;
          LocalFileStream.CopyFrom(ChunkStream, ChunkStream.Size);

          // 프로그레스 업데이트
          ProgressBar1.Position := ChunkIndex + 1;

          // 화면 갱신이 필요하다면, 처리해
          Application.ProcessMessages;
        finally
          ChunkStream.Free;
        end
        else
        begin
          ShowMessage('청크 다운로드 실패: ' + IntToStr(ChunkIndex));
          Break;
        end;
      end;

      ShowMessage('다운로드 완료!');
    finally
      LocalFileStream.Free;
    end;
  finally
    FileInfo.Free;
  end;
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
  ClientModule1.SQLConnection1.Connected := True;
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
  ClientModule1.SQLConnection1.Connected := False;
end;

procedure TfrmMain.btnSendFileClick(Sender: TObject);
begin
  var LOpenDialog := TOpenDialog.Create(nil);
  try
    LOpenDialog.Filter := '모든 파일(*.*)|*.*';
    if LOpenDialog.Execute(Handle) then
      UploadFile(LOpenDialog.FileName);
  finally
    LOpenDialog.Free;
  end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  var LRemoteFile := 'firebird-5.pdf';
  var LLocalFile := 'firebird-5-copy.pdf';

  ProgressBar1.Position := 0;
  DownloadFile(LRemotefile, LLocalFile);
end;

procedure TfrmMain.Log(const AMessage: string; const AParams: array of const);
begin
  Log(Format(AMessage, AParams));
end;

procedure TfrmMain.Log(const AMessage: string);
begin
  eLogs.Lines.Add(AMessage);
end;

procedure TfrmMain.TriggerConnect(Sender: TObject);
begin
  Log('연결되었습니다');
end;

procedure TfrmMain.TriggerDisconnect(Sender: TObject);
begin
  Log('연결이 끊어졌습니다');
end;

procedure TfrmMain.UploadFile(const AFileName: string);
const
  CHUNK_SIZE = 1024 * 64;  // 64K
var
  FileStream: TFileStream;
  ChunkStream: TMemoryStream;
  ChunkIndex, TotalChunks: Integer;
  BytesRead: Integer;
  Buffer: array[0..CHUNK_SIZE-1] of Byte;
begin
  FileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    TotalChunks := Ceil(FileStream.Size / CHUNK_SIZE);
    ChunkIndex := 0;

    while FileStream.Position < FileStream.Size do
    begin
      ChunkStream := TMemoryStream.Create;
      try
        BytesRead := FileStream.Read(Buffer, CHUNK_SIZE);
        ChunkStream.Write(Buffer, BytesRead);
        ChunkStream.Position := 0;

        // 서버로 청크 전송
        ClientModule1.ServerMethods1Client.UploadFile(
          ExtractFileName(AFileName),
          ChunkStream,
          ChunkIndex,
          TotalChunks
        );

        Inc(ChunkIndex);
      finally
        ChunkStream.Free;
      end;
    end;
  finally
    FileStream.Free;
  end;
end;

end.
