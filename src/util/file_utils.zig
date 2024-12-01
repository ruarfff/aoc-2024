const std = @import("std");
const print = std.debug.print;

/// Error type for file operations
pub const FileError = error{
    FileNotFound,
    ReadError,
    OutOfMemory,
};

/// Reads a file and returns its contents as an array of strings (one per line)
/// Caller owns the returned memory
pub fn readFileToLines(
    allocator: std.mem.Allocator,
    filepath: []const u8,
) ![][]u8 {
    // Open the file
    const file = try std.fs.cwd().openFile(filepath, .{});
    defer file.close();

    // Create a buffered reader
    var buf_reader = std.io.bufferedReader(file.reader());
    var reader = buf_reader.reader();

    // Create an array list to store the lines
    var lines = std.ArrayList([]u8).init(allocator);
    defer {
        // If an error, free any lines that were allocated
        if (lines.items.len > 0) {
            for (lines.items) |line| {
                allocator.free(line);
            }
        }
    }

    // Read the file line by line
    while (true) {
        const line = reader.readUntilDelimiterAlloc(allocator, '\n', 1024) catch |err| {
            if (err == error.EndOfStream) break;
            return err;
        };
        try lines.append(line);
    }

    // Return the lines array, transferring ownership to caller
    return lines.toOwnedSlice();
}

const expect = std.testing.expect;
const eql = std.mem.eql;

test "read file to lines" {
    const allocator = std.heap.page_allocator;
    const lines = try readFileToLines(allocator, "src/util/input.txt");
    defer {
        for (lines) |line| {
            allocator.free(line);
        }
    }

    for (lines, 0..) |line, index| {
        print("{d} - {s}\n", .{ index, line });
    }

    try expect(lines.len == 2);
    try std.testing.expectEqualStrings(lines[0], "just a file for testing");
    try std.testing.expectEqualStrings(lines[1], "testing 123");
}
