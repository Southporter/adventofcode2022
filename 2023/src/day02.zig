const std = @import("std");

pub fn main() !void {
    const data = @embedFile("data/day02.txt");

    const answer1 = try part1(data);
    std.debug.print("Part 1 answer: {}\n", .{answer1});
    const answer2 = try part2(data);
    std.debug.print("Part 2 answer: {}\n", .{answer2});
}

fn parseGameId(input: []const u8) !usize {
    return try std.fmt.parseInt(usize, input[5..], 10);
}

const Color = enum(u8) {
    red,
    green,
    blue,
};

fn colorMax(color: Color) usize {
    return switch (color) {
        .red => 12,
        .green => 13,
        .blue => 14,
    };
}

fn part1(input: []const u8) !usize {
    var total: usize = 0;
    var lines = std.mem.splitAny(u8, input, "\n");

    while (lines.next()) |line| linebreak: {
        if (line.len == 0) {
            continue;
        }
        var stats = std.mem.tokenizeSequence(u8, line, ": ");
        const game_id = try parseGameId(stats.next().?);
        var games = std.mem.tokenizeSequence(u8, stats.next().?, "; ");
        var is_valid = true;
        while (games.next()) |game| {
            var groups = std.mem.tokenizeSequence(u8, game, ", ");
            while (groups.next()) |group| {
                var parts = std.mem.splitAny(u8, group, " ");
                const count = try std.fmt.parseInt(usize, parts.next().?, 10);
                const color = std.meta.stringToEnum(Color, parts.next().?).?;
                if (count > colorMax(color)) {
                    is_valid = false;
                    break :linebreak;
                }
            }
        }
        if (is_valid) {
            total += game_id;
        }
    }
    return total;
}

fn part2(input: []const u8) !usize {
    var total: usize = 0;
    var lines = std.mem.splitAny(u8, input, "\n");

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var stats = std.mem.tokenizeSequence(u8, line, ": ");
        _ = stats.next();
        var games = std.mem.tokenizeSequence(u8, stats.next().?, "; ");
        var counts = [3]u8{ 0, 0, 0 };
        while (games.next()) |game| {
            var groups = std.mem.tokenizeSequence(u8, game, ", ");
            while (groups.next()) |group| {
                var parts = std.mem.splitAny(u8, group, " ");
                const count = try std.fmt.parseInt(u8, parts.next().?, 10);
                const color = @intFromEnum(std.meta.stringToEnum(Color, parts.next().?).?);
                const max = counts[color];
                if (count > max) {
                    counts[color] = count;
                }
            }
        }
        std.debug.print("Counts: {d}\n", .{counts});
        var power: usize = 1;
        for (counts) |count| {
            if (count == 0) {
                continue;
            }
            power *= count;
        }
        std.debug.print("Power: {d}\n", .{power});
        total += power;
    }
    return total;
}

const test_data: []const u8 =
    \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    \\
;

test "part1" {
    try std.testing.expectEqual(try part1(test_data), 8);
}

test "part2" {
    try std.testing.expectEqual(try part2(test_data), 2286);
}
