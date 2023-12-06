package main

import (
	"fmt"
	"log"
	"strconv"
	"strings"

	utils "github.com/ssedrick/adventofcode2021"
	board "github.com/ssedrick/adventofcode2021/board"
)

func main() {
	// lines, err := utils.ReadLines("input.test.txt")
	lines, err := utils.ReadLines("input.txt")

	if err != nil {
		log.Fatalf("Error reading lines: %s", err)
		return
	}

	drawings := strings.Split(lines[0], ",")
	log.Printf("Num Drawings: %d, drawing one: %s", len(drawings), drawings[0])

	lines = lines[1:]

	var boards []*board.Board

	var boardLines []string

	for i, line := range lines {
		if len(line) == 0 && i != 0 {
			newBoard, err := board.NewBoard(boardLines)
			if err != nil {
				log.Fatalln(err)
				return
			}
			boards = append(boards, newBoard)
			boardLines = nil
		}
		boardLines = append(boardLines, line)
	}
	lastBoard, err := board.NewBoard(boardLines)
	if err != nil {
		log.Fatalln(err)
		return
	}
	boards = append(boards, lastBoard)

	for _, drawing := range drawings {
		fmt.Printf("****** Drawing: %s ***************\n", drawing)
		if len(drawing) == 0 {
			continue
		}
		d, err := strconv.Atoi(drawing)
		if err != nil {
			log.Fatalf("Drawing is not a number: %s", err)
		}
		for _, board := range boards {
			board.Mark(d)
			board.PrettyPrint()
			// log.Println("Checking for winners")
			if board.HasWin() {
				board.PrettyPrint()
				value := board.CalculateValue()
				log.Println("Found winner", value)

				log.Printf("Answer: %d", value*d)
				return
			}
		}
	}
}
