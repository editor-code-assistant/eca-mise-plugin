# eca-mise-plugin

A [mise](https://mise.jdx.dev) tool plugin for [ECA (Editor Code Assistant)](https://eca.dev).

## About ECA

ECA (Editor Code Assistant) is an AI-powered pair-programming tool that works with any editor. It provides:

- 📄 **Editor-agnostic**: protocol for any editor to integrate
- ⚙️ **Single configuration**: Configure ECA making it work the same in any editor
- ➿ **Chat interface**: ask questions, review code, work together to code
- ☕ **Agentic**: let LLM work as an agent with its native tools and MCPs
- 💉 **Context support**: giving more details about your code to the LLM
- 🚀 **Multi models**: Login to OpenAI, Anthropic, Copilot, Ollama local models and many more

## Installation

```bash
# Install the plugin
mise plugin install eca https://github.com/editor-code-assistant/eca-mise-plugin

# Install latest version ECA
mise install eca
mise use -g eca

# or install and use
# desired version
mise install eca@0.58.0
mise use -g eca@0.58.0

# Verify installation
eca --version
```

## Usage

After installation, you can use ECA with your preferred editor:

```bash
# Start ECA server
eca server

# Or use with editor plugins (Emacs, VSCode, Vim, IntelliJ)
```

## Configuration

ECA can be configured globally or per project. See the [ECA documentation](https://eca.dev) for detailed configuration options.

## Supported Platforms

- Linux (x64, ARM64)
- macOS (Intel, Apple Silicon)
- Windows (x64)

## Testing

Run the test script to verify the plugin works:

```bash
./test/test.sh
```

## Publishing Releases

1. Update version in `metadata.lua`
2. Create annotated git tag:
   ```bash
   git tag -a v1.0.1 -m "Release v1.0.1"
   git push origin v1.0.1
   git push origin main
   ```
3. Create GitHub release with release notes

## Contributing

Pull requests welcome! Please run `./test/test.sh` before submitting.

## License

Apache-2.0 (same as ECA)
