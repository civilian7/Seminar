program Client;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  ClientClassesUnit1 in 'ClientClassesUnit1.pas',
  ClientModuleUnit1 in 'ClientModuleUnit1.pas' {ClientModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClientModule1, ClientModule1);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
