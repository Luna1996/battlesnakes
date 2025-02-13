const std = @import("std");
const j = @import("type_json.zig");

pub const Pos = @Vector(2, i32);

pub const Dir = enum {
  up, right, down, left,

  pub fn diff(dir: Dir) Pos {
    return switch (dir) {
      .up    => .{ 0,  1},
      .right => .{ 1,  0},
      .down  => .{ 0, -1},
      .left  => .{-1,  0},
    };
  }
};

pub const Map = enum {
  standard, royale, constrictor, snail_mode,
};

pub const Mind = enum {
  basic,

  pub fn onMove(mind: Mind, allocator: std.mem.Allocator, info: j.Info) !j.Move {
    return switch (mind) {
      .basic => try @import("mind_basic.zig").onMove(allocator, info),
    };
  }
};

pub const Item = struct {
  cell: union(enum) { empty, hazard },
  what: union(enum) { empty, food, snake_body, snake_head: u16 },

  pub const empty: Item = .{.cell = .empty, .what = .empty};
};

pub const Grid = [][]Item;

pub const DMap = [][]u32;