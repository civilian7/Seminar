program Client;

uses
  Vcl.Forms,
  Vcl.Controls,
  uMain in 'uMain.pas' {frmMain},
  uClient in 'uClient.pas' {ClientModule: TDataModule},
  uPacket in '..\Common\uPacket.pas',
  JsonDataObjects in '..\Common\JsonDataObjects.pas',
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
