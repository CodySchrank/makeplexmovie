#!/bin/sh

############################################
PLEX_MOVIE_LOCATION="/mnt/plexy/Plex/Movies/"
############################################

DIR=""
DIR_RENAME=""
MOVIE_RENAME=""
WATCH=0

# read the options
TEMP=`getopt -o b:d:r:m:h --long both:,dir:,rename:,movie:,help -n 'makeplexmovie.sh' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -b|--both)
            case "$2" in
                "") shift 2 ;;
                *) DIR_RENAME=$2 ; MOVIE_RENAME=$2 ; shift 2 ;;
            esac ;;
        -d|--dir)
            case "$2" in
                "") shift 2 ;;
                *) DIR=$2 ; shift 2 ;;
            esac ;;
        -r|--rename)
            case "$2" in
                "") shift 2 ;;
                *) DIR_RENAME=$2 ; shift 2 ;;
            esac ;;
        -w|--watch)
            case "$2" in
                "") shift 2 ;;
                *) WATCH=1 ; shift 2 ;;
            esac ;;
        -m|--movie)
            case "$2" in
                "") shift 2 ;;
                *) MOVIE_RENAME=$2 ; shift 2 ;;
            esac ;;
        -h|--help) echo -e "# OPTIONAL -d --dir the movie dir (if none provided script looks in closest dirs for any movie file and continues)
# OPTIONAL -b --both rename the movie and the dir to this (dont use -r and -m with this)
# OPTIONAL -r --rename rename the dir to this
# OPTIONAL -m --movie rename the movie to this (dont type extention)
# OPTIONAL -w --watch watch progress of moving file
# OPTIONAL -h --help show options"
            return; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

TEMP=""

echo -e "Ok lets go!\n"

if [ -z "$DIR" ]
then
    echo -e "No dir specified so attempting to find one"
    DIR="$(find . -mindepth 1 -maxdepth 1 -type d)"
fi

cd "$DIR"

# Finds a movie file (stops on the first file found)
MOVIE="$(find . -type f \( -name "*.mp4" -or -name "*.mkv" -or -name "*.avi" \)) -print -quit"
prefix="./"
MOVIE=${MOVIE#$prefix}
MOVIE_EXTENTION="${MOVIE##*.}"
MOVIE="${MOVIE%.*}"

if [ -z "$MOVIE" ]
then
    return "Could not find movie of type .mp4, .mkv, or .avi"
else
    echo -e "Found: $MOVIE\n"
    echo -e "It is $MOVIE_EXTENTION\n"
fi

# Remove extraneous files
sudo rm -rf *.txt
sudo rm -rf *.nfo
sudo rm -rf *.jpg
sudo rm -rf *.png

# Subtitles are nice
count=`ls -1 *.srt 2>/dev/null | wc -l`
if [ $count != 0 ]
then 
    echo -e "Has subtitles!\n"
else
    echo -e "No subtitles!\n"
fi

cd ..

if [ -n $"$DIR_RENAME" ]
then
    sudo mv "$DIR" "$DIR_RENAME"
    DIR="$DIR_RENAME"
fi

if [ -n "$MOVIE_RENAME" ]
then
    cd "$DIR"
    sudo mv "$MOVIE"."$MOVIE_EXTENTION" "$MOVIE_RENAME"."$MOVIE_EXTENTION"
    MOVIE="$MOVIE_RENAME"
    cd ..
fi

# DONT USE DIR_RENAME OR MOVIE_RENAME FROM HERE 
if [ $WATCH == 1 ]
then
    sudo mv "$DIR" "$PLEX_MOVIE_LOCATION" & sudo watch progress -w
else
    sudo mv "$DIR" "$PLEX_MOVIE_LOCATION"
fi