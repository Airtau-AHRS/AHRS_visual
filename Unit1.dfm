object FormAHRS: TFormAHRS
  Left = 203
  Top = 173
  BorderStyle = bsDialog
  Caption = 'AHRS visualisation console'
  ClientHeight = 497
  ClientWidth = 968
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButtonOpenClose: TSpeedButton
    Left = 8
    Top = 40
    Width = 121
    Height = 25
    Caption = 'Connect'
    OnClick = SpeedButtonOpenCloseClick
  end
  object SpeedButtonSendCMD: TSpeedButton
    Left = 440
    Top = 8
    Width = 81
    Height = 25
    Caption = 'send'
    Enabled = False
    OnClick = SpeedButtonSendCMDClick
  end
  object MemoLogs: TMemo
    Left = 536
    Top = 8
    Width = 425
    Height = 465
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
    WordWrap = False
  end
  object ComboBoxDeviceName: TComboBox
    Left = 8
    Top = 8
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnChange = ComboBoxDeviceNameChange
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 478
    Width = 968
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 150
      end>
    SizeGrip = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 80
    Width = 137
    Height = 393
    ActivePage = TabSheet2
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'Calibrate'
      object SpeedButtonCalGYRO: TSpeedButton
        Left = 16
        Top = 16
        Width = 90
        Height = 24
        Caption = 'Calibrate GYRO'
        Enabled = False
        OnClick = SpeedButtonCalGYROClick
      end
      object SpeedButtonCalMag: TSpeedButton
        Left = 16
        Top = 52
        Width = 90
        Height = 24
        Caption = 'Calibrate MAG'
        Enabled = False
        OnClick = SpeedButtonCalMagClick
      end
      object SpeedButtonSetMAG: TSpeedButton
        Left = 16
        Top = 264
        Width = 90
        Height = 24
        Caption = 'Save MAG'
        Enabled = False
        OnClick = SpeedButtonSetMAGClick
      end
      object SpeedButtonSaveConfig: TSpeedButton
        Left = 16
        Top = 296
        Width = 90
        Height = 24
        Caption = 'Save Config'
        Enabled = False
        OnClick = SpeedButtonSaveConfigClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Monitoring'
      object SpeedButtonMonEKF: TSpeedButton
        Left = 16
        Top = 16
        Width = 90
        Height = 24
        Caption = 'monitoring EKF'
        Enabled = False
        OnClick = SpeedButtonMonEKFClick
      end
      object SpeedButtonMonGYRO: TSpeedButton
        Left = 16
        Top = 48
        Width = 90
        Height = 24
        Caption = 'monitoring GYRO'
        Enabled = False
        OnClick = SpeedButtonMonGYROClick
      end
      object SpeedButtonMonBARO: TSpeedButton
        Left = 16
        Top = 82
        Width = 90
        Height = 24
        Caption = 'monitoring BARO'
        Enabled = False
        OnClick = SpeedButtonMonBAROClick
      end
      object SpeedButtonMonACC: TSpeedButton
        Left = 16
        Top = 112
        Width = 90
        Height = 24
        Caption = 'monitoring ACCEL'
        Enabled = False
        OnClick = SpeedButtonMonACCClick
      end
      object SpeedButtonMonGPS: TSpeedButton
        Left = 16
        Top = 142
        Width = 90
        Height = 24
        Caption = 'monitoring GPS'
        Enabled = False
        OnClick = SpeedButtonMonGPSClick
      end
      object SpeedButtonMonOFF: TSpeedButton
        Left = 16
        Top = 188
        Width = 90
        Height = 24
        Caption = 'STOP monitoring'
        Enabled = False
        OnClick = SpeedButtonMonOFFClick
      end
      object SpeedButtonResetYAW: TSpeedButton
        Left = 16
        Top = 264
        Width = 90
        Height = 24
        Caption = 'Reset YAW'
        Enabled = False
        OnClick = SpeedButtonResetYAWClick
      end
      object SpeedButtonResetREF: TSpeedButton
        Left = 16
        Top = 296
        Width = 90
        Height = 24
        Caption = 'Reset REF'
        Enabled = False
        OnClick = SpeedButtonResetRefClick
      end
    end
  end
  object Panel1: TPanel
    Left = 136
    Top = 56
    Width = 400
    Height = 400
    Caption = 'Panel1'
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 136
    Top = 32
    Width = 97
    Height = 17
    Caption = 'Show EKF'
    Enabled = False
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 144
    Top = 456
    Width = 97
    Height = 17
    Caption = 'Reverse Roll'
    Enabled = False
    TabOrder = 5
    OnClick = CheckBox2Click
  end
  object CheckBox3: TCheckBox
    Left = 256
    Top = 456
    Width = 97
    Height = 17
    Caption = 'Reverse Pitch'
    Enabled = False
    TabOrder = 7
    OnClick = CheckBox3Click
  end
  object CheckBox4: TCheckBox
    Left = 368
    Top = 456
    Width = 97
    Height = 17
    Caption = 'Reverse YAW'
    Enabled = False
    TabOrder = 6
    OnClick = CheckBox4Click
  end
  object CheckBox5: TCheckBox
    Left = 248
    Top = 32
    Width = 97
    Height = 17
    Caption = 'Turn on YAW'
    Enabled = False
    TabOrder = 9
    OnClick = CheckBox5Click
  end
  object EditSendCmd: TEdit
    Left = 136
    Top = 8
    Width = 297
    Height = 21
    Enabled = False
    TabOrder = 10
  end
  object LogAllowed: TCheckBox
    Left = 440
    Top = 32
    Width = 81
    Height = 17
    Caption = 'Log Allowed'
    TabOrder = 11
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 560
    Top = 16
  end
  object ComPort: TComPort
    Active = False
    BufferSizes.Input = 1024
    BufferSizes.Output = 1024
    DeviceName = 'COM1'
    Options = [opCheckParity]
    ThreadPriority = tpNormal
    AfterClose = ComPortAfterClose
    AfterOpen = ComPortAfterOpen
    AfterWrite = ComPortAfterWrite
    OnError = ComPortError
    OnLineError = ComPortLineError
    OnRxChar = ComPortRxChar
    Left = 592
    Top = 16
  end
end
