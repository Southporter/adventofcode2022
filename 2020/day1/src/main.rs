use std::fs::File;
use std::io::prelude::*;

fn part1(numbers: Vec<i32>) -> std::io::Result<()> {
    let len = numbers.len();
    for i in 1..len {
        let number = numbers[i];
        match numbers.iter().find(|x| **x + number == 2020) {
            Some(x) => {
                println!(
                    "Numbers are {} and {}. Multiple is {}",
                    number,
                    x,
                    number * x
                );
                break;
            }
            None => {}
        }
    }
    Ok(())
}

fn part2(numbers: Vec<i32>) -> std::io::Result<()> {
    let len = numbers.len();
    for i in 1..len - 2 {
        for j in i..len - 1 {
            for k in j..len {
                if numbers[i] + numbers[j] + numbers[k] == 2020 {
                    println!(
                        "Numbers are {}, {}, and {}. Multiple is {}",
                        numbers[i],
                        numbers[j],
                        numbers[k],
                        numbers[i] * numbers[j] * numbers[k]
                    );
                    break;
                }
            }
        }
    }

    Ok(())
}

fn main() -> std::io::Result<()> {
    let mut input_file = File::open("input.txt")?;
    let mut contents_str = String::new();
    input_file.read_to_string(&mut contents_str)?;
    let numbers: Vec<i32> = contents_str
        .split("\n")
        .filter_map(|s| match s.parse::<i32>() {
            Ok(i) => Some(i),
            Err(_) => None,
        })
        .collect();

    // part1(numbers)
    part2(numbers)
}
