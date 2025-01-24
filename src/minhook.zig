const std = @import("std");
const minhook = @cImport(@cInclude("MinHook.h"));

// MH_ALL constant
pub const ALL = null;

// MinHook errors enum
inline fn getMinhookError(error_code: i32) ?anyerror {
    return switch (error_code) {
        0 => null,
        1 => error.MH_ERROR_ALREADY_INITIALIZED,
        2 => error.MH_ERROR_NOT_INITIALIZED,
        3 => error.MH_ERROR_ALREADY_CREATED,
        4 => error.MH_ERROR_NOT_CREATED,
        5 => error.MH_ERROR_ENABLED,
        6 => error.MH_ERROR_DISABLED,
        7 => error.MH_ERROR_NOT_EXECUTABLE,
        8 => error.MH_ERROR_UNSUPPORTED_FUNCTION,
        9 => error.MH_ERROR_MEMORY_ALLOC,
        10 => error.MH_ERROR_MEMORY_PROTECT,
        11 => error.MH_ERROR_MODULE_NOT_FOUND,
        12 => error.MH_ERROR_FUNCTION_NOT_FOUND,
        else => error.MH_UNKNOWN,
    };
}

/// Initialize the MinHook library. You must call this function EXACTLY ONCE
/// at the beginning of your program.
pub fn initialize() !void {
    if (getMinhookError(minhook.MH_Initialize())) |err| {
        return err;
    }
}

/// Uninitialize the MinHook library. You must call this function EXACTLY
/// ONCE at the end of your program.
pub fn uninitialize() !void {
    if (getMinhookError(minhook.MH_Initialize())) |err| {
        return err;
    }
}

/// Creates a hook for the specified target function, in disabled state.
pub fn createHook(target: *const anyopaque, detour: *const anyopaque, original: ?*?*anyopaque) !void {
    if (getMinhookError(minhook.MH_CreateHook(@constCast(target), @constCast(detour), original))) |err| {
        return err;
    }
}

// Removes an already created hook.
pub fn removeHook(target: ?*const anyopaque) !void {
    if (getMinhookError(minhook.MH_RemoveHook(@constCast(target)))) |err| {
        return err;
    }
}

/// Enables an already created hook.
pub fn enableHook(target: ?*const anyopaque) !void {
    if (getMinhookError(minhook.MH_EnableHook(@constCast(target)))) |err| {
        return err;
    }
}

/// Disables an already created hook.
pub fn disableHook(target: ?*const anyopaque) !void {
    if (getMinhookError(minhook.MH_DisableHook(@constCasttarget)))) |err| {
        return err;
    }
}
