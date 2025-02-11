const Self = @This();

const std = @import("std");
const web = @import("web");
const log = @import("logs.zig");

pub usingnamespace log;

allocator: std.mem.Allocator,

pub fn init(allocator: std.mem.Allocator) Self {
  return .{
    .allocator = allocator,
  };
}

pub fn main() !void {
  var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
  defer _ = gpa.deinit();
  defer _ = gpa.detectLeaks();
  // const allocator = gpa.allocator();

  // var app = init(allocator);

  // var server = try
}