const std = @import("std");

fn count(word: []const u8) [26]u8 {
    var counts = [_]u8{0} ** 26;
    for (word) |c| counts[std.ascii.toLower(c) - 'a'] += 1;
    return counts;
}
pub fn detectAnagrams(all: std.mem.Allocator, word: []const u8, cans: []const []const u8) !std.BufSet {
    var buffer = std.BufSet.init(all);
    errdefer buffer.deinit();
    const word_counts = count(word);
    for (cans) |can| {
        if (std.ascii.eqlIgnoreCase(word, can)) continue;
        if (std.mem.eql(u8, &word_counts, &count(can))) try buffer.insert(can);
    } else return buffer;
}
