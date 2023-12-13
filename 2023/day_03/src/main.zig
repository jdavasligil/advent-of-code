const std = @import("std");

const Point = struct {
    x: usize,
    y: usize,
};

// P1 ATTEMPTS:
// 536202 Final
// 534871 LOW
// 536298 HIGH
// 556474 VHIGH
pub fn main() anyerror!void {
    std.debug.print("Part Number Sum: {d}\n", .{try partNumberSum("data/input.dat")});
}

fn powOfTen(p: usize) u32 {
    return switch (p) {
        0 => 1,
        1 => 1E1,
        2 => 1E2,
        3 => 1E3,
        4 => 1E4,
        5 => 1E5,
        6 => 1E6,
        7 => 1E7,
        8 => 1E8,
        9 => 1E9,
        else => std.math.maxInt(u32),
    };
}

fn charToDigit(c: u8) u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        'A'...'Z' => c - 'A' + 10,
        'a'...'z' => c - 'a' + 10,
        else => std.math.maxInt(u8),
    };
}

fn isDigit(c: u8) bool {
    return switch (c) {
        '0'...'9' => true,
        else => false,
    };
}

fn isSymbol(c: u8) bool {
    return switch (c) {
        '0'...'9' => false,
        'A'...'Z' => false,
        'a'...'z' => false,
        '.' => false,
        '\n' => false,
        '\r' => false,
        else => true,
    };
}

fn hashPair(p: Point) usize {
    return if (p.x >= p.y) p.x * p.x + p.x + p.y else p.x + p.y * p.y;
}

fn fillSymMap(smap: []bool, path: []const u8) anyerror!void {
    const in_file = try std.fs.cwd().openFile(path, .{});
    defer in_file.close();

    var br = std.io.bufferedReader(in_file.reader());
    const in_stream = br.reader();

    var buffer: [1024]u8 = undefined;

    var p = Point{
        .x = 0,
        .y = 0,
    };

    while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        for (line) |c| {
            if (isSymbol(c)) {
                smap[hashPair(p)] = true;
                //std.debug.print("({d},{d}) {c}\n", .{ p.x, p.y, c });
            }
            p.x += 1;
        }
        p.x = 0;
        p.y += 1;
    }
}

fn isPartNumber(p: Point, len: usize, smap: []bool) bool {
    var result: bool = false;
    var px: usize = p.x;
    var width: usize = len + 2;

    if (px > 0) {
        px -= 1;
    } else {
        width -= 1;
    }

    //   std.debug.print("px: {d} py: {d}\n", .{ px, p.y });

    if (p.y > 0) {
        for (0..width) |i| {
            result = result or smap[hashPair(.{ .x = (px + i), .y = (p.y - 1) })];
        }
    }

    result = result or smap[hashPair(.{ .x = px, .y = p.y })];
    result = result or smap[hashPair(.{ .x = (px + width - 1), .y = p.y })];

    for (0..width) |i| {
        result = result or smap[hashPair(.{ .x = (px + i), .y = (p.y + 1) })];
    }

    return result;
}

// Solve day 3 Part 1.
// BOUNDS -> X,Y <= 140. N <= 999. TOTAL < 2^32.
fn partNumberSum(path: []const u8) anyerror!u32 {
    std.debug.print("DEBUG\n", .{});

    var sym_map: [19880]bool = undefined;
    @memset(&sym_map, false);

    try fillSymMap(&sym_map, path);

    //const width: usize = std.mem.sliceTo(&buffer, '\n').len;
    const in_file = try std.fs.cwd().openFile(path, .{});
    defer in_file.close();

    var br = std.io.bufferedReader(in_file.reader());
    const in_stream = br.reader();

    var total: u32 = 0;
    var buffer: [1024]u8 = undefined;

    // The location of the first digit of a number being parsed
    var p = Point{
        .x = 0,
        .y = 0,
    };

    // The length of a number being parsed
    var num_len: usize = 0;
    var num: u32 = 0;

    var i: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        i = 0;
        p.x = 0;

        // Add all numbers with symbols we can find in the line
        while (true) {
            // Locate first digit
            while (i < line.len and !isDigit(line[i])) {
                i += 1;
                p.x += 1;
            }

            if (i == line.len) break;

            num_len = 0;
            num = 0;

            // Get number length
            while (i < line.len and isDigit(line[i])) {
                i += 1;
                num_len += 1;
            }

            if (num_len == 0) break;

            // Get number value
            for (0..num_len) |j| {
                num += charToDigit(line[i - 1]) * powOfTen(j);
                i -= 1;
            }

            if (isPartNumber(.{ .x = p.x, .y = p.y }, num_len, &sym_map)) {
                std.debug.print("NUM: {d}, LEN: {d}, px: {d}, py: {d}\n", .{ num, num_len, p.x, p.y });
                total += num;
            }

            i += num_len;
            p.x = i;

            if (i >= line.len) break;
        }

        p.y += 1;
    }
    //std.debug.print("{s}\n", .{std.mem.sliceTo(line, '\n')});

    return total;
}

fn gearRatio(prev: []u8, curr: []u8, next: []u8, width: usize) u32 {
    _ = next;
    _ = prev;
    //var num: u32 = 0;
    //_ = num;
    //var num_len: usize = 0;
    //_ = num_len;
    //var num_count: u8 = 0;
    //_ = num_count;
    var i: usize = 0;

    while (i < width and curr[i] != '*') {
        i += 1;
    }

    if (i == width) {
        return 0;
    }

    return 0;
}

// Solve day 3 Part 2.
fn gearRatioSum(path: []const u8) anyerror!u32 {
    std.debug.print("DEBUG\n", .{});

    const in_file = try std.fs.cwd().openFile(path, .{});
    defer in_file.close();

    var br = std.io.bufferedReader(in_file.reader());
    const in_stream = br.reader();

    var total: u32 = 0;

    var prev: [1024]u8 = undefined;
    var curr: [1024]u8 = undefined;
    var next: [1024]u8 = undefined;

    @memset(&prev, '.');
    @memset(&curr, '.');
    @memset(&next, '.');

    _ = try in_stream.readUntilDelimiterOrEof(&curr, '\n');

    const width: usize = std.mem.sliceTo(&curr, '\n').len;

    while (try in_stream.readUntilDelimiterOrEof(&next, '\n')) |nline| {
        _ = nline;

        //std.debug.print("{s}\n", .{std.mem.sliceTo(&curr, '\n')});
        total += gearRatio(&prev, &curr, &next, width);

        @memcpy(&prev, &curr);
        @memcpy(&curr, &next);
    }

    // -- LAST LINE --
    @memset(&next, '.');
    //std.debug.print("{s}\n", .{std.mem.sliceTo(&curr, '\n')});
    total += gearRatio(&prev, &curr, &next, width);

    return total;
}

//test powOfTen {
//    try std.testing.expectEqual(powOfTen(0), 1);
//    try std.testing.expectEqual(powOfTen(1), 10);
//    try std.testing.expectEqual(powOfTen(2), 100);
//    try std.testing.expectEqual(powOfTen(3), 1000);
//}

//test partNumberSum {
//    try std.testing.expectEqual(try partNumberSum("data/calibration.dat"), 0);
//}

test gearRatioSum {
    try std.testing.expectEqual(try gearRatioSum("data/calibration.dat"), 0);
}
