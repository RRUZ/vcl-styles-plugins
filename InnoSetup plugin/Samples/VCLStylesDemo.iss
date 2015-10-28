#define VCLStyle "Auric.vsf"
[Setup]
AppName=VCL Styles Example
AppVerName=VCL Styles Example v1.0
AppVersion=1.0.0.0
AppCopyright=The Road To Delphi
DefaultDirName={pf}\The Road To Delphi\VCL Styles Inno Demo
DefaultGroupName=The Road To Delphi
Compression=lzma
SolidCompression=true
WizardImageFile=WizModernImage-IS.bmp
WizardSmallImageFile=WizModernSmallImage-IS.bmp
OutputDir=.\Output
OutputBaseFilename=Setup
VersionInfoVersion=1.0.0.0
VersionInfoCompany=The Road To Delphi
VersionInfoDescription=VCL Styles Setup
VersionInfoTextVersion=1, 0, 0, 0
InternalCompressLevel=max
;LicenseFile="ISPPExample1License.txt"
[Files]
Source: ..\VclStylesinno.dll; DestDir: {app}; Flags: dontcopy
;Source: ..\Win32\Debug\VclStylesinno.dll; DestDir: {app}; Flags: dontcopy
Source: ..\Styles\{#VCLStyle}; DestDir: {app}; Flags: dontcopy


[Code]
// Import the LoadVCLStyle function from VclStylesInno.DLL
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall';
// Import the UnLoadVCLStyles function from VclStylesInno.DLL
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall';

function InitializeSetup(): Boolean;
begin
	ExtractTemporaryFile('{#VCLStyle}');
	LoadVCLStyle(ExpandConstant('{tmp}\{#VCLStyle}'));
	Result := True;
end;

procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;
