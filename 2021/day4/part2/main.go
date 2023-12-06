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
			log.Println("Checking for winners")
			if board.HasWin() {
				board.PrettyPrint()
				log.Println("Found winner", d)
				if len(boards) > 1 {
					boards = findAndDelete(boards, board)
					log.Println("Removed. Remaining: ", len(boards))
				} else {
					value := boards[0].CalculateValue()
					log.Printf("Value: %d  Last drawing: %d", value, d)
					log.Println("Answer: ", value*d)
					return
				}
			}
		}
	}
}

func findAndDelete(boards []*board.Board, board *board.Board) []*board.Board {
	index := -1
	for i, b := range boards {
		if b == board {
			log.Println("Found: ", i)
			index = i
		}
	}
	if index < 0 {
		return boards
	}
	front := boards[:index]
	back := boards[index+1:]
	log.Printf("Front: %d, back: %d", len(front), len(back))
	return append(front, back...)
}
