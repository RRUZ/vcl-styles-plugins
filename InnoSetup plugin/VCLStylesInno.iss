#define MyAppName 'VCL Styles for Inno Setup'
#define MyAppVersion GetFileVersion('Win32\Release\VclStylesinno.dll')
[Setup]
AppName={#MyAppName}
AppVerName={#MyAppName} {#MyAppVersion}
AppVersion={#MyAppVersion}
AppCopyright=The Road To Delphi
DefaultDirName={pf}\The Road To Delphi\VCL Styles Inno
DefaultGroupName=The Road To Delphi
Compression=lzma
SolidCompression=true
WizardImageFile=images\WizModernImage-IS.bmp
WizardSmallImageFile=images\WizModernSmallImage-IS.bmp
OutputDir=.\Output
OutputBaseFilename=SetupVCLStylesInno
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany=The Road To Delphi
VersionInfoDescription=VCL Styles for Inno Setup
InternalCompressLevel=max

[Files]
Source: Win32\Release\VclStylesinno.dll; DestDir: {app}
Source: Samples\CodeClasses.iss; DestDir: {app}\Samples\
Source: Samples\VCLStylesDemo.iss; DestDir: {app}\Samples\
Source: Samples\VCLStylesDemo_Uninstall.iss; DestDir: {app}\Samples\
Source: Samples\Readme-German.txt; DestDir: {app}\Samples\
Source: Samples\Components.iss; DestDir: {app}\Samples\
Source: Samples\MyProg.chm; DestDir: {app}\Samples\
Source: Samples\MyProg.exe; DestDir: {app}\Samples\
Source: Samples\Readme.txt; DestDir: {app}\Samples\
Source: Samples\Readme-Dutch.txt; DestDir: {app}\Samples\
Source: Images\WizModernImage-IS.bmp; DestDir: {app}\Images\
Source: Images\WizModernImage-IS_BW.bmp; DestDir: {app}\Images\
Source: Images\WizModernImage-IS_Green.bmp; DestDir: {app}\Images\
Source: Images\WizModernImage-IS_Orange.bmp; DestDir: {app}\Images\
Source: Images\WizModernImage-IS_Purple.bmp; DestDir: {app}\Images\
Source: Images\WizModernSmallImage-IS.bmp; DestDir: {app}\Images\
Source: Images\WizModernSmallImage-IS_BW.bmp; DestDir: {app}\Images\
Source: Images\WizModernSmallImage-IS_Green.bmp; DestDir: {app}\Images\
Source: Images\WizModernSmallImage-IS_Orange.bmp; DestDir: {app}\Images\
Source: Images\WizModernSmallImage-IS_Purple.bmp; DestDir: {app}\Images\
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\Redist\win32\BitmapStyleDesigner.exe; DestDir: {app}
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\Redist\win32\VclStyleViewer.exe; DestDir: {app}
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\bin\designide170.bpl; DestDir: {app}
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\Redist\win32\rtl170.bpl; DestDir: {app}
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\Redist\win32\vcl170.bpl; DestDir: {app}
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\Redist\win32\vclactnband170.bpl; DestDir: {app}
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\Redist\win32\vclimg170.bpl; DestDir: {app}
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\Redist\win32\vclx170.bpl; DestDir: {app}
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\Redist\win32\xmlrtl170.bpl; DestDir: {app}
Source: C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\Redist\win32\midas.dll; DestDir: {app}
Source: background.bmp; Flags: dontcopy
Source: Styles New\Amakrits.vsf; DestDir: {app}\Styles\
Source: Styles New\AmethystKamri.vsf; DestDir: {app}\Styles\
Source: Styles New\AquaGraphite.vsf; DestDir: {app}\Styles\
Source: Styles New\AquaLightSlate.vsf; DestDir: {app}\Styles\
Source: Styles New\Auric.vsf; DestDir: {app}\Styles\
Source: Styles New\BlueGraphite.vsf; DestDir: {app}\Styles\
Source: Styles New\Carbon.vsf; DestDir: {app}\Styles\
Source: Styles New\CharcoalDarkSlate.vsf; DestDir: {app}\Styles\
Source: Styles New\CobaltXEMedia.vsf; DestDir: {app}\Styles\
Source: Styles New\CyanDusk.vsf; DestDir: {app}\Styles\
Source: Styles New\CyanNight.vsf; DestDir: {app}\Styles\
Source: Styles New\Glossy.vsf; DestDir: {app}\Styles\
Source: Styles New\Glow.vsf; DestDir: {app}\Styles\
Source: Styles New\GoldenGraphite.vsf; DestDir: {app}\Styles\
Source: Styles New\GreenGraphite.vsf; DestDir: {app}\Styles\
Source: Styles New\IcebergClassico.vsf; DestDir: {app}\Styles\
Source: Styles New\LavenderClassico.vsf; DestDir: {app}\Styles\
Source: Styles New\Light.vsf; DestDir: {app}\Styles\
Source: Styles New\LightGreen.vsf; DestDir: {app}\Styles\
Source: Styles New\lilac.vsf; DestDir: {app}\Styles\
Source: Styles New\Luna.vsf; DestDir: {app}\Styles\
Source: Styles New\MetroBlack.vsf; DestDir: {app}\Styles\
Source: Styles New\MetroBlue.vsf; DestDir: {app}\Styles\
Source: Styles New\MetroGreen.vsf; DestDir: {app}\Styles\
Source: Styles New\OnyxBlue.vsf; DestDir: {app}\Styles\
Source: Styles New\OrangeGraphite.vsf; DestDir: {app}\Styles\
Source: Styles New\RubyGraphite.vsf; DestDir: {app}\Styles\
Source: Styles New\SapphireKamri.vsf; DestDir: {app}\Styles\
Source: Styles New\Sky.vsf; DestDir: {app}\Styles\
Source: Styles New\SlateClassico.vsf; DestDir: {app}\Styles\
Source: Styles New\SmokeyQuartzKamri.vsf; DestDir: {app}\Styles\
Source: Styles New\TabletDark.vsf; DestDir: {app}\Styles\
Source: Styles New\TurquoiseGray.vsf; DestDir: {app}\Styles\
Source: Styles New\Windows10.vsf; DestDir: {app}\Styles\
Source: Styles New\Windows10Blue.vsf; DestDir: {app}\Styles\
Source: Styles New\Windows10Dark.vsf; DestDir: {app}\Styles\
Source: Styles New\YellowGraphite.vsf; DestDir: {app}\Styles\; Flags: nocompression

[Code]
// Import the LoadVCLStyle function from VclStylesInno.DLL
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall';
// Import the UnLoadVCLStyles function from VclStylesInno.DLL
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall';



procedure BitmapImageOnClick(Sender: TObject);
var
  ErrorCode : Integer;
begin
  ShellExec('open', 'https://github.com/RRUZ/vcl-styles-plugins', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure CreateWizardPages;
var
  Page: TWizardPage;
  BitmapImage: TBitmapImage;
  BitmapFileName: String;
begin
  BitmapFileName := ExpandConstant('{tmp}\background.bmp');
  ExtractTemporaryFile(ExtractFileName(BitmapFileName));

  { TBitmapImage }
  Page := CreateCustomPage(wpInstalling, 'Contributions',
  'If you want show your appreciation for this project. Go to the github page, login with you github account and star the project.');

  BitmapImage := TBitmapImage.Create(Page);
  BitmapImage.AutoSize := True;
  BitmapImage.Left := 0;
  BitmapImage.Top  := 0;
  BitmapImage.Bitmap.LoadFromFile(BitmapFileName);
  BitmapImage.Cursor := crHand;
  BitmapImage.OnClick := @BitmapImageOnClick;
  BitmapImage.Parent := Page.Surface;
  BitmapImage.Align:=alCLient;
  BitmapImage.Stretch:=True;
end;

procedure InitializeWizard();
begin
  CreateWizardPages;
end;

function InitializeSetup(): Boolean;
begin
	ExtractTemporaryFile('Glossy.vsf');
	LoadVCLStyle(ExpandConstant('{tmp}\Glossy.vsf'));
	Result := True;
end;

procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;
[Dirs]
Name: {app}\Styles
Name: {app}\Samples
Name: {app}\Images
