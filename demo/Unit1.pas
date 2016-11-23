unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, unit2,
  StdCtrls, Buttons, unit3, unit4, unit5, unit6, Balloon;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    BalloonHint1: TBalloonHint;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
form2.show;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
form3.show;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
form4.show;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
form5.show;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
form6.show;
end;

end.
