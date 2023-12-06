package main

import (
	"flag"

	"./day1"
	"./day2"
	"./day3"
)

type ParseError struct {
	message string
}

func (pe *ParseError) Error() string {
	return pe.message
}

func parseFlags() (int, int, bool, error) {
	day := flag.Int("day", 0, "specifices which day to run")
	star := flag.Int("star", 0, "specifies which start to run. Accepted values are 1 and 2")
	isTest := flag.Bool("test", false, "Should we run the program on test data?")

	flag.Parse()
	if *day < 1 || *day > 25 {
		return 0, 0, false, &ParseError{"There are only 25 days in the advent. Please pick a day between 1 and 25."}
	}
	if *star < 1 || *star > 2 {
		return 0, 0, false, &ParseError{"Star can only have a value of 0 and 1"}
	}

	return *day, *star, *isTest, nil
}

func main() {
	day, star, isTest, err := parseFlags()
	if err != nil {
		panic(err)
	}
	switch day {
	case 1:
		day1.Run(star, isTest)
	case 2:
		day2.Run(star, isTest)
	case 3:
		day3.Run(star, isTest)
	}
}
