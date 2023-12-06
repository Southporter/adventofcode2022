package main

import (
	"fmt"
	"log"
	"strconv"
	"strings"

	utils "github.com/ssedrick/adventofcode2021"
)

func increment(octos [][]int) {
	for i, row := range octos {
		for j, o := range row {
			octos[i][j] = o + 1
		}
	}
}

func min(a, b int) int {
	if a <= b {
		return a
	}
	return b
}
func max(a, b int) int {
	if a >= b {
		return a
	}
	return b
}

func chain(octos [][]int, i, j int) int {
	log.Printf("Starting chain: (%d, %d)", i, j)
	numFlashes := 0
	for k := max(0, i-1); k < min(len(octos), i+2); k++ {
		for l := max(0, j-1); l < min(len(octos[k]), j+2); l++ {
			if octos[k][l] != 0 {
				octos[k][l] = octos[k][l] + 1
				if octos[k][l] > 9 {
					numFlashes++
					octos[k][l] = 0
					numFlashes += chain(octos, k, l)
				}
			}
		}
	}
	return numFlashes
}

func flash(octos [][]int) int {
	anyFlashes := true
	numFlashes := 0
	for anyFlashes {
		anyFlashes = false
		for i, row := range octos {
			for j, o := range row {
				if o > 9 {
					anyFlashes = true
					numFlashes++
					octos[i][j] = 0
					numFlashes += chain(octos, i, j)
				} else {
					octos[i][j] = o
				}
			}
		}
	}
	return numFlashes
}

func checkAllFlashed(octos [][]int) bool {
	for _, row := range octos {
		for _, o := range row {
			if o != 0 {
				return false
			}
		}
	}
	return true
}

func main() {
	// lines, err := utils.ReadLines("test.txt")
	lines, err := utils.ReadLines("input.txt")

	if err != nil {
		log.Fatalf("Error reading lines: %s", err)
	}

	octos := make([][]int, len(lines))

	for i, line := range lines {
		levels := strings.Split(line, "")
		for _, level := range levels {
			level, err := strconv.Atoi(level)
			if err != nil {
				log.Fatalf("One of the squares is not a number: %s", err)
			}
			octos[i] = append(octos[i], level)
		}
	}

	numSteps := 0
	allFlashed := false
	for !allFlashed {
		increment(octos)
		flash(octos)
		log.Println("Done incrementing", numSteps)
		allFlashed = checkAllFlashed(octos)
		numSteps++
	}
	log.Println("Octos:")
	for _, row := range octos {
		for _, o := range row {
			fmt.Printf("%d ", o)
		}
		fmt.Println()
	}
	log.Printf("Total Flashes: %d", numSteps)
}
