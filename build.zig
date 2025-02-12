const std = @import("std");

pub fn build(b: *std.Build) void {
    b.exe_dir = "bin";

    const bootloader_query = std.Target.Query {
        .cpu_arch = .x86_64,
        .os_tag = .uefi,
        .abi = .msvc,
        .ofmt = .coff,
    };

    const bootloader_target = b.resolveTargetQuery(bootloader_query);
    
    const kernel_query = std.Target.Query {
        .cpu_arch = .x86_64,
        .os_tag = .freestanding,
        .abi = .none,
        .ofmt = .elf,
    };

    const kernel_target = b.resolveTargetQuery(kernel_query);

    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseFast,
    });

    // Bootloader
    const bootloader = b.addExecutable(.{
        .name = "bootx64",
        .root_source_file = b.path("bootloader/bootloader.zig"),
        .target = bootloader_target,
        .optimize = optimize,
        .single_threaded = true,
        .strip = true,
        .use_lld = true,
    });
    b.installArtifact(bootloader);

    // Kernel

    const kernel = b.addExecutable(.{
        .name = "kernel.elf",
        .root_source_file = b.path("kernel/kernel.zig"),
        .target = kernel_target,
        .optimize = optimize,
        .single_threaded = true,
        .strip = true,
        .use_lld = true,
    });
    kernel.entry = .disabled;
    kernel.setLinkerScript(b.path("kernel/kernel.ld"));

    b.installArtifact(kernel);

    // After that, we create a directory in the zig cache into which we can copy files.
    const boot_dir = b.addWriteFiles();
    // Now, we copy the bootloader executable into a folder that will be recognized by UEFI.
    _ = boot_dir.addCopyFile(bootloader.getEmittedBin(), b.pathJoin(&.{"efi/boot", bootloader.out_filename}));
    // Here, we copy the kernel executable to a custom location.
    _ = boot_dir.addCopyFile(kernel.getEmittedBin(), kernel.out_filename);

    const install_step = b.getInstallStep();
    install_step.dependOn(&bootloader.step);
    install_step.dependOn(&kernel.step);

    const qemu_cmd = b.addSystemCommand(&.{"qemu-system-x86_64"});
    // …that depends on the bootloader and kernel install steps we defined above…
    qemu_cmd.step.dependOn(b.getInstallStep());

    qemu_cmd.addArg("-bios");
    qemu_cmd.addFileArg(b.path("OVMF.fd"));
    // …an emulated FAT drive using the directory we made in the above…
    qemu_cmd.addArg("-hdd");
    qemu_cmd.addPrefixedDirectoryArg("fat:rw:", boot_dir.getDirectory());
    // …the standard output mapped to the COM1, allowing us to see messages from the operating
    // system directly on our console…
    qemu_cmd.addArg("-serial");
    qemu_cmd.addArg("mon:stdio");
    // …a GTK-based window for display…
    qemu_cmd.addArg("-display");
    qemu_cmd.addArg("gtk");
    // …and a GDB (a debugger tool) remote-connection client available on localhost:1234 via TCP.
    // qemu_cmd.addArg("-s");
    // The we create a subcommand (`zig build qemu`) to run the above system command…
    const qemu_step = b.step("run", "Run the kernel via QEMU");
    // …and make sure it depends on that command's step.
    qemu_step.dependOn(&qemu_cmd.step);
}
