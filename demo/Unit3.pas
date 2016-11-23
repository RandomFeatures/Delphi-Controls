unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, TBusyControl, StdCtrls;

type
  TForm3 = class(TForm)
    Busy1: TBusy;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

procedure TForm3.FormShow(Sender: TObject);
begin
busy1.play := true;

end;

end.
