program Client;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uClient in 'uClient.pas' {ClientModule: TDataModule},
  uPacket in '..\Common\uPacket.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClientModule, ClientModule);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
