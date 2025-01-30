const std = @import("std");
const mem = std.mem;

fn val(s: []const u8) u32 {
    var acc: u32 = 0;
    for (s) |c| {
        acc += c;
    }
    return acc;
}
// 97-122 a-z
// 65-90 A-Z
fn compareArrays(arr1: []u8, arr2: []u8) !bool {
    var i: usize = 0;
    var j: usize = 0;
    var found: bool = false;
    while (i < arr1.len) : (i += 1) {
        j = 0;
        found = false;
        while (j < arr2.len) : (j += 1) {
            if ((arr1[i] == arr2[j])) {
                found = true;
                break;
            }
        }
        if (!found) {
            return false;
        }
    }
    return true;
}

pub fn detectAnagrams(allocator: mem.Allocator, word: []const u8, candidates: []const []const u8) !std.BufSet {
    // _ = allocator;
    var new_word: []u8 = try allocator.alloc(u8, word.len);

    for (word, 0..) |c, i| {
        new_word[i] = std.ascii.toUpper(c);
    }

    // _ = candidates;
    // var my_hash_map = std.StringHashMap(u8).init(allocator);

    var matches = std.BufSet.init(allocator);
    const magic_val = val(new_word);
    var isMatch: bool = false;

    for (candidates) |candid| {
        if (candid.len > word.len) {
            continue;
        } else {
            var check_words: []u8 = try allocator.alloc(u8, candid.len);

            for (candid, 0..) |c, i| {
                check_words[i] = std.ascii.toUpper(c);
            }
            const curr_val = val(check_words);
            isMatch = magic_val == curr_val and !std.mem.eql(u8, new_word, check_words);
            std.debug.print("Comparing {s} {d} {d} vs {d} \n", .{ word, @intFromBool(isMatch), magic_val, curr_val });

            if (isMatch and try compareArrays(new_word[0..], check_words[0..])) {
                try matches.insert(candid);
            }
            defer allocator.free(check_words);
        }
    }
    defer allocator.free(new_word);

    return matches;
}
pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const candidates = [_][]const u8{ "hello", "world", "zombies", "pants" };
    _ = try detectAnagrams(allocator, "diaper", &candidates);

    const candidates2 = [_][]const u8{ "lemons", "cherry", "melons" };
    _ = try detectAnagrams(allocator, "solemn", &candidates2);

    // defer allocator.
}
const testing = std.testing;
// const detectAnagrams = @import("anagram.zig").detectAnagrams;
fn testAnagrams(
    expected: []const []const u8,
    word: []const u8,
    candidates: []const []const u8,
) !void {
    var actual = try detectAnagrams(testing.allocator, word, candidates);
    defer actual.deinit();
    try testing.expectEqual(expected.len, actual.count());
    for (expected) |e| {
        try testing.expect(actual.contains(e));
    }
}
test "no matches" {
    const expected = [_][]const u8{};
    const word = "diaper";
    const candidates = [_][]const u8{ "hello", "world", "zombies", "pants" };
    try testAnagrams(&expected, word, &candidates);
}
test "detects two anagrams" {
    const expected = [_][]const u8{ "lemons", "melons" };
    const word = "solemn";
    const candidates = [_][]const u8{ "lemons", "cherry", "melons" };
    try testAnagrams(&expected, word, &candidates);
}
test "does not detect anagram subsets" {
    const expected = [_][]const u8{};
    const word = "good";
    const candidates = [_][]const u8{ "dog", "goody" };
    try testAnagrams(&expected, word, &candidates);
}
test "detects anagram" {
    const expected = [_][]const u8{"inlets"};
    const word = "listen";
    const candidates = [_][]const u8{ "enlists", "google", "inlets", "banana" };
    try testAnagrams(&expected, word, &candidates);
}
test "detects three anagrams" {
    const expected = [_][]const u8{ "gallery", "regally", "largely" };
    const word = "allergy";
    const candidates = [_][]const u8{ "gallery", "ballerina", "regally", "clergy", "largely", "leading" };
    try testAnagrams(&expected, word, &candidates);
}
test "detects multiple anagrams with different case" {
    const expected = [_][]const u8{ "Eons", "ONES" };
    const word = "nose";
    const candidates = [_][]const u8{ "Eons", "ONES" };
    try testAnagrams(&expected, word, &candidates);
}
test "does not detect non-anagrams with identical checksum" {
    const expected = [_][]const u8{};
    const word = "mass";
    const candidates = [_][]const u8{"last"};
    try testAnagrams(&expected, word, &candidates);
}
test "detects anagrams case-insensitively" {
    const expected = [_][]const u8{"Carthorse"};
    const word = "Orchestra";
    const candidates = [_][]const u8{ "cashregister", "Carthorse", "radishes" };
    try testAnagrams(&expected, word, &candidates);
}
test "detects anagrams using case-insensitive subject" {
    const expected = [_][]const u8{"carthorse"};
    const word = "Orchestra";
    const candidates = [_][]const u8{ "cashregister", "carthorse", "radishes" };
    try testAnagrams(&expected, word, &candidates);
}
test "detects anagrams using case-insensitive possible matches" {
    const expected = [_][]const u8{"Carthorse"};
    const word = "orchestra";
    const candidates = [_][]const u8{ "cashregister", "Carthorse", "radishes" };
    try testAnagrams(&expected, word, &candidates);
}
test "does not detect an anagram if the original word is repeated" {
    const expected = [_][]const u8{};
    const word = "go";
    const candidates = [_][]const u8{"goGoGO"};
    try testAnagrams(&expected, word, &candidates);
}
test "anagrams must use all letters exactly once" {
    const expected = [_][]const u8{};
    const word = "tapper";
    const candidates = [_][]const u8{"patter"};
    try testAnagrams(&expected, word, &candidates);
}
test "words are not anagrams of themselves" {
    const expected = [_][]const u8{};
    const word = "BANANA";
    const candidates = [_][]const u8{"BANANA"};
    try testAnagrams(&expected, word, &candidates);
}
test "words are not anagrams of themselves even if letter case is partially different" {
    const expected = [_][]const u8{};
    const word = "BANANA";
    const candidates = [_][]const u8{"Banana"};
    try testAnagrams(&expected, word, &candidates);
}
test "words are not anagrams of themselves even if letter case is completely different" {
    const expected = [_][]const u8{};
    const word = "BANANA";
    const candidates = [_][]const u8{"banana"};
    try testAnagrams(&expected, word, &candidates);
}
test "words other than themselves can be anagrams" {
    const expected = [_][]const u8{"Silent"};
    const word = "LISTEN";
    const candidates = [_][]const u8{ "LISTEN", "Silent" };
    try testAnagrams(&expected, word, &candidates);
}
