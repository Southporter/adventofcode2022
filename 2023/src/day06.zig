const std = @import("std");

pub fn main() !void {
    const data = @embedFile("data/day06.txt");

    const answer1 = try part1(data);
    std.debug.print("Part 1 answer: {}\n", .{answer1});
    const answer2 = try part2(data);
    std.debug.print("Part 2 answer: {}\n", .{answer2});
}

fn part1(input: []const u8) !u64 {
    var sections = std.mem.splitAny(u8, input, "\n");
    var times = std.mem.tokenizeAny(u8, sections.next().?, ": ");
    var distances = std.mem.tokenizeAny(u8, sections.next().?, ": ");
    _ = times.next().?;
    _ = distances.next().?;

    var total: u64 = 1;

    while (times.next()) |time_str| {
        const dist_str = distances.next().?;
        // std.debug.print("Time: {s}, Dist: {s}\n", .{ time_str, dist_str });
        const max_time = try std.fmt.parseInt(usize, time_str, 10);
        const max_dist = try std.fmt.parseInt(usize, dist_str, 10);
        // std.debug.print("Max time: {d}, dist: {d}\n", .{ max_time, max_dist });

        var ways_to_win: usize = 0;
        for (1..max_time) |hold| {
            const distance = hold * (max_time - hold);
            // std.debug.print("Hold: {d}, distance: {d}\n", .{ hold, distance });
            if (distance > max_dist) {
                ways_to_win += 1;
            }
        }
        // std.debug.print("Ways to win: {d}\n", .{ways_to_win});
        total *= ways_to_win;
    }

    return total;
}

fn part2(input: []const u8) !usize {
    var sections = std.mem.splitAny(u8, input, "\n");
    var times = std.mem.tokenizeAny(u8, sections.next().?, ": ");
    var distances = std.mem.tokenizeAny(u8, sections.next().?, ": ");
    _ = times.next().?;
    _ = distances.next().?;

    var buf = [_]u8{0} ** 64;
    var buf_allocator = std.heap.FixedBufferAllocator.init(&buf);
    var str = std.ArrayList(u8).init(buf_allocator.allocator());
    var writer = str.writer();

    while (times.next()) |time| {
        try writer.writeAll(time);
    }
    const time = try std.fmt.parseInt(usize, str.items, 10);
    str.clearRetainingCapacity();
    writer = str.writer();
    while (distances.next()) |dist| {
        try writer.writeAll(dist);
    }
    const distance = try std.fmt.parseInt(usize, str.items, 10);

    var total: usize = 0;
    for (1..time) |hold| {
        const dist = hold * (time - hold);
        if (dist > distance) {
            total += 1;
        }
    }

    return total;
}

const test_data: []const u8 =
    \\ Time:      7  15    30
    \\ Distance:  9  40   200
;

test "part1" {
    try std.testing.expectEqual(try part1(test_data), 288);
}

test "part2" {
    try std.testing.expectEqual(try part2(test_data), 71503);
}
