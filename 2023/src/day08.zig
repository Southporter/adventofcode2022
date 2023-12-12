const std = @import("std");

pub fn main() !void {
    const data = @embedFile("data/day08.txt");

    const answer1 = try part1(data, std.heap.page_allocator);
    std.debug.print("Part 1 answer: {}\n", .{answer1});
    const answer2 = try part2(data, std.heap.page_allocator);
    std.debug.print("Part 2 answer: {}\n", .{answer2});
}

const Node = struct {
    left: []const u8,
    right: []const u8,
};

const TreeContext = struct {
    pub fn hash(self: TreeContext, key: []const u8) u32 {
        _ = self;
        return std.hash.XxHash32.hash(42, key);
    }

    pub fn eql(self: TreeContext, lhs: []const u8, rhs: []const u8, b_index: usize) bool {
        _ = self;
        _ = b_index;
        return std.mem.eql(u8, lhs, rhs);
    }
};
const Tree = std.ArrayHashMap(
    []const u8,
    Node,
    TreeContext,
    false,
);
fn parseTree(input: []const u8, tree: *Tree) ![]const u8 {
    var lines = std.mem.splitAny(u8, input, "\n");
    const first = lines.next().?;
    var first_parts = std.mem.splitSequence(u8, first, " = ");
    const first_key = first_parts.next().?;
    var first_paths = first_parts.next().?;
    const first_left = first_paths[1..4];
    const first_right = first_paths[6..9];
    try tree.put(first_key, Node{ .left = first_left, .right = first_right });
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var parts = std.mem.splitSequence(u8, line, " = ");
        const key = parts.next().?;
        var paths = parts.next().?;
        const left = paths[1..4];
        const right = paths[6..9];
        try tree.put(key, Node{ .left = left, .right = right });
    }
    return first_key;
}
fn part1(input: []const u8, allocator: std.mem.Allocator) !usize {
    var parts = std.mem.splitSequence(u8, input, "\n\n");
    const directions = std.mem.trim(u8, parts.next().?, "\n");
    var network = Tree.init(allocator);
    defer network.deinit();

    const tree = parts.next().?;
    var current = try parseTree(tree, &network);
    const end: []const u8 = "ZZZ";

    var steps: usize = 0;
    while (steps < 100000) : (steps += 1) {
        if (std.mem.eql(u8, current, end)) {
            return steps;
        }
        if (network.get(current)) |next| {
            switch (directions[@mod(steps, directions.len)]) {
                'L' => current = next.left,
                'R' => current = next.right,
                else => {
                    std.debug.print("Invalid direction: {}\n", .{directions[@mod(steps, directions.len)]});
                    unreachable;
                },
            }
        } else {
            std.debug.print("No node found for key: {s}\n", .{current});
            unreachable;
        }
    }
    unreachable;
}

fn parseTreePart2(input: []const u8, tree: *Tree, start_locations: *std.ArrayList([]const u8)) !void {
    var lines = std.mem.splitAny(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var parts = std.mem.splitSequence(u8, line, " = ");
        const key = parts.next().?;
        if (key[key.len - 1] == 'A') {
            try start_locations.append(key);
        }
        var paths = parts.next().?;
        const left = paths[1..4];
        const right = paths[6..9];
        try tree.put(key, Node{ .left = left, .right = right });
    }
}

fn allEndInZ(positions: [][]const u8) bool {
    for (positions) |position| {
        if (position[position.len - 1] != 'Z') {
            return false;
        }
    }
    return true;
}

fn stepsUntilZ(start: []const u8, network: *Tree, directions: []const u8) usize {
    var steps: usize = 0;
    var current = start;
    while (steps < 100000) : (steps += 1) {
        if (current[current.len - 1] == 'Z') {
            return steps;
        }
        if (network.get(current)) |next| {
            current = switch (directions[@mod(steps, directions.len)]) {
                'L' => next.left,
                'R' => next.right,
                else => {
                    std.debug.print("Invalid direction: {}\n", .{directions[@mod(steps, directions.len)]});
                    unreachable;
                },
            };
        } else {
            std.debug.print("No node found for key: {s}\n", .{current});
            unreachable;
        }
    }
    unreachable;
}

fn part2(input: []const u8, allocator: std.mem.Allocator) !usize {
    var parts = std.mem.splitSequence(u8, input, "\n\n");
    const directions = std.mem.trim(u8, parts.next().?, "\n");
    // std.debug.print("Directions: {s}\n", .{directions});
    var network = Tree.init(allocator);
    defer network.deinit();
    var current_locations = std.ArrayList([]const u8).init(allocator);
    defer current_locations.deinit();

    const tree = parts.next().?;
    try parseTreePart2(tree, &network, &current_locations);

    var steps_for_each = std.ArrayList(usize).init(allocator);
    defer steps_for_each.deinit();

    const positions = current_locations.items;
    for (positions) |start| {
        try steps_for_each.append(stepsUntilZ(start, &network, directions));
    }
    const primes = [_]usize{ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 277 };
    var current_prime: u8 = 0;
    var lcm: usize = 1;
    const steps = steps_for_each.items;
    while (current_prime < primes.len) {
        std.debug.print("Steps: {d}\n", .{steps});
        if (std.mem.count(usize, steps, &[_]usize{1}) == steps.len) {
            return lcm;
        }
        var found = false;
        for (steps, 0..) |step, i| {
            if (@mod(step, primes[current_prime]) == 0) {
                found = true;
                steps[i] = step / primes[current_prime];
            }
        }
        if (found) {
            lcm *= primes[current_prime];
        } else {
            current_prime += 1;
        }
    }
    unreachable;
}

const test_data_1: []const u8 =
    \\RL
    \\
    \\AAA = (BBB, CCC)
    \\BBB = (DDD, EEE)
    \\CCC = (ZZZ, GGG)
    \\DDD = (DDD, DDD)
    \\EEE = (EEE, EEE)
    \\GGG = (GGG, GGG)
    \\ZZZ = (ZZZ, ZZZ)
;
const test_data_2: []const u8 =
    \\LLR
    \\
    \\AAA = (BBB, BBB)
    \\BBB = (AAA, ZZZ)
    \\ZZZ = (ZZZ, ZZZ)
;

const test_data_3: []const u8 =
    \\LR
    \\
    \\11A = (11B, XXX)
    \\11B = (XXX, 11Z)
    \\11Z = (11B, XXX)
    \\22A = (22B, XXX)
    \\22B = (22C, 22C)
    \\22C = (22Z, 22Z)
    \\22Z = (22B, 22B)
    \\XXX = (XXX, XXX)
;

test "part1" {
    try std.testing.expectEqual(try part1(test_data_1, std.testing.allocator), 2);
    try std.testing.expectEqual(try part1(test_data_2, std.testing.allocator), 6);
}

test "part2" {
    try std.testing.expectEqual(try part2(test_data_3, std.testing.allocator), 6);
}
