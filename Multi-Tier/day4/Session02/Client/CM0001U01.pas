unit CM0001U01;

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
  Vcl.StdCtrls,

  DS.Packet,
  uBaseForm;

type
  TCM0001F01 = class(TBaseForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

implementation

{$R *.dfm}

procedure TCM0001F01.Button1Click(Sender: TObject);
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  LRequest := TRequest.Create('User', 'UserList');
  LRequest.Params.I['seq'] := 15;

  Execute(LRequest, LResponse,
    procedure(AResponse: IResponse)
    begin
      ShowMessage(AResponse.ToString);
    end
  );
end;

initialization
  RegisterClass(TCM0001F01);
end.
