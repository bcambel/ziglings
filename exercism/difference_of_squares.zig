const std = @import("std");

pub fn squareOfSum(number: usize) usize {
    // _ = number;
    var accumulator: usize = 0;

    for (0..number + 1) |i| {
        accumulator += i;
    }

    return std.math.pow(usize, accumulator, 2);
}

pub fn sumOfSquares(number: usize) usize {
    var accumulator: usize = 0;

    for (0..number + 1) |i| {
        accumulator += std.math.pow(usize, i, 2);
    }

    return accumulator;
}

pub fn differenceOfSquares(number: usize) usize {
    return squareOfSum(number) - sumOfSquares(number);
}

const testing = std.testing;
const difference_of_squares = @import("difference_of_squares.zig");
test "square of sum up to 1" {
    const expected: usize = 1;
    const actual = difference_of_squares.squareOfSum(1);
    try testing.expectEqual(expected, actual);
}
test "square of sum up to 5" {
    const expected: usize = 225;
    const actual = difference_of_squares.squareOfSum(5);
    try testing.expectEqual(expected, actual);
}
test "square of sum up to 100" {
    const expected: usize = 25_502_500;
    const actual = difference_of_squares.squareOfSum(100);
    try testing.expectEqual(expected, actual);
}
test "sum of squares up to 1" {
    const expected: usize = 1;
    const actual = difference_of_squares.sumOfSquares(1);
    try testing.expectEqual(expected, actual);
}
test "sum of squares up to 5" {
    const expected: usize = 55;
    const actual = difference_of_squares.sumOfSquares(5);
    try testing.expectEqual(expected, actual);
}
test "sum of squares up to 100" {
    const expected: usize = 338_350;
    const actual = difference_of_squares.sumOfSquares(100);
    try testing.expectEqual(expected, actual);
}
test "difference of squares up to 1" {
    const expected: usize = 0;
    const actual = difference_of_squares.differenceOfSquares(1);
    try testing.expectEqual(expected, actual);
}
test "difference of squares up to 5" {
    const expected: usize = 170;
    const actual = difference_of_squares.differenceOfSquares(5);
    try testing.expectEqual(expected, actual);
}
test "difference of squares up to 100" {
    const expected: usize = 25_164_150;
    const actual = difference_of_squares.differenceOfSquares(100);
    try testing.expectEqual(expected, actual);
}
