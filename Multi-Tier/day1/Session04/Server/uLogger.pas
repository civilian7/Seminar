unit uLogger;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TLogEvent = procedure(Sender: TObject; const AMessage: string) of object;

  TLogger = class
  strict private
    class var
      FOnLog: TLogEvent;
  private
    class procedure DoLog(Sender: TObject; const AMessage: string); static;
  public
    class procedure Log(Sender: TObject; const AMessage: string); overload; static;
    class procedure Log(Sender: TObject; const AMessage: string; const AParams: array of const); overload; static;

    class property OnLog: TLogEvent read FOnLog write FOnLog;
  end;

implementation

{ TLogger }

class procedure TLogger.DoLog(Sender: TObject; const AMessage: string);
begin
  if Assigned(FOnLog) then
    FOnLog(Sender, AMessage);
end;

class procedure TLogger.Log(Sender: TObject; const AMessage: string);
begin
  DoLog(Sender, AMessage);
end;

class procedure TLogger.Log(Sender: TObject; const AMessage: string; const AParams: array of const);
begin
  Log(Sender, Format(AMessage, AParams));
end;

end.
