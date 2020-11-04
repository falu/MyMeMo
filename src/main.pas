unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  XMLPropStorage, ExtCtrls, ComCtrls, ActnList, Menus, IniFiles;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actCaption: TAction;
    actSave: TAction;
    actShortcut: TAction;
    actSetTheme: TAction;
    actTitleBack: TAction;
    actTitleFont: TAction;
    actMemoBack: TAction;
    actMemoFont: TAction;
    alMain: TActionList;
    dlgColor: TColorDialog;
    dlgFont: TFontDialog;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    tiAutoSave: TIdleTimer;
    Image1: TImage;
    imgClose: TImage;
    imgResize: TImage;
    Label1: TLabel;
    memMain: TMemo;
    clrMemo: TPanel;
    clrTitle: TPanel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    pnlTheme: TPanel;
    pnlMain: TPanel;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    popMain: TPopupMenu;
    stFocusCatcher: TEdit;
    tiFocus: TTimer;
    xpsData: TXMLPropStorage;
    procedure actCaptionExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actShortcutExecute(Sender: TObject);
    procedure actMemoBackExecute(Sender: TObject);
    procedure actMemoFontExecute(Sender: TObject);
    procedure actSetThemeExecute(Sender: TObject);
    procedure actTitleBackExecute(Sender: TObject);
    procedure actTitleFontExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure imgResizeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure imgResizeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure OnMoveTimer(Sender: TObject);
    procedure OnResizeTimer(Sender: TObject);
    procedure pnlTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure pnlTopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure tiAutoSaveTimer(Sender: TObject);
    procedure tiFocusTimer(Sender: TObject);
  private
    iPosX: integer;
    iPosY: integer;
    tiMove: TTimer;

    iSizeX: integer;
    iSizeY: integer;
    tiResize: TTimer;

    sText: string;
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  tiMove := TTimer.Create(Application);
  tiMove.Interval := 30;
  tiMove.Enabled := False;
  tiMove.OnTimer := @OnMoveTimer;

  tiResize := TTimer.Create(Application);
  tiResize.Interval := 30;
  tiResize.Enabled := False;
  tiResize.OnTimer := @OnResizeTimer;

  {$ifndef linux}
  actShortcut.Visible := False;
  {$endif}

end;

procedure TfrmMain.actTitleBackExecute(Sender: TObject);
begin
  dlgColor.Color := clrTitle.Color;
  if dlgColor.Execute then
  begin
    clrTitle.Color := dlgColor.Color;
    actSetTheme.Execute;
  end;
end;

procedure TfrmMain.actTitleFontExecute(Sender: TObject);
begin
  dlgFont.Font := clrTitle.Font;
  if dlgFont.Execute then
  begin
    clrTitle.Font := dlgFont.Font;
    actSetTheme.Execute;
  end;
end;

procedure TfrmMain.actSetThemeExecute(Sender: TObject);
begin
  pnlTop.Color := clrTitle.Color;
  pnlTop.Font := clrTitle.Font;

  pnlMain.Color := clrMemo.Color;
  pnlMain.Font := clrMemo.Font;

  pnlBottom.Color := clrMemo.Color;
  pnlBottom.Font := clrMemo.Font;
end;

procedure TfrmMain.actMemoBackExecute(Sender: TObject);
begin
  dlgColor.Color := clrMemo.Color;
  if dlgColor.Execute then
  begin
    clrMemo.Color := dlgColor.Color;
    actSetTheme.Execute;
  end;
end;

procedure TfrmMain.actCaptionExecute(Sender: TObject);
var
  tmp: string;
begin
  tmp := inputbox('MyMeMo', 'Caption', pnlTop.Caption);
  if tmp <> '' then
    pnlTop.Caption := tmp;
end;

procedure TfrmMain.actSaveExecute(Sender: TObject);
begin
  //save settings and data
  xpsData.Save;
end;

