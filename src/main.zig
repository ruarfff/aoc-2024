const std = @import("std");
const runDay1 = @import("day1/day1.zig").run;

pub fn main() !void {
    std.debug.print("AOC 2024.\n", .{});
    try runDay1();
}
