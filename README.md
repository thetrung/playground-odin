Playground Odin
================
[Fast as C](https://programming-language-benchmarks.vercel.app/odin-vs-c) while Simpler to write than Zig/Rust.

### Examples 
1. memory allocation & pointer/dereference in use (^/^^/&).
2. game of life : loop, struct, defer, raylib example.

### Install Odin on Ubuntu 25.04
I assume you will want to install `Odin` into `$HOME/Odin`, change the path as you wish : 

1. `cd ~/ && git clone https://github.com/odin-lang/Odin.git && cd Odin`

2. `sudo apt install llvm clang`

3. `make release-native`

4. `echo 'export PATH="$PATH:$HOME/Odin"' >> ~/.bashrc && source ~/.bashrc`