procedure TfrmMain.actShortcutExecute(Sender: TObject);
var
  ini: tinifile;
  inifn: string;
  inipath: string;
  exefn: string;
  exepath: string;
  homedir: string;
const
  section = 'Desktop Entry';
begin
  //create desktop icon
  homedir := IncludeTrailingPathDelimiter(GetEnvironmentVariable('HOME'));
  inipath := IncludeTrailingPathDelimiter(homedir + '.local/share/applications');
  forcedirectories(inipath);
  inifn := 'mymemo.desktop';
  exefn := ParamStr(0);
  exepath := IncludeTrailingPathDelimiter(extractfilepath(exefn));
  ini := tinifile.Create(inipath + inifn);
  ini.WriteString(section, 'Name', 'MyMeMo');
  ini.WriteString(section, 'Comment', 'Simple Note Taking Application');
  ini.WriteString(section, 'Terminal', 'false');
  ini.WriteString(section, 'Type', 'Application');
  ini.WriteString(section, 'Path', exepath);
  ini.WriteString(section, 'Exec', exefn);
  ini.WriteString(section, 'Icon', exepath + 'mymemo.ico');
  ini.UpdateFile;
  ini.Free;
end;

procedure TfrmMain.actMemoFontExecute(Sender: TObject);
begin
  dlgFont.Font := clrMemo.Font;
  if dlgFont.Execute then
  begin
    clrMemo.Font := dlgFont.Font;
    actSetTheme.Execute;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  stFocusCatcher.SetFocus;
  actSetTheme.Execute;
end;

procedure TfrmMain.Image1Click(Sender: TObject);
begin
  popMain.PopUp();
end;

procedure TfrmMain.imgCloseClick(Sender: TObject);
begin
  Close;
end;

// mozgatás

procedure TfrmMain.pnlTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = mbLeft then
  begin
    iPosX := Mouse.CursorPos.X - Left;
    iPosY := Mouse.CursorPos.Y - Top;
    tiMove.Enabled := True;
  end;
end;

procedure TfrmMain.pnlTopMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = mbLeft then
  begin
    tiMove.Enabled := False;
  end;
end;

procedure TfrmMain.tiAutoSaveTimer(Sender: TObject);
begin
  if sText <> memMain.Text then
  begin
    xpsData.Save;
    sText := memMain.Text;
  end;
end;

procedure TfrmMain.tiFocusTimer(Sender: TObject);
begin
  //label1.Caption:=format('x=%d, y=%d',[Mouse.CursorPos.X,Mouse.CursorPos.Y ]);
  if (Mouse.CursorPos.X > left) and (Mouse.CursorPos.X < left + Width) and
    (Mouse.CursorPos.Y > top) and (Mouse.CursorPos.Y < top + Height) then
  begin
    alphablend := False;
    memMain.SetFocus;
  end
  else
  begin
    if alphablend = False then
    begin
      alphablend := True;
      stFocusCatcher.SetFocus;
      self.Deactivate;
    end;
  end;
end;

procedure TfrmMain.OnMoveTimer(Sender: TObject);
begin
  Top := Mouse.CursorPos.Y - iPosY;
  Left := Mouse.CursorPos.X - iPosX;
end;

// átméretezés

procedure TfrmMain.OnResizeTimer(Sender: TObject);
var
  h, w: integer;
begin
  h := Mouse.CursorPos.Y - iSizeY;
  w := Mouse.CursorPos.X - iSizeX;
  if (h >= 100) and (w >= 100) then
  begin
    Height := h;
    Width := w;
  end;
end;

procedure TfrmMain.imgResizeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = mbLeft then
  begin
    iSizeX := Mouse.CursorPos.X - Width;
    iSizeY := Mouse.CursorPos.Y - Height;
    tiResize.Enabled := True;
  end;
end;

procedure TfrmMain.imgResizeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = mbLeft then
  begin
    tiResize.Enabled := False;
  end;
end;

end.
