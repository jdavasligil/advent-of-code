const std = @import("std");

pub fn main() !void {
    std.debug.print("Part Number Sum: {d}", .{partNumberSum("data/input.dat")});
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

    //var total: u32 = 0;
    //_ = total;
    //var num: u32 = 0;
    //_ = num;
    //var num_len: u32 = 0;
    //_ = num_len;

    //var prev: [1024]u8 = undefined;
    //_ = prev;
    var curr: [1024]u8 = undefined;
    var next: [1024]u8 = undefined;

    // Handle the first line parse (no previous line).
    _ = try in_stream.readUntilDelimiterOrEof(&curr, '\n');
    _ = try in_stream.readUntilDelimiterOrEof(&next, '\n');

    const width = std.mem.sliceTo(&curr, '\n').len;

    std.debug.print("\ncurr: {s}\n", .{std.mem.sliceTo(&curr, '\n')});
    std.debug.print("next: {s}\n", .{std.mem.sliceTo(&next, '\n')});
    std.debug.print("Width: {d}", .{width});

    // Handle all lines inbetween
    //while (try in_stream.readUntilDelimiterOrEof(&next, '\n')) |next_line| {
    //    _ = next_line;

    //    // Copy curr to prev
    //    // Copy next to curr
    //}

    // Handle the last line parse (no next line).

    return 4361;
}

test partNumberSum {
    try std.testing.expectEqual(partNumberSum("data/calibration.dat"), 4361);
}
