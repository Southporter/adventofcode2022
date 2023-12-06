package day3

import (
	"bufio"
	"fmt"
	"os"
)

func star1(filename string) {
	file, err := os.Open(filename)
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)
	fabric := generateFabric()

	for scanner.Scan() {
		line := scanner.Text()
		fmt.Println(line)

		claim := parseClaim(line)

		var yOffset int64
		var xOffset int64

		for yOffset = 0; yOffset < claim.dy; yOffset++ {
			for xOffset = 0; xOffset < claim.dx; xOffset++ {
				fabric[claim.y+yOffset][claim.x+xOffset]++
			}
		}
	}

	multipleClaimsCount := 0

	for y := range fabric {
		for x := range fabric[y] {
			if fabric[y][x] >= 2 {
				multipleClaimsCount++
			}
		}
	}

	fmt.Printf("%d inches have 2 or more claims", multipleClaimsCount)
}
