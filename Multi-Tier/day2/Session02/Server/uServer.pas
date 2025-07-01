unit uServer;

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
  Vcl.ComCtrls,
  Vcl.ToolWin,

  uServerContainer;

type
  TfrmMain = class(TForm)
    ToolBar1: TToolBar;
    tsStart: TToolButton;
    tsStop: TToolButton;
    eLogs: TMemo;
    procedure tsStartClick(Sender: TObject);
    procedure tsStopClick(Sender: TObject);
  private
    procedure Log(const AMessage: string);
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Log(const AMessage: string);
begin
  TThread.Queue(
    nil,
    procedure
    begin
      var LMessage := Format('[%s] %s', [FormatDateTime('hh:nn:ss.zzz', Now), AMessage]);
      eLogs.Lines.Add(LMessage);
    end
  );
end;

procedure TfrmMain.tsStartClick(Sender: TObject);
begin
  TServerContainer.Instance.Start(
    procedure(ASuccess: Boolean)
    begin
      Log('서버 실행');
    end
  );
end;

procedure TfrmMain.tsStopClick(Sender: TObject);
begin
  TServerContainer.Instance.Stop(
    procedure
    begin
      Log('서버 중지');
    end
  );
end;

end.
