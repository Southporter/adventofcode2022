package main

import (
	"log"
	"strconv"
	"strings"

	utils "github.com/ssedrick/adventofcode2021"
)

func main() {
	// lines, err := utils.ReadLines("test.txt")
	lines, err := utils.ReadLines("input.txt")
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
			top, bottom, left, right := 10, 10, 10, 10
			if i != 0 {
				top = m[i-1][j]
			}
			if i != len(m)-1 {
				bottom = m[i+1][j]
			}
			if j != 0 {
				left = m[i][j-1]
			}
			if j != len(row)-1 {
				right = m[i][j+1]
			}
			// log.Printf("(%d,%d) Top: %d; Bottom: %d; Left: %d; Right: %d; Num: %d", i, j, top, bottom, left, right, num)
			if top > num && bottom > num && left > num && right > num {
				riskLevel += num + 1
			}
		}
	}

	log.Println("Risk level is ", riskLevel)
}
