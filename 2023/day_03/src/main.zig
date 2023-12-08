const std = @import("std");

pub fn main() anyerror!void {
    std.debug.print("Part Number Sum: {d}\n", .{try partNumberSum("data/input.dat")});
}

fn isSymbol(c: u8) bool {
    return switch (c) {
        '0'...'9' => false,
        'A'...'Z' => false,
        'a'...'z' => false,
        '.' => false,
        else => true,
    };
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

// Solve day 3 Part 1.
fn partNumberSum(path: []const u8) anyerror!u32 {
    const in_file = try std.fs.cwd().openFile(path, .{});
    defer in_file.close();

    var br = std.io.bufferedReader(in_file.reader());
    const in_stream = br.reader();

    var total: u32 = 0;
    var num: u32 = 0;
    var num_len: u32 = 0;
    var dist: u32 = 0;
    var i: usize = 0;
    var j: usize = 0;
    var d: u8 = 0;

    var prev: [1024]u8 = undefined;
    var curr: [1024]u8 = undefined;
    var next: [1024]u8 = undefined;

    // Handle the first line parse (no previous line).
    _ = try in_stream.readUntilDelimiterOrEof(&curr, '\n');
    _ = try in_stream.readUntilDelimiterOrEof(&next, '\n');

    const width: usize = std.mem.sliceTo(&curr, '\n').len;

    i = width - 1;

    while (i > 0) {
        num = 0;
        num_len = 0;

        // Find first digit from the right
        while (i > 0 and charToDigit(curr[i]) == std.math.maxInt(u8)) {
            i -= 1;
        }

        // Compute number and digit length
        while (true) {
            d = charToDigit(curr[i]);
            if (d == std.math.maxInt(u8)) break;
            num += d * powOfTen(num_len);
            num_len += 1;

            if (i > 0) {
                i -= 1;
            } else {
                break;
            }
        }

        if (num == 0 and i == 0) break;

        // Determine if number is adjacent to a symbol
        if (isSymbol(curr[i])) {
            total += num;
        } else if ((i + num_len) < width and isSymbol(curr[i + num_len])) {
            total += num;
        } else {
            dist = num_len + 2;
            j = i;
            while (dist > 0 and j < width) : ({
                j += 1;
                dist -= 1;
            }) {
                if (isSymbol(next[j])) {
                    total += num;
                    break;
                }
            }
        }
    }

    @memcpy(&prev, &curr);
    @memcpy(&curr, &next);

    // Handle all lines inbetween
    while (try in_stream.readUntilDelimiterOrEof(&next, '\n')) |next_line| {
        _ = next_line;
        i = width - 1;

        while (i > 0) {
            num = 0;
            num_len = 0;

            // Find first digit from the right
            while (i > 0 and charToDigit(curr[i]) == std.math.maxInt(u8)) {
                i -= 1;
            }

            // Compute number and digit length
            while (true) {
                d = charToDigit(curr[i]);
                if (d == std.math.maxInt(u8)) break;
                num += d * powOfTen(num_len);
                num_len += 1;

                if (i > 0) {
                    i -= 1;
                } else {
                    break;
                }
            }

            if (num == 0 and i == 0) break;

            // Determine if number is adjacent to a symbol
            if (isSymbol(curr[i])) {
                total += num;
            } else if ((i + num_len) < width and isSymbol(curr[i + num_len])) {
                total += num;
            } else {
                dist = num_len + 2;
                j = i;
                while (dist > 0 and j < width) : ({
                    j += 1;
                    dist -= 1;
                }) {
                    if (isSymbol(next[j]) or isSymbol(prev[j])) {
                        total += num;
                        break;
                    }
                }
            }
        }

        @memcpy(&prev, &curr);
        @memcpy(&curr, &next);
    }

    // Handle the last line parse (no next line).
    i = width - 1;

    while (i > 0) {
        num = 0;
        num_len = 0;

        // Find first digit from the right
        while (i > 0 and charToDigit(curr[i]) == std.math.maxInt(u8)) {
            i -= 1;
        }

        // Compute number and digit length
        while (true) {
            d = charToDigit(curr[i]);
            if (d == std.math.maxInt(u8)) break;
            num += d * powOfTen(num_len);
            num_len += 1;

            if (i > 0) {
                i -= 1;
            } else {
                break;
            }
        }

        if (num == 0 and i == 0) break;

        // Determine if number is adjacent to a symbol
        if (isSymbol(curr[i])) {
            total += num;
        } else if ((i + num_len) < width and isSymbol(curr[i + num_len])) {
            total += num;
        } else {
            dist = num_len + 2;
            j = i;
            while (dist > 0 and j < width) : ({
                j += 1;
                dist -= 1;
            }) {
                if (isSymbol(prev[j])) {
                    total += num;
                    break;
                }
            }
        }
    }

    std.debug.print("LAST LINE: {s}\n", .{std.mem.sliceTo(&curr, '\n')});

    return total;
}

test powOfTen {
    try std.testing.expectEqual(powOfTen(0), 1);
    try std.testing.expectEqual(powOfTen(1), 10);
    try std.testing.expectEqual(powOfTen(2), 100);
    try std.testing.expectEqual(powOfTen(3), 1000);
}

test partNumberSum {
    try std.testing.expectEqual(partNumberSum("data/calibration.dat"), 4361);
}
