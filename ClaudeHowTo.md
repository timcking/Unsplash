To initialize Claude to assist with your existing Flutter project in 2026, the industry standard is using the **Claude Code CLI**. This tool operates directly on your codebase, allowing it to read your files, run terminal commands, and perform Git operations.

## 1. Install Claude Code

Open your terminal and run the native installer for your operating system:

- **macOS / Linux / WSL:**

  Bash

  ```
  curl -fsSL https://claude.ai/install.sh | bash
  ```

- **Windows (PowerShell):**

  PowerShell

  ```
  irm https://claude.ai/install.ps1 | iex
  ```

## 2. Initialize the Project Context

Navigate to the root directory of your Flutter project and start the CLI. On the first run, you will be prompted to log in to your Anthropic account.

Bash

```
cd /path/to/your/flutter_project
claude
```

Once inside the Claude interface, run the initialization command:

Bash

```
/init
```

**What `/init` does for Flutter:**

- **Analyzes `pubspec.yaml`:** Identifies your dependencies (e.g., Riverpod, Bloc, GoRouter).
- **Detects Project Structure:** Maps out your `lib/`, `test/`, and platform-specific folders.
- **Generates `CLAUDE.md`:** This is the most critical step. It creates a "Project Guide" file that instructs Claude on your specific coding standards, build commands (like `flutter pub run build_runner build`), and state management preferences.

------

## 3. Add the Dart & Flutter MCP Server (Optional but Recommended)

To give Claude "superpowers"—like the ability to inspect your widget tree, trigger hot reloads, or run specific Dart tests—you should connect it to the **Model Context Protocol (MCP)** server for Flutter.

Run this command inside the Claude CLI:

Bash

```
claude mcp add dart -- dart mcp-server
```

------

## 4. Common Workflows for Flutter

Once initialized, you can use natural language to manage your files:

- **Refactoring:** `"Refactor lib/widgets/login_form.dart to use the new theme colors."`
- **Dependency Management:** `"Add the flutter_lints package and fix all current warnings."`
- **Testing:** `"Write a widget test for the ProfileScreen in test/ui/."`
- **Building:** `"Run build_runner and tell me if there are any conflicts."`

## Quick Commands Reference

| **Command**       | **Action**                                                   |
| ----------------- | ------------------------------------------------------------ |
| **`/init`**       | Re-scans project and updates `CLAUDE.md` context.            |
| **`/compact`**    | Compresses long conversations to save tokens while keeping key context. |
| **`Shift + Tab`** | Toggles **Plan Mode** (best for complex architectural changes). |
| **`Ctrl + C`**    | Exits the Claude CLI.                                        |

**Would you like me to generate a custom `CLAUDE.md` file tailored to the specific state management and linting rules you use in your project?**

[Setup Claude Code in 2 minutes](https://www.youtube.com/watch?v=NBQePr-XjrU)

This video provides a complete walkthrough of the 2026 installation process and shows how Claude interacts with local project files.
