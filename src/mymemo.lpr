program mymemo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, runtimetypeinfocontrols, uniqueinstanceraw
  { you can add units after this };

{$R *.res}

begin
  if InstanceRunning('mymemo.falu.me') then exit;
  RequireDerivedFormResource:=True;
  Application.Title:='MyMeMo';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

