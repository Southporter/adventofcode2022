package main

import "testing"

func TestAllFlashed(t *testing.T) {
	m := [][]int{
		{0, 0, 0},
		{0, 0, 0},
		{0, 0, 0},
	}

	if !checkAllFlashed(m) {
		t.Fail()
	}

	m = [][]int{
		{1, 0, 0},
		{0, 1, 0},
		{0, 0, 2},
	}

	if checkAllFlashed(m) {
		t.Fail()
	}
}
