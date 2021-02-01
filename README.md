# Mushy's Adventure

Mushy's Adventure was originally written in 48 hours for Global Game Jam 2020.

## Playing the Game

Playing the game is relatively simple. First you will need to download the game `.GB` file and then run it on an emulator.

### Download

You can download the latest release [here](https://github.com/thebillington/mushys_adventure/releases).

### Windows

If you are running on Windows we recommend using [BGB](https://bgb.bircd.org/), a Game Boy Color emulator that sets the gold standard.

### Unix

If you are on Unix then BGB is still the best option with full [Wine compatability](https://appdb.winehq.org/objectManager.php?sClass=application&iId=11138) from version 1.5.4 onwards. Note that if you're running with Wine on OSx 10.15+ (Catalina) then you will need to use the 64 bit version of BGB, or alternatively install [homebrew-wine](https://github.com/Gcenx/homebrew-wine) which has `wine32on64` support.

### Android/iOS

There are loads of emulators available on mobile. Find one in the store that suits you and then use it to load the provided GB ROM file. Note that if you don't use a 'true' emulator then the game file may load with inconsistencies.

### In Browser

If you don't want to install an emulator you can try out Alex Aladren's [JS GameBoy Emulator](http://gb.alexaladren.net/). Note that it can be slightly buggy at times so the game may not load and run perfectly.

## The Game Boy CPU

The project is written in gbZ80 Assembly, a unique assembly language originally designed to run on the Game Boy's SHARP LR35902 processor, which takes a subset of the Zilog Z80 instruction set and by extension, the Intel 8080 instruction set.

The LR35902 also added some unique instructions diverging from the Z80; the purpose of these instructions is mostly related to the way the Game Boy addresses memory directly as registers instead of using a subset of I/O registers for data and address R/W, as with the Z80.

## Running from Source

The game is written to be compiled with [RGBDS](https://github.com/gbdev/rgbds), a free Game Boy assembler/linker which also includes a useful `rgbfix` method which will make the ROM playable on actual hardware.

Follow the instructions to install RGBDS for your system (on Mac RGBDS is available as a homebrew package) and then you can compile the game from source simply by executing the make file:

```
make
```

And that's it, you should now have the game compiled into `main.gb`.