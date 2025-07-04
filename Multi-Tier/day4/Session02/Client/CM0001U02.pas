unit CM0001U02;

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

  uBaseForm;

type
  TCM0001F02 = class(TBaseForm)
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCM0001F02);
end.
