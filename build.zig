const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {

    // If CPU arch is not `x86_64` or not `x86`
    if (builtin.cpu.arch != .x86_64 and builtin.cpu.arch != .x86) {
        @compileError("MinHook can be compiled only for `x86_64` and `x86` CPU arch");
    }

    // If target OS is not `Windows`
    if (builtin.os.tag != .windows) {
        @compileError("MinHook can be compiled only for Windows");
    }

    // If target ABI is not `GNU`
    if (builtin.abi != .gnu) {
        @compileError("MinHook can be compiled only for GNU ABI");
    }

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const minhook_lib = b.addStaticLibrary(.{
        .name = "minhook",
        .target = target,
        .optimize = optimize,
    });

    minhook_lib.linkLibC();
    minhook_lib.addCSourceFiles(.{
        .files = &.{
            "minhook/src/hook.c",
            "minhook/src/buffer.c",
            "minhook/src/trampoline.c",
        },
    });

    if (target.result.cpu.arch == .x86_64) {
        minhook_lib.addCSourceFile(.{ .file = b.path("minhook/src/hde/hde64.c") });
    } else {
        minhook_lib.addCSourceFile(.{ .file = b.path("minhook/src/hde/hde32.c") });
    }

    const module = b.addModule("minhook", .{
        .root_source_file = b.path("src/minhook.zig"),
        .target = target,
        .optimize = optimize,
    });
    module.addIncludePath(b.path("minhook/include"));
    module.linkLibrary(minhook_lib);
}
