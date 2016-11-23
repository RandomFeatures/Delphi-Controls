unit Tlabedit;

interface

uses
  Windows, Messages, Classes, Controls, ExtCtrls, StdCtrls,dsgnIntf, Dialogs, forms,
  Graphics;

var
Si: byte;

Type
        {Define the about box as a property}
	TAboutLabelEditProperty = class(TPropertyEditor)
	public
		procedure Edit; override;
		function GetAttributes: TPropertyAttributes; override;
		function GetValue: string; override;
	end;
        {Define the option for the layout}
       	TLabelEditLayout = (leCaptionTop, leCaptioLeft);
        {Define the options for the effects}
        TLabelEditEffect = (leSunken, leFlying);

  TLabelEdit = class(TCustomPanel)
  private
    { Private declarations }
    FLabel: TLabel;
    FEdit: TEdit;
    FCaptionText: String;
    FEditText: String;
    FCaptionAlignment: TAlignment;
    FCaptionFont: TFont;
    FEditFont: TFont;
    FCaptionHeight: Integer;
    FEditHeight: Integer;
    FAbout: TAboutLabelEditProperty;
    FLayout: TLabelEditLayout;
    FEffect: TLabelEditEffect;
    FCaptionWidth: Integer;
    FCanvas: TCanvas;
  protected
    { Protected declarations }

  public
    { Public declarations }
    property label1: TLabel read Flabel;
    property edit1: TEdit read FEdit;
    property Canvas: TCanvas read FCanvas;

    destructor Destroy; override;
    Constructor Create(AOwner: TComponent); override;

    Procedure WMSize(var Message: TWMSize); message WM_SIZE;
    Procedure Paint; override;
    procedure SetCaptionText(Value: String);
    procedure SetEditText(Value: String);
    procedure SetCaptionAlignment(Value: TAlignment);
    Procedure SetCaptionFont(Value: TFont);
    Procedure SetEditFont(Value: TFont);
    procedure SetCaptionHeight(Value: Integer);
    procedure SetCaptionWidth(Value: Integer);
    procedure SetLayout(value: TLabelEditLayout);
    Procedure SetEffect(Value: TLabelEditEffect);
    Procedure SetEditHeight(Value: Integer);
    Procedure DrawLayout;
    procedure AddShadow;
    Function GetEditText: String;
  published
    { Published declarations }
    property About: TAboutLabelEditProperty read FAbout write FAbout;
    property Layout: TLabelEditLayout read FLayout write SetLayout stored True default leCaptionTop;
    property Effect: TLabelEditEffect read FEffect write SetEffect stored True default leSunken;

    property CaptionText: String read FCaptionText write SetCaptionText;
    property EditText: String read GetEditText write SetEditText;
    property CaptionAlignment: TAlignment read FCaptionAlignment write SetCaptionAlignment;
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont stored true;
    property EditFont: TFont read FEditFont write SetEditFont stored true;
    Property CaptionHeight: Integer read FCaptionHeight write SetCaptionHeight default 30;
    Property EditHeight: Integer read FEditHeight write SetEditHeight default 30;
    Property CaptionWidth: Integer read FCaptionWidth write SetCaptionWidth default 150;
    Property BevelInner;
    property BevelOuter;
    property BorderWidth;
    property BorderStyle;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnResize;





  end;

procedure Register;

implementation

procedure Register;
begin
  {Register the component}
  RegisterComponents('RFI', [TLabelEdit]);
  {Register the about box as a property}
  RegisterPropertyEditor(TypeInfo(TAboutLabelEditProperty), TLabelEdit, 'ABOUT', TAboutLabelEditProperty);

end;

{Set up our about box}
procedure TAboutLabelEditProperty.Edit;
begin
     {Display a dialog when the user tries to edit the about property}
	Application.MessageBox('This component is freeware. (c) 1997 Random Features, Inc.',
   						'TLabelEdit component version 2.0', MB_OK+ MB_ICONINFORMATION);
end;

