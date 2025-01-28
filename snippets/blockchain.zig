const std = @import("std");
const mem = std.mem;
const ArrayList = std.ArrayList;

pub fn hash(plaintext: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var golden_coins = ArrayList(u32).init(allocator);
    const hasher = std.crypto.hash.sha2.Sha256;
    var sha256 = hasher.init(.{});
    // defer _ = hasher.deinit();

    // sha256.update(plaintext);
    // const result = sha256.finalResult();
    // const hex = std.fmt.bytesToHex(result, .upper);
    // std.debug.print("hash = {s}\n", .{hex});
    // std.debug.print("hash = {s}\n", .{hex[0..4]});
    var search = true;
    var idx: u32 = 0;
    // var buf: [100]u8 = undefined;
    // var golden_coins: [1_000]u32 = undefined;

    while (search) {
        // const numAsString = try std.fmt.bufPrint(&buf, "{}", .{idx});
        // const new_len: usize = plaintext.len + numAsString.len;
        // var fmt: [*]u8 = undefined;
        // mem.copy(u8, fmt[0..], numAsString);
        const fmt = try std.fmt.allocPrint(allocator, "{s}{d}", .{ plaintext, idx });
        sha256.update(fmt);
        const result = sha256.finalResult();
        const hex = std.fmt.bytesToHex(result, .upper);

        if (std.mem.eql(u8, hex[0..4], "0" ** 4)) {
            // search = false;
            // std.debug.print("Match found {d} {s}\n", .{ idx, hex });
            // break;
            try golden_coins.append(idx);
        }
        if (idx % 1_000_000 == 0) {
            std.debug.print("Did {d} {s} {d}\n", .{ idx, hex, golden_coins.items.len });
        }
        if (idx == 100_000_000_000) {
            search = false;
        }
        idx += 1;
    }
    std.debug.print("hash = {d}\n", .{idx});

    // return hex[0..];
}

pub fn main() !void {
    // const testing: []u8 = *[]u8{ 'T', 'e' }; //"Testing"[0..];
    try hash("Testing");

    std.debug.print("{s}", .{"Holdup"});
}

// test "sha256" {
//     var plaintext = try std.heap.page_allocator.alloc(u8, 10);
//     defer _ = std.heap.page_allocator.free(plaintext);

//     try plaintext.copySlice(0, &[_]u8{ 1, 2, 3, 4, 5 });
//     const hash = try sha256(plaintext);

//     // Print the SHA-256 hash
//     for (hash) |b| {
//         std.debug.print("{} ", .{b});
//     }
// }
