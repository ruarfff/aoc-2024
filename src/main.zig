const std = @import("std");
const runDay1 = @import("day1/day1.zig").run;
const runDay2 = @import("day2/day2.zig").run;
const runDay3 = @import("day3/day3.zig").run;

pub fn main() !void {
    std.debug.print("AOC 2024.\n", .{});
    // try runDay1();
    // try runDay2(false);
    // try runDay2(true);
    try runDay3();
}
