package board

import (
	"fmt"
	"log"
	"strconv"
	"strings"
)

type Square struct {
	value  int
	marked bool
}

type Board struct {
	values [][]*Square
}

func NewBoard(lines []string) (*Board, error) {
	b := &Board{}
	for _, line := range lines {
		if len(line) == 0 {
			continue
		}
		b.values = append(b.values, nil)
		parts := strings.Split(line, " ")
		for _, part := range parts {
			if len(part) == 0 || part == " " {
				continue
			}
			value, err := strconv.Atoi(part)
			if err != nil {
				log.Fatalf("Error converting value: %s", err)
				return nil, err
			}
			lastIndex := len(b.values) - 1
			row := b.values[lastIndex]
			row = append(row, &Square{value, false})
			b.values[lastIndex] = row
		}
	}

	return b, nil
}

func (b *Board) Mark(val int) {
	for _, row := range b.values {
		for _, col := range row {
			if col.value == val {
				col.marked = true
				return
			}
		}
	}
}

func (b *Board) HasWin() bool {
	max := len(b.values)
	columnCounts := make([]int, max)
	// topLeftToBottomRight := 0
	// topRightToBottomLeft := 0

	for _, row := range b.values {
		rowCount := 0

		for j, square := range row {
			// columnCounts[j] = 0

			if square.marked {
				rowCount++
				columnCounts[j]++

				// if i == j {
				// 	topLeftToBottomRight++
				// }

				// if i+j == len(b.values) {
				// 	topRightToBottomLeft++
				// }
			}
		}
		if rowCount == len(row) {
			return true
		}
	}
	// if topLeftToBottomRight == max || topRightToBottomLeft == max {
	// 	return true
	// }
	for _, col := range columnCounts {
		if col == max {
			return true
		}
	}
	return false
}

func (b *Board) CalculateValue() int {
	sum := 0
	for _, row := range b.values {
		for _, col := range row {
			if !col.marked {
				sum += col.value
			}
		}
	}
	return sum
}

func (b *Board) PrettyPrint() {
	for _, row := range b.values {
		fmt.Println("")
		for _, s := range row {
			if s.marked {
				fmt.Printf("*")
			} else {
				fmt.Printf(" ")
			}
			fmt.Printf("%2d,", s.value)
		}
	}
	fmt.Println("")
}
