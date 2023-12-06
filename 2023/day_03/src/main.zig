const std = @import("std");

pub fn main() !void {
    const in_file = try std.fs.cwd().openFile("data/calibration.dat", .{});
    defer in_file.close();

    var br = std.io.bufferedReader(in_file.reader());
    const in_stream = br.reader();

    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});
    }
}

test "calibration input" {
    const in_file = try std.fs.cwd().openFile("data/calibration.dat", .{});
    defer in_file.close();

    var br = std.io.bufferedReader(in_file.reader());
    const in_stream = br.reader();

    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});
    }
}
