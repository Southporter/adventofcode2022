const std = @import("std");

pub fn main() !void {
    const data = @embedFile("data/day07.txt");

    const answer1 = try part1(data, std.heap.page_allocator);
    std.debug.print("Part 1 answer: {}\n", .{answer1});
    const answer2 = try part2(data, std.heap.page_allocator);
    std.debug.print("Part 2 answer: {}\n", .{answer2});
}

const Kind = enum(u8) {
    high_card = 1,
    one_pair,
    two_pair,
    three_of_a_kind,
    full_house,
    four_of_a_kind,
    five_of_a_kind,
};

const Hand = struct {
    kind: Kind,
    cards: [5]u8,
    bid: u16,
};

fn valueForCard(c: u8) u8 {
    return switch (c) {
        'T' => 10,
        'J' => 11,
        'Q' => 12,
        'K' => 13,
        'A' => 14,
        '2'...'9' => c - '0',
        else => unreachable,
    };
}

fn parseHand(input: []const u8, hand: *Hand) void {
    var counts_raw: [5]u8 = undefined;
    for (input, 0..) |c, i| {
        const count = std.mem.count(u8, input, input[i..(i + 1)]);
        counts_raw[i] = @truncate(count);
        hand.cards[i] = valueForCard(c);
    }
    const counts: []const u8 = &counts_raw;
    const twos = std.mem.count(u8, counts, &[_]u8{2});
    if (counts[0] == 5) {
        hand.kind = Kind.five_of_a_kind;
    } else if (std.mem.indexOf(u8, counts, &[_]u8{4}) != null) {
        hand.kind = Kind.four_of_a_kind;
    } else if (std.mem.indexOf(u8, counts, &[_]u8{3}) != null and std.mem.indexOf(u8, counts, &[_]u8{2}) != null) {
        hand.kind = Kind.full_house;
    } else if (std.mem.indexOf(u8, counts, &[_]u8{3}) != null) {
        hand.kind = Kind.three_of_a_kind;
    } else if (twos == 4) {
        hand.kind = Kind.two_pair;
    } else if (twos == 2) {
        hand.kind = Kind.one_pair;
    } else {
        hand.kind = Kind.high_card;
    }
}

fn sortHands(context: @TypeOf(.{}), a: Hand, b: Hand) bool {
    _ = context;
    if (@intFromEnum(a.kind) < @intFromEnum(b.kind)) {
        return true;
    }
    if (a.kind == b.kind) {
        for (a.cards, b.cards) |ca, cb| {
            if (ca < cb) {
                return true;
            }
            if (ca == cb) {
                continue;
            }
            return false;
        }
    }
    return false;
}

fn part1(input: []const u8, allocator: std.mem.Allocator) !usize {
    var lines = std.mem.splitAny(u8, input, "\n");
    var hands = try std.ArrayList(Hand).initCapacity(allocator, 1000);
    defer hands.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var parts = std.mem.tokenizeAny(u8, line, " ");
        const hand_str = parts.next().?;
        const bid_str = parts.next().?;
        const bid = try std.fmt.parseInt(u16, bid_str, 10);
        var hand = try hands.addOne();
        hand.bid = bid;
        parseHand(hand_str, hand);
    }

    std.sort.pdq(Hand, hands.items, .{}, sortHands);

    var total: usize = 0;
    for (hands.items, 1..) |hand, rank| {
        const value = rank * hand.bid;
        // std.debug.print("Rank: {d} - Value: {d} -- Hand: {any}\n", .{ rank, value, hand });
        total += value;
    }

    return total;
}

fn valueForCardJoker(c: u8) u8 {
    return switch (c) {
        'T' => 10,
        'J' => 1,
        'Q' => 12,
        'K' => 13,
        'A' => 14,
        '2'...'9' => c - '0',
        else => unreachable,
    };
}

