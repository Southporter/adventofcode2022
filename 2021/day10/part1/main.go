package main

import (
	"log"

	utils "github.com/ssedrick/adventofcode2021"
)

type Stack struct {
	stack []rune
}

func (s *Stack) top() rune {
	n := len(s.stack) - 1
	return s.stack[n]
}

func (s *Stack) push(c rune) {
	// log.Printf("Pushing %c", c)
	s.stack = append(s.stack, c)
}

func (s *Stack) pop() {
	n := len(s.stack) - 1
	// log.Printf("%c popped", s.stack[n])
	s.stack = s.stack[:n]
}

const (
	PAREN_VALUE   = 3
	BRACKET_VALUE = 57
	CURLY_VALUE   = 1197
	ANGLE_VALUE   = 25137
)

func checkLine(line string) int {
	stack := &Stack{}
	for _, char := range line {
		switch char {
		case '<', '(', '[', '{':
			stack.push(char)
		case '>':
			last := stack.top()
			if last != '<' {
				return ANGLE_VALUE
			}
			stack.pop()
		case ')':
			last := stack.top()
			if last != '(' {
				return PAREN_VALUE
			}
			stack.pop()
		case ']':
			last := stack.top()
			if last != '[' {
				return BRACKET_VALUE
			}
			stack.pop()
		case '}':
			last := stack.top()
			if last != '{' {
				return CURLY_VALUE
			}
			stack.pop()
		}
	}
	return 0
}

func main() {
	// lines, err := utils.ReadLines("test.txt")
	lines, err := utils.ReadLines("input.txt")
	if err != nil {
		log.Fatalf("Error reading file: %s", err)
	}

	points := 0

	for _, line := range lines {
		// log.Println("Line: ", line)
		points += checkLine(line)
	}

	log.Println("Points: ", points)
}
