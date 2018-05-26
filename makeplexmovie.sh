#!/bin/sh

############################################
PLEX_MOVIE_LOCATION="/mnt/plexy/Plex/Movies/"
############################################

# REQUIRED -d --dir the movie dir
# OPTIONAL -b --both rename the movie and the dir to this (dont use -r and -m with this)
# OPTIONAL -r --rename rename the dir to this
# OPTIONAL -m --movie rename the movie to this (dont type extention)
# OPTIONAL -h --help show options

DIR=""
DIR_RENAME=""
MOVIE_RENAME=""

# read the options
TEMP=`getopt -o d:r:m:h --long dir:,rename:,movie:,help -n 'makeplexmovie.sh' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -d|--dir)
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
        -m|--movie)
            case "$2" in
                "") shift 2 ;;
                *) MOVIE_RENAME=$2 ; shift 2 ;;
            esac ;;
        -h|--help) echo -e "# REQUIRED -d --dir the movie dir
# OPTIONAL -b --both rename the movie and the dir to this (dont use -r and -m with this)
# OPTIONAL -r --rename rename the dir to this
# OPTIONAL -m --movie rename the movie to this (dont type extention)
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
    return "Must have dir.  For help use --help"
else
    cd "$DIR"
fi

# Finds a movie with type .mp4 or .mkv - stops on the first file found
MOVIE="$(find . -type f \( -name "*.mp4" -or -name "*.mkv" \) -print -quit)"
prefix="./"
MOVIE=${MOVIE#$prefix}
MOVIE_EXTENTION="${MOVIE##*.}"
MOVIE="${MOVIE%.*}"

if [ -z "$MOVIE" ]
then
    return "Could not find movie of type .mp4 or .mkv"
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

sudo mv "$DIR" "$PLEX_MOVIE_LOCATION" & sudo watch progress -w
