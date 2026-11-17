# Bunnymark Jai D3D11
just checking how fast computers go without a slow engine. probably the fastest bunnymark.

i think this benchmark is cpu bound. there's no SIMD, SOA, Threads, or CPU optimization of any kind when updating bunnies. because i think this is how a real game would work.


## Demo
https://www.youtube.com/watch?v=_cSMGs2LyD8




#### 1,000 bunnies at 24,000 fps (cpu: 12700, gpu: RX 6800) || 1,000 bunnies at 13,000 fps (cpu: 8700k, gpu: 1070 mini)
[![bunnymark youtube video](https://github.com/farzher/Bunnymark-Jai-D3D11/assets/1005136/3e284d96-4d22-455a-9a95-66c8bd7952e1)](https://www.youtube.com/watch?v=_cSMGs2LyD8)

#### 50,000 bunnies at 4,000 fps (cpu: 8700k, gpu: 3090) || 50,000 bunnies at 4,000 fps (cpu: 12700, gpu: RX 6800)
[![bunnymark youtube video](https://i.imgur.com/QszPnXp.png)](https://www.youtube.com/watch?v=_cSMGs2LyD8)

#### 3,607,125 bunnies at 60 fps (cpu: 8700k, gpu: 3090) || 3,500,000 bunnies at 60 fps (cpu: 12700, gpu: RX 6800)
[![bunnymark youtube video](https://github.com/farzher/Bunnymark-Jai-D3D11/assets/1005136/13116875-dfc3-49cc-9ad4-6b92720aaf53)](https://www.youtube.com/watch?v=_cSMGs2LyD8)


# Download the exe
https://github.com/farzher/Bunnymark-Jai-D3D11/releases/download/v0.0.3/bunnymark.exe



### Build From Source

Two versions of the same benchmark, the same bunnies the same way, with the
picture in `assets/` shared:

- `jai/`: the original, brought up to date for the current Jai compiler.
  0. have #the_compiler(v0.2.30)
  1. in `jai/`, run `run.bat` (optimized, `jai first.jai -o`), or
     `run-debug.bat` (`jai first.jai - DEBUG`: shaders unoptimized, D3D11's
     debug bindings)
- `rain/`: a port to 'rain, on its D3D11 module, with its Random module's
  xoshiro256** for the bunnies' randomness.
  1. in `rain/`, run `rain -release -run bunnymark.rain` (optimized, through
     LLVM), or `rain -run bunnymark.rain` (a debug build, with D3D11's debug
     layer when it's installed)

### Automated runs

Either version, given `-auto`, runs unattended: as if the left button were
held throughout, with the mouse at a random place in the window each frame,
adding bunnies by the time since the first frame (10,000 a second), so every
run has as many at the same time however fast it goes. After `-seconds:N`
(20) it ends and prints each second's bunnies, frames and slowest frame (only
then, so printing costs the run nothing).

- Jai: `bunnymark.exe -auto -seconds:20 -profile:bunnymark.profile` samples
  it with 'rain's profiler (the Rain_Profile module), then `rain
  -report:bunnymark.profile` reports it.
- rain: `rain -release -profile bunnymark.rain -auto -seconds:20`.

Both present through a blt swap chain (one buffer, copied into the window):
in a window, without vsync, some GPUs draw twice the frames a second this way
as through a flipped one.
