# zsh-ask

A lightweight Zsh plugin serves as a ChatGPT API frontend, enabling you to interact with ChatGPT directly from the `Zsh` shell using only `cURL` and `jq`.

## Installation

See [INSTALL.md](INSTALL.md) or run `source zsh-ask.zsh` for a quick start.

## Preliminaries

Make sure you have [`cURL`](https://curl.se/) and [`jq`](https://stedolan.github.io/jq/) installed.

If you would like to have markdown rendering with option `-m`, [`glow`](https://github.com/charmbracelet/glow) is required (Recommend).

## Usage

Fill your OpenAI api key as `ZSH_ASK_API_KEY` (see [INSTALL.md](INSTALL.md) for detail information), then just run

```
ask who are you
```

Use `-c` for dialogue format communication.

```
ask -c chat with me
```

Use `-m` for markdown rendering (`glow` required)

```
ask -m how to code quick sort in python
```

Use `-s` for streaming display (doesn't work with `-m` yet)

```
ask -s write a poem for me
```

Use `-i` to inherits history from last chat (which is recorded in ZSH_ASK_HISTORY).

```
ask -i tell me more about it
```

Use `-h` for more information.

```
ask -h
```

Have fun!

## License

This project is licensed under [MIT license](http://opensource.org/licenses/MIT). For the full text of the license, see the [LICENSE](LICENSE) file.