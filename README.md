# makeplexmovie

Preps a movie for plex by stripping extraneous files, offering rename options, and then moving it to plex movie location.

# Install

Clone to script folder

In .bashrc add:
`alias makeplexmovie='. /path/to/script/folder/makeplexmovie.sh'`

Must change `PLEX_MOVIE_LOCATION` to the path of the plex movie folder

# Options

REQUIRED -d --dir the movie dir

OPTIONAL -b --both rename the movie and the dir to this (dont use -r and -m with this)

OPTIONAL -r --rename rename the dir to this

OPTIONAL -m --movie rename the movie to this (dont type extention)

OPTIONAL -h --help show options
