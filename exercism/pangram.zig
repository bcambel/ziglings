const std = @import("std");

// 97-122 a-z
// 65-90 A-Z

pub fn isPangram(str: []const u8) bool {
    var buf: [26]bool = [_]bool{false} ** 26;

    for (str) |c| {
        if (c >= 97 and c <= 122) {
            buf[c - 97] = true;
        } else {
            if (c >= 65 and c <= 90) {
                buf[c - 65] = true;
            }
        }
    }
    var acc: i8 = 0;
    for (buf) |b| {
        acc += if (b) 1 else 0;
    }
    std.debug.print("{d} - {s}\n", .{ acc, str });
    return acc == 26;
}

pub fn main() !void {
    _ = isPangram("the quick brown fox jumps over the lazy dog");
    _ = isPangram("!he quick brown fox jumps over the lazy dog");
    _ = isPangram("txe xuick brown fox jumps over the lazy dog");
    _ = isPangram("\"txe xuick brown fox jumps over the lazy dog");
    _ = isPangram(" ABCDEFGHIJKLM");
}

const testing = std.testing;
const pangram = @import("pangram.zig");
test "empty sentence" {
    try testing.expect(!pangram.isPangram(""));
}
test "perfect lower case" {
    try testing.expect(pangram.isPangram("abcdefghijklmnopqrstuvwxyz"));
}
test "only lower case" {
    try testing.expect(pangram.isPangram("the quick brown fox jumps over the lazy dog"));
}
test "missing the letter 'x'" {
    try testing.expect(!pangram.isPangram("a quick movement of the enemy will jeopardize five gunboats"));
}
test "missing the letter 'h'" {
    try testing.expect(!pangram.isPangram("five boxing wizards jump quickly at it"));
}
test "with underscores" {
    try testing.expect(pangram.isPangram("the_quick_brown_fox_jumps_over_the_lazy_dog"));
}
test "with numbers" {
    try testing.expect(pangram.isPangram("the 1 quick brown fox jumps over the 2 lazy dogs"));
}
test "missing letters replaced by numbers" {
    try testing.expect(!pangram.isPangram("7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog"));
}
test "mixed case and punctuation" {
    try testing.expect(pangram.isPangram("\"Five quacking Zephyrs jolt my wax bed.\""));
}
test "a-m and A-M are 26 different characters but not a pangram" {
    try testing.expect(!pangram.isPangram("abcdefghijklm ABCDEFGHIJKLM"));
}
test "non-alphanumeric printable ASCII" {
    try testing.expect(!pangram.isPangram(" !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"));
}
