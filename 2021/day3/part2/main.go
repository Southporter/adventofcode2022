package main

import (
	"log"
	"strconv"

	utils "github.com/ssedrick/adventofcode2021"
)

type picker func([]string, []string) []string

func filterCandidates(candidates []string, index int, p picker) string {
	log.Printf("Index[%d]: Num candidates? %d", index, len(candidates))
	if len(candidates) == 1 {
		return candidates[0]
	}
	var zeros, ones []string
	for _, line := range candidates {
		log.Println("Candidate: ", line)
		switch line[index] {
		case '0':
			zeros = append(zeros, line)
		case '1':
			ones = append(ones, line)
		}
	}

	newCandidates := p(zeros, ones)

	return filterCandidates(newCandidates, index+1, p)
}

func pickO2(zeros []string, ones []string) []string {
	if len(ones) >= len(zeros) {
		return ones
	}
	return zeros
}

func pickCO2(zeros []string, ones []string) []string {
	if len(zeros) <= len(ones) {
		return zeros
	}
	return ones
}

func main() {
	// lines, err := utils.ReadLines("input.test.txt")
	lines, err := utils.ReadLines("input.txt")
	if err != nil {
		log.Fatalf("Error reading lines: %s", err)
		return
	}

	oxyBits := filterCandidates(lines, 0, pickO2)
	co2Bits := filterCandidates(lines, 0, pickCO2)

	log.Printf("O2: %s; CO2 %s;", oxyBits, co2Bits)

	o2, err := strconv.ParseInt(oxyBits, 2, 0)
	if err != nil {
		log.Fatalf("Error converting o2: %s", err)
		return
	}
	co2, err := strconv.ParseInt(co2Bits, 2, 0)
	if err != nil {
		log.Fatalf("Error converting epsilon: %s", err)
		return
	}

	log.Printf("Answer: %d", o2*co2)
}
