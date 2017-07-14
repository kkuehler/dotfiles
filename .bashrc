#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=/usr/bin/vim

# shell opts: see bash(1)
shopt -s cdspell dirspell checkwinsize

alias ls='ls --group-directories-first --color=auto -F'
alias ll='ls -l --group-directories-first --color=auto -F'
alias lla='ls -la --group-directories-first --color=auto -F'
alias df='df -h'
alias fol='source ~/scripts/follow.sh'
alias godark='sudo openvpn --config $HOME/.config/cryptostorm/cstorm_linux-uswest_udp.ovpn --auth-nocache --daemon'
alias morning='sudo pacman -Syu && $HOME/scripts/upgrade_aur.sh'


export PS1="\[\e[0;49;31m\][\[\e[0;49;32m\]\u\[\e[0;49;33m\]@\[\e[0;49;36m\]\h \[\e[0;39;35m\]\W\[\e[0;49;31m\]]\[\e[0;49;37m\]\\$ \[$(tput sgr0)\]"

# External config
if [[ -r ~/.dircolors ]] && type -p dircolors >/dev/null; then
  eval $(dircolors -b "$HOME/.dircolors")
fi

streaming() {
    INRES="1600x900" # input resolution
    OUTRES="1600x900" # output resolution
    FPS="30" # target FPS
    GOP="60" # i-frame interval, should be double of FPS,
    GOPMIN="30" # min i-frame interval, should be equal to fps,
    THREADS="2" # max 6
    CBR="1000k" # constant bitrate (should be between 1000k - 3000k)
    QUALITY="ultrafast"  # one of the many FFMPEG preset
    AUDIO_RATE="44100"
    STREAM_KEY="$1" # use the terminal command Streaming streamkeyhere to stream your video to twitch or justin
    SERVER="live-lax" # twitch server in Los Angeles, see http://bashtech.net/twitch/ingest.php for list

    ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0 -f alsa -i pulse -f flv -ac 2 -ar $AUDIO_RATE \
      -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
      -s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -threads $THREADS -strict normal \
      -bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"
}
