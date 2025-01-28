const std = @import("std");

pub fn eggCount(number: usize) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // _ = number;
    // @compileError("please implement the eggCount function");
    const fmt = try std.fmt.allocPrint(allocator, "{b}", .{number});
    std.debug.print("{s:10}\n", .{fmt});
    std.debug.print("{b:>10}\n", .{number});

    var counter: usize = 0;
    for (fmt) |f| {
        if (f == '1') {
            counter += 1;
        }
    }

    return counter;
}

const testing = std.testing;
const eliuds_eggs = @import("eliuds_eggs.zig");
test "0 eggs" {
    const expected: usize = 0;
    const actual = eliuds_eggs.eggCount(0);
    try testing.expectEqual(expected, actual);
}
test "1 egg" {
    const expected: usize = 1;
    const actual = eliuds_eggs.eggCount(16);
    try testing.expectEqual(expected, actual);
}
test "4 eggs" {
    const expected: usize = 4;
    const actual = eliuds_eggs.eggCount(89);
    try testing.expectEqual(expected, actual);
}
test "13 eggs" {
    const expected: usize = 13;
    const actual = eliuds_eggs.eggCount(2000000000);
    try testing.expectEqual(expected, actual);
}
pub fn main() !void {
    _ = try eggCount(100);
}
