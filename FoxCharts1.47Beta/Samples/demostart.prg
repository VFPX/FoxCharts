LOCAL lcPath
lcPath = ADDBS(JUSTPATH(SYS(16)))

SET PATH TO (lcPath) ADDITIVE
SET PATH TO (lcPath + "images\") ADDITIVE
SET PATH TO (lcPath + "..\source\") ADDITIVE

DO (LOCFILE("System.app"))
DO FORM FoxChartsSamplesMain

READ EVENTS

CLEAR EVENTS 

IF _VFP.Startmode = 4 && EXE or APP
	CLEAR ALL
	ON SHUTDOWN
	QUIT
ENDIF
