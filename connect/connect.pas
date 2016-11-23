unit connect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, DXPlay, DirectX,
  ExtCtrls, StdCtrls, registry;

type
  TfrmConnect = class(TForm)
    Bevel1: TBevel;
    Notebook: TNotebook;
    Label1: TLabel;
    ProviderList: TListBox;
    Label2: TLabel;
    NewGame: TRadioButton;
    JoinGame: TRadioButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    NewGameSessionName: TEdit;
    NewGamePlayerName: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    JoinGamePlayerName: TEdit;
    JoinGameSessionList: TListBox;
    NextButton: TButton;
    BackButton: TButton;
    CancelButton: TButton;
    Panel1: TPanel;
    Image1: TImage;
    Label10: TLabel;
    ModemPhoneNumber: TEdit;
    Label11: TLabel;
    ModemComboBox: TComboBox;
    Label12: TLabel;
    SessionNameEdit: TEdit;
    TCPIPHostName: TComboBox;
    Label6: TLabel;
    Label13: TLabel;
    procedure NextButtonClick(Sender: TObject);
    procedure JoinGameSessionListClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure NotebookPageChanged(Sender: TObject);
    procedure ProviderListClick(Sender: TObject);
    procedure ProviderListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NewGameClick(Sender: TObject);
    procedure NewGameSessionNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NewGamePlayerNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure JoinGameSessionListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure JoinGamePlayerNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure JoinGamePlayerNameKeyPress(Sender: TObject; var Key: Char);
  private
    procedure Connect;
  public
    DXPlay: TDXPlay;
  end;

var
  frmConnect: TfrmConnect;

implementation

uses DXConsts;

{$R *.DFM}

procedure TfrmConnect.NextButtonClick(Sender: TObject);
begin
if  Notebook.activepage = 'SelectProvider' then
    begin
         DXPlay.ProviderName := ProviderList.Items[ProviderList.ItemIndex];
         Notebook.activepage := 'SessionType';
    end
else
    begin
         if Notebook.activepage = 'SessionType' then
            begin
                 if NewGame.Checked then
                    begin
                         Notebook.ActivePage := 'SessionNew';
                    end
                 else
                     begin
                            if CompareMem(PGUID(ProviderList.Items.Objects[ProviderList.ItemIndex]), @DPSPGUID_TCPIP, SizeOf(TGUID)) then
                               begin
                                    {  TCP/IP  }
                                    Notebook.ActivePage := 'ProviderSettingTCPIP';
                               end else
                               if CompareMem(PGUID(ProviderList.Items.Objects[ProviderList.ItemIndex]), @DPSPGUID_MODEM, SizeOf(TGUID)) then
                                  begin
                                       {  Modem  }
                                       Notebook.ActivePage := 'ProviderSettingModem';
                                       if ModemComboBox.Items.Count=0 then
                                       begin
                                            Screen.Cursor := crHourGlass;
                                            try
                                               ModemComboBox.Items := DXPlay.ModemSetting.ModemNames;
                                               ModemComboBox.ItemIndex := 0;
                                            finally
                                                   Screen.Cursor := crDefault;
                                            end;
                                       end;
                                  end;
                     end;
            end
         else
             begin
                  if Notebook.ActivePage='SessionNew' then
                     begin
                       DXPlay.Open2(True, NewGameSessionName.Text, NewGamePlayerName.Text);
                       Tag := 1;
                       ModalResult := mrOk;
                       //Close;
                     end
                  else
                      begin
                           if Notebook.ActivePage='SessionJoin' then
                              begin
                                    DXPlay.Open2(False, SessionNameEdit.Text, JoinGamePlayerName.Text);
                                    Tag := 1;
                                    ModalResult := mrOK;
                                    //Close;
                              end
                           else
                               begin
                                    if Notebook.ActivePage = 'ProviderSettingTCPIP' then
                                    begin
                                           JoinGameSessionList.Items.Clear;
                                           DXPlay.TCPIPSetting.HostName := TCPIPHostName.Text;
                                           DXPlay.TCPIPSetting.Enabled := True;
                                           DXPlay.ProviderName := ProviderList.Items[ProviderList.ItemIndex];
                                           Connect;
                                    end
                                    else
                                    if Notebook.ActivePage = 'ProviderSettingModem' then
                                        begin
                                             DXPlay.ModemSetting.PhoneNumber := ModemPhoneNumber.Text;
                                             DXPlay.ModemSetting.ModemName := ModemComboBox.Items[ModemComboBox.ItemIndex];
                                             DXPlay.ModemSetting.Enabled := True;
                                             DXPlay.ProviderName := ProviderList.Items[ProviderList.ItemIndex];

                                             Connect;
                                        end
                                    else
                                        begin
                                               JoinGameSessionList.Items.Clear;

                                               DXPlay.ProviderName := ProviderList.Items[ProviderList.ItemIndex];

                                               Connect;
                                        end;

                                    Notebook.ActivePage := 'SessionJoin';
                               end
                      end;
             end;
    end;
