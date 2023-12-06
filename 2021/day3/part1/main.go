package main

import (
	"log"
	"strconv"
	"strings"

	utils "github.com/ssedrick/adventofcode2021"
)

type BitData struct {
	zero int
	one  int
}

func main() {
	// lines, err := utils.ReadLines("input.test.txt")
	lines, err := utils.ReadLines("input.txt")
	if err != nil {
		log.Fatalf("Error reading lines: %s", err)
		return
	}

	var minMax []*BitData

	for i, line := range lines {
		parts := strings.Split(line, "")
		for j, part := range parts {
			var data *BitData
			if i == 0 {
				data = &BitData{}
				minMax = append(minMax, data)
			} else {
				data = minMax[j]
			}
			switch part {
			case "0":
				data.zero++
			case "1":
				data.one++
			}
		}
	}

	gammaBits, epsilonBits := "", ""

	for _, data := range minMax {
		if data.one > data.zero {
			gammaBits += "1"
			epsilonBits += "0"
		} else {
			gammaBits += "0"
			epsilonBits += "1"
		}
	}

	log.Printf("Gamma: %s; Epsilon %s;", gammaBits, epsilonBits)

	gamma, err := strconv.ParseInt(gammaBits, 2, 0)
	if err != nil {
		log.Fatalf("Error converting gamma: %s", err)
		return
	}
	epsilon, err := strconv.ParseInt(epsilonBits, 2, 0)
	if err != nil {
		log.Fatalf("Error converting epsilon: %s", err)
		return
	}

	log.Printf("Answer: %d", gamma*epsilon)
}
