const std = @import("std");

pub const std_options = std.Options {
  .logFn = log,
};

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

  nosuspend {
      writer.print(lvl_txt ++ src_txt ++ fmt ++ "\n\x1b[0m", arg) catch return;
      bw.flush() catch return;
  }
}