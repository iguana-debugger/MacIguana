#  MacIguana

![MacIguana running a demo program](MacIguana.png)

MacIguana is an ARM debugger for macOS, intended as a modern replacement for [Komodo](https://studentnet.cs.manchester.ac.uk/resources/software/komodo/). It uses the same underlying emulator as Komodo.

# Installation

1. Download `MacIguana.zip` from https://github.com/iguana-debugger/MacIguana/releases
2. Extract `MacIguana.app` from `MacIguana.zip`
3. Move `MacIguana.app` to `/Applications`

# Usage

When opening MacIguana, you will be prompted to open a `.s` file. Once opened, you can run the program using the run button in the toolbar. To set breakpoints, click to the left of the address that you want to break on in the top disassembly pane. The instruction pointed to by the program counter is highlighted in green.

To load in new changes when editing your assembly file, press the reload button in the toolbar. This resets the emulator state and loads in the file again.

# Reporting Issues

If you run into any issues with MacIguana, please open a GitHub issue. If possible, please provide a `.s` file that reproduces the issue - note that sharing coursework directly is not allowed and could be considered academic misconduct.
