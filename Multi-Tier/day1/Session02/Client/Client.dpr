program Client;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uDM in 'uDM.pas' {DM: TDataModule},
  uEdit in 'uEdit.pas' {frmEditUser};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
