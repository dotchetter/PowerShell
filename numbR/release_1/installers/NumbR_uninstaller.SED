[Version]
Class=IEXPRESS
SEDVersion=3
[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=0
HideExtractAnimation=0
UseLongFileName=1
InsideCompressed=0
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=I
InstallPrompt=%InstallPrompt%
DisplayLicense=%DisplayLicense%
FinishMessage=%FinishMessage%
TargetName=%TargetName%
FriendlyName=%FriendlyName%
AppLaunched=%AppLaunched%
PostInstallCmd=%PostInstallCmd%
AdminQuietInstCmd=%AdminQuietInstCmd%
UserQuietInstCmd=%UserQuietInstCmd%
SourceFiles=SourceFiles
[Strings]
InstallPrompt=Vad tråkigt att du vill avinstallera NumbR. Vi kommer återställa PowerShell ExecutionPolicy till utgångsläget "Restricted" och ta bort all sparad information som du skapat med NumbR. Är du säker?
DisplayLicense=
FinishMessage=NumbR avinstallerades.
TargetName=C:\Users\admin\Git\PowerShell\numbR\release_1\installers\NumbR_Uninstaller.exe
FriendlyName=NumbR Uninstaller
AppLaunched=cmd.exe /k uninstall.cmd
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=
FILE0="uninstall.cmd"
[SourceFiles]
SourceFiles0=C:\Users\admin\Git\PowerShell\numbR\release_1\installers\
[SourceFiles0]
%FILE0%=
