#!/bin/bash

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "dialog is not installed. Installing..."
    sudo apt install -y dialog
fi

# Function to install selected packages
install_packages() {
    sudo apt install -y "$@"
}

# Function to run install scripts
run_script() {
    script_path="$1"
    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        dialog --msgbox "Error: Script not found - $script_path" 10 90
    fi
}

# Categories and Packages
declare -A categories=(
    ["File Managers"]="ranger nnn lf thunar pcmanfm nemo dolphin"
    ["Terminals"]="alacritty kitty foot xfce4-terminal"
    ["Text Editors"]="micro vim geany kate mousepad"
    ["Web Browsers"]="librewolf qutebrowser falkon lynx w3m"
    ["Multimedia"]="mpv vlc ffmpeg flameshot sxiv gimp inkscape"
    ["Music & Audio"]="ncmpcpp mpd deadbeef pulsemixer pavucontrol sox"
    ["Development Tools"]="tmux fzf fd ripgrep"
    ["System Utilities"]="htop btop neofetch bat tree curl wget brightnessctl numlockx"
    ["Networking & Security"]="nm-tray whois nmap tcpdump wireshark"
)

selected_packages=()

# Function to display a checklist using dialog
show_menu() {
    local category_name=$1
    local options=()
    local packages=(${categories[$category_name]})

    for pkg in "${packages[@]}"; do
        options+=("$pkg" "$pkg" "off")
    done

    choices=$(dialog --stdout --separate-output --checklist "Select $category_name to install:" 20 90 15 "${options[@]}")
    if [ -n "$choices" ]; then
        selected_packages+=($choices)
    fi
}

# Loop through categories
for category in "${!categories[@]}"; do
    show_menu "$category"
done

# Binary Installations
binary_scripts=(
    "Zen Browser ~/.config/suckless/scripts/zen-install.sh"
    "Firefox (Latest) ~/.config/suckless/scripts/firefox-latest.sh"
    "Discord ~/.config/suckless/scripts/discord.sh"
    "Neovim (Latest) "
    "Just A Guy Linux Neovim Config"
)

binary_choices=()
for entry in "${binary_scripts[@]}"; do
    name="${entry% *}"
    path="${entry#* }"
    binary_choices+=("$name" "$name" "off")
done

binary_selections=$(dialog --stdout --separate-output --checklist "Select additional software to install:" 20 90 15 "${binary_choices[@]}")

for selection in $binary_selections; do
    case $selection in
        "Zen Browser") run_script "~/.config/suckless/scripts/zen-install.sh" ;;
        "Firefox (Latest)") run_script "~/.config/suckless/scripts/firefox-latest.sh" ;;
        "Discord") run_script "~/.config/suckless/scripts/discord.sh" ;;
        "Neovim (Latest)") 
            wget -O /tmp/nvim-linux-x86_64.deb "https://github.com/drewgrif/nvim/blob/main/nvim-linux-x86_64.deb"
            sudo dpkg -i /tmp/nvim-linux-x86_64.deb
            ;;
        "Just A Guy Linux Neovim Config")
            git clone https://github.com/drewgrif/nvim ~/.config/nvim
            ;; 
    esac
done

# Confirm and install selected packages
if [ ${#selected_packages[@]} -gt 0 ]; then
    dialog --yesno "Proceed with installing selected packages?" 10 90
    if [ $? -eq 0 ]; then
        install_packages "${selected_packages[@]}"
        dialog --msgbox "Installation complete!" 10 90
    else
        dialog --msgbox "Installation canceled." 10 90
    fi
else
    dialog --msgbox "No additional packages selected." 10 90
fi

clear
