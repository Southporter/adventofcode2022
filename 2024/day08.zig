const std = @import("std");
const log = std.log.scoped(.day08);

pub const std_options = .{
    .log_level = .debug,
};

const test_data =
    \\............
    \\........0...
    \\.....0......
    \\.......0....
    \\....0.......
    \\......A.....
    \\............
    \\............
    \\........A...
    \\.........A..
    \\............
    \\............
    \\
;

const easy_test_data =
    \\T.........
    \\...T......
    \\.T........
    \\..........
    \\..........
    \\..........
    \\..........
    \\..........
    \\..........
    \\..........
    \\
;
const actual_data = @embedFile("./day08.txt");
const data = actual_data;

const Matrix = struct {
    rows: usize,
    cols: usize,
    stride: usize,
    buf: []const u8,

    pub fn init(buf: []const u8) Matrix {
        const cols = std.mem.indexOf(u8, data, "\n").?;
        const stride = cols + 1;
        const rows = data.len / stride;

        log.info("Have rows: {d} and cols: {d}", .{ rows, cols });
        return .{ .rows = rows, .cols = cols, .stride = stride, .buf = buf };
    }

    pub fn calcIndex(mat: Matrix, coord: Coord) usize {
        std.debug.assert(mat.inBounds(coord));
        const row: usize = @intCast(coord.row);
        const col: usize = @intCast(coord.col);
        return row * mat.stride + col;
    }

    pub fn getCoord(mat: Matrix, index: usize) Coord {
        return .{ .row = @intCast(index / mat.stride), .col = @intCast(index % mat.stride) };
    }

    pub inline fn rowInBounds(mat: Matrix, row: isize) bool {
        return row >= 0 and row < mat.rows;
    }

    pub inline fn colInBounds(mat: Matrix, col: isize) bool {
        return col >= 0 and col < mat.cols;
    }

    pub fn inBounds(mat: Matrix, coord: Coord) bool {
        return mat.rowInBounds(coord.row) and mat.colInBounds(coord.col);
    }
};

const Coord = struct {
    row: isize,
    col: isize,
};

pub fn main() !void {
    var matrix = Matrix.init(data);
    var antinodes = [_]bool{false} ** data.len;
    var antinodes2 = [_]bool{false} ** data.len;

    for (data, 0..) |cell, index| {
        if (cell == '.' or cell == '\n') continue;
        for (data[index + 1 ..], index + 1..) |next_cell, next_i| {
            if (next_cell != cell) continue;

            const first = matrix.getCoord(index);
            antinodes2[index] = true;
            const second = matrix.getCoord(next_i);
            antinodes2[next_i] = true;

            log.debug("First: {any}, second: {any}", .{ first, second });

            const row_dist = second.row - first.row;
            const col_dist = second.col - first.col;

            var before = Coord{
                .row = first.row - row_dist,
                .col = first.col - col_dist,
            };
            log.debug("Before: {any}", .{before});
            if (matrix.inBounds(before)) {
                antinodes[matrix.calcIndex(before)] = true;
            }
            while (matrix.inBounds(before)) {
                antinodes2[matrix.calcIndex(before)] = true;
                before.row -= row_dist;
                before.col -= col_dist;
            }
            var after = Coord{
                .row = second.row + row_dist,
                .col = second.col + col_dist,
            };
            log.debug("After: {any}", .{after});
            if (matrix.inBounds(after)) {
                antinodes[matrix.calcIndex(after)] = true;
            }
            while (matrix.inBounds(after)) {
                antinodes2[matrix.calcIndex(after)] = true;
                after.row += row_dist;
                after.col += col_dist;
            }
        }
    }
    var count: usize = 0;
    std.debug.print("Map:  ", .{});
    for (antinodes, 0..) |node, i| {
        if (node) count += 1;

        if (node) {
            std.debug.print("#", .{});
        } else {
            if (data[i] == '\n') {
                std.debug.print("\n      ", .{});
            } else {
                std.debug.print("{c}", .{data[i]});
            }
        }
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Antinodes: {d} (should be 364)\n", .{count});
    var count2: usize = 0;
    std.debug.print("Map:  ", .{});
    for (antinodes2, 0..) |node, i| {
        if (node) count2 += 1;
        if (node) {
            std.debug.print("#", .{});
        } else {
            if (data[i] == '\n') {
                std.debug.print("\n      ", .{});
            } else {
                std.debug.print("{c}", .{data[i]});
            }
        }
    }
    try stdout.print("Antinodes (part2): {d} (should be 1231)\n", .{count2});
}
