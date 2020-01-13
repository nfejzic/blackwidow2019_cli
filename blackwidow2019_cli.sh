#!/usr/bin/bash

# path to keyboard driver
dev_path="/sys/bus/hid/drivers/razerkbd/0003:1532:0241.0003"

# default colors
fKeys="\xff\xa2\x00" # - warm yello - wand ESC key 
letters="\x00\xff\x80" # - seafoam green
modK="\xff\x22\x00" # - orangish red - Mod keys such as ctrl, used for hjkl in my case
posK="\xff\xa2\x00" # - same as fKeys - Position keys - home, pos1, page up / down etc.
numK="\x00\x80\xff" # - sky blue
none="\x0\x0\x0" # empty, I don't have these keys on my keyboard
other="\xff\xa2\x00" # any other keys - currently not used on my keyboard

function assignColor {
    selector=$1
    color=$2

    case $selector in

        fKeys)
            fKeys="$color"
            ;;
        letters)
            letters="$color"
            ;;
        modK)
            modK="$color"
            ;;
        posK)
            posK="$color"
            ;;
        numK)
            numK="$color"
            ;;
        other)
            other="$color"
            ;;
        *)
            echo -e "Invalid selector!\n"
            echo -e "Usage:"
            echo -e "     selector=color in hexadecimal format for RGB values. \n"
            echo -e "     For example: fKeys=FF0000"
            echo -e "     This sets the F1 - F12 keys to red color. \n"
            echo -e "     Available selectors: "
            echo -e "     fKeys | letters | modK | posK | numK | other"
            ;;
    esac

}

if [[ "$1" =~ [0-9]{4}:[0-9]{4}:[0-9]{4}\.[0-9]{4} ]]
then
    dev_path="/sys/bus/hid/drivers/razerkbd/$1"
    echo -e "Device path: $dev_path \n"
    shift
else
    echo "First parameter should be the id of your keyboard device!"
    echo "For example: 0003:1532:0241.0003"
    exit 1
fi

while [ "$1" != "" ]; do
    # get the selector part of the parameter, for example fKeys
    selector=$(echo "$1" | grep -oP "(?=.+=)\w*")
    # get the color in hex code in format 000000 - for black FFFFFF - for white
    color=$(echo "$1" | grep -oP "(?<==).*")

    echo "Color is : $color"

    # extract red, green and blue hex values
    red="${color:0:2}"
    green="${color:2:2}"
    blue="${color:4:2}"

    # write to the color variable in format \x00\x00\x00 - for black
    color="\\x$red\\x$green\\x$blue"

    assignColor $selector $color
    shift
done

# output color values just for info
echo ""
echo "fKeys: $fKeys"
echo "letters: $letters"
echo "modK: $modK"
echo "posK: $posK"
echo "numK: $numK"
echo "other: $other"

# push the color values into keyboard memory
echo -n -e "\x0\x0\x15$none$fKeys$none$fKeys$fKeys$fKeys$fKeys$fKeys$fKeys$fKeys$fKeys$fKeys$fKeys$fKeys$fKeys$other$other$other$none$none$none$none" >| $dev_path/matrix_custom_frame
echo -n -e "\x1\x0\x15$none$numK$numK$numK$numK$numK$numK$numK$numK$numK$numK$numK$numK$numK$numK$posK$posK$posK$numK$numK$numK$numK" >| $dev_path/matrix_custom_frame
echo -n -e "\x2\x0\x15$none$modK$letters$letters$letters$letters$letters$letters$letters$letters$letters$letters$letters$letters$modK$posK$posK$posK$numK$numK$numK$numK" >| $dev_path/matrix_custom_frame
echo -n -e "\x3\x0\x15$none$modK$letters$letters$letters$letters$letters$modK$modK$modK$modK$letters$letters$letters$modK$none$none$none$numK$numK$numK$none" >| $dev_path/matrix_custom_frame
echo -n -e "\x4\x0\x15$none$modK$letters$letters$letters$letters$letters$letters$letters$letters$letters$letters$letters$none$modK$none$modK$none$numK$numK$numK$numK" >| $dev_path/matrix_custom_frame
echo -n -e "\x5\x0\x15$none$modK$fKeys$modK$letters$letters$letters$letters$none$none$modK$letters$fKeys$fKeys$modK$modK$modK$modK$none$numK$numK$none" >| $dev_path/matrix_custom_frame

# apply the custom effect, that is custom colors
echo -n "1" > $dev_path/matrix_effect_custom

# kill openrazer-daemon as it prevents usage of fn keys
for i in {1..5}
do
    if [ "$(pidof openrazer-daemon)" != "" ]
        then
            openrazer-daemon -s
            sleep 2
    else
        break
    fi
done
