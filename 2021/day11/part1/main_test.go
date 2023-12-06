package main

import "testing"

func TestIncrement(t *testing.T) {
	m := [][]int{
		[]int{1, 2},
		[]int{3, 4},
	}

	increment(m)

	if m[0][0] != 2 || m[0][1] != 3 || m[1][0] != 4 || m[1][1] != 5 {
		t.Fail()
	}
}
