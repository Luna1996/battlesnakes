const Self = @This();

const std = @import("std");
const web = @import("web");
const log = @import("logs.zig");

pub usingnamespace log;

const PORT = 8888;
const INFO = .{
  .apiversion = "1",
  .author = "Luna1996",
  .color = "#ffd700",
  .head = "pixel",
  .tail = "pixel",
  .version = "0.1.0",
};

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
  const allocator = gpa.allocator();

  var app = init(allocator);

  var server = try web.Server(*Self).init(allocator, .{.port = PORT}, &app);
  defer server.deinit();

  var router = server.router(.{});
  router.get("/", onPing, .{});

  try server.listen();
  defer server.stop();
}

pub fn onPing(_: *Self, _: *web.Request, res: *web.Response) !void {
  res.status = 200;
  try res.json(INFO, .{});
}