unit TShadowControl;

interface

uses
  Windows, Messages, Classes, Controls, ExtCtrls, StdCtrls, dsgnIntf, Dialogs, forms,
  Graphics, SysUtils, Custbtn, Buttons,ComCtrls;


{
TShadow Puts a shadow behind controls placed directly on a form
}
Type
        {AboutBox dialog as a property}
	TAboutShadowProperty = class(TPropertyEditor)
	public
		procedure Edit; override;
		function GetAttributes: TPropertyAttributes; override;
		function GetValue: string; override;
	end;

        {Define which controls can have shadows}
	TShadowOption = (boTButton, boTLabel, boTEdit, boTMemo, boTComboBox, boTPanel, boTListBox, boTBitBtn, boTSpeedButton, boTWinControl, boTGraphicControl, boTCustomControl, boTRichEdit);
	TShadowOptions = set of TShadowOption;

  TShadow = class(TComponent)

  private
    { Private declarations }
    FShadowDepth: integer;
    FShadowColor: TColor;
    FAbout: TAboutShadowProperty;
    FInclude: TShadowOptions;


  protected
    { Protected declarations }
    procedure MyOnPaint(Sender: TObject);
  public
    { Public declarations }
    MyOwner : Tform;
    Constructor Create(AOwner: TComponent); override;
    procedure AddShadows(MyOwner:Tform);  {Call this from the forms Paint event}
  published
    { Published declarations }
    property About: TAboutShadowProperty read FAbout write FAbout;
    property ShadowDepth: Integer read FShadowDepth write FShadowDepth;
    property Include: TShadowOptions read FInclude write FInclude stored True;
    property ShadowColor: TColor read FShadowColor write FShadowColor;

  end;


  {TShadowPanel - Any control place within the panel will get a shadow}
  Type
        {AboutBox as a property}
	TAboutShadowPanelProperty = class(TPropertyEditor)
	public
		procedure Edit; override;
		function GetAttributes: TPropertyAttributes; override;
		function GetValue: string; override;
	end;



  TShadowPanel = class(TPanel)

  private
    { Private declarations }
    FShadowPanelDepth: integer;
    FAbout: TAboutShadowPanelProperty;
    FCanvas: TCanvas;
    FShadowPanelColor: TColor;
  protected
    { Protected declarations }
  public
    { Public declarations }
    Constructor Create(AOwner: TComponent); override;
    procedure AddPanelShadows;
    destructor Destroy; override;
    Procedure Paint; override;
    property Canvas: TCanvas read FCanvas;
    procedure SetColor(Value:TColor);
    procedure SetDepth(Value: Integer);

  published
    { Published declarations }
    property About: TAboutShadowPanelProperty read FAbout write FAbout;
    property ShadowPanelDepth: Integer read FShadowPanelDepth write SetDepth;
    Property ShadowPanelColor: TColor read FShadowPanelColor write SetColor;

  end;

procedure Register;

implementation

procedure Register;
begin  {Register the component and register the about box as a property}
  RegisterComponents('RFI', [TShadow]);
  RegisterPropertyEditor(TypeInfo(TAboutShadowProperty), TShadow, 'ABOUT', TAboutShadowProperty);
  RegisterComponents('RFI', [TShadowPanel]);
  RegisterPropertyEditor(TypeInfo(TAboutShadowPanelProperty), TShadowPanel, 'ABOUT', TAboutShadowPanelProperty);
end;


{About for the TShadow Component}
procedure TAboutShadowProperty.Edit;
begin
{Display the about box when the user try to edit the about property}
	Application.MessageBox('This component is freeware. (c) 1997 Random Features, Inc.',
   						'TShadow component version 1.0', MB_OK+ MB_ICONINFORMATION);
end;

function TAboutShadowProperty.GetAttributes: TPropertyAttributes;
begin
{Define the about property}
	Result := [paMultiSelect, paDialog, paReadOnly];
