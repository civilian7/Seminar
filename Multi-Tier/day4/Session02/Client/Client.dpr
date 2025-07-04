program Client;

uses
  Vcl.Forms,
  Vcl.Controls,
  uMain in 'uMain.pas' {frmMain},
  uClient in 'uClient.pas' {ClientModule: TDataModule},
  uLogin in 'uLogin.pas' {LoginDialog},
  uGlobal in 'uGlobal.pas',
  uLog in 'uLog.pas' {LogManager};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClientModule, ClientModule);

  TLogManager.Instance.Show;

  TLogManager.Instance.Log('로그인창을 띄웁니다');
  if TLoginDialog.Execute = mrOk then
  begin
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  end;
end.
