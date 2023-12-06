package main

import (
	"log"
	"sort"

	utils "github.com/ssedrick/adventofcode2021"
)

type Stack struct {
	stack []rune
}

func (s *Stack) top() rune {
	n := len(s.stack) - 1
	// log.Println("Top possition: ", n)
	if n >= 0 {
		return s.stack[n]
	}
	return rune(0)
}

func (s *Stack) push(c rune) {
	// log.Printf("Pushing %c", c)
	s.stack = append(s.stack, c)
}

func (s *Stack) pop() {
	n := len(s.stack) - 1
	// log.Printf("%c popped", s.stack[n])
	if n < 0 {
		return
	}
	s.stack = s.stack[:n]
}

const (
	PAREN_VALUE   = 1
	BRACKET_VALUE = 2
	CURLY_VALUE   = 3
	ANGLE_VALUE   = 4
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
				return 0
			}
			stack.pop()
		case ')':
			last := stack.top()
			if last != '(' {
				return 0
			}
			stack.pop()
		case ']':
			last := stack.top()
			if last != '[' {
				return 0
			}
			stack.pop()
		case '}':
			last := stack.top()
			if last != '{' {
				return 0
			}
			stack.pop()
		}
	}
	remaining := 0
	top := stack.top()
	for top != rune(0) {
		remaining *= 5
		switch top {
		case '<':
			remaining += ANGLE_VALUE
		case '(':
			remaining += PAREN_VALUE
		case '[':
			remaining += BRACKET_VALUE
		case '{':
			remaining += CURLY_VALUE
		}
		stack.pop()
		top = stack.top()
	}
	return remaining
}

func main() {
	// lines, err := utils.ReadLines("test.txt")
	lines, err := utils.ReadLines("input.txt")
	if err != nil {
		log.Fatalf("Error reading file: %s", err)
	}

	var scores []int

	for _, line := range lines {
		// log.Println("Line: ", line)
		score := checkLine(line)
		if score > 0 {
			scores = append(scores, score)
		}
	}

	sort.Ints(scores)
	middle := scores[len(scores)/2]
	log.Println("Points: ", middle)
}
