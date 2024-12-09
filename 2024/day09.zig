const std = @import("std");
const log = std.log.scoped(.day09);

const test_data = "2333133121414131402";

const actual_data = @embedFile("./day09.txt");
const data = test_data;
// const data = actual_data;

const Disk = struct {
    const DISK_SIZE: usize = 4096 * 1024;
    buffer: [DISK_SIZE]u16 = [_]u16{std.math.maxInt(u16)} ** DISK_SIZE,
    len: usize = 0,

    pub fn init(disk: *Disk, files: []const u8) void {
        var is_free = false;
        var current_index: u16 = 0;

        for (files) |size| {
            var i: u8 = '0';
            while (i < size) : (i += 1) {
                if (is_free) {
                    disk.buffer[disk.len] = std.math.maxInt(u16);
                } else {
                    disk.buffer[disk.len] = current_index;
                }
                disk.len += 1;
            }
            is_free = !is_free;
            if (!is_free) {
                current_index += 1;
            }
        }
    }
    pub fn checksum(disk: *Disk) u64 {
        var result: u64 = 0;
        for (disk.buffer[0..disk.len], 0..) |id, i| {
            if (disk.buffer[i] == std.math.maxInt(u16)) {
                break;
            }
            result += id * i;
        }
        return result;
    }
};

pub fn main() !void {
    const part1_result = part1(data);
    const part2_result = part2(data);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Part 1: {d}\n", .{part1_result});
    try stdout.print("Part 2: {d}\n", .{part2_result});
}

fn part1(files: []const u8) u64 {
    var disk: Disk = .{};
    // var last_index = (files.len - 1) / 2;
    // if (files.len % 2 == 0) {
    //     last_index -= 1;
    // }
    disk.init(files);

    log.debug("Disk: {d}", .{disk.buffer[0..disk.len]});
    var end = disk.len - 1;
    for (0..disk.len) |i| {
        if (i > end) break;
        if (disk.buffer[i] == std.math.maxInt(u16)) {
            disk.buffer[i] = disk.buffer[end];
            disk.buffer[end] = std.math.maxInt(u16);
            while (disk.buffer[end] == std.math.maxInt(u16)) {
                end -= 1;
            }
        }
    }
    log.debug("Compacted: {d}", .{disk.buffer[0..disk.len]});

    log.debug("Running checksum", .{});
    return disk.checksum();
}

fn part2(_: []const u8) u64 {
    return 0;
    // var new_files = []u8{'0'} ** files.len;
    // var is_free = false;
    // for (files) |size, file_| {
    //     defer is_free = !is_free;

    //     if (is_free) {
    //         // Find the last one that will fit
    //         for (0..files.len) |i| {
    //             if (files[files.len - i - 1] == size) {
    //                 new_
    //             }
    //         }
    //     }
    // }

    // var disk: Disk = .{};
    // disk.init(new_files);

    // return disk.checksum();
}
