# blackwidow2019_cli
Small CLI script for setting up Razer Blackwidow 2019 keyboard. Basic layout is chosen, colors can be manually setup.

## What is it for?
I got myself a Razer Blackwidow 2019 keyboard, and soon found out that the configuration is really limited on Linux.
There exists a driver - [OpenRazer](https://openrazer.github.io), but no complete front-end to set the keyboard easily.

On top of that, on my machine, while openrazer-daemon runs my FN key doesn't function, and therefore can't use the media keys like volume up and down etc.
That's why I created this script.

## Usage

This is a simple bash script, which accepts few parameters. First one is a must, and is a keyboard id.
It is formatted as: ```xxxx:xxxx:xxxx.xxxx``` and can be found in ```/sys/bus/hid/drivers/razerkbd/``` folder.

After this parameter, colors can be specified like this: selector=color
Color is to be specified in HEX format for RGB values, for example ```ff0000``` for **red**.
Selector is one of the specified:

**fKeys** - for FN keys, Super (Windows logo) and FN key

**letters** - for all the letters, except hjkl - these use other color... I like this as a VIM user

**modK** - for modificator keys, such as CTRL, ALT, and in my case hjkl keys

**posK** - for Positional keys ( I don't know what to call them ) - these are Home, End, Page Up/Down etc.

**numK** - Row of keys above letters + numpad keys

**other** - for any other keys, altough for now, I don't use them in my script


#### Default colors are:
**fKeys** = ffa200

**letters** = 00ff80

**modK** = ff2200

**posK** = ff8000

**numK** = 0080ff

**other** = ff8000


Colors chosen with the help of : https://www.sessions.edu/color-calculator/

This script can be run as systemd service at startup for automatic coloring of keyboard on system boot.

### Systemd config

Systemd script - name it what you want, I named it **razer-setup.service**

#### razer-setup.service
```
[Unit]
Description=Stop the openrazer-daemon so that media keys function
After=suspend.target

[Service]
ExecStart=/home/username/.config/custom_scripts/blackwidow2019_cli.sh 0003:1532:0241.0003

[Install]
WantedBy=multi-user.target sleep.target

```

**Keep in mind** that the ```/home/username/.config/custom_script/blackwidow2019_cli.sh``` is path to this script! Replace ```username``` with your username, and complete path with wherever you placed the ```blackwidow2019_cli.sh``` script!

Place the **razer-setup.service** file in ```~/.config/systemd/user/``` directory.

Then run these commands in terminal

```systemd --user daemon-reload``` - to detect new systemd script
```systemd --user enable razer-setup.service``` - to enable the script at startup

## Feedback

Feel free to write me a feedback, or extend and make your own script as you wish!
Have fun!
