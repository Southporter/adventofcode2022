package main

import (
	"log"

	utils "github.com/ssedrick/adventofcode2021"
)

func main() {
	// ages, err := utils.ReadInts("test.txt")
	ages, err := utils.ReadInts("input.txt")

	if err != nil {
		log.Fatalf("Error reading file: %s", err)
		return
	}

	cycles := make([]uint64, 9)

	for _, age := range ages {
		cycles[age]++
	}

	log.Printf("Starting: %v", cycles)

	for i := 0; i < 256; i++ {

		log.Println("Starting day ", i)
		spawningFish := cycles[0]
		log.Printf("%d fish are ready to spawn", spawningFish)
		cycles = cycles[1:]
		cycles[6] += spawningFish
		cycles = append(cycles, spawningFish)
	}

	var totalFish uint64
	totalFish = 0
	for _, generation := range cycles {
		totalFish += generation
	}

	log.Printf("There are %d fish", totalFish)
}