end;

function TAboutShadowProperty.GetValue: string;
begin
{Set the caption for the about property}
	Result := '(about)';
end;


{Aboutbox for the TShadowPanel Component}
procedure TAboutShadowPanelProperty.Edit;
begin
{Display the about box when the user try to edit the about property}
	Application.MessageBox('This component is freeware. (c) 1997 Random Features, Inc.',
   						'TShadowPanel component version 1.0', MB_OK+ MB_ICONINFORMATION);
end;

function TAboutShadowPanelProperty.GetAttributes: TPropertyAttributes;
begin
{Define the about property}
	Result := [paMultiSelect, paDialog, paReadOnly];
end;

function TAboutShadowPanelProperty.GetValue: string;
begin
{Set the caption for the about property}
	Result := '(about)';
end;


{Create the TShadow Component}
Constructor TShadow.Create(AOwner: TComponent);
Begin
     Inherited Create(AOwner);

     {Define the default components to shadow}
     FInclude := [boTEdit, boTMemo, boTListBox];

     FShadowColor:= clBtnShadow;

     with Owner as TForm do
     begin
      OnPaint := MyOnPaint;
     end;

     {At design time deafult the Shadow Depth to 2}
     if (csDesigning in ComponentState) then
         FShadowDepth := 2;

  end;


procedure TShadow.MyOnPaint(Sender: TObject);
begin
  AddShadows(Owner as TForm);
end;

{Create the TShadowPanel component}
Constructor TShadowPanel.Create(AOwner: TComponent);
Begin
     Inherited Create(AOwner);

     {Add a TCanvas to the Panel so we have something to draw on}
     FCanvas := TControlCanvas.Create;
     TControlCanvas(FCanvas).Control := Self;

     FShadowPanelColor:= clBtnShadow;

     {At design time deafult the Shadow Depth to 2}
     if (csDesigning in ComponentState) then
         FShadowPanelDepth := 2;
end;


destructor TShadowPanel.Destroy;
begin
{Remember to destory the TCanvas}
  FCanvas.Free;
  inherited Destroy;
end;

{AddShadows to the Controls on the form}
procedure TShadow.AddShadows(MyOwner: TForm);
var
iCntrlIndx: integer;
iShadowDepth: integer;
Doit: Boolean;
begin

     for iCntrlIndx := 0 to MyOwner.ComponentCount -1 do
     begin
           DoIt :=False;
           {Set the collor of the Shadow}
           MyOwner.Canvas.Pen.Color := FShadowColor;
           {Varify that each control should have a shadow}
           if (boTButton in FInclude)and (MyOwner.Components[iCntrlIndx] is TButton) then Doit := True;
           if (boTLabel in FInclude)and (MyOwner.Components[iCntrlIndx] is TLabel) then Doit := True;
           if (boTEdit in FInclude)and (MyOwner.Components[iCntrlIndx] is TEdit) then Doit := True;
           if (boTMemo in FInclude)and (MyOwner.Components[iCntrlIndx] is TMemo) then Doit := True;
           if (boTComboBox in FInclude)and (MyOwner.Components[iCntrlIndx] is TComboBox) then Doit := True;
           if (boTPanel in FInclude)and (MyOwner.Components[iCntrlIndx] is TPanel) then Doit := True;
           if (boTListBox in FInclude)and (MyOwner.Components[iCntrlIndx] is TListBox) then Doit := True ;
           if (boTBitBtn in FInclude)and (MyOwner.Components[iCntrlIndx] is TBitBtn) then Doit := True;
           if (boTSpeedButton in FInclude)and (MyOwner.Components[iCntrlIndx] is TSpeedButton) then Doit := True;
           if (boTGraphicControl in FInclude)and (MyOwner.Components[iCntrlIndx] is TGraphicControl) then Doit := True;
           if (boTCustomControl in FInclude)and (MyOwner.Components[iCntrlIndx] is TCustomControl) then Doit := True;
           if (boTWinControl in FInclude)and (MyOwner.Components[iCntrlIndx] is TWinControl) then Doit := True;
           if (boTRichEdit in FInclude)and (MyOwner.Components[iCntrlIndx] is TRichEdit) then Doit := True;

                       {Draw teh shadow for the control}
           If Doit = true then
              for iShadowDepth := 0 to FShadowDepth do
              begin
                   {Bottom}
                   MyOwner.Canvas.MoveTo((MyOwner.Components[iCntrlIndx] as TControl).Left + 2, (MyOwner.Components[iCntrlIndx] as TControl).top + (MyOwner.Components[iCntrlIndx] as TControl).Height + iShadowDepth);
                   MyOwner.Canvas.LineTo((MyOwner.Components[iCntrlIndx] as TControl).Left + iShadowDepth + (MyOwner.Components[iCntrlIndx] as TControl).width, (MyOwner.Components[iCntrlIndx] as TControl).top +  (MyOwner.Components[iCntrlIndx] as TControl).height + iShadowDepth);
                   {Side}
                   MyOwner.Canvas.MoveTo((MyOwner.Components[iCntrlIndx] as TControl).Left + iShadowDepth + (MyOwner.Components[iCntrlIndx] as TControl).width, (MyOwner.Components[iCntrlIndx] as TControl).top +  (MyOwner.Components[iCntrlIndx] as TControl).Height + iShadowDepth);
                   MyOwner.Canvas.LineTo((MyOwner.Components[iCntrlIndx] as TControl).Left + iShadowDepth + (MyOwner.Components[iCntrlIndx] as TControl).width, (MyOwner.Components[iCntrlIndx] as TControl).top + 2);

               end;{For iShadowDepth}
     end;{For iCntrlIndex}

