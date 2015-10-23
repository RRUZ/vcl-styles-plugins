
echo XE2
call "C:\Program Files (x86)\Embarcadero\RAD Studio\9.0\bin\rsvars.bat"
msbuild.exe "VclStylesInno.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=release
copy Win32\Release\VclStylesInno.dll Lite\VclStylesInno.dll 
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO XE3
pause
EXIT


:XE3
call "C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\bin\rsvars.bat"
msbuild.exe "VclStylesInno.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=release
set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 GOTO OK
pause
EXIT

:OK

del *.bpl
del *.map
del *.drc
del *.local
del *.identcache

pause
EXIT