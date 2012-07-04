unit SafeListsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, IniFiles, ComCtrls, Forms, DateUtils,
  Dialogs;


type



  TSafeStringList = class(TStringList)
  private
    FCS: RTL_Critical_Section;
  public
     constructor Create;
     destructor Destroy; override;
     procedure GetAccess;
     procedure ReleaseAccess;
  end;


  TSafeList = class(TList)
  private
    FCS: RTL_Critical_Section;
  public
     constructor Create;
     destructor Destroy; override;
     procedure GetAccess;
     procedure ReleaseAccess;
  end;




  TSafeIniFile = class(TIniFile)
  private
    FCS: RTL_Critical_Section;
  public
     constructor Create(const FileName: string);
     destructor Destroy; override;
     procedure GetAccess;
     procedure ReleaseAccess;
     function ReadString(const Section, Ident, Default: string): string; override;
     procedure WriteString(const Section, Ident, Value: String); override;
     procedure DeleteKey(const Section, Ident: String); override;

  end;



implementation


{ TSafeStringList }


constructor TSafeStringList.Create;
begin
  inherited Create;
  InitializeCriticalSection(FCS);
end;

destructor TSafeStringList.Destroy;
begin
  DeleteCriticalSection(FCS);
  inherited;
end;

procedure TSafeStringList.GetAccess;
begin
  EnterCriticalSection(FCS);
end;



procedure TSafeStringList.ReleaseAccess;
begin
  LeaveCriticalSection(FCS);
end;

{ TSafeList }

constructor TSafeList.Create;
begin
  inherited Create;
  InitializeCriticalSection(FCS);
end;

destructor TSafeList.Destroy;
begin
  DeleteCriticalSection(FCS);
  inherited;
end;

procedure TSafeList.GetAccess;
begin
  EnterCriticalSection(FCS);
end;

procedure TSafeList.ReleaseAccess;
begin
  LeaveCriticalSection(FCS);
end;



{ TSafeIniFile }

constructor TSafeIniFile.Create(const FileName: string);
begin
  inherited Create(FileName);
  InitializeCriticalSection(FCS);
end;

procedure TSafeIniFile.DeleteKey(const Section, Ident: String);
begin
  GetAccess;
  try
    inherited;
    UpdateFile;
  finally
    ReleaseAccess;
  end;
end;

destructor TSafeIniFile.Destroy;
begin
  DeleteCriticalSection(FCS);
  inherited;
end;

procedure TSafeIniFile.GetAccess;
begin
  EnterCriticalSection(FCS);
end;

function TSafeIniFile.ReadString(const Section, Ident, Default: string): string;
begin
  GetAccess;
  try
    if Trim(Ident) = '' then Result:= Default
    else
    Result:=inherited ReadString(Section,Ident,Default);
  finally
    ReleaseAccess;
  end;
end;

procedure TSafeIniFile.ReleaseAccess;
begin
  LeaveCriticalSection(FCS);
end;

procedure TSafeIniFile.WriteString(const Section, Ident, Value: String);
begin
  GetAccess;
  try
    if Trim(Ident) = '' then exit;
    inherited;
    UpdateFile;
  finally
    ReleaseAccess;
  end;
end;




end.

