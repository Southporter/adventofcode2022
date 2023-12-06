use std::fs::File;
use std::io::prelude::*;

fn is_valid_length(v: &Vec<String>) -> bool {
    if v.len() == 8 {
        true
    } else if v.len() < 7 {
        false
    } else if !v.iter().any(|s| s.contains("cid")) {
        true
    } else {
        false
    }
}

fn part1(parts: &Vec<Vec<String>>) -> usize {
    parts.iter().filter(|v| is_valid_length(*v)).count()
}

fn part2(parts: &Vec<Vec<String>>) -> usize {
    use regex::Regex;
    let r = Regex::new(
        r#"byr:(19[2-9][0-9]|200[0-2]) (cid:\d+ )?ecl:(amb|blu|brn|gry|grn|hzl|oth) eyr:(202[0-9]|2030) hcl:#[0-9a-f]{6} hgt:((1[5-8][0-9]cm)|(19[0-3]cm)|(59in)|(6[0-9]in)|(7[0-6]in)) iyr:((201[0-9])|(2020)) pid:\d{9}"#,
    ).expect("Regex did not compile");
    parts
        .iter()
        .filter(|v| is_valid_length(*v))
        .filter(|&v| {
            let s = v.join(" ");
            let is_valid = r.is_match(&s);
            println!("S is {}: valid: {}", s, is_valid);
            is_valid
        })
        .count()
}

fn main() -> std::io::Result<()> {
    let mut input_file = File::open("input.txt")?;
    // let mut input_file = File::open("test.txt")?;
    let mut content = String::new();
    input_file.read_to_string(&mut content)?;

    let parts: Vec<Vec<String>> = content
        .split("\n\n")
        .map(|s| {
            let mut strs = s
                .replace("\n", " ")
                .split(" ")
                .map(|r| r.into())
                .filter(|r: &String| !r.is_empty())
                .collect::<Vec<String>>();
            strs.sort();
            strs
        })
        .collect();
    // let valid = part1(&parts);
    let valid = part2(&parts);

    println!("Valid: {}", valid);

    Ok(())
}
