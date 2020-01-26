# BOSSA

## Introduction

BOSSA is a flash programming utility for Atmel's SAM family of flash-based ARM microcontrollers.  The motivation behind BOSSA is to create a simple, easy-to-use, open source utility to replace Atmel's SAM-BA software.  BOSSA is an acronym for Basic Open Source SAM-BA Application to reflect that goal.  What's wrong with using SAM-BA?  Well, there are several reasons to consider an alternative.

The first reason is complexity.  SAM-BA tries to be the Swiss army knife of utilities by programming all kinds of memories and external devices attached to a SAM microcontroller.  Because of this, SAM-BA's interface can be confusing and intimidating for someone getting started with microcontrollers or for someone not well versed in hardware.  BOSSA strives to provide a simple interface with just the basic functionality necessary to program the SAM device's internal flash memory.

The second reason is expandability.  SAM-BA ships with support for all of Atmel's evaluation kits but does not provide generic configurations for other boards.  It is a complex task with little documentation to modify SAM-BA to support custom boards.  Sometimes, one can get away with using one of the evaluation kit configurations if it is similar to a custom board but other times not since custom external devices could cause a conflict.  BOSSA is focused solely on programming the flash inside of the SAM device and so is independent of the board's external devices.  So long as one develops a custom board with a crystal and I/O connections capable of communicating with SAM-BA, BOSSA can reliably program the flash without having to worry about external device conflicts.

The third reason is reliability.  SAM-BA is a complex application built on top of a TCL/TK scripting engine.  It works fairly well under Windows XP but there are a lot of reports of crashing or locking up on Windows Vista and Windows 7.  It also doesn't run well with 64-bit versions of Windows.  BOSSA by contrast is a native application and runs reliably in all versions of Windows from Windows 2000 on up for both 32-bit and 64-bit versions.

The fourth reason is portability.  SAM-BA is available only for Windows and Linux but not for any other platforms.  BOSSA leverages the wxWidgets cross-platform framework and thus is easily ported to any of the numerous platforms available for wxWidgets.  Versions of BOSSA are available for Windows, Linux, and Mac.

The last reason is size.  A default installation of the 2.10 version of SAM-BA consumes 76MB of storage space across 2,037 files.  BOSSA is a single, self-contained executable that is a couple of MB in size.  BOSSA also does not need to be installed into the operating system so you can freely copy and run it without having to worry about an installer.

BOSSA communicates with the SAM-BA boot loader running on the SAM device via either a RS-232 port connected to the SAM device's debug serial port or for SAM devices that support USB, over a USB CDC virtual serial port.

BOSSA supports all of Atmel's known flash-based SAM devices but some specific devices and device families have not been tested.  The matrix below shows the current level of testing.
  	16K 	32K
	64K 	128K 	256K 	512K
SAM3S 	- 	- 	F 	F 	T 	-
SAM3U 	- 	- 	F 	F 	T 	-
SAM3N 	- 	- 	F 	F 	T 	-
SAM7S 	F 	F 	F 	F 	T 	T
SAM7SE 	- 	F 	- 	- 	T 	T
SAM7X 	- 	- 	- 	F 	F 	F
SAM7XC 	- 	- 	- 	F 	T 	F
SAM7L 	- 	- 	S 	S 	- 	-
SAM9XE 	- 	- 	- 	S 	S 	S

Letter 	Meaning
- 	No such device
S 	Supported but not tested
F 	Family tested but not device
T 	Device fully tested

You can help make BOSSA better either by reporting results for untested devices or by donating hardware to help us test them.  A big thanks to Atmel for generously providing evaluation boards to test on for the SAM3S and SAM3U.


## BOSSA Command Line

BOSSA is also available in a command line version that enables one to quickly program devices from the command line or to integrate BOSSA into automated scripts.  The help for BOSSA command line is shown below.

