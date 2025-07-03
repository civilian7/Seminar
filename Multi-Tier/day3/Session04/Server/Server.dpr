program Server;

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uServer in 'uServer.pas' {frmMain},
  uServerMethods in 'uServerMethods.pas',
  uServerContainer in 'uServerContainer.pas' {ServerContainer: TDataModule},
  uPacket in '..\Common\uPacket.pas',
  uResourceUser in 'uResourceUser.pas',
  uResourceSystem in 'uResourceSystem.pas',
  JsonDataObjects in '..\Common\JsonDataObjects.pas',
  uDBPool in 'uDBPool.pas',
  uResourceDB in 'uResourceDB.pas' {DBResource: TDSServerModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

