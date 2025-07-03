unit ServerMethodsUnit1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Math,

  Datasnap.DSServer,
  Datasnap.DSAuth;

type
{$METHODINFO ON}
  TFileService = class(TComponent)
  strict private
    const
      CHUNK_SIZE = 1024 * 64;  // 64K
  public
    function GetFileInfo(const FileName: string): TJSONObject;
    function DownloadFileChunk(const FileName: string; ChunkIndex: Integer): TStream;
    function UploadFile(const AFileName: string; AStream: TStream;
      AChunkIndex: Integer; ATotalChunks: Integer): Boolean;
  end;
{$METHODINFO OFF}

implementation

uses
  System.IOUtils;

{ TFileService }

function TFileService.DownloadFileChunk(const FileName: string;
  ChunkIndex: Integer): TStream;
var
  FileStream: TFileStream;
  MemStream: TMemoryStream;
  StartPos: Int64;
  BytesToRead: Integer;
  Buffer: array[0..CHUNK_SIZE-1] of Byte;
  BytesRead: Integer;
begin
  var LFileName := ExtractFilePath(ParamStr(0)) + FileName;
  if not FileExists(LFileName) then
    Exit(nil);

  FileStream := TFileStream.Create(LFileName, fmOpenRead or fmShareDenyWrite);
  try
    StartPos := Int64(ChunkIndex) * CHUNK_SIZE;

    if StartPos >= FileStream.Size then
      Exit(nil);

    FileStream.Position := StartPos;
    BytesToRead := Min(CHUNK_SIZE, FileStream.Size - StartPos);

    MemStream := TMemoryStream.Create;
    BytesRead := FileStream.Read(Buffer, BytesToRead);
    MemStream.Write(Buffer, BytesRead);
    MemStream.Position := 0;

    Result := MemStream;
  finally
    FileStream.Free;
  end;
end;

function TFileService.GetFileInfo(const FileName: string): TJSONObject;
var
  FileStream: TFileStream;
  JsonObj: TJSONObject;
begin
  var LFileName := ExtractFilePath(ParamStr(0)) + FileName;
  if not FileExists(LFileName) then
    Exit(nil);

  FileStream := TFileStream.Create(LFileName, fmOpenRead);
  try
    JsonObj := TJSONObject.Create;
    JsonObj.AddPair('FileName', ExtractFileName(LFileName));
    JsonObj.AddPair('FileSize', TJSONNumber.Create(FileStream.Size));
    JsonObj.AddPair('TotalChunks', TJSONNumber.Create(Ceil(FileStream.Size / CHUNK_SIZE)));
    Result := JsonObj;
  finally
    FileStream.Free;
  end;
end;

function TFileService.UploadFile(const AFileName: string; AStream: TStream;
  AChunkIndex, ATotalChunks: Integer): Boolean;
begin
  var LFileName := ExtractFilePath(ParamStr(0)) + AFileName + '.tmp';

  var LStream: TFileStream;
  if AChunkIndex = 0 then
    LStream := TFileStream.Create(LFileName, fmCreate)
  else
  begin
    LStream := TFileStream.Create(LFileName, fmOpenWrite);
    LStream.Seek(0, soFromEnd);
  end;

  AStream.Position := 0;
  LStream.CopyFrom(AStream, AStream.Size);
  LStream.Free;

  if (AChunkIndex = ATotalChunks-1) then
  begin
    RenameFile(LFileName, ChangeFileExt(LFileName, ''));
  end;

  Result := True;
end;

end.
