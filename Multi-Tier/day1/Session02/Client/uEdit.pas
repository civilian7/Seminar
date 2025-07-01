unit uEdit;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,

  Data.DB,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.ExtCtrls,
  Vcl.DBCtrls,

  uDM;

type
  TfrmEditUser = class(TForm)
    DataSource1: TDataSource;
    Label1: TLabel;
    eUserID: TDBEdit;
    Label2: TLabel;
    eUserName: TDBEdit;
    Label3: TLabel;
    eUserPassword: TDBEdit;
    Label4: TLabel;
    eUserLevel: TDBEdit;
    btnOk: TButton;
    btnCancel: TButton;
  private
  public
    class function Execute: TModalResult; static;
  end;

implementation

{$R *.dfm}

{ TfrmEditUser }

class function TfrmEditUser.Execute: TModalResult;
begin
  var LDialog := TfrmEditUser.Create(nil);
  try
    Result := LDialog.ShowModal;
  finally
    LDialog.Free;
  end;
end;

end.
