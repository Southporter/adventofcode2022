const std = @import("std");

const log = std.log.scoped(.day07);

const test_data =
    \\190: 10 19
    \\3267: 81 40 27
    \\83: 17 5
    \\156: 15 6
    \\7290: 6 8 6 15
    \\161011: 16 10 13
    \\192: 17 8 14
    \\21037: 9 7 18 13
    \\292: 11 6 16 20
;

const actual_data = @embedFile("./day07.txt");
// const data = test_data;
const data = actual_data;

pub fn main() !void {
    var lines = std.mem.splitScalar(u8, data, '\n');

    var result1: u64 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var parts = std.mem.splitSequence(u8, line, ": ");
        const res_raw = parts.next().?;
        const res = try std.fmt.parseInt(u64, res_raw, 10);
        const operands_raw = parts.next().?;

        var operands: [16]u16 = undefined;
        var count: usize = 0;
        var operands_iter = std.mem.splitScalar(u8, operands_raw, ' ');
        while (operands_iter.next()) |op| {
            operands[count] = try std.fmt.parseInt(u16, op, 10);
            count += 1;
        }

        if (checkEquation(res, operands[0..count])) {
            result1 += res;
        }
    }

    log.warn("Result1: {}", .{result1});
}

fn checkEquation(total: u64, nums: []u16) bool {
    var ops = std.bit_set.IntegerBitSet(16).initEmpty();
    const max = std.math.pow(u16, 2, @truncate(nums.len));

    while (ops.mask < max) : (ops.mask += 1) {
        var current: u64 = 0;
        for (nums, 0..) |num, i| {
            current = if (ops.isSet(i)) current + num else current * num;

            if (current > total) {
                break;
            }
        }
        if (current == total) {
            std.debug.print("Found a match: {d} = ", .{total});
            for (nums, 0..) |num, i| {
                const op_char: u8 = if (ops.isSet(i)) '+' else '*';
                std.debug.print("{d} {c} ", .{ num, op_char });
            }
            std.debug.print("\n", .{});
            return true;
        }
    }
    return false;
}
