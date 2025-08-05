#include "stopwatch.hpp"

#pragma region redefines
#ifdef KEY_ENTER
#undef KEY_ENTER
#endif
#ifdef KEY_SPACE
#undef KEY_SPACE
#endif
#define KEY_ENTER 10
#define KEY_SPACE 32
#pragma endregion

void clearline();
void print_help();
void reg_checkpoint();

int main(){
	using namespace std::string_literals;
	using namespace std::string_view_literals;
	namespace sw = stopwatch;

	bool stopflag = false;
	const auto start = sw::init();
	u32 current_line = 0;

	nodelay(stdscr, true);

	while (stopflag == false) {
		print_help();
		printw("%s", sw::make_output(start).data());
		sw::delayMicros(500);
		refresh();

		s32 key = getch();
		if (key == KEY_SPACE) {
			reg_checkpoint();
		} else {
			clearline();
		}

		if (key == KEY_ENTER) {
			stopflag = true;
		}


	}


	endwin();
	return 0;
}

void clearline(){
	s32 row = getcury(stdscr);
	move(0, row);
	clrtoeol();
}

void print_help(){
/*	using sv = std::string_view;
//	sv line1 = "How to use:";
//	sv line2 = "[SPACEBAR] = Register checkpoint";
//	sv line3 = "[RETURN / ENTER] = Exit";
//	int max_x = getmaxx(stdscr);
//	move(max_x - line1.length(),0);
*/// redo this function, its far from finished, also its shitty right now lol
}
