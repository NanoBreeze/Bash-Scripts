#!/bin/bash
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin # allows crontab to use environment variables

# 1. Check that the downloaded image doesn't already exist. If it does, exit (assumes that it is already the wallpaper)
# 2. Go to https://apod.nasa.gov/apod/ap{year}{month}{date}.html
# 3. Regex for the path to the image
# 4. Combine the path with the vase path (https://apod.nasa.gov/apod/) and download the image
# 5. Set the image as the screen saver

basePath='https://apod.nasa.gov/apod/'

year=$(date+"%y")
month=$(date+"%m")
day=$(date+"%d")

imageDestination="/Users/$USER/Downloads/nasa_${year}_${month}_${day}.jpg"

if [ -f "$imageDestination" ]; then
	echo "The image at $imageDestination already exists. Exiting"
	exit 0
fi

hrefAttribute=$(curl "${basePath}ap${year}${month}${day}.html" | grep -io "href=\"image\/.*\"")
imagePath=$(echo "$hrefAttribute" | grep -io "\".*\"" | tr -d '"') # Extract the path, which is between the quotes

imageSource=${basePath}${imagePath}

$(curl "$imageSource" -o "$imageDestination")

echo "Download complete. The image is at: $imageDestination" # Note: This might be displayed even if the image destination is invalid

$(osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$imageDestination\"")