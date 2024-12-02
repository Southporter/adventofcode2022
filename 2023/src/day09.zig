const std = @import("std");

pub fn main() !void {
    const data = @embedFile("data/day09.txt");

    const answer1 = try part1(data, std.heap.page_allocator);
    std.debug.print("Part 1 answer: {}\n", .{answer1});
    const answer2 = try part2(data, std.heap.page_allocator);
    std.debug.print("Part 2 answer: {}\n", .{answer2});
}

fn part1(input: []const u8, allocator: std.mem.Allocator) !isize {
    var lines = std.mem.splitAny(u8, input, "\n");
    var total: isize = 0;
    var sequences = std.ArrayList(isize).init(allocator);
    defer sequences.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var tokens = std.mem.tokenizeAny(u8, line, " ");
        sequences.clearRetainingCapacity();
        while (tokens.next()) |tok| {
            const num = try std.fmt.parseInt(isize, tok, 10);
            if (sequences.items.len == 0) {
                try sequences.append(num);
                continue;
            }
            var prev = num;
            for (sequences.items, 0..) |seq, i| {
                sequences.items[i] = prev;
                prev -= seq;
            }
            if (prev != 0) {
                try sequences.append(prev);
            }
        }
        var val: isize = 0;
        std.mem.reverse(isize, sequences.items);
        for (sequences.items) |seq| {
            val += seq;
        }
        total += val;
    }
    return total;
}

fn part2(input: []const u8, allocator: std.mem.Allocator) !isize {
    var lines = std.mem.splitAny(u8, input, "\n");
    var total: isize = 0;
    var sequences = std.ArrayList(isize).init(allocator);
    defer sequences.deinit();
    var firsts = std.ArrayList(isize).init(allocator);
    defer firsts.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var tokens = std.mem.tokenizeAny(u8, line, " ");
        sequences.clearRetainingCapacity();
        firsts.clearRetainingCapacity();

        while (tokens.next()) |tok| {
            const num = try std.fmt.parseInt(isize, tok, 10);
            if (sequences.items.len == 0) {
                try sequences.append(num);
                try firsts.append(num);
                continue;
            }
            if (firsts.items.len < sequences.items.len) {
                std.debug.print("firsts: {d} -- {d}\n", .{ firsts.items, sequences.items });
                try firsts.append(sequences.items[sequences.items.len - 1]);
            }
            std.debug.print("num: {d} to {d}\n", .{ num, sequences.items });
            var prev = num;
            for (sequences.items, 0..) |seq, i| {
                sequences.items[i] = prev;
                prev -= seq;
            }
            std.debug.print("prev: {d}\n", .{prev});
            if (prev != 0) {
                try sequences.append(prev);
            } else {
                try firsts.append(prev);
            }
        }
        std.debug.print("\n\nsequence: {d}\n", .{sequences.items});
        std.debug.print("firsts: {d}\n", .{firsts.items});
        var val: isize = 0;
        std.mem.reverse(isize, firsts.items);
        for (firsts.items) |seq| {
            val = seq - val;
        }
        std.debug.print("val: {d}\n\n\n", .{val});
        total += val;
    }
    return total;
}

const test_data: []const u8 =
    \\0 3 6 9 12 15
    \\1 3 6 10 15 21
    \\10 13 16 21 30 45
;

test "part1" {
    try std.testing.expectEqual(try part1(test_data, std.testing.allocator), 114);
}

test "part2" {
    try std.testing.expectEqual(try part2(test_data, std.testing.allocator), 2);
}
