const std = @import("std");
const t   = @import("type.zig");

pub fn onMove(_: std.mem.Allocator, _: t.Info) !t.Move {
  return .{.move = .right};
}