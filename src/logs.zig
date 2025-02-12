const std = @import("std");

pub const std_options = std.Options {
  .logFn = log,
};

pub const d = std.log.debug;
pub const i = std.log.info;
pub const w = std.log.warn;
pub const e = std.log.err;

fn log(
  comptime lvl: std.log.Level,
  comptime src: @Type(.enum_literal),
  comptime fmt: []const u8,
  arg: anytype,
) void {
  const lvl_txt = switch (lvl) {
    .err   => "\x1b[38;2;230;78;77m"   ++ "[E]",
    .warn  => "\x1b[38;2;200;167;0m"   ++ "[W]",
    .info  => "\x1b[38;2;78;148;255m"  ++ "[I]",
    .debug => "\x1b[38;2;117;117;117m" ++ "[D]",
  };
  const src_txt = if (src == .default) " " else " (" ++ @tagName(src) ++ ") ";
  const stdout = std.io.getStdOut().writer();
  var bw = std.io.bufferedWriter(stdout);
  const writer = bw.writer();

  std.Progress.lockStdErr();
  defer std.Progress.unlockStdErr();

  nosuspend {
      writer.print(lvl_txt ++ src_txt ++ fmt ++ "\n\x1b[0m", arg) catch return;
      bw.flush() catch return;
  }
}

pub fn logErrorTrace() void {
  const trace: ?*std.builtin.StackTrace = @errorReturnTrace();
  if (trace == null) return;
  nosuspend {
    if (comptime std.builtin.target.isWasm()) {
      if (std.debug.native_os == .wasi) {
        std.log.err("Unable to dump stack trace: not implemented for Wasm", .{});
      }
      return;
    }
    if (std.builtin.strip_debug_info) {
      std.log.err("Unable to dump stack trace: debug info stripped", .{});
      return;
    }
    const debug_info = std.debug.getSelfDebugInfo() catch |err| {
      std.log.err("Unable to dump stack trace: Unable to open debug info: {s}\n", .{@errorName(err)});
      return;
    };
    std.debug.writeStackTrace(trace.?, std.io.getStdOut().writer(), debug_info, std.io.tty.detectConfig(std.io.getStdOut())) catch |err| {
      std.log.err("Unable to dump stack trace: {s}\n", .{@errorName(err)});
      return;
    };
  }
}