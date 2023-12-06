use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;

#[derive(Debug)]
struct State {
    pub trees: u32,
    pub column: usize,
    pub line: usize,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input_file = File::open("input.txt")?;
    let input_reader = BufReader::new(input_file);

    // let map: Vec<Vec<char>> = input_reader
    //     .lines()
    //     .map(|l| l.unwrap().chars().collect())
    //     .collect();
    //
    let init_state = State {
        trees: 0,
        column: 0,
        line: 0,
    };
    let end_state = input_reader
        .lines()
        .fold(init_state, |state, line| match line {
            Ok(content) => {
                let mut next_state = State {
                    trees: state.trees,
                    column: (state.column + 1) % content.len(),
                    line: state.line + 1,
                };
                if state.line % 2 != 0 {
                    next_state
                } else {
                    let c = content.get(state.column..state.column + 1);
                    // println!("Found {:?} at col {}", c, state.column);
                    if let Some("#") = c {
                        next_state.trees = state.trees + 1;
                    }
                    next_state
                }
            }
            Err(e) => {
                println!("Error: {}", e);
                state
            }
        });

    println!("End State: {:?}", end_state);

    Ok(())
}
