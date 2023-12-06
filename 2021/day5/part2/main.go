package main

import (
	"log"
	"strconv"
	"strings"

	utils "github.com/ssedrick/adventofcode2021"
)

const (
	MAX_SIZE = 1000
)

func main() {
	lines, err := utils.ReadLines("input.test.txt")
	// lines, err := utils.ReadLines("input.txt")

	if err != nil {
		log.Fatalf("Error reading file: %s", err)
		return
	}

	m := make([][]uint, MAX_SIZE)

	for i, _ := range m {
		m[i] = make([]uint, MAX_SIZE)
	}

	for _, line := range lines {
		log.Println("Line: ", line)
		parts := strings.Split(line, " -> ")
		if len(parts) != 2 {
			log.Fatalf("Error splitting line: Not 2 parts")
			return
		}
		startParts, stopParts := strings.Split(parts[0], ","), strings.Split(parts[1], ",")
		x1, err := strconv.Atoi(startParts[0])
		if err != nil {
			log.Fatalf("X1 is not a number: %s", err)
			return
		}
		y1, err := strconv.Atoi(startParts[1])
		if err != nil {
			log.Fatalf("Y1 is not a number: %s", err)
			return
		}
		x2, err := strconv.Atoi(stopParts[0])
		if err != nil {
			log.Fatalf("X2 is not a number: %s", err)
			return
		}
		y2, err := strconv.Atoi(stopParts[1])
		if err != nil {
			log.Fatalf("Y2 is not a number: %s", err)
			return
		}
		if x1 == x2 && y1 == y2 {
			log.Printf("Found a point: %d,%d -> %d, %d", x1, y1, x2, y2)
		}

		if x1 != x2 && y1 == y2 {
			if x2 < x1 {
				x2, x1 = x1, x2
			}
			for i := x1; i <= x2; i++ {
				// log.Printf("Previous value: %d  (%d,%d)", m[y1][i], i, y1)
				m[y1][i]++
			}
			continue
		}

		if y1 != y2 && y2 == y1 {
			if y2 < y1 {
				y2, y1 = y1, y2
			}
			for i := y1; i <= y2; i++ {
				m[i][x1]++
			}
			continue
		}

		// We hit a diagonal

	}

	crosses := 0

	for _, row := range m {
		for _, cell := range row {
			// if cell > 0 {
			// 	fmt.Print(cell)
			// } else {
			// 	fmt.Print(".")
			// }
			if cell > 1 {
				crosses++
			}
		}
		// fmt.Print("\n")
	}

	log.Printf("Number of crosses: %d", crosses)
}
