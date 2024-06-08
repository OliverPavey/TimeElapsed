# TimeElapsed - command line utiltity

`TimeElapsed` makes it easier for Windows BATCH scripts, and Linux BASH scripts to report
the time elapsed when running a series of commands.

## Windows BATCH example

```bat
SET start=%time: =0%_%date%
SLEEP 1
SET until=%time: =0%_%date%
TimeElapsed %start% %until%
```

Output: `Duration: 1.13s`

## Linux BASH example

```bash
export start=$(date +%H:%M:%S.%2N_%d/%m/%Y)
sleep 1
export until=$(date +%H:%M:%S.%2N_%d/%m/%Y)
TimeElapsed "$start" "$until"
```

Output: `Duration: 1.13s`

#Features

- The output will scale to days, hours, minutes and seconds.
- The calculation remains correct if the process runs across midnight.
- The date format is the same on Windows and Linux; which allows comparison with remote values (where clocks are in sync).

## Date format

The date format is `HH:MM:SS.NN_dd/mm/yyyy` because that date format can be collected on Windows in BATCH files, using `%time: =0%_%date%`. Linux `date` command is more flexible so we specify the same format on Linux, using `$(date +%H:%M:%S.%2N_%d/%m/%Y)`.

These formats are human readable, and hence can be logged independently of the use of the TimeElapsed tool.
