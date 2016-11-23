unit TRoundControl;

interface

uses
  Windows, Messages, Classes, Controls, ExtCtrls, StdCtrls, dsgnIntf, Dialogs, forms,
  Graphics, SysUtils, Custbtn, Buttons,ComCtrls;


  Type
        {AboutBox as a property}
	TAboutRoundProperty = class(TPropertyEditor)
	public
		procedure Edit; override;
		function GetAttributes: TPropertyAttributes; override;
		function GetValue: string; override;
	end;


  TRoundAbout = class(TComponent)

  private
    { Private declarations }
    FAbout: TAboutRoundProperty;
    procedure DrawEllipticRegion(wnd : HWND; rect : TRect);

  protected
    { Protected declarations }
    procedure Loaded; override;
  public
    { Public declarations }
    Constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    { Published declarations }
    property About: TAboutRoundProperty read FAbout write FAbout;
  end;

procedure Register;

implementation

procedure Register;
begin  {Register the component and register the about box as a property}
  RegisterComponents('RFI', [TRoundAbout]);
  RegisterPropertyEditor(TypeInfo(TAboutRoundProperty), TRoundAbout, 'ABOUT', TAboutRoundProperty);
end;



procedure TAboutRoundProperty.Edit;
begin
{Display the about box when the user try to edit the about property}
	Application.MessageBox('This component is freeware. (c) 1997 Random Features, Inc.',
   						'TRoundAbout component version 1.0', MB_OK+ MB_ICONINFORMATION);
end;

function TAboutRoundProperty.GetAttributes: TPropertyAttributes;
begin
{Define the about property}
	Result := [paMultiSelect, paDialog, paReadOnly];
end;

function TAboutRoundProperty.GetValue: string;
begin
{Set the caption for the about property}
	Result := '(about)';
end;



{Create the TBusy component}
Constructor TRoundAbout.Create(AOwner: TComponent);
Begin
     Inherited Create(AOwner);

     {So we know when the form is closing}
     with Owner as TForm do
     begin
     end;


end;


destructor TRoundAbout.Destroy;
begin
{Remember to destory the TCanvas}

  inherited Destroy;
end;

procedure TRoundAbout.DrawEllipticRegion(wnd : HWND; rect : TRect);
Var
rgn: hrgn;
begin
  rgn := CreateEllipticRgn(rect.left, rect.top, rect.right, rect.bottom);
  SetWindowRgn(wnd, rgn, TRUE);
end;


procedure TRoundAbout.Loaded;
begin
     with Owner as TForm do
     begin
          borderStyle := bsNone;
          Caption := '';
          BorderIcons:= [];
          FormStyle := fsStayOnTop;
          Position := poScreenCenter;
     end;

 DrawEllipticRegion((Owner as TForm).Handle, (Owner as TForm).ClientRect);
end;

end.
