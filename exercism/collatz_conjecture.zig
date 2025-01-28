const std = @import("std");
const print = std.debug.print;
pub const ComputationError = error{IllegalArgument};

fn calculate(number: usize) anyerror!usize {
    if (number % 2 == 0) {
        return number / 2;
    } else {
        return (number * 3) + 1;
    }
}

pub fn steps(number: usize) anyerror!usize {
    var matched = false;
    var last_value: usize = number;
    var total_steps: usize = 0;
    if (number == 0) {
        return ComputationError.IllegalArgument;
    }
    if (number == 1) {
        return 0;
    }

    while (!matched) : (total_steps += 1) {
        last_value = try calculate(last_value);
        matched = last_value == 1;
        // print("Iterating {d} {d} - {d}\n", .{ number, last_value, total_steps });
    }
    std.debug.print("{d} -> Total steps is {d}\n", .{ number, total_steps });
    return total_steps;
}

const testing = std.testing;

const collatz_conjecture = @import("collatz_conjecture.zig");
// const ComputationError = collatz_conjecture.ComputationError;
test "zero steps for one" {
    const expected: usize = 0;
    const actual = try collatz_conjecture.steps(1);
    try testing.expectEqual(expected, actual);
}
test "divide if even" {
    const expected: usize = 4;
    const actual = try collatz_conjecture.steps(16);
    try testing.expectEqual(expected, actual);
}
test "even and odd steps" {
    const expected: usize = 9;
    const actual = try collatz_conjecture.steps(12);
    try testing.expectEqual(expected, actual);
}
test "large number of even and odd steps" {
    const expected: usize = 152;
    const actual = try collatz_conjecture.steps(1_000_000);
    try testing.expectEqual(expected, actual);
}
test "zero is an error" {
    const expected = ComputationError.IllegalArgument;
    const actual = collatz_conjecture.steps(0);
    try testing.expectError(expected, actual);
}

pub fn main() !void {
    _ = try steps(1);
    _ = try steps(12);
    _ = try steps(1000);
    _ = try steps(1_000_000);
}
