const std = @import("std");

pub fn build(b: *std.Build) void {
  b.installArtifact(b.addExecutable(.{
    .name = "main",
    .target = b.standardTargetOptions(.{}),
    .optimize = b.standardOptimizeOption(.{}),
    .root_source_file = b.path("src/main.zig"),
  }));
}