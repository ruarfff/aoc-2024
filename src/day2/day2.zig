const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const file_util = @import("../util/file_utils.zig");

pub fn run() !void {
    const allocator = std.heap.page_allocator;
    const lines = try file_util.readFileToLines(allocator, "src/day2/input.txt");
    defer {
        for (lines) |line| {
            allocator.free(line);
        }
    }

    var safe_count: u32 = 0;

    for (lines) |line| {
        var it = std.mem.split(u8, line, " ");
        var levels = std.ArrayList(i32).init(allocator);
        defer levels.deinit();

        while (it.next()) |num_str| {
            const num = try std.fmt.parseInt(i32, num_str, 10);
            try levels.append(num);
        }

        var is_safe: bool = true;

        if (std.sort.isSorted(i32, levels.items, {}, std.sort.asc(i32)) or std.sort.isSorted(i32, levels.items, {}, std.sort.desc(i32))) {
            for (levels.items[1..], 0..) |level, prev_index| {
                const previous = levels.items[prev_index];

                const diff: u32 = @intCast(@abs(@as(i64, previous) - @as(i64, level)));
                if (diff < 1 or diff >= 4) {
                    is_safe = false;
                    break;
                }
            }
        } else {
            is_safe = false;
        }

        if (is_safe) {
            safe_count += 1;
            print("Level is safe: {any}\n", .{levels.items});
        } else {
            print("Level is not safe: {any}\n", .{levels.items});
        }
    }

    print("Safe count: {d}\n", .{safe_count});
}
