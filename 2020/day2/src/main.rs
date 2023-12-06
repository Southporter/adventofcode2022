use regex::Regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;

fn part1(min: u16, max: u16, target: char, password: &str) -> bool {
    let targets = password
        .chars()
        .fold(0, |count, c| if c == target { count + 1 } else { count });

    targets >= min && targets <= max
}

fn part2(min: usize, max: usize, target: char, password: &str) -> bool {
    let password_chars: Vec<char> = password.chars().collect();
    if password_chars[min - 1] == target {
        if password_chars[max - 1] != target {
            true
        } else {
            false
        }
    } else {
        if password_chars[max - 1] == target {
            true
        } else {
            false
        }
    }
}

fn main() -> std::io::Result<()> {
    let input_file = File::open("input.txt")?;
    let input_reader = BufReader::new(input_file);

    let line_regex = Regex::new(r#"(\d+)-(\d+) ([a-z]): ([a-z]+)"#).unwrap();

    let mut valid_passwords = 0;

    for line in input_reader.lines() {
        match line {
            Ok(content) => {
                // println!("Content of line is: {}", content);
                match line_regex.captures(&content) {
                    Some(parts) => {
                        let min = &parts[1].parse::<u16>().unwrap();
                        let max = &parts[2].parse::<u16>().unwrap();
                        let target = &parts[3].chars().next().unwrap();
                        let password = &parts[4];

                        // println!("Password is: {}", password);
                        // if part1(*min, *max, *target, password) {
                        //     // println!("Found Match!");
                        //     valid_passwords += 1;
                        // }
                        if part2(*min as usize, *max as usize, *target, password) {
                            valid_passwords += 1;
                        }
                    }
                    None => println!("No captures found"),
                }
            }
            Err(e) => println!("There was an error: {}", e),
        }
    }

    println!("There are {} valid passwords", valid_passwords);

    Ok(())
}
