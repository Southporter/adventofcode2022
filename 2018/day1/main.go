package day1

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func doOperation(operation byte, left int64, right int64) int64 {
	if operation == '-' {
		return left - right
	} else if operation == '+' {
		return left + right
	}
	return left
}

func Run(star int, isTest bool) {
	filename := "./day1/day1.dat"
	if isTest {
		filename = "./day1/day1.test.dat"
	}

	if star == 1 {
		star1(filename)
	} else if star == 2 {
		star2(filename)
	}
}