$ bossac -h
Usage: bossac.exe [OPTION...] [FILE]
Basic Open Source SAM-BA Application (BOSSA) Version 1.2
Flash programmer for Atmel SAM devices.
Copyright (c) 2011 ShumaTech (http://www.shumatech.com)

Examples:
  bossac -e -w -v -b image.bin   # Erase flash, write flash with image.bin,
                                 # verify the write, and set boot from flash
  bossac -r0x10000 image.bin     # Read 64KB from flash and store in image.bin

Options:
  -e, --erase           erase the entire flash
  -w, --write           write FILE to the flash; accelerated when
                        combined with erase option
  -r, --read[=SIZE]     read SIZE from flash and store in FILE;
                        read entire flash if SIZE not specified
  -v, --verify          verify FILE matches flash contents
  -p, --port=PORT       use serial PORT to communicate to device;
                        default behavior is to auto-scan all serial ports
  -b, --boot[=BOOL]     boot from ROM if BOOL is 0;
                        boot from FLASH if BOOL is 1 [default];
                        option is ignored on unsupported devices
  -c, --bod[=BOOL]      no brownout detection if BOOL is 0;
                        brownout detection is on if BOOL is 1 [default]
  -t, --bor[=BOOL]      no brownout reset if BOOL is 0;
                        brownout reset is on if BOOL is 1 [default]
  -l, --lock[=REGION]   lock the flash REGION as a comma-separated list;
                        lock all if not given [default]
  -u, --unlock[=REGION] unlock the flash REGION as a comma-separated list;
                        unlock all if not given [default]
  -s, --security        set the flash security flag
  -i, --info            display device information
  -d, --debug           print debug messages
  -h, --help            display this help text

BOSSA Shell

BOSSA also comes as an interactive shell which, in addition to flash programming, comes with a number of simple diagnostic operations such as memory reading and writing, PIO line manipulation, and ARM disassembly.  The shell is built on top of the GNU readline library so it has the familiar line editing and history operations familiar to users of Unix command shells.  A list of the supported commands is shown below.

bod -- Change the brownout detect flag.
bootf -- Change the boot to flash flag.
bor -- Change the brownout reset flag.
connect -- Connect to device over serial port.
debug -- Change the debug state.
disass -- Disassemble ARM code at memory address.
dump -- Dump memory in hexadecimal and ascii.
erase -- Erase the entire flash.
exit -- Exit the BOSSA shell.
go -- Execute ARM code at address.
help -- Display help for a command.
history -- List the command history.
lock -- Set lock bits in the flash.
info -- Display information about the flash.
mrb -- Read bytes from memory.
mrf -- Read memory to file.
mrw -- Read words from memory.
mwb -- Write bytes to memory.
mwf -- Write memory from file.
mww -- Write words to memory.
pio -- Parallel input/output operations.
read -- Read flash into a binary file.
scan -- Scan all serial ports for a device.
security -- Enable the security flag.
verify -- Verify binary file with the flash.
write -- Write binary file into flash.

To give you a feel for what BOSSA shell can do, the example session below demonstrates connecting to a SAM3S device and executing a few of the available commands.

$ bossash
Press Ctrl-D or enter "exit" to end session.
Enter "help" to display a command list.
bossa> scan
Checking port COM1...
Checking port COM3...
Connected to device on COM3
bossa> info
Device       : ATSAM3S4
Chip ID      : 28a00960
Version      : v1.4 Jul 21 2009 11:30:50
Address      : 4194304
Pages        : 1024
Page Size    : 256 bytes
Total Size   : 256KB
Planes       : 1
Lock Regions : 16
Locked       : none
Security     : false
Boot Flash   : false
bossa> dump 0x800080 0x40
            0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00800080 | a4 0f 00 00 c4 0f 00 00 10 3a 24 bf 78 c8 78 c1 | .........:$.x.x.
00800090 | fa d8 52 07 24 bf 30 c8 30 c1 44 bf 04 68 0c 60 | ..R.$.0.0.D..h.`
008000a0 | 70 47 00 00 00 23 00 24 00 25 00 26 10 3a 28 bf | pG...#.$.%.&.:(.
008000b0 | 78 c1 fb d8 52 07 28 bf 30 c1 48 bf 0b 60 70 47 | x...R.(.0.H..`pG
bossa> disass 0x800080 0x40
  800080:       00000fa4        andeq   r0, r0, r4, lsr #31
  800084:       00000fc4        andeq   r0, r0, r4, asr #31
  800088:       bf243a10        svclt   0x00243a10
  80008c:       c178c878        cmngt   r8, r8, ror r8
  800090:       0752d8fa        smmlsreq        r2, sl, r8, sp
  800094:       c830bf24        ldmdagt r0!, {r2, r5, r8, r9, sl, fp, ip, sp, pc}
  800098:       bf44c130        svclt   0x0044c130
  80009c:       600c6804        andvs   r6, ip, r4, lsl #16
  8000a0:       00004770        andeq   r4, r0, r0, ror r7
  8000a4:       24002300        strcs   r2, [r0], #-768 ; 0x300
  8000a8:       26002500        strcs   r2, [r0], -r0, lsl #10
  8000ac:       bf283a10        svclt   0x00283a10
  8000b0:       d8fbc178        ldmle   fp!, {r3, r4, r5, r6, r8, lr, pc}^
  8000b4:       bf280752        svclt   0x00280752
  8000b8:       bf48c130        svclt   0x0048c130
  8000bc:       4770600b        ldrbmi  r6, [r0, -fp]!
bossa> pio pb status
                3      2 2      1 1
                1      4 3      6 5      8 7      0
PIO Mode      : EEEEEEEE EEEEEEEE EEEEEEEE EEEEEEEE
Direction     : IIIIIIII IIIIIIII IIIIIIII IIIIIIII
Input Level   : LLLLLLLL LLLLLLLL LLLLLLLL LLLLLLLL
Output Level  : LLLLLLLL LLLLLLLL LLLLLLLL LLLLLLLL
Multi-Drive   : DDDDDDDD DDDDDDDD DDDDDDDD DDDDDDDD
Pull-Up       : EEEEEEEE EEEEEEEE EEEEEEEE EEEEEEEE
Peripheral    : AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA
bossa> pio pb0 high
bossa> pio pb0 status
PIO Mode      : enable
Direction     : output
Input Level   : low
Output Level  : high
Multi-Drive   : disable
Pull-Up       : enable
Peripheral    : A
bossa> exit

Installation

To install BOSSA, download the installation file below that is appropriate for your system.
Windows

It is recommended that you download the Windows installer because it will create a Start menu group and install a USB CDC driver for your SAM devices that is compatible with BOSSA.  Make sure to only download the 64-bit version of the installer if you are running on a 64-bit version of Windows.  You can optionally download the executable versions of BOSSA if you are sure you already have a USB CDC driver installed by Atmel's SAM-BA or other software.

If you are using Windows 7, then your SAM devices may be detected as "GPS Camera Detect" ports but will otherwise work fine with BOSSA.  Note that on Windows XP, Atmel's SAM-BA software installs a proprietary USB driver.  You must use the CDC version of SAM-BA after installing BOSSA because it will replace the proprietary USB driver with a USB CDC driver.
Linux

The Linux versions of BOSSA are compiled to use GTK+ shared libraries.  Make sure that you have GTK+ installed on your Linux system in order to run BOSSA.  GTK+ is a required component of the GNOME desktop and is installed by default in most major Linux distributions.  Both 32-bit (i686) and 64-bit (x86-64) versions of BOSSA are available below.  Note that the BOSSA command line version (bossac) does not have the GTK+ requirement and can run on a minimal Linux system.

Linux versions 2.6.31 and earlier require manual installation of the usbserial driver:

rmmod usbserial
modprobe usbserial vendor=0x03eb product=0x6124

Linux versions between 2.6.32 and 2.6.36 are not compatible with BOSSA using USB due to a bug in the Linux kernel.  You must either use a RS-232 port or update your kernel to 2.6.37 or later.

Linux versions 2.6.37 and later include a dedicated driver for SAM devices and should not require any manual intervention if the driver is compiled into the kernel.

For USB connections, use the Linux 'dmesg' command to make sure that a driver is installed for your SAM device when you connect it.
Mac OS X

Download the disk image file and open it.  Drag the BOSSA and BOSSAC icons to their respective folder links that the arrows point to.