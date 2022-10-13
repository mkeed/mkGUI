const std = @import("std");
const mkgui = @import("mkGUI.zig");

const Pixel = struct {
    codePoint: u32,
    face: mkgui.FaceID,
};

pub fn draw(out: anytype, widget: mkGUI.Widget, alloc: std.mem.Allocator, dimensions: mkgui.Rect) !void {
    var pixels = try alloc.alloc(Pixel, dimensions.x * dimensions.y);
    for (pixels) |*v| v.* = Pixel{ .codePoint = ' ', .face = 0 };
    switch (widget) {
        .split => |s| {},
    }
    //Clear Screen, Go Home, Turn off Cursor
    try std.fmt.format(out, "{s}{s}{s}", .{ clearScreen, goHome, cursor[0] });
    defer try std.fmt.format(out, "{s}", .{cursor[1]});
}

pub fn flow(rect: mkgui.Rect, split: mkgui.SPLIT, alloc: std.mem.Allocator) !std.ArrayList(Position) {
    var xSizes = try alloc.alloc(usize, split.horizontal.items.len);
    defer alloc.free(xSizes);
    var ySizes = try alloc.alloc(usize, split.vertical.items.len);
    defer alloc.free(ySizes);

    mkgui.computeSizes(rect.size.x, split.horizontal.items, xSizes);
    mkgui.computeSizes(rect.size.y, split.vertical.items, ySizes);
    var list = std.ArrayList(mkgui.Rect).init(alloc);
    errdefer list.deinit();
    var yOffset: usize = 0;
    var idx: usize = 0;
    for (ySizes) |yval| {
        var xOffset: usize = 0;
        for (xSizes) |xval| {
            try list.append(.{
                .pos = .{ .x = xOffset, .y = yOffset },
                .size = .{ .x = xval, .y = yval },
            });
            idx += 1;
            xOffset += xval;
        }
        yOffset += yval;
    }
}

const clearScren = "\x1b[2J";
const goHome = "\x1b[H";
const cursor = [2][]const u8{ "\x1b[?25l", "\x1b[?25h" };