end;

procedure TfrmConnect.JoinGameSessionListClick(Sender: TObject);
begin
SessionNameEdit.Text := JoinGameSessionList.Items[JoinGameSessionList.ItemIndex];
NotebookPageChanged(nil)
end;

procedure TfrmConnect.Connect;
begin
  Screen.Cursor := crHourGlass;
  try
    DXPlay.GetSessions;
    JoinGameSessionList.Items := DXPlay.Sessions;
  finally
    Screen.Cursor := crDefault;
  end;

end;


procedure TfrmConnect.FormShow(Sender: TObject);
var
iniOptions : TRegIniFile;
PIndex: integer;
begin
PIndex := 0;

          iniOptions := TRegIniFile.Create(Application.ExeName);
          NewGamePlayerName.text := iniOptions.ReadString('DirectPlay', 'NewPlayerName', '');
          JoinGamePlayerName.text := iniOptions.ReadString('DirectPlay', 'JoinPlayerName', '');
          NewGameSessionName.text := iniOptions.ReadString('DirectPlay', 'SessionName', '');
          if iniOptions.ReadString('DirectPlay', 'HostName', '') <> '' then
          begin
               TCPIPHostName.Items.add(iniOptions.ReadString('DirectPlay', 'HostName', ''));
               TCPIPHostName.ItemIndex := 0;
          end;
          ModemPhoneNumber.text := iniOptions.ReadString('DirectPlay', 'PhoneNumber', '');
          PIndex := iniOptions.ReadInteger('DirectPlay', 'Provider', 0);
          iniOptions.free;
          iniOptions := nil;



  ProviderList.Items := DXPlay.Providers;
  ProviderList.ItemIndex := PIndex;
  ProviderListClick(nil);
  NoteBook.ActivePage :='SelectProvider';

end;

procedure TfrmConnect.BackButtonClick(Sender: TObject);
begin

  if Notebook.ActivePage='SessionNew' then
  begin
//    DPlay := nil;
    Notebook.ActivePage := 'SessionType'
  end else if Notebook.ActivePage='SessionJoin' then
  begin
//    DPlay := nil;
    Notebook.ActivePage := 'SessionType'
  end
    else if Notebook.ActivePage='ProviderSettingTCPIP' then
  begin
//    DPlay := nil;
    Notebook.ActivePage := 'SessionType'
  end
    else if Notebook.ActivePage='ProviderSettingModem' then
  begin
//    DPlay := nil;
    Notebook.ActivePage := 'SessionType'
  end
  else
    Notebook.PageIndex := Notebook.PageIndex - 1;

end;

procedure TfrmConnect.CancelButtonClick(Sender: TObject);
begin
  Close;

end;

procedure TfrmConnect.NotebookPageChanged(Sender: TObject);
begin
  if Notebook.ActivePage='SelectProvider' then
  begin
    BackButton.Enabled := False;
    NextButton.Enabled := ProviderList.ItemIndex<>-1;
    NextButton.Caption := 'Next >';
  end else if Notebook.ActivePage='SessionType' then
  begin
    BackButton.Enabled := True;
    NextButton.Enabled := NewGame.Checked or JoinGame.Checked;
    NextButton.Caption := 'Next >';
  end else if Notebook.ActivePage='SessionNew' then
  begin
    BackButton.Enabled := True;
    NextButton.Enabled := (NewGameSessionName.Text<>'') and (NewGamePlayerName.Text<>'');
    NextButton.Caption := 'Finish';
  end else if Notebook.ActivePage='SessionJoin' then
  begin
    BackButton.Enabled := True;
    NextButton.Enabled := (JoinGameSessionList.ItemIndex<>-1) and (JoinGamePlayerName.Text<>'');
    NextButton.Caption := 'Finish';
  end  else if Notebook.ActivePage='ProviderSettingTCPIP' then
  begin
    BackButton.Enabled := True;
    NextButton.Enabled := (TCPIPHostName.ItemIndex<>-1) or (TCPIPHostName.Text<>'');
    NextButton.Caption := 'Next >';
  end else if Notebook.ActivePage='ProviderSettingModem' then
  begin
    BackButton.Enabled := True;
    NextButton.Enabled := (ModemComboBox.ItemIndex<>-1) or (ModemPhoneNumber.Text<>'');
    NextButton.Caption := 'Next >';
  end


