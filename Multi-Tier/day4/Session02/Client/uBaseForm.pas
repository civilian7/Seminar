unit uBaseForm;

interface

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

  DS.Packet,
  uClient;

type
  TBaseForm = class(TForm)
  public
    procedure Execute(ARequest: IRequest; out AResponse: IResponse; const AProc: TProc<IResponse> = nil);
  end;

implementation

{ TBaseForm }

procedure TBaseForm.Execute(ARequest: IRequest; out AResponse: IResponse;
  const AProc: TProc<IResponse>);
begin
  ClientModule.Execute(ARequest, AResponse, AProc);
end;

end.
