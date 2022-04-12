# Zig on Bare-metal Teensy 4.1

Just a sample program that blinks Pin 13 (aka on-board LED) on and off.
The real neat thing is that this is all bare metal! Our only dependency is Zig and Arm's objcopy.

Build the flashable image using `zig build`, then use `arm-none-eabi\bin\objcopy -O ihex -R .eeprom <output ELF in zig-out>` 
to produce a valid image for the default Teensy flashing program.

This project was mostly based on using https://github.com/blazer82/baremetal-blinky.teensy as a template to translate from.
