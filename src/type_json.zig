const std = @import("std");
const t = @import("type.zig");

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
  turn:  u32   = 0,
  board: Board = .{},
  you:   Snake = .{},

  pub fn toGrid(self: Info, allocator: std.mem.Allocator) !t.Grid {
    const grid = try allocator.alloc([]t.Item, self.board.width);
    for (grid) |*line| {
      line.* = try allocator.alloc(t.Item, self.board.height);
      for (line.*) |*item| item.* = .empty;
    }
    for (self.board.hazards) |*xy| grid[xy.x][xy.y].cell = .hazard;
    for (self.board.food)    |*xy| grid[xy.x][xy.y].what = .food;
    for (self.board.snakes)  |*snake| {
      grid[snake.head.x][snake.head.y].what = .{ .snake_head = snake.body.len};
      for (snake.body)       |*xy| grid[xy.x][xy.y].what = .snake_body;
    }
    return grid;
  }
};

pub const Move = struct {
  move:   t.Dir      = .up,
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
  foodSpawnChance:        u32 = 0,
  minimumFood:            u32 = 0,
  hazardDamagePerTurn:    u32 = 0,
  hazardMap:       []const u8 = "",
  hazardMapAuthor: []const u8 = "",
  royale: struct {
    shrinkEveryNTurns:    u32 = 0,
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
  x: i32 = 0,
  y: i32 = 0
};