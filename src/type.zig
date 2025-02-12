const std = @import("std");

pub const Ping = struct {
  apiversion: []const u8 = "1",
  author:    ?[]const u8 = null,
  color:     ?[]const u8 = null,
  head:      ?[]const u8 = null,
  tail:      ?[]const u8 = null,
  version:   ?[]const u8 = null,
};

pub const Info = struct {
  game:  Game  = .{},
  turn:  i32   = 0,
  board: Board = .{},
  you:   Snake = .{},
};

pub const Move = struct {
  move:   Dir        = .up,
  shout: ?[]const u8 = null,
};

pub const Game = struct {
  id:      []const u8 = "",
  ruleset: RuleSet    = .{},
  map:     []const u8 = "",
  timeout: i32        = 0,
  source:  []const u8 = "",
};

pub const RuleSet = struct {
  name:     []const u8 = "",
  version:  []const u8 = "",
  settings: Settings   = .{},
};

pub const Settings = struct {
  foodSpawnChance:        i32 = 0,
  minimumFood:            i32 = 0,
  hazardDamagePerTurn:    i32 = 0,
  hazardMap:       []const u8 = "",
  hazardMapAuthor: []const u8 = "",
  royale: struct {
    shrinkEveryNTurns:    i32 = 0,
  } = .{},
  squad: struct {
    allowBodyCollisions: bool = false,
    sharedElimination:   bool = false,
    sharedHealth:        bool = false,
    sharedLength:        bool = false,
  } = .{},
};

pub const Snake = struct {
  id:      []const u8 = "",
  name:    []const u8 = "",
  health:  i32        = 0,
  body:    []const XY = &.{},
  latency: []const u8 = "",
  head:    XY         = .{},
  length:  i32        = 0,
  shout:   []const u8 = "",
  squad:   []const u8 = "",
  customizations: struct {
    color: []const u8 = "",
    head:  []const u8 = "",
    tail:  []const u8 = "",
  } = .{},
};

pub const Board = struct {
  height:  i32           = 0,
  width:   i32           = 0,
  food:    []const XY    = &.{},
  hazards: []const XY    = &.{},
  snakes:  []const Snake = &.{}
};

pub const XY = struct {
  x: i32 = 0, y: i32 = 0,

  pub fn pos(self: XY) Pos {
    return .{self.x, self.y};
  }
};

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

  pub fn onMove(mind: Mind, allocator: std.mem.Allocator, info: Info) !Move {
    return switch (mind) {
      .basic => try @import("mind_basic.zig").onMove(allocator, info),
    };
  }
};