end;




{Add a shadow to all the control in the panel}
procedure TShadowPanel.AddPanelShadows;
var
iCntrlIndx: integer;
iShadowDepth: integer;
begin
     {Go through all the contorls}
     for iCntrlIndx := 0 to Self.ControlCount -1 do
     begin
          {SetCancasColor}
          Self.Canvas.Pen.Color := FShadowPanelColor;
          {Draw the Shadow}
          for iShadowDepth := 0 to FShadowPanelDepth do
              begin
                   {Bottom}
                   Self.Canvas.MoveTo(Self.Controls[iCntrlIndx].Left + 2, Self.Controls[iCntrlIndx].top + Self.Controls[iCntrlIndx].Height + iShadowDepth);
                   Self.Canvas.LineTo(Self.Controls[iCntrlIndx].Left + iShadowDepth + Self.Controls[iCntrlIndx].width, Self.Controls[iCntrlIndx].top +  Self.Controls[iCntrlIndx].height + iShadowDepth);
                   {Side}
                   Self.Canvas.MoveTo(Self.Controls[iCntrlIndx].Left + iShadowDepth + Self.Controls[iCntrlIndx].width, Self.Controls[iCntrlIndx].top + Self.Controls[iCntrlIndx].height + iShadowDepth);
                   Self.Canvas.LineTo(Self.Controls[iCntrlIndx].Left + iShadowDepth + Self.Controls[iCntrlIndx].width, Self.Controls[iCntrlIndx].top + 2);

              end;{for iShadowDepth}
     end;{for iCntrlIndex}

end;

{force the shadows to draw and keep things neat}
Procedure TShadowPanel.paint;
begin
  Inherited Paint;
  AddPanelShadows;
end;
{Redraw the control when the color changes}
Procedure TShadowPanel.SetColor(Value: TColor);
begin
     FShadowPanelColor := Value;
     Invalidate;
end;
{Redraw the control when the Shadowdepth changes}
Procedure TShadowPanel.SetDepth(Value: Integer);
begin
   FShadowPanelDepth := Value;
   Invalidate;
end;

end.
