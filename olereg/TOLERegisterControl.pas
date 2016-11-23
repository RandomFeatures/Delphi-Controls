unit TOLERegisterControl;

interface

uses
  Windows, Messages, Classes, sysutils, dsgnIntf, Dialogs, forms;


  Type
        {AboutBox as a property}
	TAboutOLERegisterProperty = class(TPropertyEditor)
	public
		procedure Edit; override;
		function GetAttributes: TPropertyAttributes; override;
		function GetValue: string; override;
	end;


  TOLERegister = class(TComponent)

  private
    { Private declarations }
    FAbout: TAboutOLERegisterProperty;
    FFileToRegister: String;
    FSuccessful: Boolean;
  protected
    { Protected declarations }
    {procedure Loaded; override;}
    procedure DLLSelfReg(szFileToRegister: String);
  public
    { Public declarations }


    Constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SuccessFul: Boolean Read FSuccessful write FSuccessful;
    Procedure Execute;
  published
    { Published declarations }
    property About: TAboutOLERegisterProperty read FAbout write FAbout;
    property FileToRegister: String Read FFileToRegister Write FFileToRegister;

  end;

procedure Register;

implementation

procedure Register;
begin  {Register the component and register the about box as a property}
  RegisterComponents('RFI', [TOLERegister]);
  RegisterPropertyEditor(TypeInfo(TAboutOLERegisterProperty), TOLERegister, 'ABOUT', TAboutOLERegisterProperty);
end;



procedure TAboutOLERegisterProperty.Edit;
begin
{Display the about box when the user try to edit the about property}
	Application.MessageBox('This component is freeware. (c) 1997 Random Features, Inc.',
   						'TOLERegister component version 1.0', MB_OK+ MB_ICONINFORMATION);
end;

function TAboutOLERegisterProperty.GetAttributes: TPropertyAttributes;
begin
{Define the about property}
	Result := [paMultiSelect, paDialog, paReadOnly];
end;

function TAboutOLERegisterProperty.GetValue: string;
begin
{Set the caption for the about property}
	Result := '(about)';
end;



{Create the TBusy component}
Constructor TOLERegister.Create(AOwner: TComponent);
Begin
     Inherited Create(AOwner);

end;


destructor TOLERegister.Destroy;
begin
{Remember to destory the TCanvas}

  inherited Destroy;
end;



procedure TOLERegister.DLLSelfReg(szFileToRegister: String);
var
   DllRegisterserver: TFarProc;
   HStr: THandle;
   pfilename: PChar;
begin
     try

        pfilename := pChar(0);
        pfilename := StrAlloc(255);
        if FileExists(szFileToRegister) then
           Begin
             StrPCopy(pfilename, szFileToRegister);
             Hstr:= LoadLibrary(pfilename);
             DllRegisterserver := (GetProcAddress(hStr, 'DllRegisterServer'));
            
             if (dllRegisterServer <> NIL) then {DLL Call worked}
                begin
                     {Make it work}
                     asm
                        push CS
                        call DllRegisterServer
                     end;
                     FSuccessful := True;
                end
            else
                FSuccessful := False;
                 {raise ERegistryException.Create('UNKOWN ERROR: Unable to registered '+ StrPas(FileName)+ ' with windows.');}
           end
        else
            FSuccessful := False;

     finally
            StrDispose(pfileName);
            FreeProcInstance(DllRegisterServer);
            FreeLibrary(Hstr);
     end;{Try}
end;{procedure}

 Procedure TOLERegister.Execute;
 begin
   if FFileToRegister <> '' then
      DLLSelfReg(FFileToRegister)
   else
       FSuccessful := False;

 end;


end.
