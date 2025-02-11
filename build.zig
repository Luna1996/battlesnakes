const std = @import("std");

pub fn build(b: *std.Build) void {
  const target = b.standardTargetOptions(.{});
  const optimize = b.standardOptimizeOption(.{});

  const main_exe = b.addExecutable(.{
    .name = "main",
    .target = target,
    .optimize = optimize,
    .root_source_file = b.path("src/main.zig"),
  });

  const zap_dep = b.dependency("zap", .{
    .target = target,
    .optimize = optimize,
  });

  main_exe.root_module.addImport("zap", zap_dep.module("zap"));

  b.installArtifact(main_exe);
}