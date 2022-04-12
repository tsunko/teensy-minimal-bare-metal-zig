const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const teensyTarget = std.zig.CrossTarget{
        .cpu_arch = .thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m7 },
        .os_tag = .freestanding,
    };

    const entry = b.addExecutable("teensy-zig-minimal", "src/_startup.zig");
    entry.setTarget(teensyTarget);
    entry.setLinkerScriptPath(std.build.FileSource { .path = "src/linker.ld" });
    entry.setBuildMode(.ReleaseSmall);
    entry.install();

    b.default_step.dependOn(&entry.step);
}