fn parseHandJoker(input: []const u8, hand: *Hand) void {
    var counts_raw: [5]u8 = undefined;
    var jokers: usize = 0;
    for (input, 0..) |c, i| {
        if (c == 'J') {
            jokers += 1;
        }
        const count = std.mem.count(u8, input, input[i..(i + 1)]);
        counts_raw[i] = @truncate(count);
        hand.cards[i] = valueForCardJoker(c);
    }

    const counts: []const u8 = &counts_raw;
    const twos = std.mem.count(u8, counts, &[_]u8{2});
    if (counts[0] == 5) {
        hand.kind = Kind.five_of_a_kind;
    } else if (std.mem.indexOf(u8, counts, &[_]u8{4}) != null) {
        if (jokers == 1 or jokers == 4) {
            hand.kind = Kind.five_of_a_kind;
        } else {
            hand.kind = Kind.four_of_a_kind;
        }
    } else if (std.mem.indexOf(u8, counts, &[_]u8{3}) != null and std.mem.indexOf(u8, counts, &[_]u8{2}) != null) {
        if (jokers == 2 or jokers == 3) {
            hand.kind = Kind.five_of_a_kind;
        } else {
            hand.kind = Kind.full_house;
        }
    } else if (std.mem.indexOf(u8, counts, &[_]u8{3}) != null) {
        if (jokers == 1 or jokers == 3) {
            hand.kind = Kind.four_of_a_kind;
        } else {
            hand.kind = Kind.three_of_a_kind;
        }
    } else if (twos == 4) {
        if (jokers == 2) {
            hand.kind = Kind.four_of_a_kind;
        } else if (jokers == 1) {
            hand.kind = Kind.full_house;
        } else {
            hand.kind = Kind.two_pair;
        }
    } else if (twos == 2) {
        if (jokers == 2 or jokers == 1) {
            hand.kind = Kind.three_of_a_kind;
        } else {
            hand.kind = Kind.one_pair;
        }
    } else if (jokers == 2) {
        hand.kind = Kind.three_of_a_kind;
    } else if (jokers == 1) {
        hand.kind = Kind.one_pair;
    } else {
        hand.kind = Kind.high_card;
    }
}

fn part2(input: []const u8, allocator: std.mem.Allocator) !usize {
    var lines = std.mem.splitAny(u8, input, "\n");
    var hands = try std.ArrayList(Hand).initCapacity(allocator, 1000);
    defer hands.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var parts = std.mem.tokenizeAny(u8, line, " ");
        const hand_str = parts.next().?;
        const bid_str = parts.next().?;
        const bid = try std.fmt.parseInt(u16, bid_str, 10);
        var hand = try hands.addOne();
        hand.bid = bid;
        parseHandJoker(hand_str, hand);
    }

    std.sort.pdq(Hand, hands.items, .{}, sortHands);

    var total: usize = 0;
    for (hands.items, 1..) |hand, rank| {
        const value = rank * hand.bid;
        // std.debug.print("Rank: {d} - Value: {d} -- Hand: {any}\n", .{ rank, value, hand });
        total += value;
    }

    return total;
}

const test_data: []const u8 =
    \\32T3K 765
    \\T55J5 684
    \\KK677 28
    \\KTJJT 220
    \\QQQJA 483
;

test "sortHands" {
    const hand_a = Hand{ .kind = .high_card, .cards = [5]u8{ 2, 3, 4, 5, 6 }, .bid = 0 };
    const hand_b = Hand{ .kind = .high_card, .cards = [5]u8{ 2, 3, 4, 5, 7 }, .bid = 0 };
    const hand_c = Hand{ .kind = .high_card, .cards = [5]u8{ 7, 3, 4, 5, 2 }, .bid = 0 };
    const hand_d = Hand{ .kind = .full_house, .cards = [5]u8{ 2, 2, 10, 10, 10 }, .bid = 0 };
    const hand_e = Hand{ .kind = .two_pair, .cards = [5]u8{ 11, 11, 4, 5, 5 }, .bid = 0 };

    try std.testing.expect(sortHands(.{}, hand_a, hand_b));
    try std.testing.expect(!sortHands(.{}, hand_b, hand_a));
    try std.testing.expect(sortHands(.{}, hand_b, hand_c));
    try std.testing.expect(!sortHands(.{}, hand_c, hand_b));
    try std.testing.expect(sortHands(.{}, hand_c, hand_d));
    try std.testing.expect(!sortHands(.{}, hand_d, hand_c));
    try std.testing.expect(sortHands(.{}, hand_e, hand_d));
    try std.testing.expect(!sortHands(.{}, hand_d, hand_e));
    try std.testing.expect(sortHands(.{}, hand_c, hand_e));
    try std.testing.expect(!sortHands(.{}, hand_e, hand_c));
}

