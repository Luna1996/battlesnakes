const std = @import("std");

pub fn build(b: *std.Build) void {
  const target = b.standardTargetOptions(.{});
  const optimize = b.standardOptimizeOption(.{});

  const main_mod = b.createModule(.{
    .target = target,
    .optimize = optimize,
    .root_source_file = b.path("src/main.zig"),
  });

  const http_dep = b.dependency("httpz", .{
    .target = target,
    .optimize = optimize,
  });

  main_mod.addImport("web", http_dep.module("httpz"));

  const main_exe = b.addExecutable(.{
    .name = "main",
    .root_module = main_mod
  });

  b.installArtifact(main_exe);
}