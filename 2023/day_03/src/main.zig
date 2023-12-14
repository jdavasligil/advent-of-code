const std = @import("std");

const Point = struct {
    x: usize,
    y: usize,
};

// P1 ATTEMPTS:
// 536202 FINAL
// 534871 LOW
// 536298 HIGH
// 556474 VHIGH
//
// P2 ATTEMPTS:
// 78272573 FINAL
// 3006409730 HIGH
// 13207030 LOW
pub fn main() anyerror!void {
    std.debug.print("Part Number Sum: {d}\n", .{try partNumberSum("data/input.dat")});
    std.debug.print("Gear Ratio Sum: {d}\n", .{try gearRatioSum("data/input.dat")});
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

// This is kind of insane, but it works?
fn gearRatio(prev: []u8, curr: []u8, next: []u8, width: usize) u32 {
    var ratio_count: u32 = 0;

    var nums: [6]u32 = undefined;
    var num_count: u8 = 0;
    var num_idx: usize = 0;

    var i: usize = 0;
    var j: usize = 0;
    var pow: usize = 0;

    while (true) {
        num_idx = 0;
        num_count = 0;
        @memset(&nums, 0);

        // Find gear
        while (i < width and curr[i] != '*') {
            i += 1;
        }

        // Gear not found
        if (i == width) {
            break;
        }

        // Count numbers around gear
        if (isDigit(prev[i - 1]) and !isDigit(prev[i]) and isDigit(prev[i + 1])) {
            num_count += 2;

            j = i - 1;
            pow = 0;
            while (isDigit(prev[j])) {
                nums[num_idx] += charToDigit(prev[j]) * powOfTen(pow);
                pow += 1;
                j -= 1;
            }
            num_idx += 1;

            j = i + 1;
            pow = 0;
            while (isDigit(prev[j + 1]))
                j += 1;
            while (isDigit(prev[j])) {
                nums[num_idx] += charToDigit(prev[j]) * powOfTen(pow);
                pow += 1;
                j -= 1;
            }
            num_idx += 1;
        } else if (isDigit(prev[i - 1]) or isDigit(prev[i]) or isDigit(prev[i + 1])) {
            num_count += 1;

            j = i - 1;
            pow = 0;
            while (!isDigit(prev[j]) or isDigit(prev[j + 1]))
                j += 1;
            while (isDigit(prev[j])) {
                nums[num_idx] += charToDigit(prev[j]) * powOfTen(pow);
                pow += 1;
                j -= 1;
            }
            num_idx += 1;
        }

        num_count += @intFromBool(isDigit(curr[i - 1]));
        num_count += @intFromBool(isDigit(curr[i + 1]));

        if (isDigit(next[i - 1]) and !isDigit(next[i]) and isDigit(next[i + 1])) {
            num_count += 2;

            j = i - 1;
            pow = 0;
            while (isDigit(next[j])) {
                nums[num_idx] += charToDigit(next[j]) * powOfTen(pow);
                pow += 1;
                j -= 1;
            }
            num_idx += 1;

            j = i + 1;
            pow = 0;
            while (isDigit(next[j + 1]))
                j += 1;
            while (isDigit(next[j])) {
                nums[num_idx] += charToDigit(next[j]) * powOfTen(pow);
                pow += 1;
                j -= 1;
            }
            num_idx += 1;
        } else if (isDigit(next[i - 1]) or isDigit(next[i]) or isDigit(next[i + 1])) {
            num_count += 1;

            j = i - 1;
            pow = 0;
            while (!isDigit(next[j]) or isDigit(next[j + 1]))
                j += 1;
            while (isDigit(next[j])) {
                nums[num_idx] += charToDigit(next[j]) * powOfTen(pow);
                pow += 1;
                j -= 1;
            }
            num_idx += 1;
        }

        // Gear iff count is 2
        if (num_count != 2) {
            i += 1;
            continue;
        }

        if (isDigit(curr[i - 1])) {
            j = i - 1;
            pow = 0;
            while (isDigit(curr[j])) {
                nums[num_idx] += charToDigit(curr[j]) * powOfTen(pow);
                pow += 1;
                j -= 1;
            }
            num_idx += 1;
        }

        if (isDigit(curr[i + 1])) {
            j = i + 1;
            pow = 0;
            while (isDigit(curr[j + 1]))
                j += 1;
            while (isDigit(curr[j])) {
                nums[num_idx] += charToDigit(curr[j]) * powOfTen(pow);
                pow += 1;
                j -= 1;
            }
            num_idx += 1;
        }

        ratio_count += nums[0] * nums[1];

        i += 1;
    }

    return ratio_count;
}

// Solve day 3 Part 2.
fn gearRatioSum(path: []const u8) anyerror!u32 {
    std.debug.print("DEBUG\n", .{});

    const in_file = try std.fs.cwd().openFile(path, .{});
    defer in_file.close();

    var br = std.io.bufferedReader(in_file.reader());
    const in_stream = br.reader();

    var total: u32 = 0;
    total += 1;
    total -= 1;

    var prev: [1024]u8 = undefined;
    var curr: [1024]u8 = undefined;
    var next: [1024]u8 = undefined;

    @memset(&prev, '.');
    @memset(&curr, '.');
    @memset(&next, '.');

    _ = try in_stream.readUntilDelimiterOrEof(curr[1..], '\n');

    const width: usize = std.mem.sliceTo(&curr, '\n').len;

    while (try in_stream.readUntilDelimiterOrEof(next[1..], '\n')) |nline| {
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
    try std.testing.expectEqual(try gearRatioSum("data/calibration.dat"), 16345);
}
