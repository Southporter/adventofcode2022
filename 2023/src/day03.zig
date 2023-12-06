const std = @import("std");

pub fn main() !void {
    const data = @embedFile("data/day03.txt");
    const allocator = std.heap.page_allocator;

    const answer1 = try part1(data, allocator);
    std.debug.print("Part 1 answer: {}\n", .{answer1});
    const answer2 = try part2(data, allocator);
    std.debug.print("Part 2 answer: {}\n", .{answer2});
}

fn isSymbol(c: u8) bool {
    return switch (c) {
        '*', '#', '+', '$', '^', '!', '=', '-', '_', '@', '%', '&', '/', '?', ';', ':' => true,
        else => false,
    };
}

fn isGear(c: u8) bool {
    return c == '*';
}
fn isNumber(c: u8) bool {
    return c <= '9' and c >= '0';
}

fn findNum(input: []const u8, index: usize) !u64 {
    var start = index;
    while (start > 0 and isNumber(input[start - 1])) : (start -= 1) {}
    var end = index;
    while (end < input.len and isNumber(input[end])) : (end += 1) {}
    // std.debug.print("Found number: {s}\n", .{input[start..end]});
    return std.fmt.parseInt(u64, input[start..end], 10) catch |err| {
        std.debug.print("Error parsing number: ({d} - {d}) {s}\n", .{ start, end, input });
        return err;
    };
}

fn gearRatio(input: []const []const u8, row: usize, col: usize) !u64 {
    const start_col = if (col > 0) col - 1 else col;
    const end_col = std.math.clamp(col + 1, 0, input[row].len - 1);
    var total_nums: usize = 0;
    var ratio: u64 = 1;
    if (row > 0) {
        const line = input[row - 1];
        const first = isNumber(line[start_col]);
        const middle = isNumber(line[col]);
        const end = isNumber(line[end_col]);
        // std.debug.print("Line before: ({s}) {} {} {}\n", .{ line, first, middle, end });
        if (first and end and !middle) {
            const num1 = try findNum(line, start_col);
            const num2 = try findNum(line, end_col);
            total_nums += 2;
            ratio *= num1;
            ratio *= num2;
        } else if (first) {
            ratio *= try findNum(line, start_col);
            total_nums += 1;
        } else if (middle or end) {
            ratio *= try findNum(line, if (middle) col else end_col);
            total_nums += 1;
        }
    }
    const current_line = input[row];
    if (isNumber(current_line[start_col])) {
        ratio *= try findNum(current_line, start_col);
        total_nums += 1;
    }
    if (isNumber(current_line[end_col])) {
        ratio *= try findNum(current_line[end_col..], 0);
        total_nums += 1;
    }
    if (row + 1 < input.len) {
        const line = input[row + 1];
        const first = isNumber(line[start_col]);
        const middle = isNumber(line[col]);
        const end = isNumber(line[end_col]);
        if (first and end and !middle) {
            const num1 = try findNum(line, start_col);
            const num2 = try findNum(line, end_col);
            total_nums += 2;
            ratio *= num1;
            ratio *= num2;
        } else if (first) {
            ratio *= try findNum(line, start_col);
            total_nums += 1;
        } else if (middle or end) {
            ratio *= try findNum(line, if (middle) col else end_col);
            total_nums += 1;
        }
    }
    if (total_nums == 2) {
        return ratio;
    }
    return 0;
}