test "parseHand" {
    const HandTest = struct {
        raw: [5]u8,
        parsed: Hand,
    };
    var hands = std.ArrayList(HandTest).init(std.testing.allocator);
    defer hands.deinit();

    try hands.append(.{
        .raw = [5]u8{ '2', '3', '4', '5', '6' },
        .parsed = Hand{
            .kind = .high_card,
            .cards = [5]u8{ 2, 3, 4, 5, 6 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [5]u8{ '2', '3', '4', '5', '5' },
        .parsed = Hand{
            .kind = .one_pair,
            .cards = [5]u8{ 2, 3, 4, 5, 5 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '4', '4', '3', '6', '6' },
        .parsed = Hand{
            .kind = .two_pair,
            .cards = [5]u8{ 4, 4, 3, 6, 6 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '2', '2', 'T', 'T', 'T' },
        .parsed = Hand{
            .kind = .full_house,
            .cards = [5]u8{ 2, 2, 10, 10, 10 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '6', '6', '6', '6', 'A' },
        .parsed = Hand{
            .kind = .four_of_a_kind,
            .cards = [5]u8{ 6, 6, 6, 6, 14 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ 'K', 'K', 'K', 'K', 'K' },
        .parsed = Hand{
            .kind = .five_of_a_kind,
            .cards = [5]u8{ 13, 13, 13, 13, 13 },
            .bid = 1,
        },
    });

    var parsed: Hand = undefined;
    parsed.bid = 1;
    for (hands.items) |hand| {
        parseHand(&hand.raw, &parsed);
        try std.testing.expectEqualDeep(parsed, hand.parsed);
    }
}

test "valueForCard" {
    try std.testing.expectEqual(valueForCard('2'), 2);
    try std.testing.expectEqual(valueForCard('3'), 3);
    try std.testing.expectEqual(valueForCard('4'), 4);
    try std.testing.expectEqual(valueForCard('5'), 5);
    try std.testing.expectEqual(valueForCard('6'), 6);
    try std.testing.expectEqual(valueForCard('7'), 7);
    try std.testing.expectEqual(valueForCard('8'), 8);
    try std.testing.expectEqual(valueForCard('9'), 9);
    try std.testing.expectEqual(valueForCard('T'), 10);
    try std.testing.expectEqual(valueForCard('J'), 11);
    try std.testing.expectEqual(valueForCard('Q'), 12);
    try std.testing.expectEqual(valueForCard('K'), 13);
    try std.testing.expectEqual(valueForCard('A'), 14);
}

test "part1" {
    try std.testing.expectEqual(try part1(test_data, std.testing.allocator), 6440);
}

test "parseHandJoker" {
    const HandTest = struct {
        raw: [5]u8,
        parsed: Hand,
    };
    var hands = std.ArrayList(HandTest).init(std.testing.allocator);
    defer hands.deinit();

    try hands.append(.{
        .raw = [5]u8{ '2', '3', '4', '5', '6' },
        .parsed = Hand{
            .kind = .high_card,
            .cards = [5]u8{ 2, 3, 4, 5, 6 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [5]u8{ '2', '3', '4', '5', '5' },
        .parsed = Hand{
            .kind = .one_pair,
            .cards = [5]u8{ 2, 3, 4, 5, 5 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [5]u8{ '2', '3', 'J', '5', '6' },
        .parsed = Hand{
            .kind = .one_pair,
            .cards = [5]u8{ 2, 3, 1, 5, 6 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '4', '4', '3', '6', '6' },
        .parsed = Hand{
            .kind = .two_pair,
            .cards = [5]u8{ 4, 4, 3, 6, 6 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '4', 'J', '3', '6', '6' },
        .parsed = Hand{
            .kind = .three_of_a_kind,
            .cards = [5]u8{ 4, 1, 3, 6, 6 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '4', '4', 'J', '6', '6' },
        .parsed = Hand{
            .kind = .full_house,
            .cards = [5]u8{ 4, 4, 1, 6, 6 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '2', '2', 'T', 'T', 'T' },
        .parsed = Hand{
            .kind = .full_house,
            .cards = [5]u8{ 2, 2, 10, 10, 10 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '2', '3', 'T', 'T', 'T' },
        .parsed = Hand{
            .kind = .three_of_a_kind,
            .cards = [5]u8{ 2, 3, 10, 10, 10 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '2', '3', 'J', 'T', 'T' },
        .parsed = Hand{
            .kind = .three_of_a_kind,
            .cards = [5]u8{ 2, 3, 1, 10, 10 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '2', '3', 'J', 'J', 'T' },
        .parsed = Hand{
            .kind = .three_of_a_kind,
            .cards = [5]u8{ 2, 3, 1, 1, 10 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ '6', '6', '6', '6', 'A' },
        .parsed = Hand{
            .kind = .four_of_a_kind,
            .cards = [5]u8{ 6, 6, 6, 6, 14 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ 'J', '6', '6', '6', 'A' },
        .parsed = Hand{
            .kind = .four_of_a_kind,
            .cards = [5]u8{ 1, 6, 6, 6, 14 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ 'J', '6', 'J', '6', 'A' },
        .parsed = Hand{
            .kind = .four_of_a_kind,
            .cards = [5]u8{ 1, 6, 1, 6, 14 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ 'K', 'K', 'K', 'K', 'K' },
        .parsed = Hand{
            .kind = .five_of_a_kind,
            .cards = [5]u8{ 13, 13, 13, 13, 13 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ 'K', 'J', 'J', 'J', 'K' },
        .parsed = Hand{
            .kind = .five_of_a_kind,
            .cards = [5]u8{ 13, 1, 1, 1, 13 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ 'T', 'J', 'J', 'J', '4' },
        .parsed = Hand{
            .kind = .four_of_a_kind,
            .cards = [5]u8{ 10, 1, 1, 1, 4 },
            .bid = 1,
        },
    });
    try hands.append(.{
        .raw = [_]u8{ 'K', 'J', 'J', 'J', 'J' },
        .parsed = Hand{
            .kind = .five_of_a_kind,
            .cards = [5]u8{ 13, 1, 1, 1, 1 },
            .bid = 1,
        },
    });

    var parsed: Hand = undefined;
    parsed.bid = 1;
    for (hands.items) |hand| {
        std.debug.print("Testing hand: {s}\n", .{hand.raw});
        parseHandJoker(&hand.raw, &parsed);
        try std.testing.expectEqualDeep(parsed, hand.parsed);
    }
}

test "valueForCardJoker" {
    try std.testing.expectEqual(valueForCardJoker('2'), 2);
    try std.testing.expectEqual(valueForCardJoker('3'), 3);
    try std.testing.expectEqual(valueForCardJoker('4'), 4);
    try std.testing.expectEqual(valueForCardJoker('5'), 5);
    try std.testing.expectEqual(valueForCardJoker('6'), 6);
    try std.testing.expectEqual(valueForCardJoker('7'), 7);
    try std.testing.expectEqual(valueForCardJoker('8'), 8);
    try std.testing.expectEqual(valueForCardJoker('9'), 9);
    try std.testing.expectEqual(valueForCardJoker('T'), 10);
    try std.testing.expectEqual(valueForCardJoker('J'), 1);
    try std.testing.expectEqual(valueForCardJoker('Q'), 12);
    try std.testing.expectEqual(valueForCardJoker('K'), 13);
    try std.testing.expectEqual(valueForCardJoker('A'), 14);
}

test "part2" {
    try std.testing.expectEqual(try part2(test_data, std.testing.allocator), 5905);
}
