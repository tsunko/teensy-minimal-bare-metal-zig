const chip = @import("imxrt1062.zig");
const reg = chip.registers;

pub export fn main() void {
    // configure B0_03 (PIN #13) for output
    reg.IOMUXC.SW_MUX_CTL_PAD_GPIO_B0_03.raw = 5;
    reg.IOMUXC.SW_PAD_CTL_PAD_GPIO_B0_03.raw = (7 & 0x07) << 3;
    reg.IOMUXC_GPR.GPR27.raw = 0xFFFFFFFF;
    reg.GPIO7.GDIR.* |= (1 << 3);

    while(true){
        var i: u32 = 0;
        
        reg.GPIO7.DR_CLEAR.* = (1 << 3);
        while(i < 20000000) : (i += 1) {
            asm volatile ("" : : [val] "rm" (i) : "memory");
        }

        i = 0;

        reg.GPIO7.DR_SET.* = (1 << 3);
        while(i < 20000000) : (i += 1) {
            asm volatile ("" : : [val] "rm" (i) : "memory");
        }    
    }
}

inline fn busyDelay() void {

}