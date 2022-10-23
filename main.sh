#! /bin/bash
clear

# Declaring variables
declare -Ag deps=([node]="nodejs" [npm]="npm" [git]="git") # Pre-Defined dependencies
declare -Ag package_managers=([arch]="pacman -Sy" [debian]="apt-get install" [fedora]="dnf install")
declare -ag missing_deps=() # Packages to be installed get added here

declare user_editor=""; # Gets the user-prefered code editor
declare user_linux=""; # Gets the user's installed linux

declare red="\e[31m";
declare green="\e[32m";


declare -A compatible_pm=([arch]="pacman -Sy " [debian]="apt-get install ");

declare -ag compatible_editors=("vscode" "neovim" "sublime")
declare -ag compatible_linux=("arch" "debian")

if [ "$EUID" -ne 0 ]
  then echo -e "${red}[ERROR] : USER_NOT_SUDO ( https://kimide.github.io/ndk/errors/000x4.html for more information. )"
  exit
fi

function install_deps() {
  for pm in ${!compatible_pm[@]}; do
    ${compatible_pm[$pm]} $1
    clear
    echo -e "${green}[Success] : NDK Finished downloading the dependencies."
  done
};

# Reading user input
printf "Compatible Linux Operating Systems:\n(${compatible_linux[*]})\n";
read -rep "Which linux are you currently using? > " user_linux
clear;

printf "Available code editors:\n(${aval_editor[@]})\n"
read -rep "Which of listed code editors would you like to be installed? > " user_editor
clear

# Making sure that the user_linux is the same as the one in /etc/os-release

if [[ ! "ID_LIKE=${user_linux}" == "$( cat /etc/os-release | grep 'ID_LIKE=' )" ]]; then
  echo -e "${red}[ERROR] : INVALID_LINUX_INPUT ( https://kimide.github.io/ndk/errors/000x1.html for more information. )"
fi;

for dependency in "${deps[*]}"; do
    missing_deps+=($dependency $user_editor);
done


if [[ "${#missing_deps[@]}" != 0 ]]; then
    install_deps ${missing_deps[@]}
else
  echo -e "${red}[ERROR] : DEPENDENCIES_COULD_NOT_PROVIDE ( https://kimide.github.io/ndk/errors/000x2.html for more information. )"
fi

