package main

import (
	"fmt"
	"log"

	utils "github.com/ssedrick/adventofcode2021"
)

func main() {
	// lines, err := readLines("input.test.txt")
	lines, err := utils.ReadInts("input.txt")

	if err != nil {
		log.Fatalf("readlines: %s", err)
	}

	increases := 0

	for i, line := range lines {
		if i == 0 {
			continue
		}
		if lines[i-1] < line {
			increases++
		}
	}

	fmt.Println("Increases: ", increases)
}
