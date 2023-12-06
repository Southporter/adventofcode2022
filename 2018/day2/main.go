package day2

import "fmt"

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func printMap(m map[rune]int) {
	for key, value := range m {
		fmt.Printf("%c - %d\n", key, value)
	}
}

func Run(star int, isTest bool) {
	if star == 1 {
		star1(isTest)
	} else if star == 2 {
		star2(isTest)
	}
}
