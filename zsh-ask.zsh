# A lightweight Zsh plugin serves as a ChatGPT API frontend, enabling you to interact with ChatGPT directly from the Zsh.
# https://github.com/Michaelwmx/zsh-ask
# Copyright (c) 2023 Leachim

#--------------------------------------------------------------------#
# Global Configuration Variables                                     #
#--------------------------------------------------------------------#

0=${(%):-%N}
typeset -g ZSH_ASK_PATH=${0:A:h}
typeset -g ZSH_ASK_VERSION=$(<"$ZSH_ASK_PATH"/VERSION)


(( ! ${+ZSH_ASK_REPO} )) &&
typeset -g ZSH_ASK_REPO="Michaelwmx/zsh-ask"

# Get the corresponding endpoint for your desired model.
(( ! ${+ZSH_ASK_API_URL} )) &&
typeset -g ZSH_ASK_API_URL="https://api.openai.com/v1/chat/completions"

# Fill up your OpenAI api key here.
(( ! ${+ZSH_ASK_API_KEY} )) &&
typeset -g ZSH_ASK_API_KEY="sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Default configurations
(( ! ${+ZSH_ASK_CONVERSATION} )) &&
typeset -g ZSH_ASK_CONVERSATION=false
(( ! ${+ZSH_ASK_INHERITS} )) &&
typeset -g ZSH_ASK_INHERITS=false
(( ! ${+ZSH_ASK_MARKDOWN} )) &&
typeset -g ZSH_ASK_MARKDOWN=false
(( ! ${+ZSH_ASK_STREAM} )) &&
typeset -g ZSH_ASK_STREAM=false
(( ! ${+ZSH_ASK_TOKENS} )) &&
typeset -g ZSH_ASK_TOKENS=800
(( ! ${+ZSH_ASK_HISTORY} )) &&
typeset -g ZSH_ASK_HISTORY=""
(( ! ${+ZSH_ASK_INITIALROLE} )) &&
typeset -g ZSH_ASK_INITIALROLE="system"
(( ! ${+ZSH_ASK_INITIALROLE} )) &&
typeset -g ZSH_ASK_INITIALPROMPT="You are a large language model trained by OpenAI. Answer as concisely as possible.\nKnowledge cutoff: {knowledge_cutoff} Current date: {current_date}"

function _zsh_ask_show_help() {
  echo "A lightweight Zsh plugin serves as a ChatGPT API frontend, enabling you to interact with ChatGPT directly from the Zsh."
  echo "Usage: ask [options...]"
  echo "       ask [options...] '<your-question>'"
  echo "Options:"
  echo "  -h                Display this help message."
  echo "  -v                Display the version number."
  echo "  -i                Inherits conversation from last chat."
  echo "  -c                Enable conversation."
  echo "  -f <path_to_file> Enable file as query suffix."
  echo "  -m                Enable markdown rendering (glow required)."
  echo "  -s                Enable streaming (Beta, just for chat)."
  echo "  -t <max_tokens>   Set max tokens to <max_tokens>, default sets to 800."
  echo "  -u                Check for updates."
  echo "  -U                Upgrade this plugin."
  echo "  -d                Print debug information."
}

function _zsh_ask_check_update() {
  if local version=$(curl -s "https://raw.githubusercontent.com/$ZSH_ASK_REPO/master/VERSION") ; then
    if [[ "$version" != "$ZSH_ASK_VERSION" ]]; then
      echo "New version $version is available."
      echo "Run 'ask -U' to upgrade."
      return 0
    else
      echo "You are in the latest version."
      return 0
    fi
  else
    echo "Failed to check for updates."
    return 1
  fi
}

function _zsh_ask_upgrade() {
  if git -C $ZSH_ASK_PATH pull; then
    return 0
  else
    echo "Failed to upgrade."
    return 1
  fi
}

function _zsh_ask_show_version() {
  echo "$ZSH_ASK_VERSION"
}

