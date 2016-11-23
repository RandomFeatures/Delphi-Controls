unit TVerifyDriveLetter;

interface

uses
   Windows, Messages, Classes, Controls, ExtCtrls, StdCtrls, dsgnIntf, Dialogs, forms,
  Graphics, SysUtils;


Type
	TAboutVerifyDrivesProperty = class(TPropertyEditor)
	public
		procedure Edit; override;
		function GetAttributes: TPropertyAttributes; override;
		function GetValue: string; override;
	end;

  TVerifyDrives = class(TComponent)
  private

    { Private declarations }
     FAbout: TAboutVerifyDrivesProperty;
     FDriveLetter: Char;
     FDriveIsAvailable: Boolean;
     FAvailableDrives: String;
     FCheckOnStartUp: Boolean;

  protected
    { Protected declarations }
  procedure Loaded; override;
  function DiskInDrive(Drive: Char): Boolean;
  Procedure SetDriveLetter(Value: Char);

  public
    { Public declarations }
  Procedure CheckDrivesNow;
    constructor Create(AOwner: TComponent); override;

  published
    { Published declarations }
    property About: TAboutVerifyDrivesProperty read FAbout write FAbout;
    property DriveLetter: Char Read FDriveLetter Write SetDriveLetter;
    property DriveIsAvailable: Boolean read FDriveIsAvailable Write FDriveIsAvailable;
    property AvailableDrives: String read FAvailableDrives write FAvailableDrives;
    Property CheckOnStartUp: Boolean read FCheckOnStartUp write FCheckOnStartUp;

  end;


procedure Register;

implementation
procedure TVerifyDrives.Loaded;


begin
   inherited Loaded;
   if Not(csDesigning in ComponentState) then
     if FCheckOnStartUp = True then
        CheckDrivesNow
     else
         FAvailableDrives := 'N/A';



end;

procedure TAboutVerifyDrivesProperty.Edit;
begin
	Application.MessageBox('This component is freeware. (c) 1997 Random Features, Inc.',
   						'TVerifyDrives component version 1.0', MB_OK+ MB_ICONINFORMATION);
end;

function TAboutVerifyDrivesProperty.GetAttributes: TPropertyAttributes;
begin
	Result := [paMultiSelect, paDialog, paReadOnly];
end;

function TAboutVerifyDrivesProperty.GetValue: string;
begin
	Result := '(about)';
end;

{Create BDE Componet}
constructor TVerifyDrives.Create(AOwner: TComponent);

begin
    inherited Create(AOwner);
    DriveLetter := 'C';
    FAvailableDrives := 'N/A';
end;


procedure Register;
begin
  RegisterComponents('RFI', [TVerifyDrives]);
  RegisterPropertyEditor(TypeInfo(TAboutVerifyDrivesProperty), TVerifyDrives, 'ABOUT', TAboutVerifyDrivesProperty);

end;

Procedure TVerifyDrives.CheckDrivesNow;
var
iDriveA: LongInt;
iDriveZ: LongInt;
x: LongInt;
begin
    iDriveA := Ord('A');
    iDriveZ := Ord('Z');
    FAvailableDrives := '';
    for x :=  iDriveA to iDriveZ do
        begin
             if DiskInDrive(Chr(x)) then
                FAvailableDrives := FAvailableDrives + Char(X) + ',';
        end;
    if Length(FAvailableDrives) > 0 then
       Delete(FAvailableDrives,Length(FAvailableDrives),1);
      { AvailableDrivesss := FAvailableDrivesss;}
end;


Procedure TVerifyDrives.SetDriveLetter(Value: Char);
Begin
     FDriveLetter := Value;
     FDriveIsAvailable := DiskInDrive(Value);
end;

function TVerifyDrives.DiskInDrive(Drive: Char): Boolean;
var
  ErrorMode: word;
begin
  { make it upper case }
  if Drive in ['a'..'z'] then Dec(Drive, $20);
  { make sure it's a letter }
  if not (Drive in ['A'..'Z']) then
    raise EConvertError.Create('Not a valid Drive ID');
  { turn off critical errors }
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    { Drivess 1 = a, 2 = b, 3 = c, etc. }
    if DiskSize(Ord(Drive) - $40) = -1 then
      Result := False
    else
      Result := True;
  finally
    { restore old error mode }
    SetErrorMode(ErrorMode);
  end;
end;



end.
