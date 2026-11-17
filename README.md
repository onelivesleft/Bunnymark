# Bunnymark D3D11
just checking how fast computers go without a slow engine. probably the fastest bunnymark.

i think this benchmark is cpu bound. there's no SIMD, SOA, Threads, or CPU optimization of any kind when updating bunnies. because i think this is how a real game would work.


#### 1,000 bunnies at 24,000 fps (cpu: 12700, gpu: RX 6800) || 1,000 bunnies at 13,000 fps (cpu: 8700k, gpu: 1070 mini)
![1,000 bunnies](https://github.com/farzher/Bunnymark-Jai-D3D11/assets/1005136/3e284d96-4d22-455a-9a95-66c8bd7952e1)

#### 50,000 bunnies at 4,000 fps (cpu: 8700k, gpu: 3090) || 50,000 bunnies at 4,000 fps (cpu: 12700, gpu: RX 6800)
![50,000 bunnies](https://i.imgur.com/QszPnXp.png)

#### 3,607,125 bunnies at 60 fps (cpu: 8700k, gpu: 3090) || 3,500,000 bunnies at 60 fps (cpu: 12700, gpu: RX 6800)
![3,607,125 bunnies](https://github.com/farzher/Bunnymark-Jai-D3D11/assets/1005136/13116875-dfc3-49cc-9ad4-6b92720aaf53)


## What it does

How many bunnies a computer can draw without an engine in the way: each
falls, bounces off the floor and the walls, and spins, moved on the CPU one
at a time (no SIMD, no threads), then all of them drawn with one instanced
draw through Direct3D 11. Hold the left mouse button to add bunnies (10,000 a
second) where it is; the window's title gives the frames a second, the
slowest frame's rate, and the bunnies' count. Escape closes it.

There are two versions of it, the same bunnies the same way, with the
picture in `assets/` shared: the original in Jai (by farzher), and a port to
'rain.

## Building

- `jai/`, with Jai v0.2.30: in `jai/`, run `run.bat` (optimized,
  `jai first.jai -o`), or `run-debug.bat` (`jai first.jai - DEBUG`: shaders
  unoptimized, D3D11's debug bindings).
- `rain/`, on 'rain's D3D11 module, with its Random module's xoshiro256** for
  the bunnies' randomness: in `rain/`, run `rain -release -run
  bunnymark.rain` (optimized, through LLVM), or `rain -run bunnymark.rain` (a
  debug build, with D3D11's debug layer when it's installed).

## Automated runs

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
