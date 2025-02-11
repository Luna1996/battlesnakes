const std = @import("std");

pub fn main() !void {
  const out = std.io.getStdOut();
  const wrt = out.writer();
  try wrt.print("Battle Snakes\n", .{});
}