unit uLogin;

interface

{$REGION 'USES'}
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

  uPacket,
  uClient;
{$ENDREGION}

type
  TLoginDialog = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    eUserID: TEdit;
    ePassword: TEdit;
    lbStatus: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
  private
  public
    class function Execute: TModalResult; static;
  end;

implementation

{$R *.dfm}

{ TLoginDialog }

procedure TLoginDialog.btnOkClick(Sender: TObject);
begin
  ClientModule.Connect;
  ClientModule.Login(eUserID.Text, ePassword.Text,
    procedure(AResponse: IResponse)
    begin
      var LResult := AResponse.ErrorCode;
      case LResult of
      0:
        ModalResult := mrOk;
      1:
        lbStatus.Caption := '����� ���̵� �����ϴ�';
      2:
        lbStatus.Caption := '��й�ȣ�� ��ġ���� �ʽ��ϴ�';
      end;
    end
  );
end;

class function TLoginDialog.Execute: TModalResult;
begin
  var LDialog := TLoginDialog.Create(Application);
  try
    {$IFDEF DEBUG}
    LDialog.eUserID.Text := 'user01';
    LDialog.ePassword.Text := 'P@55w0rd!@';
    {$ENDIF}
    Result := LDialog.ShowModal;
  finally
    LDialog.Free;
  end;
end;

end.
