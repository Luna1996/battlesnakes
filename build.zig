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

  const http_dep = b.dependency("httpz", .{
    .target = target,
    .optimize = optimize,
  });

  main_exe.root_module.addImport("web", http_dep.module("httpz"));

  b.installArtifact(main_exe);
}