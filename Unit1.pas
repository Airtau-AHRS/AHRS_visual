unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls,
  ComPort, ComSignal,
  GL, GLU, UrickGL, U3Dpolys, SafeListsUnit;

type
  TFormAHRS = class(TForm)
    MemoLogs: TMemo;
    SpeedButtonOpenClose: TSpeedButton;
    ComboBoxDeviceName: TComboBox;
    StatusBar: TStatusBar;
    SpeedButtonMonEKF: TSpeedButton;
    SpeedButtonMonGYRO: TSpeedButton;
    SpeedButtonMonBARO: TSpeedButton;
    SpeedButtonMonOFF: TSpeedButton;
    SpeedButtonSetREF: TSpeedButton;
    SpeedButtonSetREF1: TSpeedButton;
    SpeedButtonConfig: TSpeedButton;
    SpeedButtonCalMag: TSpeedButton;
    SpeedButtonSetMag: TSpeedButton;
    SpeedButtonResetYAW: TSpeedButton;
    SpeedButtonMonACC: TSpeedButton;
    SpeedButtonSendCMD: TSpeedButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    SpeedButtonCalGYRO: TSpeedButton;
    Panel1: TPanel;
    Timer1: TTimer;
    ComPort: TComPort;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    EditSendCmd: TEdit;
    LogAllowed: TCheckBox;
    procedure ComPortRxChar(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxDeviceNameChange(Sender: TObject);

    procedure SpeedButtonConfigClick(Sender: TObject);
    procedure SpeedButtonOpenCloseClick(Sender: TObject);


    procedure ComPortAfterClose(ComPort: TCustomComPort);
    procedure ComPortAfterOpen(ComPort: TCustomComPort);
    procedure ComPortError(ComPort: TCustomComPort; E: EComError; var Action: TComAction);
    procedure ComPortLineError(Sender: TObject; LineErrors: TLineErrors);
    procedure ComPortAfterWrite(Sender: TObject; Buffer: Pointer; Length: Integer; WaitOnCompletion: Boolean);

    procedure SpeedButtonMonEKFClick(Sender: TObject);
    procedure SpeedButtonMonOFFClick(Sender: TObject);
    procedure SpeedButtonSetREFClick(Sender: TObject);

    procedure SpeedButtonCalGYROClick(Sender: TObject);
    procedure SpeedButtonMonGYROClick(Sender: TObject);
    procedure SpeedButtonMonBAROClick(Sender: TObject);

    procedure SpeedButtonCalMagClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButtonResetYAWClick(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure SpeedButtonMonACCClick(Sender: TObject);
    procedure SpeedButtonSendCMDClick(Sender: TObject);

  private
    { Private declarations }
    FReadCount: Integer;
    FWriteCount: Integer;
    procedure AddReadBytes(ReadCount: Integer);
    procedure AddWriteBytes(WriteCount: Integer);
    procedure UpdateComInfo;
  public
    { Public declarations }
    Scene: TSceneGL;

    splitList: TStringList;
    Revroll: integer;
    RevPitch: integer;
    RevYaw: integer;
    useEKF: boolean;
    YawOn: boolean;

    YawRefPos: single;

    procedure ProcessComportInput(msg: string);
    procedure WriteLog(msg: string);
    function UpdateDecimalSeparator(const s: string): string;
    function LastPos(SubStr, S: string): Integer;
  end;

var
  FormAHRS: TFormAHRS;
  rx, ry, rz: single;

implementation

{$R *.DFM}

procedure TFormAHRS.ComPortRxChar(Sender: TObject);
var resultCode, Text, s: string;
  i, j, k: Integer;
begin

  Text := ComPort.ReadString;
  try
    if Text <> '' then begin
      resultCode := MemoLogs.selText + Text;
      while Pos(#13#10, resultCode) > 0 do begin
        i := Pos(#13#10, resultCode);
        s := Copy(resultCode, 1, i - 1);
        WriteLog(s + #13#10);
        ProcessComportInput(s);
        AddReadBytes(Length(s));
        Delete(resultCode, 1, i + 1);
      end;
      if resultCode <> '' then
        WriteLog(MemoLogs.SelText + resultCode);
    end;
  except
    on E: Exception do
      WriteLog(E.ClassName + ' ошибка: ' + E.Message);
  end;

end;

procedure TFormAHRS.SpeedButtonOpenCloseClick(Sender: TObject);
begin
  ComPort.Active := not ComPort.Active;
end;

procedure TFormAHRS.ComboBoxDeviceNameChange(Sender: TObject);
begin
  ComPort.DeviceName := '\\.\' + ComboBoxDeviceName.Text;
end;

procedure TFormAHRS.FormCreate(Sender: TObject);
var
  cube: Tentity;
  Face: TFace;
  light: Tlight;
  n: TPoint;

  x, y, z: real;
begin

  Revroll := 1;
  RevPitch := 1;
  RevYaw := 1;

  YawRefPos := 0;

  splitList := TStringList.Create;

  Scene := TSceneGL.create; // Создаем новую сцену
  Cube := TEntity.create; // Создаем пустой объект TEntity
  Cube.SetColor(255, 200, 230); // Инициируем цвета R,G,B
  Face := cube.addFace;

  x := 3;
  y := 0.2;
  z := 1;


  Face.AddVertex(x, y, z, 0.0, 0.0, 1.0); // добавляем 1-й  vertex
  Face.AddVertex(-x, y, z, 0.0, 0.0, 1.0); // добавляем 2-й  vertex
  Face.AddVertex(-x, -y, z, 0.0, 0.0, 1.0); // добавляем 3-й  vertex
  Face.AddVertex(x, -y, z, 0.0, 0.0, 1.0); // добавляем 4-й  vertex


  Face := cube.addFace;
  Face.AddVertex(x, y, -z, 0.0, 0.0, -1.0);
  Face.AddVertex(x, -y, -z, 0.0, 0.0, -1.0);
  Face.AddVertex(-x, -y, -z, 0.0, 0.0, -1.0);
  Face.AddVertex(-x, y, -z, 0.0, 0.0, -1.0);

  Face := cube.addFace;
  Face.AddVertex(-x, y, z, -1.0, 0.0, 0.0);
  Face.AddVertex(-x, y, -z, -1.0, 0.0, 0.0);
  Face.AddVertex(-x, -y, -z, -1.0, 0.0, 0.0);
  Face.AddVertex(-x, -y, z, -1.0, 0.0, 0.0);

  Face := cube.addFace;
  Face.AddVertex(x, y, z, 1.0, 0.0, 0.0);
  Face.AddVertex(x, -y, z, 1.0, 0.0, 0.0);
  Face.AddVertex(x, -y, -z, 1.0, 0.0, 0.0);
  Face.AddVertex(x, y, -z, 1.0, 0.0, 0.0);

  Face := cube.addFace;
  Face.SetColor(200, 10, 10);
  Face.AddVertex(-x, y, -z, 0.0, 1.0, 0.0);
  Face.AddVertex(-x, y, z, 0.0, 1.0, 0.0);
  Face.AddVertex(x, y, z, 0.0, 1.0, 0.0);
  Face.AddVertex(x, y, -z, 0.0, 1.0, 0.0);

  Face := cube.addFace;
  Face.SetColor(10, 200, 10);

  Face.AddVertex(-x, -y, -z, 0.0, -1.0, 0.0);
  Face.AddVertex(x, -y, -z, 0.0, -1.0, 0.0);
  Face.AddVertex(x, -y, z, 0.0, -1.0, 0.0);
  Face.AddVertex(-x, -y, z, 0.0, -1.0, 0.0);

  with cube do
  begin
    move(0, 0, -15); // Перемещаем куб в координаты x, y, z
    Rotate(-30, -30, -30); // и поворачиваем на угол
  end;

  Scene.Entities.add(cube); // добавим куб на сцену

  light := Tlight.create(2); // создадим источник света и
  Scene.lights.add(light); // добавим его на сцену

  Scene.InitRC(panel1.handle); // передадим Handle Panel1 нашей сцене,
                               // на ней будет происходить рендеринг
  Scene.UpdateArea(panel1.width, panel1.height);

  Timer1.Interval := 20;
  Timer1.Enabled := false;


  with ComboBoxDeviceName do
  begin
    ComPort.EnumComDevicesFromRegistry(Items);
    ItemIndex := 0;
    ComPort.DeviceName := '\\.\' + Text;
  end;

  AddReadBytes(0);
  AddWriteBytes(0);
end;

procedure TFormAHRS.ComPortError(ComPort: TCustomComPort; E: EComError;
  var Action: TComAction);
begin
  MessageDlg('Error ' + IntToStr(E.ErrorCode) + ': ' + E.Message, mtError, [mbOK], 0);
  WriteLog('ERROR: ' + E.Message);
  Action := caAbort;
end;

procedure TFormAHRS.ComPortLineError(Sender: TObject; LineErrors: TLineErrors);
begin
  if leBreak in LineErrors then MessageDlg('Break detected', mtError, [mbOK], 0);
  if leDeviceNotSelected in LineErrors then MessageDlg('Device not selected', mtError, [mbOK], 0);
  if leFrame in LineErrors then MessageDlg('Frame error', mtError, [mbOK], 0);
  if leIO in LineErrors then MessageDlg('IO error', mtError, [mbOK], 0);
  if leMode in LineErrors then MessageDlg('Mode error', mtError, [mbOK], 0);
  if leOutOfPaper in LineErrors then MessageDlg('Out of paper', mtError, [mbOK], 0);
  if leOverrun in LineErrors then MessageDlg('Overrun error', mtError, [mbOK], 0);
  if leDeviceTimeOut in LineErrors then MessageDlg('Device timeout', mtError, [mbOK], 0);
  if leRxOverflow in LineErrors then MessageDlg('Receiver overflow', mtError, [mbOK], 0);
  if leParity in LineErrors then MessageDlg('Parity error', mtError, [mbOK], 0);
  if leTxFull in LineErrors then MessageDlg('Transmitter full', mtError, [mbOK], 0);
end;

procedure TFormAHRS.AddReadBytes(ReadCount: Integer);
begin
  FReadCount := FReadCount + ReadCount;
  StatusBar.Panels[0].Text := 'Read bytes: ' + IntToStr(FReadCount);
end;

procedure TFormAHRS.AddWriteBytes(WriteCount: Integer);
begin
  FWriteCount := FWriteCount + WriteCount;
  StatusBar.Panels[1].Text := 'Write bytes: ' + IntToStr(FWriteCount);
end;

procedure TFormAHRS.ComPortAfterWrite(Sender: TObject; Buffer: Pointer;
  Length: Integer; WaitOnCompletion: Boolean);
begin
  AddWriteBytes(Length);
end;

procedure TFormAHRS.UpdateComInfo;
begin
  if Visible then
    with ComPort do
    begin
      if Active then
        SpeedButtonOpenClose.Caption := 'Disconnect'
      else
        SpeedButtonOpenClose.Caption := 'Connect';

      MemoLogs.Enabled := not Active;
      ComboBoxDeviceName.Enabled := not Active;
      SpeedButtonCalMag.Enabled := Active;
      SpeedButtonCalGYRO.Enabled := Active;
      SpeedButtonSetREF.Enabled := Active;
      SpeedButtonMonEKF.Enabled := Active;
      SpeedButtonMonGYRO.Enabled := Active;
      SpeedButtonMonBARO.Enabled := Active;
      SpeedButtonMonOFF.Enabled := Active;
      SpeedButtonSetREF.Enabled := Active;
      SpeedButtonSetREF1.Enabled := Active;
      SpeedButtonSetMag.Enabled := Active;
      SpeedButtonSendCMD.Enabled := Active;
      SpeedButtonResetYAW.Enabled := Active;
      SpeedButtonMonACC.Enabled := Active;
      EditSendCmd.Enabled := Active;
      CheckBox1.Enabled := Active;
      CheckBox2.Enabled := Active;
      CheckBox3.Enabled := Active;
      CheckBox4.Enabled := Active;
      CheckBox5.Enabled := Active;
      if Active then begin
        ComPort.WriteString(#13#10);
      end;

    end;
end;

procedure TFormAHRS.ComPortAfterClose(ComPort: TCustomComPort);
begin
  UpdateComInfo;
end;

procedure TFormAHRS.ComPortAfterOpen(ComPort: TCustomComPort);
begin
  UpdateComInfo;
end;

procedure TFormAHRS.SpeedButtonConfigClick(Sender: TObject);
begin
  ComPort.ConfigDialog;
end;

procedure TFormAHRS.SpeedButtonMonEKFClick(Sender: TObject);
begin
  ComPort.WriteString('mon on EKF' + #13#10);
end;

procedure TFormAHRS.SpeedButtonMonOFFClick(Sender: TObject);
begin
  ComPort.WriteString('mon OFF' + #13#10);
end;

procedure TFormAHRS.SpeedButtonCalGYROClick(Sender: TObject);
begin
  ComPort.WriteString('cal gyro' + #13#10);
end;

procedure TFormAHRS.SpeedButtonCalMagClick(Sender: TObject);
begin
  ComPort.WriteString('cal mag' + #13#10);
end;

procedure TFormAHRS.SpeedButtonMonGYROClick(Sender: TObject);
begin
  ComPort.WriteString('mon on gyro' + #13#10);
end;

procedure TFormAHRS.SpeedButtonMonBAROClick(Sender: TObject);
begin
  ComPort.WriteString('mon on baro' + #13#10);
end;

procedure TFormAHRS.SpeedButtonSetREFClick(Sender: TObject);
begin
  ComPort.WriteString('save ref' + #13#10);
end;

procedure TFormAHRS.Timer1Timer(Sender: TObject);
begin
  rx := rx + 0.5; if rx > 360 then rx := 0; // -- pitch
  ry := ry + 5.7; if ry > 360 then ry := 0; // yaw
  rz := rz + 1.1; if rz < 0 then rz := 360; // roll
  Tentity(Scene.Entities.Items[0]).Rotate(rx, ry, rz); // повернем куб
  Scene.Redraw; // ... и обновим сцену
end;

procedure TFormAHRS.CheckBox1Click(Sender: TObject);
begin
  useEKF := CheckBox1.Checked;
end;

procedure TFormAHRS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := false;
  Scene.free; // очищаем сцену
  splitList.Free;
  if ComPort.Active then
end;

procedure TFormAHRS.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = Vk_Escape then close; // выход
end;

procedure TFormAHRS.WriteLog(msg: string);
begin
  if LogAllowed.Checked then begin

  while MemoLogs.Lines.Count > 1000 do MemoLogs.Lines.Delete(0);
  MemoLogs.SelText := msg;

  end;
end;

function TFormAHRS.LastPos(SubStr, S: string): Integer;
var
  Found, Len, Pos: integer;
begin
  Pos := Length(S);
  Len := Length(SubStr);
  Found := 0;
  while (Pos > 0) and (Found = 0) do
  begin
    if Copy(S, Pos, Len) = SubStr then
      Found := Pos;
    Dec(Pos);
  end;
  LastPos := Found;
end;

function TFormAHRS.UpdateDecimalSeparator(const s: string): string;
begin

  case DecimalSeparator of
    ',': if (Pos('.', s) <> 0) then
        Result := Stringreplace(s, '.', DecimalSeparator, [rfReplaceAll]);
    '.': if (Pos(',', s) <> 0) then
        Result := Stringreplace(s, ',', DecimalSeparator, [rfReplaceAll]);
  end;
end;

procedure TFormAHRS.ProcessComportInput(msg: string);
var
  s: string;
  r, p, y: string;
  e: string;
  i, j: Integer;
begin

  e := '$DCM:';
  if UseEKF then e := '$EKF:';
  if Pos(e, msg) > 0 then begin
    msg := Stringreplace(msg, ' ', #13#10, [rfReplaceAll]);
    SplitList.Text := msg;
    r := SplitList[2];
    p := SplitList[3];
    y := SplitList[4];
    r := Stringreplace(r, 'r=', '', [rfReplaceAll]);
    r := UpdateDecimalSeparator(r);
    p := Stringreplace(p, 'p=', '', [rfReplaceAll]);
    p := UpdateDecimalSeparator(p); ;
    y := Stringreplace(y, 'y=', '', [rfReplaceAll]);
    y := UpdateDecimalSeparator(y); ;


    rx := RevPitch * StrToFloat(p); // -- pitch
    ry := RevYaw * StrToFloat(y); // yaw
    rz := RevRoll * StrToFloat(r); // roll

    if YawOn then
      Tentity(Scene.Entities.Items[0]).Rotate(rx, ry - YawRefPos, rz) // повернем куб
    else
      Tentity(Scene.Entities.Items[0]).Rotate(rx, 0, rz);

    Scene.Redraw; // ... и обновим сцену

  end;
end;

procedure TFormAHRS.SpeedButtonResetYAWClick(Sender: TObject);
begin
  YawRefPos := ry;
end;

procedure TFormAHRS.CheckBox5Click(Sender: TObject);
begin
  YawOn := CheckBox5.checked;
end;

procedure TFormAHRS.CheckBox2Click(Sender: TObject);
begin
  RevRoll := -Revroll;
end;

procedure TFormAHRS.CheckBox3Click(Sender: TObject);
begin
  RevPitch := -RevPitch;
end;

procedure TFormAHRS.CheckBox4Click(Sender: TObject);
begin
  RevYaw := -RevYaw;
end;

procedure TFormAHRS.SpeedButtonMonACCClick(Sender: TObject);
begin
  ComPort.WriteString('mon on accel' + #13#10);
end;

procedure TFormAHRS.SpeedButtonSendCMDClick(Sender: TObject);
begin
  ComPort.WriteString(EditSendCmd.Text + #13#10);
end;

end.

