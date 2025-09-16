# stopwatch
Well, this is just a very simple stopwatch for the terminal.
> [!NOTE]
> This branch only works on systems, that support `ncurses.h`.
> There also is a crossplatform branch, which only utilizes the C++17 STL.

## Building the executable
First you need to make sure, that ncurses is installed.
After that simply invoke `make release` inside the directory, it will build the executable inside the top level folder. If you want to know the possible options of the Makefile, simply run `make help`. <br>
By only running `make` the executable gets built in debug mode.

## Usage
Simply start the stopwatch up, a help message will be in the top right corner.<br>
If you want to log the checkpoints, simply invoke `stopwatch -l logname`, it will save a log inside the current directory.
