unit Vcl.Styles.Npp.StyleHooks;

interface

uses
  Winapi.Windows,
  System.Types,
  System.SysUtils,
  Winapi.Messages,
  Vcl.Menus,
  Vcl.Themes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Styles.Utils.Forms;

type
  TMainWndNppStyleHook = class(TSysDialogStyleHook)
  public
    constructor Create(AHandle: THandle); override;
  end;

  TScintillaStyleHook = class(TSysScrollingStyleHook)
  strict private
    FBackColor: TColor;
  protected
    procedure UpdateColors; override;
    procedure WndProc(var Message: TMessage); override;
    procedure PaintNC(Canvas: TCanvas); override;
    function GetBorderSize: TRect; override;
  public
    property BackColor: TColor read FBackColor write FBackColor;
    constructor Create(AHandle: THandle); override;
  end;

implementation

uses
  Vcl.Styles.Utils.SysControls;


{ TMainWndNppStyleHook }

constructor TMainWndNppStyleHook.Create(AHandle: THandle);
begin
  inherited;
  OverridePaintNC:=False;
end;


{ TScintillaStyleHook }

constructor TScintillaStyleHook.Create(AHandle: THandle);
begin
  inherited;
{$IF CompilerVersion > 23}
  StyleElements := [seBorder];
{$ELSE}
  OverridePaintNC := True;
  OverrideFont := False;
{$IFEND}
end;

function TScintillaStyleHook.GetBorderSize: TRect;
begin
  if SysControl.HasBorder then
    Result := Rect(2, 2, 2, 2);
end;

procedure TScintillaStyleHook.PaintNC(Canvas: TCanvas);
var
  Details: TThemedElementDetails;
  R: TRect;
begin
  if StyleServicesEnabled and SysControl.HasBorder then
  begin
    if Focused then
      Details := StyleServices.GetElementDetails(teEditBorderNoScrollFocused)
    else if MouseInControl then
      Details := StyleServices.GetElementDetails(teEditBorderNoScrollHot)
    else if SysControl.Enabled then
      Details := StyleServices.GetElementDetails(teEditBorderNoScrollNormal)
    else
      Details := StyleServices.GetElementDetails(teEditBorderNoScrollDisabled);
    R := Rect(0, 0, SysControl.Width, SysControl.Height);
    InflateRect(R, -2, -2);
    ExcludeClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
    StyleServices.DrawElement(Canvas.Handle, Details,
      Rect(0, 0, SysControl.Width, SysControl.Height));
  end;
end;

procedure TScintillaStyleHook.UpdateColors;
begin
  inherited;

end;

procedure TScintillaStyleHook.WndProc(var Message: TMessage);
begin
  //Addlog(Format('TScintillaStyleHook $0x%x %s', [SysControl.Handle, WM_To_String(Message.Msg)]));
//  case Message.Msg of
//
//    WM_SIZE : begin
//               CallDefaultProc(Message);
//               Invalidate;
//              end;
//  else
//     inherited;
//  end;

  inherited;
end;

end.
