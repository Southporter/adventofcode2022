const std = @import("std");

pub fn main() !void {
    const data = @embedFile("data/day05.txt");

    const answer1 = try part1(data, std.heap.page_allocator);
    std.debug.print("Part 1 answer: {}\n", .{answer1});
    const answer2 = try part2(data, std.heap.page_allocator);
    std.debug.print("Part 2 answer: {}\n", .{answer2});
}

fn parseSeeds(input: []const u8, seeds: []u64) !void {
    var parts = std.mem.tokenizeAny(u8, input, " ");
    _ = parts.next().?;
    var i: u8 = 0;
    while (parts.next()) |part| : (i += 1) {
        seeds[i] = try std.fmt.parseInt(u64, part, 10);
    }
}

fn parseSeedRanges(input: []const u8, seeds: *std.ArrayList(u64)) !void {
    var parts = std.mem.tokenizeAny(u8, input, " ");
    _ = parts.next().?;
    while (parts.next()) |part| {
        const start = try std.fmt.parseInt(u64, part, 10);
        const length = try std.fmt.parseInt(u64, parts.next().?, 10);

        var i: usize = 0;
        while (i < length) : (i += 1) {
            try seeds.append(start + i);
        }
    }
}

fn parseMap(input: []const u8, map: *std.ArrayList(Mapping)) ![]const u8 {
    var parts = std.mem.tokenizeAny(u8, input, "\n");
    const header = parts.next().?;
    while (parts.next()) |part| {
        var mapping = try map.addOne();
        // std.debug.print("Mapping: {s}\n", .{mapping});
        var mapping_parts = std.mem.tokenizeAny(u8, part, " ");
        const dest_str = mapping_parts.next().?;
        // std.debug.print("dest_str: {s}\n", .{dest_str});
        mapping.destination = try std.fmt.parseInt(@TypeOf(mapping.destination), dest_str, 10);
        mapping.source = try std.fmt.parseInt(@TypeOf(mapping.source), mapping_parts.next().?, 10);
        mapping.length = try std.fmt.parseInt(@TypeOf(mapping.source), mapping_parts.next().?, 10);
    }
    return header;
}

const Mapping = struct {
    source: u64,
    destination: u64,
    length: u64,
};

fn followMap(location: u64, mappings: *std.ArrayList(Mapping)) u64 {
    for (mappings.items) |mapping| {
        if (location >= mapping.source and location < mapping.source + mapping.length) {
            return mapping.destination + (location - mapping.source);
        }
    }
    return location;
}

fn part1(input: []const u8, allocator: std.mem.Allocator) !usize {
    var sections = std.mem.splitSequence(u8, input, "\n\n");
    var seeds = [_]u64{0} ** 20;
    try parseSeeds(sections.next().?, &seeds);
    var mappings = std.ArrayList(Mapping).init(allocator);
    defer mappings.deinit();

    while (sections.next()) |section| {
        mappings.clearRetainingCapacity();
        const header = try parseMap(section, &mappings);
        for (seeds, 0..) |seed, i| {
            if (seed == 0) {
                break;
            }
            seeds[i] = followMap(seed, &mappings);
        }
        std.debug.print("seeds after {s} {d}\n", .{ header, seeds });
    }

    var min_loc: usize = std.math.maxInt(usize);
    for (seeds) |location| {
        if (location == 0) {
            continue;
        }
        if (location < min_loc) {
            min_loc = location;
        }
    }

    return min_loc;
}

fn updatePartition(partition: []u64, mappings: *std.ArrayList(Mapping)) void {
    for (partition) |*seed| {
        seed.* = followMap(seed.*, mappings);
    }
}

const PartitionArgs = struct {
    partition: []u64,
    mappings: *std.ArrayList(Mapping),
};

fn part2(input: []const u8, allocator: std.mem.Allocator) !usize {
    const num_jobs: u32 = 16;
    var pool: [16]std.Thread = undefined;

    var sections = std.mem.splitSequence(u8, input, "\n\n");
    var seed_list = try std.ArrayList(u64).initCapacity(allocator, 10000000000);
    defer seed_list.deinit();

    std.debug.print("Parsing seeds\n", .{});
    try parseSeedRanges(sections.next().?, &seed_list);
    std.debug.print("Finished parsing seeds: {d}\n", .{seed_list.items.len});
    var mappings = std.ArrayList(Mapping).init(allocator);
    defer mappings.deinit();

    var seeds = seed_list.items;

    while (sections.next()) |section| {
        mappings.clearRetainingCapacity();
        const header = try parseMap(section, &mappings);
        std.debug.print("Updating seeds for {s}\n", .{header});

        const partition_size = seeds.len / num_jobs;
        for (0..num_jobs) |i| {
            const start = partition_size * i;
            var end = partition_size * (i + 1);
            if (i == num_jobs - 1) {
                end = seeds.len;
            }
            const partition = seeds[start..end];
            pool[i] = try std.Thread.spawn(.{}, updatePartition, .{
                partition,
                &mappings,
            });
        }
        for (0..num_jobs) |i| {
            std.Thread.join(pool[i]);
        }
        // std.debug.print("seeds after {s} {d}\n", .{ header, seeds });
    }

    var min_loc: usize = std.math.maxInt(usize);
    for (seeds) |location| {
        if (location < min_loc) {
            min_loc = location;
        }
    }

    return min_loc;
}

const test_data: []const u8 =
    \\seeds: 79 14 55 13
    \\
    \\seed-to-soil map:
    \\50 98 2
    \\52 50 48
    \\
    \\soil-to-fertilizer map:
    \\0 15 37
    \\37 52 2
    \\39 0 15
    \\
    \\fertilizer-to-water map:
    \\49 53 8
    \\0 11 42
    \\42 0 7
    \\57 7 4
    \\
    \\water-to-light map:
    \\88 18 7
    \\18 25 70
    \\
    \\light-to-temperature map:
    \\45 77 23
    \\81 45 19
    \\68 64 13
    \\
    \\temperature-to-humidity map:
    \\0 69 1
    \\1 0 69
    \\
    \\humidity-to-location map:
    \\60 56 37
    \\56 93 4
;

test "part1" {
    try std.testing.expectEqual(try part1(test_data, std.testing.allocator), 35);
}

test "part2" {
    try std.testing.expectEqual(try part2(test_data, std.testing.allocator), 46);
}
