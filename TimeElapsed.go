package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"time"
)

type timestamp struct {
	text   string
	valid  bool
	year   int
	month  int
	day    int
	hour   int
	minute int
	second int
	nano   int
}

func newTimestamp(text string) *timestamp {
	const regexp_timestamp = `^(?P<Hour>\d{2}):(?P<Minute>\d{2}):(?P<Second>\d{2}).(?P<Nano>\d{2})` +
		`_(?P<Day>\d{2})/(?P<Month>\d{2})/(?P<Year>\d{4}).*$`
	re, _ := regexp.Compile(regexp_timestamp)

	ts := timestamp{text: text}
	ts.valid = re.MatchString(ts.text)
	if ts.valid {
		m := re.FindStringSubmatch(ts.text)
		ts.year, _ = strconv.Atoi(m[re.SubexpIndex("Year")])
		ts.month, _ = strconv.Atoi(m[re.SubexpIndex("Month")])
		ts.day, _ = strconv.Atoi(m[re.SubexpIndex("Day")])
		ts.hour, _ = strconv.Atoi(m[re.SubexpIndex("Hour")])
		ts.minute, _ = strconv.Atoi(m[re.SubexpIndex("Minute")])
		ts.second, _ = strconv.Atoi(m[re.SubexpIndex("Second")])
		ts.nano, _ = strconv.Atoi((m[re.SubexpIndex("Nano")] + "000000000")[:9])
	}
	return &ts
}

func timestampToTime(ts timestamp) time.Time {
	return time.Date(ts.year, time.Month(ts.month), ts.day, ts.hour, ts.minute, ts.second, ts.nano, time.UTC)
}

func syntax() {
	fmt.Println("Syntax: TimeElapsed START UNTIL")
	fmt.Println("where START and UNTIL are in the format HH:MM:SS.NN_dd/mm/yyyy as may be collected using")
	fmt.Printf("%s\n", "Windows (BAT): set start=%time: =0%_%date%")
	fmt.Printf("%s\n", "Linux (Bash):  export start=$(date +%H:%M:%S.%2N_%d/%m/%Y)")
	os.Exit(1)
}

func main() {
	argCount := len(os.Args[1:])
	if argCount != 2 {
		fmt.Println("ERROR: Unsupported argument count.")
		syntax()
	}

	start := os.Args[1]
	until := os.Args[2]
	startTs := newTimestamp(start)
	untilTs := newTimestamp(until)
	if !startTs.valid {
		fmt.Printf("ERROR: Invalid START argument: '%s'", start)
	}
	if !untilTs.valid {
		fmt.Printf("ERROR: Invalid UNTIL argument: '%s'", until)
	}
	if !startTs.valid || !untilTs.valid {
		syntax()
	}

	startTime := timestampToTime(*startTs)
	untilTime := timestampToTime(*untilTs)
	if _, isSet := os.LookupEnv("TIMEELAPSED_DEBUG"); isSet {
		fmt.Printf("'%s' => %v => %v\n", start, startTs, startTime)
		fmt.Printf("'%s' => %v => %v\n", until, untilTs, untilTime)
	}

	fmt.Printf("Duration: %v\n", untilTime.Sub(startTime))
}
