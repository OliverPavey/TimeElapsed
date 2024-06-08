@ECHO OFF
SETLOCAL
REM SET TIMEELAPSED_DEBUG=true

go run TimeElapsed.go 06:23:53.13_05/06/2024 09:33:19.29_05/06/2024


SET start=%time: =0%_%date%
SLEEP 1
SET until=%time: =0%_%date%
go run TimeElapsed.go %start% %until%

ENDLOCAL