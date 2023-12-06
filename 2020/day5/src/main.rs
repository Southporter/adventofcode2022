use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;

#[derive(Debug)]
struct RowColumnState {
    // pub min_row: u32,
    // pub max_row: u32,
    // pub min_col: u32,
    // pub max_col: u32,
    pub rows: Vec<u16>,
    pub columns: Vec<u16>,
}

impl Default for RowColumnState {
    fn default() -> Self {
        Self {
            // min_row: 0,
            // max_row: 127,
            // min_col: 0,
            // max_col: 7,
            rows: (0..128).collect(),
            columns: (0..8).collect(),
        }
    }
}

fn next_state(state: RowColumnState, c: char) -> RowColumnState {
    // println!("Current state: {:?}", state);
    let row_mid = state.rows.len() / 2;
    let col_mid = state.columns.len() / 2;
    match c {
        'F' => RowColumnState {
            // min_row: state.min_row,
            // max_row: state.max_row / 2,
            // min_col: state.min_col,
            // max_col: state.max_col,
            rows: state.rows[..row_mid].into(),
            columns: state.columns,
        },
        'B' => RowColumnState {
            // min_row: state.max_row / 2 + 1,
            // max_row: state.max_row,
            // min_col: state.min_col,
            // max_col: state.max_col,
            rows: state.rows[row_mid..].into(),
            columns: state.columns,
        },
        'R' => RowColumnState {
            // min_row: state.min_row,
            // max_row: state.max_row,
            // min_col: state.max_col / 2,
            // max_col: state.max_col,
            rows: state.rows,
            columns: state.columns[col_mid..].into(),
        },
        'L' => RowColumnState {
            // min_row: state.min_row,
            // max_row: state.max_row,
            // min_col: state.min_col,
            // max_col: state.max_col / 2,
            rows: state.rows,
            columns: state.columns[..col_mid].into(),
        },
        unknown => {
            println!("Unknown char {}", unknown);
            state
        }
    }
}

fn get_row_and_column(content: &str) -> (u16, u16) {
    let final_state = content.chars().fold(RowColumnState::default(), next_state);
    println!("final state: {:?}", final_state);
    (final_state.rows[0], final_state.columns[0])
}

fn main() -> std::io::Result<()> {
    // let input_file = File::open("test.txt")?;
    let input_file = File::open("input.txt")?;

    let reader = BufReader::new(input_file);

    // PART 1
    // let max_id = reader.lines().fold(0, |max, line| match line {
    //     Ok(content) => {
    //         let (row, column) = get_row_and_column(&content);
    //         let seat_id = row * 8 + column;
    //         if seat_id > max {
    //             seat_id
    //         } else {
    //             max
    //         }
    //     }
    //     Err(e) => {
    //         println!("Error: {}", e);
    //         max
    //     }
    // });
    // println!("Max ID is {}", max_id);

    let mut seats = [true; 916];
    reader.lines().for_each(|line| match line {
        Ok(content) => {
            let (row, column) = get_row_and_column(&content);
            let seat_id = row * 8 + column;
            seats[seat_id as usize] = false;
        }
        Err(e) => {
            println!("Error: {}", e);
        }
    });
    let empty_seats: Vec<(usize, bool)> = seats
        .iter()
        .enumerate()
        .filter(|(_i, &is_empty)| is_empty)
        .map(|(i, &is_empty)| (i, is_empty))
        .collect();

    println!("empty seats: {:?}", empty_seats);

    Ok(())
}
