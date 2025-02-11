const std = @import("std");
const zap = @import("zap");

pub usingnamespace @import("logs.zig");

pub fn main() !void {
  var server = zap.HttpListener.init(.{
    .port = 8888,
    .on_request = onRequest,
  });
  try server.listen();

  zap.start(.{.threads = 1, .workers = 1});
}

fn onRequest(req: zap.Request) void {
  req.setContentType(.HTML) catch |e| std.log.err("{}\n", .{e});
  req.sendBody("<html><body><h1>Battle Snakes</h1></body></html>") catch |e| std.log.err("{}\n", .{e});
}