unit TBusyControl;

interface

uses
  Windows, Messages, Classes, Controls, ExtCtrls, StdCtrls, dsgnIntf, Dialogs, forms,
  Graphics, SysUtils, Custbtn, Buttons,ComCtrls;


  Type
        {AboutBox as a property}
	TAboutBusyProperty = class(TPropertyEditor)
	public
		procedure Edit; override;
		function GetAttributes: TPropertyAttributes; override;
		function GetValue: string; override;
	end;

   TBusy = Class;
   TTimerThread = Class(TThread)
   Public
      { Public declarations }
      OwnerTimer : TBusy;
     Procedure Execute ; Override ;
   End ;

  TBusy = class(TCustomPanel)

  private
    { Private declarations }
    FAbout: TAboutBusyProperty;
    FCanvas: TCanvas;
    FBusyColor: TColor;
    FPlay : boolean;
    FTimerThread : TTimerThread ;
    procedure SetPlay(Onn : boolean);

  protected
    { Protected declarations }
    property Canvas: TCanvas read FCanvas;
    procedure SetColor(Value:TColor);
    procedure DrawFadeColors(Clr1, Clr2: TColor; P: Integer);
    procedure MoveBar;
    procedure MyOnCloseQuery(Sender: TObject; var CanClose: Boolean);
  public
    { Public declarations }
    Constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    { Published declarations }
    property About: TAboutBusyProperty read FAbout write FAbout;
    Property BusyColor: TColor read FBusyColor write SetColor;
    property Play : boolean read FPlay write SetPlay;
    property Color;
    property Visible;
    property Align; 
  end;

procedure Register;

implementation

procedure Register;
begin  {Register the component and register the about box as a property}
  RegisterComponents('RFI', [TBusy]);
  RegisterPropertyEditor(TypeInfo(TAboutBusyProperty), TBusy, 'ABOUT', TAboutBusyProperty);
end;



procedure TAboutBusyProperty.Edit;
begin
{Display the about box when the user try to edit the about property}
	Application.MessageBox('This component is freeware. (c) 1997 Random Features, Inc.',
   						'TBusy component version 1.0', MB_OK+ MB_ICONINFORMATION);
end;

function TAboutBusyProperty.GetAttributes: TPropertyAttributes;
begin
{Define the about property}
	Result := [paMultiSelect, paDialog, paReadOnly];
end;

function TAboutBusyProperty.GetValue: string;
begin
{Set the caption for the about property}
	Result := '(about)';
end;



{Create the TBusy component}
Constructor TBusy.Create(AOwner: TComponent);
Begin
     Inherited Create(AOwner);
      BevelOuter := bvNone;
     {Add a TCanvas to the Panel so we have something to draw on}
     FCanvas := TControlCanvas.Create;
     TControlCanvas(FCanvas).Control := Self;

     {Deafult color}
     FBusyColor:= clBtnShadow;
     {Create our thread that will act as a timer}
     FTimerThread := TTimerThread . Create (true) ;
     FTimerThread.OwnerTimer := Self ;

     {So we know when the form is closing}
     with Owner as TForm do
     begin
      OnCloseQuery := MyOnCloseQuery;
     end;


end;

procedure TBusy.MyOnCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FPlay := False;
end;

destructor TBusy.Destroy;
begin
{Remember to destory the TCanvas}

  FPlay := False;
  fTimerThread.Terminate;
  FCanvas.Free;
  FTimerThread.Free;
  inherited Destroy;
end;

{Run our thread}
Procedure TTimerThread.Execute ;
Begin
   Priority := tpIdle;
   Repeat
      SleepEx(0, False);{Instand Return}
      Synchronize (OwnerTimer.MoveBar);
   Until Terminated ;
End ;




procedure TBusy.MoveBar;
var
iBusyBar: integer;
begin
     {Draw the bar and move it to the right}
     For iBusyBar := 0 - (Width div 4) to Width -(width div 4) do
         begin
              {Stop if necessary}
              if FPlay = false then
                 begin
                      invalidate;{Clear the screen}
                      exit;
                 end;

              DrawFadeColors(color, FBusyColor, iBusyBar);
              Application.Processmessages;

         end;

      {Stop if necessary}
     if FPlay = false then
        begin
             invalidate;{Clear the screen}
             exit;
        end;

     {Draw the bar and move it to the left}
     For iBusyBar :=  Width  downto 0 do

         begin
              {Stop if necessary}
              if FPlay = false then
                 begin
                      invalidate; {Clear the contorl}
                      exit;
                 end;
              DrawFadeColors(FBusyColor, color, iBusyBar);
              Application.Processmessages;

         end;
      {Stop if necessary}
     if FPlay = false then
        begin
             invalidate;
             exit;
        end;
     
end;

procedure TBusy.SetPlay(Onn : boolean);
begin
     if not (csDesigning in ComponentState) then
     if Onn <> FPlay then
        begin
             FPlay := Onn;
             if not Onn then
                begin
                     FTimerThread.Suspend; {Stop the thread}
                end
             else
                 begin
                      FTimerThread.Resume;{Start the thread}
                 end;
       end;

end;

{Redraw the control when the color changes}
Procedure TBusy.SetColor(Value: TColor);
begin
     FBusyColor := Value;
     Invalidate;{Redraw for the new color}
end;


procedure TBusy.DrawFadeColors(Clr1, Clr2: TColor; P: Integer);
var
  RGBFrom: array[0..2] of Byte; {from RGB values}
  RGBDiff: array[0..2] of integer; {difference of from/to RGB values}
  ColorBand: TRect; {color band rectangular coordinates}
  I: Integer;{color band index}
  R: Byte;{a color band's R value}
  G: Byte;{a color band's G value}
  B: Byte;{a color band's B value}
begin
   { extract from RGB values}
   RGBFrom[0] := GetRValue (ColorToRGB (Clr1));
   RGBFrom[1] := GetGValue (ColorToRGB (Clr1));
   RGBFrom[2] := GetBValue (ColorToRGB (Clr1));
   { calculate difference of from and to RGB values}
   RGBDiff[0] := GetRValue (ColorToRGB (Clr2)) - RGBFrom[0];
   RGBDiff[1] := GetGValue (ColorToRGB (Clr2)) - RGBFrom[1];
   RGBDiff[2] := GetBValue (ColorToRGB (Clr2)) - RGBFrom[2];
   { set pen sytle and mode}
   Canvas.Pen.Style := psSolid;
   Canvas.Pen.Mode := pmCopy;
   { set color band's top and bottom coordinates}
   ColorBand.Top := 2;
   ColorBand.Bottom := Height-2;
   for I := 0 to $ff do
   begin
       { calculate color band's left and right coordinates}
       ColorBand.Left  := (MulDiv (I , width div 4, $100)) + P;
       ColorBand.Right := (MulDiv (I + 1, width div 4,$100))+ p;
       { calculate color band color}
       R := RGBFrom[0] + MulDiv (I, RGBDiff[0], $ff);
       G := RGBFrom[1] + MulDiv (I, RGBDiff[1], $ff);
       B := RGBFrom[2] + MulDiv (I, RGBDiff[2], $ff);
       { select brush and paint color band}
       Canvas.Brush.Color := RGB (R, G, B);
       Canvas.FillRect (ColorBand);
   end;
end;



end.
