const std = @import("std");

pub fn main() !void {
    const data = @embedFile("data/day01.txt");
    // const data: []const u8 =
    //     \\1abc2
    //     \\pqr3stu8vwx
    //     \\a1b2c3d4e5
    //     \\treb7uchet
    // ;
    //
    // const data2: []const u8 =
    //     \\two1nine
    //     \\eighttwothree
    //     \\abcone2threexyz
    //     \\xtwoone3four
    //     \\4nineeightseven2
    //     \\zoneight234
    //     \\7pqrstsixteen
    //     \\1six15ninebgnzhtbmlxpnrqoneightfhp
    // ;

    try part1(data);
    try part2(data);
}

fn intForLine(line: []const u8) !usize {
    if (line.len == 0) {
        return 0;
    }
    var buf: [2]u8 = [_]u8{0} ** 2;
    for (line) |c| {
        switch (c) {
            '0'...'9' => {
                if (buf[0] == 0) {
                    buf[0] = c;
                } else {
                    buf[1] = c;
                }
            },
            else => {},
        }
    }
    if (buf[1] == 0) {
        buf[1] = buf[0];
    }
    return try std.fmt.parseInt(usize, &buf, 10);
}

fn part1(input: []const u8) !void {
    var lines = std.mem.splitAny(u8, input, "\n");
    var total: usize = 0;
    while (lines.next()) |line| {
        total += try intForLine(line);
    }
    std.debug.print("Part1 Total: {d}\n", .{total});
}

const dictionary = [_][]const u8{
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
};

fn part2(input: []const u8) !void {
    var lines = std.mem.splitAny(u8, input, "\n");
    var total: usize = 0;

    while (lines.next()) |line| {
        std.debug.print("Line: {s}\n", .{line});
        var new_line = std.ArrayList(u8).init(std.heap.page_allocator);
        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            var next: u8 = line[i];
            check: {
                for (dictionary, 0..) |word, digit| {
                    const end = word.len + i;
                    if (end > line.len) {
                        continue;
                    }
                    if (std.mem.eql(u8, line[i..end], word)) {
                        next = @as(u8, @truncate(digit)) + '0';
                        // i += word.len - 1;
                        break :check;
                    }
                }
            }
            try new_line.append(next);
        }
        std.debug.print("New line: {s} -> {s}\n", .{ line, new_line.items });
        const line_num = try intForLine(new_line.items);
        std.debug.print("Line num: {d}\n", .{line_num});
        total += line_num;
    }
    std.debug.print("Part2 Total: {d}\n", .{total});
}
