#!/bin/bash
#
######################
# bash_OS - The CLI OS
# version: alpha_8
# edition: Debian / Ubuntu
# author: Andi047
# date: 20.10.2021
######################


# TODO
#
# Add:
# mutt >> Mail client (apt, dnf)
# links2 >> advanced text web browser (apt) / links >> simple text only (dnf)
# telnet mapscii.me >> CLI world map (direct call, telnet needed on Fedora)
# nnn >> file manager (apt, dnf)
# ncdu >> disk analyser (apt, dnf)
# curl wttr.in/<location> >> weather forecast (direct call)
# neofetch >> system info (apt, dnf)
# ddgr >> search web with DuckDuckGo (apt, dnf)
# btop++ >> system monitor (snap)
#
#
# TODO
# for operability with RedHat based systems, it is necessary
# to install "newt" for whiptail operations in prerequisite.
#
# add:
# check for installed <newt> package
# nano text editor



# check, if running in root mode
if [[ $EUID != 0 ]]; then
  echo ""
  echo "bash_OS must be started as root user"
  echo "Please restart with 'sudo bash bash_OS.sh'."
  echo ""
  exit 1
fi

function print_help {
  echo ""
  echo "Usage: $0 [flags]"
  echo "Available flags:"
  echo "-h: print out this help"
  echo "-i: information about bash_OS"
  echo ""
}

function print_info {
  echo ""
  echo "bash_OS: A minimal OS getting the most out of your hardware."
  echo "Get a nice low-level, yet useful GUI with keyboard input."
  echo ""
  echo "Especially powerful with a minor GPU and low RAM."
  echo "Requires only a CLI-Interface / command prompt."
  echo ""
}

# parameter help
optstring=":hi"

while getopts ${optstring} options; do
  case ${options} in
    h)
      print_help
      exit 1;;
    i)
      print_info
      exit 1;;
    ?)
      echo "Unknown parameter. Try '-h' or '-i'."
      exit 1;;
  esac
done

# welcome screen
whiptail --msgbox "Welcome to bash_OS, the fast and extremely lightweight OS ! \n \n \
Press 'Enter' to continue." 20 78


# installation of CLI tools
function setup {
  whiptail --msgbox "In order to install the required apps, please \
  provide your password in the following process." 20 78

  cli_apps="mutt links2 mc"

  sudo su
  apt install ${cli_apps}
}


function help_info {
  whiptail --msgbox "bash_OS can launch different CLI-based apps. \n
  'links2' is the web-browser. It provides minimal graphical output and superior performance. \n
  'mutt' is the mail client. Support for the popular POP3 and IMAP protocol are included. \n
  'midnight commander' is the file manager and supports a broad range of operations. \n
  " 20 78
}


function help_about {
  whiptail --msgbox "bash_OS in essence is a script that manages different CLI programs. \n
  It is designed for systems with very low specifications (e.g. Netbooks) in mind and
  does not intend to replace a traditional desktop OS. \n
  Of course, CLI enthusiasts will enjoy the responsiveness and retro-like approach of this
  system. \n
  " 20 78
}


function print_weather {
  NAME=$(whiptail --inputbox "Get a weather forecast with 'wttr.in'. Please provide the name of your location:" 8 39 location --title "name of location:" 3>&1 1>&2 2>&3)
  
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    curl wttr.in/$NAME
  else
    whiptail --msgbox "You cancelled the input." 20 78
  fi
}


function launch_mapscii {
  whiptail --msgbox "Get the whole planet in full detail on your console with 'mapscii.me', based on Open-Street-Map. \n
  Use the mouse wheel and right-clicking with your mouse to navigate around. \n
  Press 'Q' to quit the app." 20 78
  
  telnet mapscii.me
}


function hardware_info {
  CLASS=$(whiptail --inputbox "Gather information about a specific component. Enter a classname. Available are: \n
  memory / cpu / firmware / pci / network / generic / storage / usb / display / multimedia / battery" 20 78 classname --title "Enter
  class here:" 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    lshw -c $NAME
  else
    whiptail --msgbox "You cancelled the input." 20 78
  fi
}


function utilities {
  while [ 1 ]; do
    CHOICE=$(whiptail --title "UTILITIES: Choose an option by pressing TAB and then ENTER" \
    --menu "Choose app to launch:" 16 100 9 \
    "1)" "Weather forecast for a location of your choice" \
    "2)" "Explore our planet with mapSCII" \
    "3)" "Get detailed information about hardware" \
    "4)" "Get back to main menu..." 3>&2 2>&1 1>&3 )
    
    case $CHOICE in
      "1)")
        print_weather
        exit
      ;;
      "2)")
        launch_mapscii
        exit
      ;;
      "3)")
        hardware_info
      ;;
      "4)")
        main_menu
      ;;
    esac
  done
}


# main menu

function main_menu {
while [ 1 ]; do
  CHOICE=$(whiptail --title "MAIN MENU: Choose an option and press TAB to OK" \
  --menu "Choose app to launch:" 16 100 9 \
  "1)" "Mail client" \
  "2)" "Web browser" \
  "3)" "File manager" \
  "4)" "Use utilities..." \
  "5)" "Update system..." \
  "6)" "Get help..." \
  "7)" "About bash_OS..." \
  "8)" "Finisch session and quit bash_OS" 3>&2 2>&1 1>&3 )  # verdreht stderr mit stout mittel Zwischenschritt

  case $CHOICE in
    "1)")
        #mutt
        exit
    ;;
    "2)")
        #links2 -g
        exit
    ;;
    "3)")
        #mc
        exit
    ;;
    "4)")
        utilities
        exit
    ;;
    "5)")
        whiptail --msgbox "bash_OS now triggers the update process." 20 78
        apt update && apt upgrade
    ;;
    "6)")
        help_info
    ;;
    "7)")
        help_about
    ;;
    "8)")
        whiptail --msgbox "Session in bash_OS quit. Press 'Enter' to exit back to CLI." 20 78
        exit
    ;;
  esac
done
}

main_menu