fn nextToSymbol(input: []const []const u8, line: usize, start: usize, end: usize) bool {
    if (line > 0) {
        const input_line = input[line - 1];
        // std.debug.print("Previous line: {s}\n", .{input_line});
        var line_start = if (start > 0) start - 1 else start;
        const line_end = std.math.clamp(end + 1, 0, input_line.len - 1);
        // std.debug.print("Previous line slice {s}\n", .{input_line[line_start..line_end]});
        while (line_start < line_end) : (line_start += 1) {
            if (isSymbol(input_line[line_start])) {
                return true;
            }
        }
    }
    const same_line = input[line];
    // std.debug.print("Checking same line: {s}\n", .{same_line});
    if (start > 0) {
        // std.debug.print("Checking before on same line: {c}\n", .{same_line[start - 1]});
        if (isSymbol(same_line[start - 1])) {
            return true;
        }
    }
    if (end < same_line.len) {
        // std.debug.print("Checking after on same line: {c}\n", .{same_line[end]});
        if (isSymbol(same_line[end])) {
            return true;
        }
    }
    if (line + 1 < input.len) {
        const input_line = input[line + 1];
        var line_start = if (start > 0) start - 1 else start;
        const line_end = std.math.clamp(end + 1, 0, input_line.len - 1);
        while (line_start < line_end) : (line_start += 1) {
            if (isSymbol(input_line[line_start])) {
                return true;
            }
        }
    }
    return false;
}

fn part1(input: []const u8, allocator: std.mem.Allocator) !usize {
    var lines = std.ArrayList([]const u8).init(allocator);
    defer lines.deinit();
    var lines_iter = std.mem.splitAny(u8, input, "\n");
    while (lines_iter.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        try lines.append(line);
    }

    var total: usize = 0;
    var row: usize = 0;
    const line_items = lines.items;
    while (row < line_items.len) : (row += 1) {
        var col: usize = 0;
        const line = line_items[row];
        while (col < line.len) : (col += 1) {
            switch (line[col]) {
                '1'...'9' => {
                    const start = col;
                    var end = col + 1;
                    while (end < line.len and line[end] <= '9' and line[end] >= '0') : (end += 1) {}
                    if (nextToSymbol(line_items, row, start, end)) {
                        const number = try std.fmt.parseInt(usize, line[start..end], 10);
                        // std.debug.print("Found number: {}\n", .{number});
                        total += number;
                    }
                    col = end;
                },
                else => {},
            }
        }
    }
    return total;
}

fn part2(input: []const u8, allocator: std.mem.Allocator) !usize {
    var lines = std.ArrayList([]const u8).init(allocator);
    defer lines.deinit();
    var lines_iter = std.mem.splitAny(u8, input, "\n");
    while (lines_iter.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        try lines.append(line);
    }

    var total: usize = 0;
    var row: usize = 0;
    const line_items = lines.items;
    while (row < line_items.len) : (row += 1) {
        var col: usize = 0;
        const line = line_items[row];
        while (col < line.len) : (col += 1) {
            switch (line[col]) {
                '*' => {
                    total += try gearRatio(line_items, row, col);
                },
                else => {},
            }
        }
    }
    return total;
}

const test_data: []const u8 =
    \\467..114..
    \\...*......
    \\..35..633.
    \\......#...
    \\617*......
    \\.....+.58.
    \\..592.....
    \\......755.
    \\...$.*....
    \\.664.598..
    \\
;

const test_lines: []const []const u8 = &[_][]const u8{
    "467..114..",
    "...*......",
    "..35..633.",
    "......#...",
    "617*......",
    ".....+.58.",
    "..592.....",
    "......755.",
    "...$.*....",
    ".664...598",
};
test "nextToSymbol" {
    try std.testing.expect(nextToSymbol(test_lines, 0, 0, 3));
    try std.testing.expect(!nextToSymbol(test_lines, 0, 7, 9));
    try std.testing.expect(nextToSymbol(test_lines, 2, 2, 4));
    try std.testing.expect(!nextToSymbol(test_lines, 5, 7, 8));
    try std.testing.expect(nextToSymbol(test_lines, 4, 0, 3));
    try std.testing.expect(!nextToSymbol(test_lines, 5, 7, 8));
    try std.testing.expect(nextToSymbol(test_lines, 9, 1, 4));
    try std.testing.expect(!nextToSymbol(test_lines, 9, 7, 9));
}

test "part1" {
    try std.testing.expectEqual(try part1(test_data, std.testing.allocator), 4361);
}

test "part2" {
    try std.testing.expectEqual(try part2(test_data, std.testing.allocator), 467835);
}
