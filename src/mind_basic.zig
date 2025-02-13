const std = @import("std");
const j   = @import("type_json.zig");

pub fn onMove(_: std.mem.Allocator, info: j.Info) !j.Move {
  return .{.move = @enumFromInt(info.turn % 4)};
}