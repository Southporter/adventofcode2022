const std = @import("std");
const log = std.log.scoped(.day11);

// const test_data = "0 1 10 99 999";
const test_data = "125 17";
const actual_data = "0 27 5409930 828979 4471 3 68524 170";
const data = actual_data;

const BUF_SIZE = 1024 * 1024 * 400;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    log.debug("buf size: {d}", .{BUF_SIZE});
    var buf1 = try allocator.alloc(u64, BUF_SIZE);
    var buf2 = try allocator.alloc(u64, BUF_SIZE);

    var iter = std.mem.tokenizeScalar(u8, data, ' ');
    var count: usize = 0;
    while (iter.next()) |token| {
        const num = try std.fmt.parseInt(u64, token, 10);
        buf1[count] = num;
        count += 1;
    }
    log.debug("Initial line: {d}", .{buf1[0..count]});

    const stdout = std.io.getStdOut().writer();
    var read = buf1[0..];
    var write = buf2[0..];
    for (0..75) |i| {
        count = blink(read, count, write);

        //log.debug("Line after {d}: {d}", .{ i + 1, write[0..count] });
        if (i == 24) try stdout.print("Part 1: {d}\n", .{count});

        const tmp = read;
        read = write;
        write = tmp;
    }

    try stdout.print("Part 2: {d}\n", .{count});
}

fn split(num: u64, digits: u64) [2]u64 {
    std.debug.assert(digits == (std.math.log10(num) + 1));
    const half = std.math.pow(u64, 10, (digits / 2));
    const top = num / half;
    const bottom = num % half;
    return .{ top, bottom };
}
test "split" {
    try std.testing.expectEqual([2]u32{ 1, 2 }, split(12, 2));
    try std.testing.expectEqual([2]u32{ 253, 0 }, split(253000, 6));
    try std.testing.expectEqual([2]u32{ 10, 10 }, split(1010, 4));
    try std.testing.expectEqual([2]u32{ 20, 24 }, split(2024, 4));
    try std.testing.expectEqual([2]u32{ 12345, 6789 }, split(1234506789, 10));
}

fn blink(read: []const u64, count: usize, write: []u64) usize {
    var i: usize = 0;

    for (read[0..count]) |num| {
        defer i += 1;
        if (num == 0) {
            write[i] = 1;
            continue;
        }
        const num_digits = std.math.log10(num) + 1;
        if (num_digits & 0x01 == 0) {
            const after = split(num, num_digits);

            write[i] = after[0];
            i += 1;
            write[i] = after[1];
            continue;
        }
        write[i] = num * 2024;
    }
    return i;
}
