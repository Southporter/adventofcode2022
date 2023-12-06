package day2

import (
	"bufio"
	"fmt"
	"os"
)

func star2(isTest bool) {
	filename := "./day2/day2.dat"
	if isTest {
		filename = "./day2/day2.test.2.dat"
	}

	file, err := os.Open(filename)
	check(err)
	defer file.Close()

	scanner1 := bufio.NewScanner(file)

	for scanner1.Scan() {
		line1 := scanner1.Text()

		file2, err := os.Open(filename)
		check(err)
		scanner2 := bufio.NewScanner(file2)
		for scanner2.Scan() {
			line2 := scanner2.Text()
			differs := 0

			line2Runes := []rune(line2)
			line1Runes := []rune(line1)
			for index, character1 := range line1Runes {
				character2 := line2Runes[index]
				if character2 != character1 {
					differs++
				}
			}

			if differs == 1 {
				fmt.Printf("found: %s : %s\n", line1, line2)
			}
		}
		file2.Close()
	}
}
