program AHRS_visual;

uses
  Forms,
  Unit1 in 'Unit1.pas' {FormAHRS};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormAHRS, FormAHRS);
  Application.Run;
end.
