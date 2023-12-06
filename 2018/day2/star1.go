package day2

import (
	"bufio"
	"fmt"
	"os"
)

func star1(isTest bool) {
	filename := "./day2/day2.dat"
	if isTest {
		filename = "./day2/day2.test.dat"
	}

	file, err := os.Open(filename)
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)

	twoCounts := 0
	threeCounts := 0

	for scanner.Scan() {
		line := scanner.Text()
		fmt.Println(line)
		counts := make(map[rune]int)

		for _, character := range line {
			counts[character]++
		}

		printMap(counts)

		foundTwo := false
		foundThree := false
		for _, value := range counts {
			if value == 3 && !foundThree {
				threeCounts++
				foundThree = true
			}
			if value == 2 && !foundTwo {
				twoCounts++
				foundTwo = true
			}
		}
	}

	fmt.Printf("Checksum: %d", twoCounts*threeCounts)
}
