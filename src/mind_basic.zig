const std = @import("std");
const t   = @import("type.zig");

pub fn onMove(_: std.mem.Allocator, info: t.Info) !t.Move {
  return .{.move = @enumFromInt(info.turn % 4)};
}