# Installation

Acquire your private api-key from [OpenAI](https://platform.openai.com/account/api-keys).

## Oh My Zsh

1. Clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`)

```sh
git clone https://github.com/Licheam/zsh-ask ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-ask
```

2. Add the plugin to the list of plugins for Oh My Zsh to load (inside `~/.zshrc`):

```sh
plugins=( 
   # other plugins...
   zsh-ask
)
```

3. Add the following to your `.zshrc`:
```sh
export ZSH_ASK_API_KEY="<Your API key here>"
```

## Manual (Git Clone)

1. Clone this repository somewhere on your machine. This guide will assume `$HOME/.zsh/zsh-ask`.
   ```sh
   git clone https://github.com/Licheam/zsh-ask $HOME/.zsh/zsh-ask
   ```
2. Add the following to your `.zshrc`:
   ```sh
   export ZSH_ASK_API_KEY="<Your API key here>"
   source $HOME/.zsh/zsh-ask/zsh-ask.zsh
   ```
3. Start a new terminal session.

## Uninstallation

1. Remove the code referencing this plugin from `~/.zshrc`.
2. Remove the git repository from your hard drive.
