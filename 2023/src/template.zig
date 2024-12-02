const std = @import("std");

pub fn main() !void {
    const data = @embedFile("data/day02.txt");

    const answer1 = try part1(data, std.heap.page_allocator);
    std.debug.print("Part 1 answer: {}\n", .{answer1});
    const answer2 = try part2(data, std.heap.page_allocator);
    std.debug.print("Part 2 answer: {}\n", .{answer2});
}

fn part1(input: []const u8, allocator: std.mem.Allocator) !usize {
    _ = input;
    return 0;
}

fn part2(input: []const u8, allocator: std.mem.Allocator) !usize {
    _ = input;
    return 0;
}

const test_data: []const u8 =
    \\
;

test "part1" {
    try std.testing.expectEqual(try part1(test_data, std.testing.allocator), 1);
}

test "part2" {
    try std.testing.expectEqual(try part2(test_data, std.testing.allocator), 1);
}