function TAboutLabelEditProperty.GetAttributes: TPropertyAttributes;
begin
         {Define how to interface the aboutbox with the object inspector}
	Result := [paMultiSelect, paDialog, paReadOnly];
end;

function TAboutLabelEditProperty.GetValue: string;
begin
	Result := '(about)';
end;


{create the TLabelEdit Contol}
Constructor TLabelEdit.Create(AOwner: TComponent);
Begin
     Inherited Create(AOwner);
     {Place a canvas on our control so that we have something to drawon}
     FCanvas := TControlCanvas.Create;
     TControlCanvas(FCanvas).Control := Self;

     {Setup our panel}
     Si := 0;
     BevelOuter := bvNone;
     Ctl3D := False;
     Caption := ' ';
     FCaptionFont := TFont.Create;
     FEditFont := TFont.Create;
     fCaptionHeight:= 30;
     FCaptionWidth := 150;
     fEditHeight := 30;


     {Create and Setup the TLabel Control}
     Flabel := TLabel.Create(Self);
     Flabel.Parent := Self;
     Flabel.Caption := 'Caption';
     FLabel.Font.Name := 'Time New Roman';
     FLabel.Font.Size := 10;
     Flabel.left := 1;
     Flabel.Top := 5;
     FLabel.AutoSize := False;
     FLabel.Transparent := True;
     FLabel.Align := alTop;
     Flabel.show;

     {Create and Setup the TEdit Control}
     Fedit := Tedit.Create(Self);
     Fedit.Parent := Self;
     FEdit.Font.Name := 'Time New Roman';
     FEdit.Font.Size := 10;
     Fedit.left := 1;
     Fedit.top := Flabel.Height + 2;
     Fedit.width := width -6;
     FEdit.Text := '';
     Fedit.show;
end;

destructor TLabelEdit.Destroy;
begin
  {Make sure we free the Tcanvas}
  FCanvas.Free;
  inherited Destroy;
end;

{Set the Layout Property and make the changes}
Procedure TLabelEdit.SetLayout(Value: TLabelEditLayout);
Begin
	if FLayout <> value then
        begin
	     FLayout := value;
             DrawLayout;
        end
End;

procedure TLabelEdit.SetEffect(Value: TLabelEditEffect);
begin

     If FEffect <> value then
     begin
          FEdit.Ctl3d := False;
          FEffect := Value;

          If FEffect = leSunken then
             begin
                  Invalidate;
                  FEdit.Ctl3D := True;
             end {IF FEffect =}
          else
              begin
                   FEdit.Ctl3d := False;
                   Application.Processmessages;
                   AddShadow;
          end;{IF Else}
     end;{If FEffect <>}
end;

Procedure TLabelEdit.paint;
begin
     Inherited Paint;
     {Draw the shadow if needed}
     If FEffect = leFlying then
         begin
            AddShadow;
         end;
end;

procedure TLabelEdit.AddShadow;
var
iShadowDepth: integer;
begin
     {Define the shadow color}
     Canvas.Pen.Color := clbtnShadow;
    {Draw the shadow}
     for iShadowDepth := 0 to 2 do
         begin
              {Bottom}
              Canvas.MoveTo(FEdit.Left + 2, FEdit.top + FEdit.Height + iShadowDepth);
              Canvas.LineTo(FEdit.Left + iShadowDepth + FEdit.width, FEdit.top +  FEdit.height + iShadowDepth);
              Canvas.MoveTo(FEdit.Left + iShadowDepth + FEdit.width, FEdit.top +  FEdit.height + iShadowDepth);
              Canvas.LineTo(FEdit.Left + iShadowDepth + FEdit.width, FEdit.top + 2);
              {Side}
              Canvas.MoveTo(FEdit.Left + 2, FEdit.top + FEdit.Height + iShadowDepth);
              Canvas.LineTo(FEdit.Left + iShadowDepth + FEdit.width, FEdit.top + FEdit.height + iShadowDepth);
              Canvas.MoveTo(FEdit.Left + iShadowDepth + FEdit.width, FEdit.top + FEdit.height + iShadowDepth);
              Canvas.LineTo(FEdit.Left + iShadowDepth + FEdit.width, FEdit.top + 2);
         end;
