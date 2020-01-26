# SAM-CMake-template

The SAM CMake template targets embedded system cross-compiling. The goal is to provide a more modern build system that is cross-platform that does not rely on makefile.
Typically, on windows, one would have to download cygwin or mingw. Now that VS 2019 packages the arm-none-eabi-gcc toolchain with its linux tools, all you need to begin
developing for ATMEL SAM systems is the dependencies and a few additional scripts.

## Building

Inside of the build/ directory, there is a CMake toolchain file that is suppose to find the ARM toolchain, bossac, and other dependencies. The toolchain currently provides
all utilities required to compile, link, and build a C program. The toolchain file 'sam_gcc.cmake' must be provided as an argument in the call to cmake. VS 2019 provides
an addition method for specifying the toolchain which I will outline in [vs_2019_setup.md](/docs/vs_2019_setup.md).

In addition to the toolchain, the CMake cache requires a few variables to be adjusted to the specifics of your platform:

	- ARM_CPU	(default is 'cortex-m0')
	- ARM_UPLOADTOOL (default is 'bossac')
	- UPLOAD_PORT	(default is 'COM4')
	- ATMEL_ARCH	(default is '')
	- SAM_MCU	(default is 'samd21g18a')

## Linking

NOTE: The typical linker scripts that come with the SAM<X>_DFP pack are modified to be compatible with UF2 loading. Inside of the provided
'samd51j20a_flash.ld', the FLASH start address and length are adjusted to meet the requirements of the UF2 specifications. Adafruit provides good documentation
on the SAMD21 and SAMD51 concerning the offsets. Below is an example of SAMD51 offsetting:

```
rom      (rx)  : ORIGIN = 0x00004000, LENGTH = 0x00100000 - 0x4000
```

## Current Status

The project currently targets the SAMD51J20A, which is the MCU on the SparkFun SAMD51 ThingPlus. All files currently exemplify setup via this MCU. 'main.c' is a
basic blink program that specifically uses the SAMD51J20A PA_17 (which is the ThingPlus LED GPIO). I am still working on the UPLOAD feature and trying to determine
the configurations of the linker script that will allow bossac to upload the binary to the MCU that is running the UF2 bootloader.

## Uploading/Flashing

The goal is to provide multiple common ways to upload/flash the executable to the MCU. So far, this project is targeting:

- BOSSA
- UF2 copying
- Segger JLink

The toolchain will search for these programs and include projects based off of available methods.

### BOSSA

### UF2
UF2 'flashing' consists of converting a binary to a *.uf2 file that is copyable. The platform needs to provide the copy command to CMake, thus CMake can
copy the output UF2 file to the Mass Storage device drive (also need to provide that Drive letter or mount point).

### Segger JLink



# TODO

- [ ] CMake caching of 'copy' command. Currently hard-coded for windows.
- [ ] Setup scaffolding for Segger JLink flashing and debugging.
- [ ] Design integration with GDB for debugging. JLink provides a GDB Server.
- [ ] Better abstract example from SAMD51J20A specifics.
- [ ] Clone Microsoft UF2 repository for SAMD packs and 'uf2conv.py' script.
- [ ] Internally control copying of linker scripts from packs via CMake.