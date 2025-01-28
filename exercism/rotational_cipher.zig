const std = @import("std");
const mem = std.mem;

pub fn rotate(allocator: mem.Allocator, text: []const u8, shiftKey: u5) ![]u8 {
    const phrase = text;

    const buf = try allocator.alloc(u8, text.len);
    // 97-122 a-z
    // 65-90 A-Z
    var shifted: u8 = 0;
    for (phrase, 0..) |t, idx| {
        // _ = try std.fmt.bufPrint(buf, "{d}", .{t + shiftKey});
        if (t == ' ' or t > 122 or t < 65) {
            buf[idx] = t;
        } else {
            shifted = @as(u8, t) + shiftKey;

            if (t >= 97 and shifted > 122) {
                shifted = shifted - 122 + 96;
            } else {
                if (t < 90 and shifted > 90) {
                    shifted = shifted - 90 + 64;
                }
            }

            buf[idx] = shifted;
        }

        // std.debug.print("{d} -> {d}\n", .{ idx, t });
    }
    const fmt = try std.fmt.allocPrint(allocator, "{d}", .{phrase});
    std.debug.print("{d}>>>>\nORIGINAL:{s}\n {d}\n{s}\n{s}\n=====\n", .{ shiftKey, fmt, buf, text, buf });
    return buf;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    _ = try rotate(allocator, "m", 13);
    _ = try rotate(allocator, "omg", 5);
    _ = try rotate(allocator, "OMG", 5);
    _ = try rotate(allocator, "O M G", 5);
    _ = try rotate(allocator, "The quick brown fox jumps over the lazy dog.", 13);
    std.debug.print("Gur dhvpx oebja sbk whzcf bire gur ynml qbt", .{});
}

const testing = std.testing;
const rotational_cipher = @import("rotational_cipher.zig");
test "rotate a by 0, same output as input" {
    const expected: []const u8 = "a";
    const actual = try rotational_cipher.rotate(testing.allocator, "a", 0);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "rotate a by 1" {
    const expected: []const u8 = "b";
    const actual = try rotational_cipher.rotate(testing.allocator, "a", 1);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "rotate a by 26, same output as input" {
    const expected: []const u8 = "a";
    const actual = try rotational_cipher.rotate(testing.allocator, "a", 26);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "rotate m by 13" {
    const expected: []const u8 = "z";
    const actual = try rotational_cipher.rotate(testing.allocator, "m", 13);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "rotate n by 13 with wrap around alphabet" {
    const expected: []const u8 = "a";
    const actual = try rotational_cipher.rotate(testing.allocator, "n", 13);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "rotate capital letters" {
    const expected: []const u8 = "TRL";
    const actual = try rotational_cipher.rotate(testing.allocator, "OMG", 5);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "rotate spaces" {
    const expected: []const u8 = "T R L";
    const actual = try rotational_cipher.rotate(testing.allocator, "O M G", 5);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "rotate numbers" {
    const expected: []const u8 = "Xiwxmrk 1 2 3 xiwxmrk";
    const actual = try rotational_cipher.rotate(testing.allocator, "Testing 1 2 3 testing", 4);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "rotate punctuation" {
    const expected: []const u8 = "Gzo'n zvo, Bmviyhv!";
    const actual = try rotational_cipher.rotate(testing.allocator, "Let's eat, Grandma!", 21);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
test "rotate all letters" {
    const expected: []const u8 = "Gur dhvpx oebja sbk whzcf bire gur ynml qbt.";
    const actual = try rotational_cipher.rotate(testing.allocator, "The quick brown fox jumps over the lazy dog.", 13);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
