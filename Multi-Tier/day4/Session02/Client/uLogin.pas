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

  uGlobal,
  uPacket,
  uClient;
{$ENDREGION}

type
  TLoginDialog = class(TForm)
    lbUserID: TLabel;
    lbPassword: TLabel;
    eUserID: TEdit;
    ePassword: TEdit;
    lbStatus: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    eSaveUserID: TCheckBox;
    procedure btnOkClick(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;

    /// <summary>
    ///  �α��� ���̾�α׸� �����Ѵ�
    /// </summary>
    /// <returns>
    ///   �α����� �����ϸ� mrOk, �����ϸ� mrCancel�� �����Ѵ�
    /// </returns>
    class function Execute: TModalResult; static;
  end;

implementation

{$R *.dfm}

{$REGION 'TLoginDialog'}

constructor TLoginDialog.Create(AOwner: TComponent);
begin
  inherited;

{$IFDEF DEBUG}
  eUserID.Text := 'user01';
  ePassword.Text := 'P@55w0rd!@';
{$ELSE}
  if TGlobal.SaveUserID then
  begin
    eUserID.Text := TGlobal.UserID;
  end;
{$ENDIF}
end;

procedure TLoginDialog.btnOkClick(Sender: TObject);
begin
  ClientModule.Login(eUserID.Text, ePassword.Text,
    procedure(AResponse: IResponse)
    begin
      var LResult := AResponse.ErrorCode;
      case LResult of
      0:
        begin
          TGlobal.SaveUserID := eSaveUserID.Checked;
          ModalResult := mrOk;
        end;
      1:
        begin
          ClientModule.Disconnect;
          lbStatus.Caption := '����� ���̵� �����ϴ�';
          eUserID.SetFocus;
          eUserID.SelectAll;
        end;
      2:
        begin
          ClientModule.Disconnect;
          lbStatus.Caption := '��й�ȣ�� ��ġ���� �ʽ��ϴ�';
          ePassword.SetFocus;
          ePassword.SelectAll;
        end;
      end;
    end
  );
end;

class function TLoginDialog.Execute: TModalResult;
begin
  var LDialog := TLoginDialog.Create(Application);
  try
    Result := LDialog.ShowModal;
  finally
    LDialog.Free;
  end;
end;

{$ENDREGION}

end.
