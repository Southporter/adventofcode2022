package lanternfish

type Lanternfish struct {
	isJuvenile       bool
	daysToGeneration int8
}

func NewLanternfish() *Lanternfish {
	return &Lanternfish{
		isJuvenile:       true,
		daysToGeneration: 8,
	}
}

func ExistingLanternfish(age int8) *Lanternfish {
	return &Lanternfish{
		isJuvenile:       false,
		daysToGeneration: age,
	}
}

func (l *Lanternfish) Age() *Lanternfish {
	l.daysToGeneration--

	if l.daysToGeneration < 0 {
		l.daysToGeneration = 6
		l.isJuvenile = false

		return NewLanternfish()
	}
	return nil
}
