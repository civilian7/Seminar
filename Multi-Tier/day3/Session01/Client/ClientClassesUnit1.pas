//
// Created by the DataSnap proxy generator.
// 2025-06-30 오후 2:30:25
//

unit ClientClassesUnit1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,

  Data.DB,
  Data.DBXCommon,
  Data.DBXClient,
  Data.DBXDataSnap,
  Data.DBXJSON,
  Data.SqlExpr,
  Data.DBXDBReaders,
  Data.DBXCDSReaders,
  Data.DBXJSONReflect,

  Datasnap.DSProxy;

type
  TServerMethods1Client = class(TDSAdminClient)
  private
    DownloadCommand: TDBXCommand;
    FileInfoCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;

    function GetFileInfo(const FileName: string): TJSONObject;
    function DownloadFileChunk(const FileName: string; ChunkIndex: Integer): TStream;
    function  UploadFile(const AFileName: string;
      AStream: TMemoryStream; AChunkIndex, ATotalChunks: Integer): Boolean;
  end;

implementation

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  DownloadCommand.Free;
  FileInfoCommand.Free;

  inherited;
end;

function TServerMethods1Client.DownloadFileChunk(const FileName: string;
  ChunkIndex: Integer): TStream;
begin
  if DownloadCommand = nil then
  begin
    DownloadCommand := FDBXConnection.CreateCommand;
    DownloadCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    DownloadCommand.Text := 'TFileService.DownloadFileChunk';
    DownloadCommand.Prepare;
  end;

  DownloadCommand.Parameters[0].Value.SetWideString(FileName);
  DownloadCommand.Parameters[1].Value.SetInt32(ChunkIndex);
  DownloadCommand.ExecuteUpdate;

  Result := DownloadCommand.Parameters[2].Value.GetStream;
end;

function TServerMethods1Client.GetFileInfo(const FileName: string): TJSONObject;
begin
  if FileInfoCommand = nil then
  begin
    FileInfoCommand := FDBXConnection.CreateCommand;
    FileInfoCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FileInfoCommand.Text := 'TFileService.GetFileInfo';
    FileInfoCommand.Prepare;
  end;

  FileInfoCommand.Parameters[0].Value.SetWideString(FileName);
  FileInfoCommand.ExecuteUpdate;
  Result := (FileInfoCommand.Parameters[1].Value.GetJSONValue as TJSONObject);
end;

function TServerMethods1Client.UploadFile(const AFileName: string; AStream: TMemoryStream;
  AChunkIndex, ATotalChunks: Integer): Boolean;
begin
  var LCommand := FDBXConnection.CreateCommand;
  try
    LCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    LCommand.Text := 'TFileService.UploadFile';
    LCommand.Prepare;

    LCommand.Parameters[0].Value.SetWideString(AFileName);
    LCommand.Parameters[1].Value.SetStream(AStream, False);
    LCommand.Parameters[2].Value.SetInt32(AChunkIndex);
    LCommand.Parameters[3].Value.SetInt32(ATotalChunks);

    LCommand.ExecuteUpdate;

    Result := LCommand.Parameters[4].Value.GetBoolean;
  finally
    LCommand.Free;
  end;
end;

end.
