#include <iostream>
#include "stopwatch.hpp"

#pragma region redefines
#ifdef KEY_ENTER
#undef KEY_ENTER
#endif
#ifdef KEY_SPACE
#undef KEY_SPACE
#endif
#ifdef sc_
#undef sc_
#endif
#define KEY_ENTER 10
#define KEY_SPACE 32
#define sc_(T,x) static_cast<T>(x)
#pragma endregion

void clearline();
void print_help();

int main(){
	using namespace std::string_literals;
	using namespace std::string_view_literals;
	namespace sw = stopwatch;

	bool stopflag = false;
	auto start = sw::init();

	int row = 0;
	int col = 0;

	sw::checkpoints_t checkpoints = {};

	nodelay(stdscr, true);

	while (stopflag == false) {
		move(row, col);
		print_help();
		printw("%s", sw::make_output(start).c_str());
		sw::delayMicros(500);
		refresh();


		s32 key = getch();

		if (key == KEY_SPACE) [[unlikely]] {
			sw::trig_checkpoint(checkpoints, start);
			printw("%c%s",' ' , sw::make_output(checkpoints).c_str());
			row++;
		} else if (key == KEY_ENTER) [[unlikely]] {
			stopflag = true;
		} else [[likely]] {
			clearline();
		}
	}
	endwin();
	printf("%s%s%c", "Stopwatch stopped at: ", sw::make_output(start).c_str(), '\n');
	// std::cout << sw::make_output(start) << std::endl; //<- somehow doesnt work?!

	return 0;
} // main()

#pragma region function_definitions

void clearline(){
	s32 row = getcury(stdscr);
	move(row, 0);
	clrtoeol();
}

void print_help(){
	int old_col = getcurx(stdscr);
	int old_row = getcury(stdscr);

	using sv = std::string_view;
	using namespace std::string_view_literals;
	std::vector<sv> lines = {
		"      How to use:"sv,
		"[SPACEBAR] = Checkpoint"sv,
		" [RETURN]  = Exit"sv,
		""sv,
		"      h:min:sec.ms"sv
	};

	const s32 max_x = getmaxx(stdscr);
	s32 help_size = 0;
	for (const auto line : lines) {
		help_size = (sc_(s32,(line.length())) > help_size) ? sc_(s32,(line.length())) : help_size;
	}

	help_size++;
	move(0, max_x - help_size);
	attron(A_BOLD);
	for(auto line : lines){
		printw("%s", line.data());
		move(getcury(stdscr) + 1, max_x - help_size);
	}
	attroff(A_BOLD);
	move(old_row, old_col);
} // void print_help()
