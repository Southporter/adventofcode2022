package main

import (
	"log"
	"math"

	utils "github.com/ssedrick/adventofcode2021"
)

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func calcFuel(x int) int {
	// log.Println("Calculating x ", x)
	if x < 1 {
		return 0
	}
	return x + calcFuel(x-1)
}

func main() {
	// positions, err := utils.ReadInts("test.txt")
	positions, err := utils.ReadInts("input.txt")

	if err != nil {
		log.Fatalf("Error reading file: %s", err)
		return
	}

	max := -1

	for _, position := range positions {
		if position > max {
			max = position
		}
	}

	log.Println("Max position is ", max)

	minFuel := math.MaxInt
	finalPosition := 0

	for i := 0; i <= max; i++ {
		positionFuel := 0
		for _, position := range positions {
			positionFuel += calcFuel(abs(position - i))
		}
		if positionFuel < minFuel {
			minFuel = positionFuel
			finalPosition = i
		}
	}

	log.Printf("Min Fuel is %d; Position is %d", minFuel, finalPosition)
}
