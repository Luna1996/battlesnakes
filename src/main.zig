const std = @import("std");
const web = @import("web");
const log = @import("logs.zig");
const t = @import("type.zig");

pub usingnamespace log;

const PORT = 8888;
const INFO = t.Ping {
  .author  = "Luna1996",
  .color   = "#00CC00",
  .head    = "pixel",
  .tail    = "pixel",
  .version = "0.1.0",
};

pub fn main() !void {
  var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
  defer _ = gpa.deinit();
  defer _ = gpa.detectLeaks();

  const allocator = gpa.allocator();

  var server = try web.Server(void).init(allocator, .{.port = PORT}, {});
  defer server.deinit();

  var router = server.router(.{});
  inline for (std.enums.values(t.Mind)) |mind| {
    var sub_router = router.group("/" ++ @tagName(mind), .{.data = &mind});
    try sub_router.tryGet ("/",      onPing,  .{});
    try sub_router.tryPost("/move",  onMove,  .{});
  }

  try server.listen();
  defer server.stop();

  log.i("http://localhost:{}", .{PORT});
}

pub fn onPing(req: *web.Request, res: *web.Response) !void {
  const mind = try getMind(req);
  try res.json(INFO, .{.emit_null_optional_fields = false});
  res.status = 200;
  log.d("[{s}] ping", .{@tagName(mind)});
}

pub fn onMove(req: *web.Request, res: *web.Response) !void {
  const mind = try getMind(req);
  const info = (try req.json(t.Info)) orelse return error.NoInfo;
  const move = try mind.onMove(req.arena, info);
  try res.json(move, .{.emit_null_optional_fields = false});
  res.status = 200;
  log.d("[{s}] [{s}] move {s}", .{@tagName(mind), info.game.id, @tagName(move.move)});
}

inline fn getMind(req: *web.Request) !t.Mind {
  return if (req.route_data) |ptr| @as(*const t.Mind, @ptrCast(ptr)).* else error.NoMind;
}