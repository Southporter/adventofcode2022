package day1

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
)

func star2(filename string) {
	file, err := os.Open(filename)
	check(err)
	defer file.Close()

	reader := bufio.NewReader(file)

	var frequency int64
	frequencies := make(map[int64]bool)
	frequencies[0] = true

	for err == nil {
		sign, err := reader.ReadByte()

		if err == io.EOF {
			_, err := file.Seek(0, 0)
			check(err)
			reader.Reset(file)
			continue
		}

		numStr, err := reader.ReadString('\n')
		check(err)

		offset, err := strconv.ParseInt(numStr[:len(numStr)-1], 0, 0)
		check(err)

		frequency = doOperation(sign, frequency, offset)
		if frequencies[frequency] {
			break
		}
		frequencies[frequency] = true
	}

	fmt.Printf("frequency: %d\n", frequency)
}
