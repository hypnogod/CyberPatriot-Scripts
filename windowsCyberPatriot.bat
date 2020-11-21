@echo off

title Window's script
color 0A

echo Checking admin rights...
net sessions

if %errorlevel%==0 (
echo Sucess
) else (
echo give/run the script admin privileges
pause
exit 
)

:PasswordPolicies
echo changing password PasswordPolicies. Make sure to check Account Lockout Policies
REM minimum password length: 8, maximum password age: 30, Password history: 5, minimum password age: 10 
REM Account lockout threshold: 5, Account lockout duration: 30, Reset account lockout counter after: 30
net accounts /MINPWLEN:8 /MAXPWAGE:30 /UNIQUEPW:5 /MINPWAGE:10 /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30
echo starting secpol.msc for manual process
start secpol.msc /wait
pause
goto:EOF

@REM :defAccounts
@REM REM Admin and Guest
@REM echo turn off admin and guest
@REM net user administrator /active:no
@REM net user guest /active:no

:firewall
set /p firewallChk="Enable firewall and basic firewall rules (y/n)"
if %firewallChk%==y (
	REM Firewall enable
	netsh advfirewall set allprofiles state on
	echo Firewall enabled (please manually check some of the settings)
	echo Setting basic firewall rules..
	netsh advfirewall firewall set rule name="Remote Assistance (DCOM-In)" new enable=no 
	netsh advfirewall firewall set rule name="Remote Assistance (PNRP-In)" new enable=no 
	netsh advfirewall firewall set rule name="Remote Assistance (RA Server TCP-In)" new enable=no 
	netsh advfirewall firewall set rule name="Remote Assistance (SSDP TCP-In)" new enable=no 
	netsh advfirewall firewall set rule name="Remote Assistance (SSDP UDP-In)" new enable=no 
	netsh advfirewall firewall set rule name="Remote Assistance (TCP-In)" new enable=no 
	netsh advfirewall firewall set rule name="Telnet Server" new enable=no 
	netsh advfirewall firewall set rule name="netcat" new enable=no
	echo Set basic firewall rules
	
)
if %firewallChk%==n (
	echo set up the firewall manually
	start firewall.cpl /wait
	pause
	goto:EOF
)
echo Invalid input %firewallChk%
goto firewall


:userAccount
echo please check the user settings (also look at CTRL + ALT + DEL)
start Control Userpasswords2 /wait
pause
goto:EOF



