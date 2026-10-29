# eca-mise-plugin

A [mise](https://mise.jdx.dev) plugin for installing [ECA](https://eca.dev) (Editor Code Assistant) and its terminal client, [eca-cli](https://github.com/editor-code-assistant/eca-cli).

ECA is an AI pair-programming server that works with any editor: Emacs, VS Code, Vim, IntelliJ and others. You configure it once and get the same chat, agent tools and model choices everywhere. eca-cli lets you use it straight from the terminal. See [eca.dev](https://eca.dev) for the details.

## Install eca

```bash
mise plugin install eca https://github.com/editor-code-assistant/eca-mise-plugin

mise use -g eca          # latest
mise use -g eca@0.58.0   # or a specific version

eca --version
```

## Install eca-cli

It's the same plugin. It decides what to install based on the name you give it, so add it again as `eca-cli`:

```bash
mise plugin install eca-cli https://github.com/editor-code-assistant/eca-mise-plugin

mise use -g eca-cli           # latest
mise use -g eca-cli@0.1.107   # or a specific version

eca-cli --version
```

eca-cli only publishes Linux and macOS binaries. On Windows, grab `eca-cli.jar` from its [releases page](https://github.com/editor-code-assistant/eca-cli/releases) and run it with [Babashka](https://babashka.org/).

## Using both

Install the plugin under both names and the two tools are managed separately:

```bash
mise plugin install eca https://github.com/editor-code-assistant/eca-mise-plugin
mise plugin install eca-cli https://github.com/editor-code-assistant/eca-mise-plugin
mise use -g eca eca-cli
```

Or per project, in `mise.toml`:

```toml
[tools]
eca = "latest"
eca-cli = "latest"
```

eca-cli normally downloads its own copy of the eca server. If you'd rather it use the one mise installed:

```bash
eca-cli --eca "$(mise which eca)"
```

## Usage

```bash
eca server   # what editor plugins talk to; you rarely run this yourself
eca-cli      # chat in the current directory
```

Configuration lives in ECA itself, either globally or per project. See the [ECA docs](https://eca.dev).

## GitHub rate limits

Release lookups go through the GitHub API, which allows 60 unauthenticated requests per hour. If you hit that limit, set a token. It doesn't need any scopes:

```bash
export GITHUB_TOKEN=...   # GH_TOKEN and GITHUB_API_TOKEN work too
```

If one of these tokens is expired, the plugin retries without it. mise can also send its own GitHub token (`MISE_GITHUB_TOKEN`, or your `gh` login). If that one has gone stale you'll see `401` errors; check it with `mise token github`.

## Platforms

|                             | eca | eca-cli          |
|-----------------------------|-----|------------------|
| Linux x64 / arm64           | yes | yes              |
| macOS Intel / Apple Silicon | yes | yes              |
| Windows x64                 | yes | no (use the jar) |

## Development

```bash
./test/test.sh   # links the plugin as eca and eca-cli, installs both, runs them
```

To release:

1. Bump `version` in `metadata.lua` and update `CHANGELOG.md`.
2. Tag and push:
   ```bash
   git tag -a v1.1.0 -m "Release v1.1.0"
   git push origin main v1.1.0
   ```
3. Create a GitHub release from the tag.

Pull requests are welcome. Please run `./test/test.sh` first.

## License

Apache-2.0, same as ECA.
