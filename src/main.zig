const std = @import("std");

pub usingnamespace @import("logs.zig");

pub fn main() !void {
  std.log.info("Battle Snakes\n", .{});
}