# Installation

## Manual (Git Clone)

1. Clone this repository somewhere on your machine. This guide will assume `$HOME/.zsh/zsh-ask`.
   ```shell
   git clone https://github.com/Licheam/zsh-ask $HOME/.zsh/zsh-ask
   ```
2. Acquire your private api-key from [OpenAI](https://platform.openai.com/account/api-keys).
3. Add the following to your `.zshrc`:
   ```shell
   export ZSH_ASK_API_KEY="<Your API key here>"
   source $HOME/.zsh/zsh-ask/zsh-ask.zsh
   ```
4. Start a new terminal session.

## Uninstallation

1. Remove the code referencing this plugin from `~/.zshrc`.
2. Remove the git repository from your hard drive
