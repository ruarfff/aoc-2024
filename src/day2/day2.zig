const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const file_util = @import("../util/file_utils.zig");

fn isSafe(level: []const i32) bool {
    var is_safe: bool = true;

    if (std.sort.isSorted(i32, level, {}, std.sort.asc(i32)) or std.sort.isSorted(i32, level, {}, std.sort.desc(i32))) {
        for (level[1..], 0..) |current, prev_index| {
            const previous = level[prev_index];

            const diff: u32 = @intCast(@abs(@as(i64, previous) - @as(i64, current)));
            if (diff < 1 or diff >= 4) {
                is_safe = false;
                break;
            }
        }
    } else {
        is_safe = false;
    }

    return is_safe;
}

fn isSafeWithDampener(level: []const i32) bool {
    var temp_list = std.ArrayList(i32).init(std.heap.page_allocator);
    defer temp_list.deinit();

    // For each position, create a new sequence without that number
    for (0..level.len) |skip_index| {
        temp_list.clearRetainingCapacity();

        // Add all numbers except the one at skip_index
        for (level, 0..) |num, i| {
            if (i != skip_index) {
                temp_list.append(num) catch continue;
            }
        }

        // Check if this sequence is safe
        if (isSafe(temp_list.items)) return true;
    }

    return false;
}

pub fn run(use_dampener: bool) !void {
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

        const is_safe: bool = isSafe(levels.items);

        if (is_safe) {
            safe_count += 1;
            print("Level is safe: {any}\n", .{levels.items});
        } else {
            print("Level is not safe: {any}\n", .{levels.items});
            if (use_dampener and isSafeWithDampener(levels.items)) {
                safe_count += 1;
                print("Level is safe with dampener: {any}\n", .{levels.items});
            }
        }
    }

    print("Safe count: {d}\n", .{safe_count});
}
