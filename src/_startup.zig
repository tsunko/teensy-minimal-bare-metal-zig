const chip = @import("imxrt1062.zig");
const reg = chip.registers;
const main = @import("main.zig").main;

extern var _flexram_bank_config: u32;
extern var _estack: u32;

extern var _stext: u32;
extern var _stextload: u32;
extern var _etext: u32;

extern var _sdata: u32;
extern var _sdataload: u32;
extern var _edata: u32;

extern var _sbss: u32;
extern var _ebss: u32;

pub export fn startup() linksection(".startup") callconv(.Naked) void {
    reg.IOMUXC_GPR.GPR17.raw = @intCast(u32, @ptrToInt(&_flexram_bank_config));
    reg.IOMUXC_GPR.GPR16.raw = 0x00000007;
    reg.IOMUXC_GPR.GPR14.raw = 0x00AA0000;
    asm volatile (
        "mov sp, %[arg1]" 
        : // no output
        : [arg1] "{r0}" (@ptrToInt(&_estack)) 
        : // no clobbers
    );

    _startup_memcpy(&_stext, &_stextload, &_etext);
    _startup_memcpy(&_sdata, &_sdataload, &_edata);
    _startup_memclr(&_sbss, &_ebss);

    // call our main function
    main();
}

fn _startup_memcpy(dst: *u32, src: *u32, dstEnd: *u32) linksection(".startup") void {
    if(dst == src) return;

    var len = @ptrToInt(dstEnd) - @ptrToInt(dst);
    var srcMany = @ptrCast([*]u32, src);
    var dstSlice = @ptrCast([*]u32, dst)[0..len];
    for(dstSlice) |*data, i|{
        data.* = srcMany[i];
    }
}

fn _startup_memclr(dst: *u32, dstEnd: *u32) linksection(".startup") void {
    for(@ptrCast([*]u32, dst)[0 .. (@ptrToInt(dstEnd) - @ptrToInt(dst))]) |*data| {
        data.* = 0;
    }
}