unit uLog;

interface

{$REGION 'USES'}
uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ToolWin,
  Vcl.ComCtrls;
{$ENDREGION}

type
  TLogManager = class(TForm)
    ToolBar1: TToolBar;
    eLogs: TMemo;
  strict private
    class var
      FInstance: TLogManager;
    class function GetInstance: TLogManager; static;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure Log(const AMessage: string);

    class property Instance: TLogManager read GetInstance;
  end;

implementation

{$R *.dfm}

{ TLogManager }

procedure TLogManager.CreateParams(var Params: TCreateParams);
begin
  inherited;

  Params.
end;

class function TLogManager.GetInstance: TLogManager;
begin
  if not Assigned(FInstance) then
    FInstance := TLogManager.Create(Application);

  Result := FInstance;
end;

procedure TLogManager.Log(const AMessage: string);
begin
  eLogs.Lines.Add(format('[%s] %s', [FormatDateTime('hh.nn.ss.zzz', Now), AMessage]));
end;

end.
