﻿unit ServerContainerUnit1;

interface

uses
  System.SysUtils,
  System.Classes,

  Datasnap.DSTCPServerTransport,
  Datasnap.DSHTTPCommon,
  Datasnap.DSHTTP,
  Datasnap.DSServer,
  Datasnap.DSCommonServer,
  Datasnap.DSAuth,

  IPPeerServer,
  IPPeerAPI;

type
  TServerContainer1 = class(TDataModule)
    DSServer1: TDSServer;
    DSTCPServerTransport1: TDSTCPServerTransport;
    DSServerClass1: TDSServerClass;
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
  private
  public
  end;

var
  ServerContainer1: TServerContainer1;

implementation

{$R *.dfm}

uses
  ServerMethodsUnit1;

procedure TServerContainer1.DSServerClass1GetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := ServerMethodsUnit1.TServerMethods1;
end;

end.
