MEMORY
{
    ITCM (rwx):  ORIGIN = 0x00000000, LENGTH = 512K
    DTCM (rwx):  ORIGIN = 0x20000000, LENGTH = 512K
    RAM (rwx):   ORIGIN = 0x20200000, LENGTH = 512K
    FLASH (rwx): ORIGIN = 0x60000000, LENGTH = 7936K
    ERAM (rwx):  ORIGIN = 0x70000000, LENGTH = 16384K
}

ENTRY(__ivt_start)

SECTIONS
{
    .text.headers : {
        /* FlexSPI configuration */
        LONG(0x42464346)     
        LONG(0x56010000)     
        LONG(0)              
        LONG(0x00030301)     
        LONG(0x00000000)     
        LONG(0)              
        LONG(0)              
        LONG(0x00000000)     
        LONG(0)              
        LONG(0)
        LONG(0)
        LONG(0)
        LONG(0)              
        LONG(0)
        LONG(0)
        LONG(0)
        LONG(0x00000000)     
        LONG(0x00080401)     
        LONG(0)              
        LONG(0)              
        LONG(0x00800000)
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0x00000000)     
        LONG(0x0A1804EB)     
        LONG(0x26043206)     
        LONG(0)              
        LONG(0)              
        LONG(0x24040405)     
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0x00000406)     
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0x08180420)     
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0x081804D8)     
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0x08180402)     
        LONG(0x00002004)     
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0x00000460)     
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(256)            
        LONG(4096)           
        LONG(1)              
        LONG(0)              
        LONG(0x00010000)     
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              
        LONG(0)              

        FILL(0xFF)
        . = ORIGIN(FLASH) + 0x1000;
            
        /* IVT */
        __ivt_start = .;
        LONG(0x402000D1)      /* header */        
        LONG(__vectors_start) /* first entry */
        LONG(0x00000000)
        LONG(0x00000000)

        LONG(__bootdata_start)
        LONG(__ivt_start)
        LONG(0x00000000)
        LONG(0x00000000)

        /* BOOTDATA */
        __bootdata_start = .;
        LONG(0x60000000)
        LONG(_flashimagelen) /* flash image length */
        LONG(0x00000000)

        /* VECTOR TABLE */
        __vectors_start = .;
        LONG(0x20010000)
        LONG(startup)

        . = ALIGN(1024);
    } > FLASH

    .text.code : {
        KEEP(*(.startup))
        *(.flashmem*)
        . = ALIGN(4);
        KEEP(*(.init))
        __preinit_array_start = .;
        KEEP (*(.preinit_array))
        __preinit_array_end = .;
        __init_array_start = .;
        KEEP (*(.init_array))
        __init_array_end = .;
        . = ALIGN(4);
    } > FLASH

    .text.progmem : {
        *(.progmem*)
        . = ALIGN(4);
    } > FLASH

    .text.itcm : {
        . = . + 32; /* MPU to trap NULL pointer deref */
        *(.fastrun)
        *(.text*)
        . = ALIGN(16);
    } > ITCM  AT> FLASH

/*    .ARM.exidx : {
        __exidx_start = .;
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
        __exidx_end = .;
    } > ITCM  AT> FLASH */

    /DISCARD/ : {
        *(.ARM.exidx*)
    }

    .data : {
        *(.endpoint_queue)   
        *(SORT_BY_ALIGNMENT(SORT_BY_NAME(.rodata*)))
        *(SORT_BY_ALIGNMENT(SORT_BY_NAME(.data*)))
        KEEP(*(.vectorsram))
    } > DTCM  AT> FLASH

    .bss ALIGN(4) : {
        *(SORT_BY_ALIGNMENT(SORT_BY_NAME(.bss*)))
        *(SORT_BY_ALIGNMENT(SORT_BY_NAME(COMMON)))
        . = ALIGN(32);
        . = . + 32; /* MPU to trap stack overflow */
    } > DTCM

    .bss.dma (NOLOAD) : {
        *(.hab_log)
        *(.dmabuffers)
        . = ALIGN(32);
    } > RAM

    .bss.extram (NOLOAD) : {
        *(SORT_BY_ALIGNMENT(SORT_BY_NAME(.externalram)))
        . = ALIGN(32);
    } > ERAM

    .text.csf : {
        FILL(0xFF)
        . = ALIGN(1024);
        KEEP(*(.csf))
        __text_csf_end = .;
    } > FLASH

    _stext = ADDR(.text.itcm);
    _etext = ADDR(.text.itcm) + SIZEOF(.text.itcm) + SIZEOF(.ARM.exidx);
    _stextload = LOADADDR(.text.itcm);

    _sdata = ADDR(.data);
    _edata = ADDR(.data) + SIZEOF(.data);
    _sdataload = LOADADDR(.data);

    _sbss = ADDR(.bss);
    _ebss = ADDR(.bss) + SIZEOF(.bss);

    _heap_start = ADDR(.bss.dma) + SIZEOF(.bss.dma);
    _heap_end = ORIGIN(RAM) + LENGTH(RAM);

    _extram_start = ADDR(.bss.extram);
    _extram_end = ADDR(.bss.extram) + SIZEOF(.bss.extram);

    _itcm_block_count = (SIZEOF(.text.itcm) + SIZEOF(.ARM.exidx) + 0x7FFF) >> 15;
    _flexram_bank_config = 0xAAAAAAAA | ((1 << (_itcm_block_count * 2)) - 1);
    _estack = ORIGIN(DTCM) + ((16 - _itcm_block_count) << 15);

    _flashimagelen = __text_csf_end - ORIGIN(FLASH);
    _teensy_model_identifier = 0x25;

    .debug_info     0 : { *(.debug_info) }
    .debug_abbrev   0 : { *(.debug_abbrev) }
    .debug_line     0 : { *(.debug_line) }
    .debug_frame    0 : { *(.debug_frame) }
    .debug_str      0 : { *(.debug_str) }
    .debug_loc      0 : { *(.debug_loc) }

}