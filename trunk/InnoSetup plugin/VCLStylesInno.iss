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
WizardImageFile=WizModernImage-IS.bmp
WizardSmallImageFile=WizModernSmallImage-IS.bmp
OutputDir=.\Output
OutputBaseFilename=SetupVCLStylesInno
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany=The Road To Delphi
VersionInfoDescription=VCL Styles for Inno Setup
InternalCompressLevel=max

[Files]
Source: Win32\Release\VclStylesinno.dll; DestDir: {app}
Source: Styles\Amakrits.vsf; DestDir: {app}\Styles\
Source: Styles\AmethystKamri.vsf; DestDir: {app}\Styles\
Source: Styles\AquaGraphite.vsf; DestDir: {app}\Styles\
Source: Styles\AquaLightSlate.vsf; DestDir: {app}\Styles\
Source: Styles\Auric.vsf; DestDir: {app}\Styles\
Source: Styles\BlueGraphite.vsf; DestDir: {app}\Styles\
Source: Styles\Carbon.vsf; DestDir: {app}\Styles\
Source: Styles\CharcoalDarkSlate.vsf; DestDir: {app}\Styles\
Source: Styles\CobaltXEMedia.vsf; DestDir: {app}\Styles\
Source: Styles\CyanDusk.vsf; DestDir: {app}\Styles\
Source: Styles\CyanNight.vsf; DestDir: {app}\Styles\
Source: Styles\EmeraldLightSlate.vsf; DestDir: {app}\Styles\
Source: Styles\GoldenGraphite.vsf; DestDir: {app}\Styles\
Source: Styles\GreenGraphite.vsf; DestDir: {app}\Styles\
Source: Styles\IcebergClassico.vsf; DestDir: {app}\Styles\
Source: Styles\khaki.vsf; DestDir: {app}\Styles\
Source: Styles\LavenderClassico.vsf; DestDir: {app}\Styles\
Source: Styles\LightGreen.vsf; DestDir: {app}\Styles\
Source: Styles\lilac.vsf; DestDir: {app}\Styles\
Source: Styles\MetroBlack.vsf; DestDir: {app}\Styles\
Source: Styles\MetroBlue.vsf; DestDir: {app}\Styles\
Source: Styles\MetroGreen.vsf; DestDir: {app}\Styles\
Source: Styles\Orange.vsf; DestDir: {app}\Styles\
Source: Styles\OrangeGraphite.vsf; DestDir: {app}\Styles\
Source: Styles\Pink.vsf; DestDir: {app}\Styles\
Source: Styles\RubyGraphite.vsf; DestDir: {app}\Styles\
Source: Styles\SapphireKamri.vsf; DestDir: {app}\Styles\
Source: Styles\sepia.vsf; DestDir: {app}\Styles\
Source: Styles\Sky.vsf; DestDir: {app}\Styles\
Source: Styles\SlateClassico.vsf; DestDir: {app}\Styles\
Source: Styles\SmokeyQuartzKamri.vsf; DestDir: {app}\Styles\
Source: Styles\TurquoiseGray.vsf; DestDir: {app}\Styles\
Source: Styles\YellowGraphite.vsf; DestDir: {app}\Styles\
Source: Samples\CodeClasses.iss; DestDir: {app}\Samples\
Source: Samples\VCLStylesDemo.iss; DestDir: {app}\Samples\
Source: Samples\Readme-German.txt; DestDir: {app}\Samples\
Source: Samples\Components.iss; DestDir: {app}\Samples\
Source: Samples\MyProg.chm; DestDir: {app}\Samples\
Source: Samples\MyProg.exe; DestDir: {app}\Samples\
Source: Samples\Readme.txt; DestDir: {app}\Samples\
Source: Samples\Readme-Dutch.txt; DestDir: {app}\Samples\
;Source: Images\WizModernImage-IS.bmp; DestDir: {app}\Images\
;Source: Images\WizModernImage-IS_BW.bmp; DestDir: {app}\Images\
;Source: Images\WizModernImage-IS_Green.bmp; DestDir: {app}\Images\
;Source: Images\WizModernImage-IS_Orange.bmp; DestDir: {app}\Images\
;Source: Images\WizModernImage-IS_Purple.bmp; DestDir: {app}\Images\
;Source: Images\WizModernSmallImage-IS.bmp; DestDir: {app}\Images\
;Source: Images\WizModernSmallImage-IS_BW.bmp; DestDir: {app}\Images\
;Source: Images\WizModernSmallImage-IS_Green.bmp; DestDir: {app}\Images\
;Source: Images\WizModernSmallImage-IS_Orange.bmp; DestDir: {app}\Images\
;Source: Images\WizModernSmallImage-IS_Purple.bmp; DestDir: {app}\Images\
Source: ..\..\..\..\Program Files (x86)\Embarcadero\RAD Studio\9.0\bin\VclStyleDesigner.exe; DestDir: {app}
Source: ..\..\..\..\Program Files (x86)\Embarcadero\RAD Studio\9.0\bin\VclStyleTest.exe; DestDir: {app}
Source: background.bmp; Flags: dontcopy

[Code]
// Import the LoadVCLStyle function from VclStylesInno.DLL
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall';
// Import the UnLoadVCLStyles function from VclStylesInno.DLL
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall';



procedure BitmapImageOnClick(Sender: TObject);
var
  ErrorCode : Integer;
begin
  ShellExec('open', 'http://code.google.com/p/vcl-styles-plugins/', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
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
  'If you want show your appreciation for this project. Go to the code google page, login with you google account and star the project.');

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
	ExtractTemporaryFile('Amakrits.vsf');
	LoadVCLStyle(ExpandConstant('{tmp}\Amakrits.vsf'));
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
