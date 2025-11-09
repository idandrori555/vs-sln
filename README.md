# VS-SLN: The No-Click Visual Studio Project Generator

Tired of wrestling with Visual Studio's new project wizard just to compile some C++ files? VS-SLN gets you from source code to a ready-to-use `.sln` file in one command.

---

### **Before**

You have a folder with your code:
```
/my-project
|-- main.cpp
|-- helpers.cpp
|-- helpers.h
```
...and you just want to open it in Visual Studio without the 17-click ceremony.

### **After**

Run one command, and get this:
```
/my-project
|-- main.cpp
|-- helpers.cpp
|-- helpers.h
|-- 🚀 my-project.sln
|-- 📄 my-project.vcxproj
|-- 📂 my-project.vcxproj.filters
```

---

## 🚀 Quick Start

1.  **Get the script:**
    *   Download `vs` (for Linux/macOS) or `vs.bat` (for Windows).
    *   Place it in your project folder or somewhere in your system's `PATH`.

2.  **Open your terminal:**
    *   `cd` into your project's directory.

3.  **Run it:**
    *   **On Windows:** `vs.bat`
    *   **On Linux/macOS:** `chmod +x vs && ./vs`

That's it. Now open `YourProjectName.sln` and get back to coding.

### ✨ Customization

Want a different name? Just pass it as an argument.
```bash
# Generates "MyAwesomeApp.sln" instead of "my-project.sln"
./vs MyAwesomeApp
```

### A Note from the Author

This tool was born out of necessity for Magshimim projects. I'm a Neovim user, but I needed to work on a C++ project that required a Visual Studio solution. Rather than surrender to a full IDE, I built this bridge. It lets me stay in my preferred environment while generating the `.sln` files needed to keep the project compatible. If you're in a similar boat, I hope this helps you too.

### Requirements
- A shell (Bash for `vs`, CMD/PowerShell for `vs.bat`)

### Contributing
Ideas? Bugs? Open an issue or a PR. We could always add more features to avoid doing real work.
