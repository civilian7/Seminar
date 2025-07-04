program Client;

uses
  Vcl.Forms,
  Vcl.Controls,
  uMain in 'uMain.pas' {frmMain},
  uClient in 'uClient.pas' {ClientModule: TDataModule},
  uLogin in 'uLogin.pas' {LoginDialog},
  uGlobal in 'uGlobal.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClientModule, ClientModule);
  if TLoginDialog.Execute = mrOk then
  begin
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  end;
end.
