package main

import (
	"log"
	"strings"

	utils "github.com/ssedrick/adventofcode2021"
)

func main() {
	// lines, err := utils.ReadLines("test.txt")
	lines, err := utils.ReadLines("input.txt")
	if err != nil {
		log.Fatalf("Error reading file: %s", err)
		return
	}

	total := 0

	for _, line := range lines {
		parts := strings.Split(line, "|")
		trimmed := strings.TrimSpace(parts[1])
		parts = strings.Split(trimmed, " ")
		for _, part := range parts {
			numChars := len(part)

			switch numChars {
			case 2, 3, 4, 7:
				total++
			}
		}
	}

	log.Println("Total: ", total)
}
