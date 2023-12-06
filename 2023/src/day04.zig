const std = @import("std");

pub fn main() !void {
    const data = @embedFile("data/day04.txt");

    const answer1 = try part1(data);
    std.debug.print("Part 1 answer: {}\n", .{answer1});
    const answer2 = try part2(data, std.heap.page_allocator);
    std.debug.print("Part 2 answer: {}\n", .{answer2});
}

fn parseCardId(input: []const u8) !usize {
    return try std.fmt.parseInt(usize, input[5..], 10);
}

fn checkForWinner(winning_numbers: []const u8, needle: u8) bool {
    for (winning_numbers) |it| {
        if (needle == it) {
            return true;
        }
    }
    return false;
}

fn part1(input: []const u8) !usize {
    var total: usize = 0;
    var lines = std.mem.splitAny(u8, input, "\n");

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var cards = std.mem.splitSequence(u8, line, ": ");
        _ = cards.next().?;
        var matches: u6 = 0;
        var card = std.mem.splitSequence(u8, cards.next().?, " | ");
        var winners = [_]u8{0} ** 10;
        var winning_numbers_iter = std.mem.tokenizeAny(u8, card.next().?, " ");
        var i: usize = 0;
        while (winning_numbers_iter.next()) |num| : (i += 1) {
            winners[i] = try std.fmt.parseInt(u8, num, 10);
        }
        var card_numbers = std.mem.tokenizeAny(u8, card.next().?, " ");
        while (card_numbers.next()) |num| {
            const number = try std.fmt.parseInt(u8, num, 10);
            const is_winner = checkForWinner(&winners, number);
            if (is_winner) {
                matches += 1;
            }
        }

        if (matches > 0) {
            const points = std.math.shl(usize, 1, matches - 1);
            total += points;
        }
    }
    return total;
}

fn part2(input: []const u8, allocator: std.mem.Allocator) !usize {
    var total: u8 = 0;
    var lines = std.mem.splitAny(u8, input, "\n");

    var extra_cards = std.AutoArrayHashMap(u8, u64).init(allocator);
    defer extra_cards.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        total += 1;
        const current_card_count = extra_cards.get(total) orelse 0;
        try extra_cards.put(total, 1 + current_card_count);
        var cards = std.mem.splitSequence(u8, line, ": ");
        _ = cards.next().?;
        var matches: u6 = 0;
        var card = std.mem.splitSequence(u8, cards.next().?, " | ");
        var winners = [_]u8{0} ** 10;
        var winning_numbers_iter = std.mem.tokenizeAny(u8, card.next().?, " ");
        var i: usize = 0;
        while (winning_numbers_iter.next()) |num| : (i += 1) {
            winners[i] = try std.fmt.parseInt(u8, num, 10);
        }
        var card_numbers = std.mem.tokenizeAny(u8, card.next().?, " ");
        while (card_numbers.next()) |num| {
            const number = try std.fmt.parseInt(u8, num, 10);
            const is_winner = checkForWinner(&winners, number);
            if (is_winner) {
                matches += 1;
            }
        }

        // const total_matches = matches;
        var extra_i: u8 = total + 1;
        const copies = extra_cards.get(total) orelse 1;
        while (matches > 0) : (matches -= 1) {
            const current_cards = extra_cards.get(extra_i) orelse 0;
            try extra_cards.put(extra_i, current_cards + copies);
            extra_i += 1;
        }
        std.debug.print("Values: {d}\n", .{extra_cards.values()});
    }
    var sum: usize = 0;
    for (extra_cards.values()) |val| {
        sum += val;
    }
    return sum;
}

const test_data: []const u8 =
    \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    \\
;

test "part1" {
    try std.testing.expectEqual(try part1(test_data), 13);
}

test "part2" {
    try std.testing.expectEqual(try part2(test_data, std.testing.allocator), 30);
}