function ask() {
    local api_url=$ZSH_ASK_API_URL
    local api_key=$ZSH_ASK_API_KEY
    local conversation=$ZSH_ASK_CONVERSATION
    local makrdown=$ZSH_ASK_MARKDOWN
    local stream=$ZSH_ASK_STREAM
    local tokens=$ZSH_ASK_TOKENS
    local inherits=$ZSH_ASK_INHERITS
    local history=""
    

    local usefile=false
    local filepath=""
    local requirements=("curl" "jq")
    local debug=false
    local satisfied=true
    local input=""
    while getopts ":hvcdmsiuUf:t:" opt; do
        case $opt in
            h)
                _zsh_ask_show_help
                return 0
                ;;
            v)
                _zsh_ask_show_version
                return 0
                ;;
            u)
                if _zsh_ask_check_update; then
                    return 0
                else
                    return 1
                fi
                ;;
            U)
                if ! which "git" > /dev/null; then
                    echo "git is required for upgrade."
                    return 1
                fi
                if _zsh_ask_upgrade; then
                    return 0
                else
                    return 1
                fi
                ;;
            c)
                conversation=true
                ;;
            d)
                debug=true
                ;;
            i)
                inherits=true
                ;;
            t)
                if ! [[ $OPTARG =~ ^[0-9]+$ ]]; then
                    echo "Max tokens has to be an valid numbers."
                    return 1
                else
                    tokens=$OPTARG
                fi
                ;;
            f)
                usefile=true
                if ! [ -f $OPTARG ]; then
                    echo "$OPTARG does not exist."
                    return 1
                else
                    if ! which "xargs" > /dev/null; then
                        echo "xargs is required for file."
                        satisfied=false
                    fi
                    filepath=$OPTARG
                fi
                ;;
            m)
                makrdown=true
                if ! which "glow" > /dev/null; then
                    echo "glow is required for markdown rendering."
                    satisfied=false
                fi
                ;;
            s)
                stream=true
                echo "\033[0;33mWarning:\033[0m Enable streaming is a testing feature that should only be used in text-only dialogue."
                ;;
            :)
                echo "-$OPTARG needs a parameter"
                return 1
                ;;
        esac
    done

    for i in "${requirements[@]}"
    do
    if ! which $i > /dev/null; then
        echo "$i is required."
        satisfied=false
    fi
    done
    if ! $satisfied; then
        return 1
    fi

    if $inherits; then
        history=$ZSH_ASK_HISTORY
    fi
    
    if [ "$history" = "" ]; then
        history='{"role":"'$ZSH_ASK_INITIALROLE'", "content":"'$ZSH_ASK_INITIALPROMPT'"}, '
    fi

    shift $((OPTIND-1))

    input=$*

    if $usefile; then
        input=$(echo "$input$(cat "$filepath")" | xargs echo)
    elif [ "$input" = "" ]; then
        echo -n "\033[32muser: \033[0m"
        read input
    fi


    while true; do
        history=$history' {"role":"user", "content":"'"$input"'"}'
        if $debug; then
            echo -E "$history"
        fi
        local data='{"messages":['$history'], "model":"gpt-3.5-turbo", "stream":'$stream', "max_tokens":'$tokens'}'
        echo -n "\033[0;36massistant: \033[0m"
        local message=""
        local generated_text=""
        if $stream; then
            local begin=true
            local token=""
            curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $api_key" -d $data $api_url | while read token; do
                if [ "$token" = "" ]; then
                    continue
                fi
                if $debug; then
                    echo $token
                fi
                token=$(echo -E $token | sed 's/^data://')
                if $debug; then
                    echo -E "$token"
                fi
                local delta_text=""
                if delta_text=$(echo -E $token | jq -re '.choices[].delta.content'); then
                    if [ $begin ] && [ $delta_text = "nn" ]; then
                        begin=false
                        continue
                    elif [[ $delta_text =~ nn$ ]]; then
                        delta_text='\n\n'
                    elif [[ $delta_text =~ [^a-zA-Z0-9]n$ ]]; then
                        delta_text='\n'
                    fi
                    begin=false
                    echo -n $delta_text
                    generated_text=$generated_text$delta_text
                fi
                if (echo -E $token | jq -re '.choices[].finish_reason' > /dev/null); then
                    echo ""
                    break
                fi
            done
            message='{"role":"assistant", "content":"'"$generated_text"'"}'
        else
            local response=$(curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $api_key" -d $data $api_url)
            if $debug; then
                echo -E "$response"
            fi
            message=$(echo -E $response | jq -r '.choices[].message');  
            generated_text=$(echo -E $message | jq -r '.content')
            if $makrdown; then
                echo $generated_text | glow
            else
                echo $generated_text
            fi
        fi
        history=$history', '$message', '
        ZSH_ASK_HISTORY=$history
        if ! $conversation; then
            break
        fi
        echo -n "\033[0;32muser: \033[0m"
        if ! read input; then
            break
        fi
    done
}