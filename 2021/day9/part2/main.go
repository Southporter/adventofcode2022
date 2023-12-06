package main

import (
	"log"
	"strconv"
	"strings"

	utils "github.com/ssedrick/adventofcode2021"
)

func main() {
	lines, err := utils.ReadLines("test.txt")
	// lines, err := utils.ReadLines("input.txt")
	if err != nil {
		log.Fatalf("Error reading file: %s", err)
	}

	m := make([][]int, len(lines))

	for i, line := range lines {
		// log.Println("Line: ", line)
		m[i] = make([]int, len(line))
		parts := strings.Split(line, "")
		for j, part := range parts {
			num, err := strconv.Atoi(part)
			if err != nil {
				log.Fatalf("Error converting: %s", err)
			}
			m[i][j] = num
		}
	}

	riskLevel := 0

	for i, row := range m {
		for j, num := range row {

		}
	}

	log.Println("Risk level is ", riskLevel)
}