end;

procedure TfrmConnect.ProviderListClick(Sender: TObject);
begin
  NotebookPageChanged(nil);

end;

procedure TfrmConnect.ProviderListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_RETURN) and (NextButton.Enabled) then
  begin
    NextButtonClick(nil);
    Key := 0;
  end;

end;

procedure TfrmConnect.NewGameClick(Sender: TObject);
begin
  NotebookPageChanged(nil);

end;

procedure TfrmConnect.NewGameSessionNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if NewGameSessionName.Text='' then Exit;

  if Key=VK_RETURN then
  begin
    if NextButton.Enabled then
    begin
      NextButtonClick(nil);
      Key := 0;
    end else if NewGamePlayerName.Text='' then
    begin
      NewGamePlayerName.SetFocus;
      Key := 0;
    end;
  end;

end;

procedure TfrmConnect.NewGamePlayerNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if NewGamePlayerName.Text='' then Exit;

  if Key=VK_RETURN then
  begin
    if NextButton.Enabled then
    begin
      NextButtonClick(nil);
      Key := 0;
    end else if NewGameSessionName.Text='' then
    begin
      NewGameSessionName.SetFocus;
      Key := 0;
    end;
  end;

end;

procedure TfrmConnect.JoinGameSessionListKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if JoinGameSessionList.ItemIndex=-1 then Exit;

  if Key=VK_RETURN then
  begin
    if NextButton.Enabled then
    begin
      NextButtonClick(nil);
      Key := 0;
    end else if JoinGamePlayerName.Text='' then
    begin
      JoinGamePlayerName.SetFocus;
      Key := 0;
    end;
  end;

end;

procedure TfrmConnect.JoinGamePlayerNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if JoinGamePlayerName.Text='' then Exit;

  if Key=VK_RETURN then
  begin
    if NextButton.Enabled then
    begin
      NextButtonClick(nil);
      Key := 0;
    end else if JoinGameSessionList.ItemIndex=-1 then
    begin
      JoinGameSessionList.SetFocus;
      Key := 0;
    end;
  end;
end;

procedure TfrmConnect.FormClose(Sender: TObject; var Action: TCloseAction);
var
iniOptions : TRegIniFile;
begin
     iniOptions := TRegIniFile.Create(Application.ExeName);
     if NewGamePlayerName.text <> '' then
     iniOptions.WriteString('DirectPlay', 'NewPlayerName', NewGamePlayerName.text);
     if JoinGamePlayerName.text <> '' then
     iniOptions.WriteString('DirectPlay', 'JoinPlayerName', JoinGamePlayerName.text);
     if NewGameSessionName.text <> '' then
     iniOptions.WriteString('DirectPlay', 'SessionName', NewGameSessionName.text);
     if ModemPhoneNumber.text <> '' then
     iniOptions.WriteString('DirectPlay', 'PhoneNumber', ModemPhoneNumber.text);
     if (TCPIPHostName.text <> '') then
     iniOptions.WriteString('DirectPlay', 'HostName', TCPIPHostName.text);
     if ProviderList.ItemIndex <> -1 then
     iniOptions.WriteInteger('DirectPlay', 'Provider', ProviderList.ItemIndex);


     iniOptions.free;
     iniOptions := nil;

end;

procedure TfrmConnect.JoinGamePlayerNameKeyPress(Sender: TObject;
  var Key: Char);
begin
    If not (Key in ['0'..'9','a'..'z','A'..'Z', #8, #13]) then
     Key := #0;
    If Key = #13 Then Key := #0;

end;

end.
