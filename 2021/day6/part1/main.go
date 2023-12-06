package main

import (
	"log"

	utils "github.com/ssedrick/adventofcode2021"
	lanternfish "github.com/ssedrick/adventofcode2021/lanternfish"
)

func main() {
	// ages, err := utils.ReadInts("test.txt")
	ages, err := utils.ReadInts("input.txt")

	if err != nil {
		log.Fatalf("Error reading file: %s", err)
		return
	}

	var school []*lanternfish.Lanternfish

	for _, age := range ages {
		school = append(school, lanternfish.ExistingLanternfish(int8(age)))
	}

	for i := 0; i < 80; i++ {
		for _, fish := range school {
			newFish := fish.Age()
			if newFish != nil {
				school = append(school, newFish)
			}
		}
		// log.Printf("There are %d fish after %d days", len(school), i)
	}

	log.Printf("There are %d fish", len(school))
}
