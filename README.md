# VS-SLN: Minimal Visual Studio Project Generator

VS-SLN is a set of scripts that instantly generate a minimal Visual Studio 2022 solution and project files for C++ projects. It's designed for developers who want to quickly create a VS project from a directory of source files without the overhead of a full-blown project setup.

This tool provides both a Bash script (`vs`) for Linux/macOS environments and a Batch script (`vs.bat`) for Windows, ensuring cross-platform compatibility.

## Features

- **Instant Project Generation**: Creates a `.sln`, `.vcxproj`, and `.vcxproj.filters` file in seconds.
- **Cross-Platform**: Supports both Windows (via `vs.bat`) and Linux/macOS (via `vs`).
- **Automatic File Discovery**: Scans the current directory for `.cpp`, `.c`, and `.h` files and adds them to the project.
- **Filter Grouping**: Automatically groups source and header files into "Source Files" and "Header Files" filters in the Visual Studio Solution Explorer.
- **Custom Project Name**: Specify a project name or let the script use the current directory's name by default.

## Prerequisites

- **Visual Studio 2022**: The generated project files are configured for Visual Studio 2022.
- **MSVC Toolchain**: Ensure the MSVC C++ toolchain is installed with Visual Studio.
- **(For Linux/macOS)**: A Bash-compatible shell.

## How to Use

1.  Place the `vs` or `vs.bat` script in a directory that is in your system's `PATH`, or directly in your project's root directory.
2.  Navigate to your project's root directory containing your `.cpp`, `.c`, and `.h` files.
3.  Run the script.

### On Windows

```batch
# Use the current directory name as the project name
> vs.bat

# Or specify a custom project name
> vs.bat MyAwesomeProject
```

### On Linux/macOS

```bash
# Make the script executable first
$ chmod +x vs

# Use the current directory name as the project name
$ ./vs

# Or specify a custom project name
$ ./vs MyAwesomeProject
```

## What It Generates

Running the script will produce the following files:

-   **`YourProjectName.sln`**: The main solution file that you can open with Visual Studio.
-   **`YourProjectName.vcxproj`**: The MSBuild project file containing build configurations and file references.
-   **`YourProjectName.vcxproj.filters`**: A file that organizes your source and header files into logical filters in the Solution Explorer.

After generation, you can immediately open the `.sln` file in Visual Studio and start coding.

## Example

Imagine you have a directory with the following files:

```
/my-cpp-project
|-- main.cpp
|-- utils.cpp
|-- utils.h
```

Running the script inside this directory will generate:

```
/my-cpp-project
|-- main.cpp
|-- utils.cpp
|-- utils.h
|-- my-cpp-project.sln
|-- my-cpp-project.vcxproj
|-- my-cpp-project.vcxproj.filters
```

You can now open `my-cpp-project.sln` in Visual Studio 2022.

## Contributing

Contributions are welcome! If you have ideas for improvements or find a bug, please open an issue or submit a pull request.

Possible enhancements could include:
-   Support for recursive file discovery.
-   Command-line flags for more advanced configurations (e.g., different target platforms, additional include directories).
-   Randomized GUID generation.

## License

This project is open-source and available under the [MIT License](LICENSE).
