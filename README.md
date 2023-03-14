# zsh-ask

A lightweight Zsh plugin serves as a ChatGPT API frontend, enabling you to interact with ChatGPT directly from the `Zsh` shell using only `cURL` and `jq`.

## Installation

See [INSTALL.md](INSTALL.md).

## Preliminaries

Make sure you have [`cURL`](https://curl.se/) and [`jq`](https://stedolan.github.io/jq/) installed.

If you would like to have markdown rendering with option `-m`, [`glow`](https://github.com/charmbracelet/glow) is required (Recommend).

## Usage

Fill your OpenAI api key as `ZSH_ASK_API_KEY` (See [INSTALL.md](INSTALL.md) for detail information), then just run

```bash
ask '<what you about to ask>'
```

Use `-c` for dialogue format communication.

```bash
ask -c
```

Use `-m` for markdown rendering (glow required)

```bash
ask -m
```

Use `-h` for more information.

```bash
ask -h
```

Have fun!
