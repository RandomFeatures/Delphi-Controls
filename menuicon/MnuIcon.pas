unit MnuIcon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, dsgnIntf;

Var
Bitmap1: TBitmap;


Type
	TAboutMnuIconProperty = class(TPropertyEditor)
	public
		procedure Edit; override;
		function GetAttributes: TPropertyAttributes; override;
		function GetValue: string; override;
	end;

  TMenuIcon = class(TComponent)
  private

    { Private declarations }
    FMenu: TMenu;
    FBitmap: TBitmap;
    FMainMenuPos: Integer;
    FSubMenuPos: Integer;
    FAbout: TAboutMnuIconProperty;

  protected
    { Protected declarations }
  procedure Loaded; override;
  public
    { Public declarations }
    Procedure UpdateMenu;
    procedure SetBitMap(Value: TBitMap);
    procedure InsertMnuIcon(MainPos:Integer; SubPos:Integer; Thebitmap:TBitmap; TheMenu: TMenu);

    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property About: TAboutMnuIconProperty read FAbout write FAbout;
    property Menu: TMenu read FMenu write FMenu;
    property Bitmap: TBitmap read FBitmap write SetBitMap;
    property MainMenuPos: Integer read FMainMenuPos write FMainMenuPos;
    property SubMenuPos: Integer read FSubMenuPos write FSubMenuPos;
  end;


procedure Register;

implementation
procedure TMenuIcon.Loaded;
begin
   inherited Loaded;
   if Not(csDesigning in ComponentState) then
   UpdateMenu;
end;

procedure TAboutMnuIconProperty.Edit;
begin
	Application.MessageBox('This component is freeware. (c) 1997 Random Features, Inc.',
   						'TMenuIcon component version 1.0', MB_OK+ MB_ICONINFORMATION);
end;

function TAboutMnuIconProperty.GetAttributes: TPropertyAttributes;
begin
	Result := [paMultiSelect, paDialog, paReadOnly];
end;

function TAboutMnuIconProperty.GetValue: string;
begin
	Result := '(about)';
end;

{Create BDE Componet}
constructor TMenuIcon.Create(AOwner: TComponent);

begin
    inherited Create(AOwner);
    FBitMap := TBitMap.Create;
    FMainMenuPos:= 0;
    FSubMenuPos:= 0;
end;

Procedure TMenuIcon.SetBitMap(Value: TBitMap);
Begin
     FBitMap.Assign(Value);
end;

procedure Register;
begin
  RegisterComponents('RFI', [TMenuIcon]);
  RegisterPropertyEditor(TypeInfo(TAboutMnuIconProperty), TMenuIcon, 'ABOUT', TAboutMnuIconProperty);

end;

Procedure TMenuIcon.InsertMnuIcon(MainPos:Integer; SubPos:Integer; Thebitmap:TBitmap; TheMenu: TMenu);
var
hSubMenu: Integer;
begin
//    'get the handle to the first drop-down menu
    hSubMenu := GetSubMenu(TheMenu.Handle, MainPos);
  //  'insert the bitmap into the menu item
    SetMenuItemBitmaps(hSubMenu, SubPos, MF_BYPOSITION, TheBitMap.Handle, TheBitMap.handle);
  //  'redraw menu bar to show changes
    DrawMenuBar(Application.Handle)
end;

Procedure TMenuIcon.UpdateMenu;
begin
    InsertMnuIcon(FMainMenuPos, FSubMenuPos, FBitMap, FMenu);
    
end;

end.
