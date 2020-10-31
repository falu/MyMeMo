unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  XMLPropStorage, ExtCtrls, ComCtrls, ActnList, Menus;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actSetTheme: TAction;
    actTitleBack: TAction;
    actTitleFont: TAction;
    actMemoBack: TAction;
    actMemoFont: TAction;
    alMain: TActionList;
    dlgColor: TColorDialog;
    dlgFont: TFontDialog;
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
    pnlTheme: TPanel;
    pnlMain: TPanel;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    popMain: TPopupMenu;
    stFocusCatcher: TEdit;
    tiFocus: TTimer;
    xpsData: TXMLPropStorage;
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
      Shift: TShiftState; X, Y: Integer);
    procedure imgResizeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMoveTimer(Sender: TObject);
    procedure OnResizeTimer(Sender: TObject);
    procedure pnlTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlTopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tiFocusTimer(Sender: TObject);
  private
    iPosX : Integer;
    iPosY : Integer;
    tiMove: TTimer;

    iSizeX : integer;
    iSizeY : integer;
    tiResize: TTimer;
  public
     a:string;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DoubleBuffered:= True;

  tiMove         := TTimer.Create(Application);
  tiMove.Interval:= 30;
  tiMove.Enabled := False;
  tiMove.OnTimer := @OnMoveTimer;

  tiResize         := TTimer.Create(Application);
  tiResize.Interval:= 30;
  tiResize.Enabled := False;
  tiResize.OnTimer := @OnResizeTimer;
end;

procedure TfrmMain.actTitleBackExecute(Sender: TObject);
begin
  dlgColor.Color:= clrTitle.Color;
  if dlgColor.Execute then begin
    clrTitle.Color:=dlgColor.Color;
    actSetTheme.Execute;
  end;
end;

procedure TfrmMain.actTitleFontExecute(Sender: TObject);
begin
  dlgFont.Font:= clrTitle.Font;
  if dlgFont.Execute then begin
    clrTitle.Font:= dlgFont.Font;
    actSetTheme.Execute;
  end;
end;

procedure TfrmMain.actSetThemeExecute(Sender: TObject);
begin
  pnlTop.Color:=clrTitle.Color;
  pnlTop.Font:=clrTitle.Font;

  pnlMain.Color:= clrMemo.Color;
  pnlMain.Font:=clrMemo.Font;

  pnlBottom.Color:= clrMemo.Color;
  pnlBottom.Font:=clrMemo.Font;
end;

procedure TfrmMain.actMemoBackExecute(Sender: TObject);
begin
  dlgColor.Color:=clrMemo.Color;
  if dlgColor.Execute then begin
    clrMemo.Color:= dlgColor.Color;
    actSetTheme.Execute;
  end;
end;

procedure TfrmMain.actMemoFontExecute(Sender: TObject);
begin
  dlgFont.Font:= clrMemo.Font;
  if dlgFont.Execute then begin
    clrMemo.Font:=dlgFont.Font;
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
  Shift: TShiftState; X, Y: Integer);
begin
  If Button = mbLeft Then Begin
    iPosX:= Mouse.CursorPos.X - Left;
    iPosY:= Mouse.CursorPos.Y - Top;
    tiMove.Enabled:= True;
  End;
end;

procedure TfrmMain.pnlTopMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If Button = mbLeft Then Begin
    tiMove.Enabled:= False;
  End;
end;

procedure TfrmMain.tiFocusTimer(Sender: TObject);
begin
  //label1.Caption:=format('x=%d, y=%d',[Mouse.CursorPos.X,Mouse.CursorPos.Y ]);
  if (Mouse.CursorPos.X>left) and (Mouse.CursorPos.X<left+width)
  and (Mouse.CursorPos.Y>top) and (Mouse.CursorPos.Y<top+height) then begin
    alphablend:=false;
    memMain.SetFocus;
  end else begin
    if alphablend=false then begin
      alphablend:=true;
      stFocusCatcher.SetFocus;
      self.Deactivate;
    end;
  end;
end;

procedure TfrmMain.OnMoveTimer(Sender: TObject);
Begin
  Top := Mouse.CursorPos.Y - iPosY;
  Left:= Mouse.CursorPos.X - iPosX;
End;

// átméretezés

procedure TfrmMain.OnResizeTimer(Sender: TObject);
var
  h,w:integer;
begin
  h:= Mouse.CursorPos.Y - iSizeY;
  w:= Mouse.CursorPos.X - iSizeX;
  if (h>=100) and (w>=100) then begin
    height := h;
    width := w;
  end;
end;

procedure TfrmMain.imgResizeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If Button = mbLeft Then Begin
    iSizeX:= Mouse.CursorPos.X - width;
    iSizeY:= Mouse.CursorPos.Y - height;
    tiResize.Enabled:= True;
  End;
end;

procedure TfrmMain.imgResizeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If Button = mbLeft Then Begin
    tiResize.Enabled:= False;
  End;
end;

end.

