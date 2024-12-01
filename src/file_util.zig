const std = @import("std");

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
        // If we encounter an error, free any lines we've allocated
        if (lines.items.len > 0) {
            for (lines.items) |line| {
                allocator.free(line);
            }
        }
    }

    // Read the file line by line
    while (true) {
        var line = reader.readUntilDelimiterAlloc(allocator, '\n', 1024) catch |err| {
            if (err == error.EndOfStream) break;
            return err;
        };
        try lines.append(line);
    }

    // Return the lines array, transferring ownership to caller
    return lines.toOwnedSlice();
}

/// Reads a file and returns its contents as a matrix of characters
/// Caller owns the returned memory
pub fn readFileToMatrix(
    allocator: std.mem.Allocator,
    filepath: []const u8,
) ![][]u8 {
    // First read the file into lines
    const lines = try readFileToLines(allocator, filepath);
    defer {
        for (lines) |line| {
            allocator.free(line);
        }
        allocator.free(lines);
    }

    // Create the matrix with the same number of rows
    var matrix = try allocator.alloc([]u8, lines.len);
    errdefer {
        for (matrix) |row| {
            allocator.free(row);
        }
        allocator.free(matrix);
    }

    // Find the maximum line length
    var max_len: usize = 0;
    for (lines) |line| {
        max_len = @max(max_len, line.len);
    }

    // Create each row of the matrix
    for (lines, 0..) |line, i| {
        var row = try allocator.alloc(u8, max_len);
        @memcpy(row[0..line.len], line);
        // Pad the rest with spaces if needed
        if (line.len < max_len) {
            @memset(row[line.len..], ' ');
        }
        matrix[i] = row;
    }

    return matrix;
}
