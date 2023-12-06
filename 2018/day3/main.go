package day3

import (
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

type Claim struct {
	x  int64
	y  int64
	dx int64
	dy int64
	id string
}

func generateFabric() [][]int16 {
	base := make([][]int16, 1000)

	for row := range base {
		base[row] = make([]int16, 1000)
	}
	return base
}

func parseClaim(claim string) Claim {
	parts := strings.Split(claim, " ")
	start := strings.Split(parts[2], ",")
	x, err := strconv.ParseInt(start[0], 10, 64)
	check(err)
	y, err := strconv.ParseInt(strings.TrimRight(start[1], ":"), 10, 64)
	check(err)
	distance := strings.Split(parts[3], "x")
	dx, err := strconv.ParseInt(distance[0], 10, 64)
	check(err)
	dy, err := strconv.ParseInt(distance[1], 10, 64)
	check(err)
	return Claim{x, y, dx, dy, parts[0]}
}

func Run(star int, isTest bool) {
	filename := "./day3/day3.dat"
	if isTest {
		filename = "./day3/day3.test.dat"
	}

	if star == 1 {
		star1(filename)
	} else if star == 2 {
		star2(filename)
	}
}
