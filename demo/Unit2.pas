unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, MnuIcon;

type
  TForm2 = class(TForm)
    MenuIcon1: TMenuIcon;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Help1: TMenuItem;
    Index1: TMenuItem;
    MenuIcon2: TMenuIcon;
    MenuIcon3: TMenuIcon;
    MenuIcon4: TMenuIcon;
    MenuIcon5: TMenuIcon;
    MenuIcon6: TMenuIcon;
    MenuIcon7: TMenuIcon;
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.Exit1Click(Sender: TObject);
begin
close;
end;

end.
