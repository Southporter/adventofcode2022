package board

import (
	"testing"
)

func TestBoardScore(t *testing.T) {
	lines := []string{
		"1 2 3 4 5",
		"6 7 8 9 10",
		"11 12 13 14 15",
		"16 17 18 19 20",
		"21 22 23 24 25",
	}
	testBoard, err := NewBoard(lines)
	if err != nil {
		t.Errorf("Got an error when creating the board %s", err)
	}
	marked := []int{1, 8, 15, 11, 17, 23, 5, 10, 20, 24}

	for _, mark := range marked {
		testBoard.Mark(mark)
		if testBoard.HasWin() {
			t.Errorf("Too early to have a win: Mark: %d", mark)
		}
	}

	testBoard.Mark(25)

	if !testBoard.HasWin() {
		t.Errorf("Should have had a win in column 'O'")
	}
}