end;


Procedure TLabelEdit.DrawLayout;
begin
     {Draw the layout base on the layout option}
     IF FLayout = leCaptiontop then
        begin
           FLabel.Align := alTop;
           Width := 155;
           Height := 53;
           FLabel.Top := 5;
           Fedit.top := Flabel.Height + 2;
           Fedit.width := width -6;
           FLabel.Left := 1;
           FEdit.Left := FLabel.Left;
        end{if FLayout}
     else
        begin
           FLabel.Align := alNone;
           Flabel.Width := 75;
           FCaptionWidth:= 75;
           Width := FLabel.Width + FEdit.Width;
           Height := FEditHeight;
           FEdit.top := FLabel.Top;
           FEdit.Left := FLabel.Left + FLabel.Width;
        end; {if Else}


end;


{Assing the property value to the text feild}
Function TLabelEdit.GetEditText: String;
Begin
     result := FEdit.Text;
end;

procedure TLabelEdit.SetCaptionHeight(Value: Integer);
begin
     FCaptionHeight := Value;
     Flabel.Height := Value;
     if FLayout = leCaptionTop then
        begin
             FEdit.Top := (FLabel.top + Flabel.Height + 2);
             Height := (FEdit.top +  FEdit.Height + 5);
        end
     else
        begin
             If FCaptionHeight > FEditHeight then
                Height := FLabel.Height + 12
             Else
                Height := FEdit.Height + 12;
        end;

end;
procedure TLabelEdit.SetEditHeight(Value: Integer);
begin
     FEditHeight := Value;
     FEdit.Height := Value;
     if FLayout = leCaptionTop then
        begin
             Height := (FEdit.top + FEdit.Height + 5);
        end
     else
        begin
             If FCaptionHeight > FEditHeight then
                Height := FLabel.Height + 12
             Else
                Height := FEdit.Height + 12;
        end;

end;


procedure TLabelEdit.SetCaptionWidth(Value: Integer);
begin

     FCaptionWidth := Value;
     Flabel.Width := Value;
      IF FLayout = leCaptiontop then
        begin
           if Value > Width then
           Width := Value;
        end
     else
        begin
           Width := FLabel.Width +2+ FEdit.Width;
           FEdit.Left := FLabel.Left + FLabel.Width + 2;
        end;

end;



procedure TLabelEdit.SetEditFont(Value: TFont);
begin
    FEdit.Font.Assign(Value);
    FEditFont.assign(Value);
end;


procedure TLabelEdit.SetCaptionFont(Value: TFont);
begin
   FLabel.Font.assign(Value);
   FCaptionFont.assign(Value);
end;

procedure TLabelEdit.SetCaptionAlignment(Value: TAlignment);
begin
          FLabel.Alignment := Value;
          FCaptionAlignment := Value;
end;

procedure TLabelEdit.SetCaptionText(Value: String);
begin
     FLabel.Caption := Value;
     FCaptionText := Value;
end;

procedure TLabelEdit.SetEditText(Value: String);
begin
     FEdit.Text := Value;
     FEditText := Value;
end;

procedure TLabelEdit.WMSize(var Message: TWMSize);
begin
     Inherited;
     {Sepcify the size}
     If si = 0 then
          Begin
               if (csDesigning in ComponentState) then
               begin
                IF FLayout = leCaptiontop then
                   begin
                        Width := 155;
                        Height := 53;

                   end
                else
                    begin
                         Width := FLabel.Width + FEdit.Width;
                         Height := FLabel.Height;
                    end;
               end;
               si := 1;

          end;

     if Assigned(FEdit) then
          begin
               IF FLayout = leCaptiontop then
                  begin
                       FEdit.Width := (Width - 6);
                  end
               else
                  begin
                       FEdit.Width := Width - FLabel.Width -8;
                       FEdit.Left := FLabel.Left +2 + FLabel.Width;
                  end;
          end;
end;
initialization
si := 1;


end.
