const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const file_util = @import("../util/file_utils.zig");

pub fn run() !void {
    const allocator = std.heap.page_allocator;

    const lines = try file_util.readFileToLines(allocator, "src/day3/input.txt");
    defer {
        for (lines) |line| {
            allocator.free(line);
        }
    }
    const mul_word = "mul";

    var result: i32 = 0;
    var enabled = true;

    for (lines) |line| {
        var iter = std.mem.split(u8, line, mul_word);
        while (iter.next()) |part| {
            var is_valid = true;
            if (part.len < 5 or part[0] != '(') {
                print("{s} is invalid\n", .{part});
                is_valid = false;
            }

            if (is_valid) {
                if (std.mem.indexOfScalarPos(u8, part, 0, ')')) |i| {
                    // We can only use this if it's two numbers separated by a comma
                    // Each number must have 1 to 3 digits
                    const bracket_content = part[1..i];
                    var bracket_iter = std.mem.split(u8, bracket_content, ",");
                    var nums = std.ArrayList(i32).init(allocator);
                    defer nums.deinit();

                    while (bracket_iter.next()) |num_str| {
                        if (num_str.len < 1 or num_str.len > 3) {
                            print("{s} is invalid\n", .{part});
                            break;
                        }
                        const num = try std.fmt.parseInt(i32, num_str, 10);
                        try nums.append(num);
                    }

                    if (nums.items.len == 2) {
                        print("{d} {d}\n", .{ nums.items[0], nums.items[1] });
                        if (enabled) {
                            print("enabled\n", .{});
                            result += nums.items[0] * nums.items[1];
                        } else {
                            print("disabled\n", .{});
                        }
                    } else {
                        print("{s} is invalid\n", .{part});
                    }
                }
            }
            const do_index = std.mem.lastIndexOf(u8, part, "do()");
            const dont_index = std.mem.lastIndexOf(u8, part, "don't()");
            if (do_index) |f| {
                print("maybe enabling {s}\n", .{part});
                if (dont_index) |s| {
                    // Both found, compare indices
                    enabled = f > s;
                } else {
                    enabled = true;
                }
            } else if (dont_index != null) {
                print("disabling {s}\n", .{part});
                enabled = false;
            } else {
                print("no action {s}\n", .{part});
            }
        }
    }
    print("Result: {d}\n", .{result});
}
