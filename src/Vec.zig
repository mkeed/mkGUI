const std = @import("std");

pub fn Vec(comptime T: type) type {
    return struct {
        const Self = @This();
        x: T,
        y: T,
        pub fn add(self: Self, other: Self) Self {
            return .{
                .x = self.x + other.x,
                .y = self.y + other.y,
            };
        }
        pub fn sub(self: Self, other: Self) Self {
            return .{
                .x = self.x - other.x,
                .y = self.y - other.y,
            };
        }
        pub fn multiply(self: Self, val: T) Self {
            return .{
                .x = self.x * val,
                .y = self.y * val,
            };
        }
        pub fn divide(self: Self, val: T) Self {
            return .{
                .x = self.x / val,
                .y = self.y / val,
            };
        }
    };
}

test {
    const a = Vec(usize){ .x = 10, .y = 10 };
    const b = Vec(usize){ .x = 10, .y = 20 };
    try std.testing.expectEqual(Vec(usize){ .x = 20, .y = 30 }, a.add(b));
    try std.testing.expectEqual(Vec(usize){ .x = 0, .y = 10 }, b.sub(a));
}

pub fn Rect(comptime T: type) type {
    return struct {
        pos: Vec(usize),
        size: Vec(usize),
    };
}
