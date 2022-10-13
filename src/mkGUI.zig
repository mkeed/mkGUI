const std = @import("std");
const vec = @import("Vec.std");
pub const mkGUI = struct {};

pub const Weight = usize;
pub const WidgetId = usize;
pub const ColourId = usize;
pub const FaceId = usize;
pub const Rect = vec.Rect(usize);
pub const DisplayArea = struct {
    width: Weight,
    height: Weight,
};

pub const Widget = union(enum) {
    split: Split,
};

pub const Split = struct {
    alloc: std.mem.Allocator,
    vertical: std.ArrayList(Weight),
    horizontal: std.ArrayList(Weight),
    items: std.ArrayList(?WidgetId),
    pub fn init(alloc: std.mem.Allocator, vertical: []const Weight, horizontal: []const Weight) !Split {
        var vert = std.ArrayList(Weight).init(alloc);
        errdefer vert.deinit();
        var horiz = std.ArrayList(Weight).init(alloc);
        errdefer horiz.deinit();

        try vert.appendSlice(vertical);
        var items = std.ArrayList(?WidgetId).init(alloc);
        try items.appendNTimes(null, vertical.len * horizontal.len);
        return TableSplit{
            .alloc = alloc,
            .vertical = vert,
            .horizontal = horiz,
            .items = items,
        };
    }
    pub fn denint(self: Split) void {
        self.vertical.deinit();
        self.horizontal.deinit();
        self.items.deinit();
    }
};

pub fn computeSizes(size: usize, weights: []const Weight, sizes: []usize) void {
    std.debug.assert(sizes.len >= weights.len);
    var totalWeight: usize = 0;
    for (weights) |v| totalWeight += v;
    var alloced: usize = size;
    for (weights) |v, idx| {
        const res = (v * size) / totalWeight;
        sizes[idx] = res;
        alloced -= res;
    }
    if (alloced != 0) {
        //add extra pixels to the fist fields
        std.debug.assert(alloced < weights.len);
        for (sizes[0..alloced]) |*v| v.* += 1;
    }
}

const WeightTest = struct {
    pub const WeightTestComp = struct {
        size: usize,
        expected: []const usize,
    };
    weights: []const Weight,
    tests: []const WeightTestComp,
};

const weighttests = [_]WeightTest{
    .{
        .weights = &.{ 30, 40, 30 },
        .tests = &.{
            .{ .size = 100, .expected = &.{ 30, 40, 30 } },
            .{ .size = 90, .expected = &.{ 27, 36, 27 } },
            .{ .size = 95, .expected = &.{ 29, 38, 28 } }, // extra pixels are added to the first members
        },
    },
};

test "computewieghts" {
    var results: [100]usize = undefined;
    for (weighttests) |wc| {
        for (wc.tests) |wct| {
            computeSizes(wct.size, wc.weights, &results);
            try std.testing.expectEqualSlices(usize, wct.expected, results[0..wc.weights.len]);
        }
    }
}
