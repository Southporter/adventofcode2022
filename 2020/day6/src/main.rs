use std::fs::File;
use std::io::prelude::*;

use std::collections::HashSet;

fn part1(content: &str) {
    let yeses: usize = content
        .split("\n\n")
        .map(|s| {
            let mut chars = s.replace("\n", "").chars().collect::<Vec<char>>();
            chars.sort();
            chars.dedup();
            chars
        })
        .fold(0, |sum, chars| sum + chars.len());

    println!("Yes: {}", yeses);
}

fn part2(content: &str) {
    let yeses: usize = content
        .split("\n\n")
        .map(|s| {
            // println!("Group: {}", s);
            let sets: Vec<HashSet<_>> = s
                .trim()
                .split("\n")
                .map(|chars| chars.chars().collect::<HashSet<_>>())
                .collect();
            sets
        })
        .fold(0, |sum, answers| {
            let first: HashSet<_> = answers.get(0).unwrap().clone();
            let intersection = answers.iter().skip(1).fold(first, |i, answer| {
                answer.intersection(&i).map(|&c| c).collect()
            });
            // println!("Intersection: {:?}", intersection);
            sum + intersection.len()
        });

    println!("Part2 yeses: {}", yeses);
}

fn main() -> std::io::Result<()> {
    let mut input_file = File::open("input.txt")?;
    // let mut input_file = File::open("test.txt")?;
    let mut content = String::new();
    input_file.read_to_string(&mut content)?;

    part1(&content);
    part2(&content);

    Ok(())
}
