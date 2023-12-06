package main

import (
	"fmt"
	"log"

	utils "github.com/ssedrick/adventofcode2021"
)

func main() {
	// lines, err := utils.ReadLines("input.test.txt")
	lines, err := utils.ReadInts("input.txt")
	if err != nil {
		log.Fatalf("Error reading lines: %s", err)
	}

	increases := 0
	lastSum := 0

	for i, line := range lines {
		if i < 2 {
			continue
		}
		sum := lines[i-2] + lines[i-1] + line
		if lastSum != 0 && lastSum < sum {
			increases++
		}
		lastSum = sum
	}

	fmt.Println("Increases: ", increases)
}
