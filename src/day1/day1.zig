const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const file_util = @import("../util/file_utils.zig");

pub fn run() !void {
    const allocator = std.heap.page_allocator;
    const lines = try file_util.readFileToLines(allocator, "src/day1/input.txt");
    defer {
        for (lines) |line| {
            allocator.free(line);
        }
    }

    var left_list = ArrayList(u32).init(allocator);
    defer left_list.deinit();
    var right_list = ArrayList(u32).init(allocator);
    defer right_list.deinit();

    for (lines) |line| {
        var it = std.mem.split(u8, line, "   ");
        var i: i8 = 0;
        while (it.next()) |x| {
            const number = try std.fmt.parseInt(u32, x, 10);
            if (i == 0) {
                try left_list.append(number);
            } else {
                try right_list.append(number);
            }
            i += 1;
        }
    }

    // Sort both list in place
    std.mem.sort(u32, left_list.items, {}, std.sort.asc(u32));
    std.mem.sort(u32, right_list.items, {}, std.sort.asc(u32));

    var total_distance: u32 = 0;

    for (left_list.items, right_list.items) |left, right| {
        const diff: u32 = @intCast(@abs(@as(i64, left) - @as(i64, right)));

        print("left {d}, right {d}: diff {d}\n", .{ left, right, diff });

        total_distance += diff;
    }
    print("len {d}\n", .{left_list.items.len});

    print("Total distance: {d}\n", .{total_distance}); //2114951

    var similarity_score: u32 = 0;
    // Slow but this is a small data set
    for (left_list.items) |left| {
        const count: u32 = @intCast(std.mem.count(u32, right_list.items, &[_]u32{left}));
        similarity_score += left * count;
    }
    print("Similarity score {}\n", .{similarity_score});
}
