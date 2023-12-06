package day3

import (
	"bufio"
	"fmt"
	"os"
)

func isClaimWhole(fabric [][]int16, claim Claim) bool {
	var yOffset, xOffset int64
	for yOffset = 0; yOffset < claim.dy; yOffset++ {
		for xOffset = 0; xOffset < claim.dx; xOffset++ {
			if fabric[claim.y+yOffset][claim.x+xOffset] > 1 {
				return false
			}
		}
	}
	return true
}

func star2(filename string) {
	file, err := os.Open(filename)
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)
	fabric := generateFabric()
	var claims []Claim

	for scanner.Scan() {
		line := scanner.Text()
		fmt.Println(line)

		claim := parseClaim(line)
		claims = append(claims, claim)

		var yOffset int64
		var xOffset int64

		for yOffset = 0; yOffset < claim.dy; yOffset++ {
			for xOffset = 0; xOffset < claim.dx; xOffset++ {
				fabric[claim.y+yOffset][claim.x+xOffset]++
			}
		}
	}

	for _, claim := range claims {
		if isClaimWhole(fabric, claim) {
			fmt.Printf("Claim %s is whole", claim.id)
		}
	}
}
