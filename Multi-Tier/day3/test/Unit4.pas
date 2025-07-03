unit Unit4;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,

  System.Generics.Collections,
  System.Diagnostics,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm4 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDict: TDictionary<Integer, string>;
    FList: TStringList;
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.FormDestroy(Sender: TObject);
begin
  FDict.Free;
  FList.Free;
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
  var LValue: string;
  var LStopWatch1 := TStopWatch.StartNew;
  for var i := 1 to 10000 do
    FDict.TryGetValue(100000, LValue);
  LStopWatch1.Stop;

  Memo1.Lines.Add('Dict: ' + LStopWatch1.ElapsedMilliseconds.ToString + ' ms');

  var LStopWatch2 := TStopWatch.StartNew;
  for var i := 1 to 10000 do
    FList.IndexOf('100000');
  LStopWatch2.Stop;

  Memo1.Lines.Add('Dict: ' + LStopWatch2.ElapsedMilliseconds.ToString + ' ms');
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  var LStopWatch1 := TStopWatch.StartNew;
  Memo1.Lines.Clear;
  for var i := 1 to 1000 do
  begin
    Memo1.Lines.Add(i.ToString);
  end;
  LStopWatch1.Stop;
  Memo1.Lines.Add('Case 1: ' + LStopWatch1.ElapsedMilliseconds.ToString + ' ms');
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
  var LStopWatch1 := TStopWatch.StartNew;
  Memo1.Lines.BeginUpdate;
  try
    Memo1.Lines.Clear;
    for var i := 1 to 1000 do
    begin
      Memo1.Lines.Add(i.ToString);
    end;
  finally
    Memo1.Lines.EndUpdate;
  end;
  LStopWatch1.Stop;
  Memo1.Lines.Add('Case 2: ' + LStopWatch1.ElapsedMilliseconds.ToString + ' ms');
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  FDict := TDictionary<Integer, string>.Create;
  FList := TStringList.Create;

  for var i := 1 to 100000 do
  begin
    FDict.AddOrSetValue(i, '');
    FList.Add(i.ToString);
  end;
end;

end.
