# ZOS - Zig Operating System

This project aims to create the fastest and stable operating system using the Zig programming language. The project is still in its early stages and is not yet ready for production use. All contributions are welcome!

## Features

- Bootloader using UEFI because BIOS is outdated... really outdated.
- Kernel written in Zig for better performance and safety.
- Every features are welcome!

> [!NOTE]
> Just keep in mind that we want to get the best performance and stability possible.

## Prerequisites

- [Zig](https://ziglang.org/) compiler (latest or nightly)
- [Task](https://taskfile.dev/) task runner
- QEMU emulator
- xorriso (for ISO creation)

> [!NOTE]
> For Windows users, it's recommended to use WSL (Windows Subsystem for Linux) to run the commands. You can install WSL by following [Microsoft's guide](https://docs.microsoft.com/en-us/windows/wsl/install).

## Available Commands

The project uses Taskfile for automation. Here are the available commands:

#### `task install`
Installs all required dependencies:
- Installs ZVM (Zig Version Manager)
- Installs specified Zig version (latest or nightly)
- Installs system dependencies (QEMU and xorriso)

#### `task build`
Compiles the project:
- Builds bootloader (UEFI compatible)
- Builds kernel
- Creates necessary binaries in `bin/` directory

#### `task run`
Executes the OS in QEMU:
- Uses QEMU to emulate x86_64 architecture
- Loads bootloader and kernel
- Provides serial output through stdio

#### `task clean`
Removes all generated files from `bin/` directory

#### `task run-dev`
Launches OS in QEMU with development features:
- Enables hardware acceleration on Linux (KVM)
- Basic mode on macOS

#### `task iso`
Creates bootable ISO image:
- Uses xorriso to package the OS
- Creates ISO file in `bin/` directory

## Potential Improvements

1. Memory Management
   - Implement proper page allocation
   - Add memory protection mechanisms
   - Implement heap allocation

2. Process Management
   - Add process scheduling
   - Implement context switching
   - Add basic system calls

3. File System
   - Implement a basic file system
   - Add file operations (read/write)
   - Support directories

4. Device Drivers
   - Add keyboard driver
   - Implement display driver
   - Add storage drivers

5. Error Handling
   - Improve error messages
   - Add error recovery mechanisms
   - Implement proper panic handling

> [!NOTE]
> The bootloader uses UEFI, which provides better compatibility with modern hardware compared to legacy BIOS bootloaders.

> [!WARNING]
> Running custom operating systems in QEMU is safe, but be careful when trying to boot on real hardware as it might cause damage if not properly tested.

## Contributing

Feel free to contribute by:
1. Forking the repository
2. Creating a feature branch
3. Making your changes
4. Submitting a pull request

## License

> [!IMPORTANT] 
> This project has not been licensed yet. 
> Please don't use it for commercial purposes without permission. 
> We are working on choosing a suitable license for this project.