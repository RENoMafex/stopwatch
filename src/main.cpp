#include <iostream>
#include <fstream>
#include <cstring>
#include <ctime>
#include "stopwatch.hpp"
#include <boost/chrono/chrono.hpp>

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
void print_minmaxavg(const stopwatch::checkpoints_t& checkpoints);

int main(int argc, char* argv[]){
	using namespace std::literals;
	namespace sw = stopwatch;

	bool stopflag = false;
	bool  logflag = false;

	int row = 1;
	int col = 0;

	sw::checkpoints_t checkpoints = {};

	std::ofstream logfile;

	if (argc > 1) {
		if (!strcmp(argv[1], "-l") && argc == 3) {
			logflag = true;
			auto t = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
			std::tm d = *std::localtime(&t);

			logfile.open(argv[2], std::ios::out | std::ios::app);
			logfile << "\n-\nLogging began at "
				<< d.tm_year+1900 << '-'
				<< d.tm_mon << '-'
				<< d.tm_mday << ' '
				<< d.tm_hour << ':'
				<< d.tm_min << ':'
				<< d.tm_sec << '.'
				<< sw::make_output(sc_(u64, std::chrono::duration_cast<std::chrono::milliseconds>(
					std::chrono::system_clock::now().time_since_epoch()
				).count()) % 1000).substr(8)
			<< std::endl;
		} else if (!strcmp(argv[1], "-l")) {
			std::cout << "You need to specify a log file name!" << std::endl;
			std::cout << "Usage of \"-l\":" << std::endl;
			std::cout << argv[0] << " -l logfilename" << std::endl;
			return 1;
		} else {
			std::cout << "Usage:" << std::endl;
			std::cout << argv[0] << std::endl;
			std::cout << "or:" << std::endl;
			std::cout << argv[0] << " -l logfilename" << std::endl;
			return 1;
		}
	}

	auto start = sw::init();

	nodelay(stdscr, true);
	printw("%s", "Checkpoint: ");
	attron(A_DIM);
	printw("%s", "Time since last checkpoint:");
	attroff(A_DIM);

	while (stopflag == false) {
		print_help();
		print_minmaxavg(checkpoints);
		move(row, col);
		printw("%s", sw::make_output(start).c_str());
		refresh();
		sw::delayMicros(500);

		s32 key = getch();

		if (key == KEY_SPACE) [[unlikely]] {
			sw::trig_checkpoint(checkpoints, start);
			attron(A_DIM);
			printw("%c%s%c",' ' , sw::make_output(checkpoints.back()).c_str(), '\n');
			attroff(A_DIM);
			row++;
		} else if (key == KEY_ENTER) [[unlikely]] {
			sw::trig_checkpoint(checkpoints, start);
			stopflag = true;
		} else [[likely]] {
			clearline();
		}
	}
	endwin();
	printf("%s%s%c", "Stopwatch stopped at: ", sw::make_output(start).c_str(), '\n');
	if (!checkpoints.empty()) [[likely]] {
		printf("%s%ld%s", "With ", checkpoints.size(), " Checkpoints\n");
	}
	if (logflag) {
		logfile << "Number of triggered checkpoints: " << checkpoints.size() << std::endl;

		size_t cp_count = 0;
		for (auto cp : checkpoints) {
			logfile << ++cp_count << '\t' << ' ' << sw::make_output(cp) << std::endl;
		}

		logfile.close();
		printf("%s%s%c", "Log saved to ", argv[2], '\n');
	}



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
		"      How to use:      "sv,
		"[SPACEBAR] = Checkpoint"sv,
		" [RETURN]  = Exit      "sv,
		"                       "sv,
		"      h:min:sec.ms     "sv,
		"                       "sv
	};

	const s32 max_x = getmaxx(stdscr);
	s32 help_size = 0;
	for (const auto line : lines) {
		help_size = (sc_(s32,(line.length())) > help_size) ? sc_(s32,(line.length())) : help_size;
	}

	help_size++;
	move(0, max_x - help_size);
	attron(A_BOLD);
	for (auto line : lines){
		printw("%s", line.data());
		move(getcury(stdscr) + 1, max_x - help_size);
	}
	attroff(A_BOLD);
	move(old_row, old_col);
} // void print_help()

void print_minmaxavg(const stopwatch::checkpoints_t& checkpoints){
	attron(COLOR_PAIR(2));
	int old_col = getcurx(stdscr);
	int old_row = getcury(stdscr);

	using str = std::string;
	using namespace std::string_literals;

	std::vector<str> lines = {
		"       Checkpoints:  "s +
			(checkpoints.size() < std::size_t(10) ? "0"s + std::to_string(checkpoints.size()) : std::to_string(checkpoints.size())),
		"       min: "s + stopwatch::make_output(stopwatch::calc_min(checkpoints)),
		"       max: "s + stopwatch::make_output(stopwatch::calc_max(checkpoints)),
		"       avg: "s + stopwatch::make_output(stopwatch::calc_avg(checkpoints))
	};

	const s32 max_x = getmaxx(stdscr);
	s32 minmaxavg_size = 0;
	for (const auto& line : lines) {
		minmaxavg_size = (sc_(s32,(line.length())) > minmaxavg_size) ? sc_(s32,(line.length())) : minmaxavg_size;
	}

	minmaxavg_size++;
	move(6, max_x - minmaxavg_size);
	attron(COLOR_PAIR(2));
	for (auto line : lines){
		printw("%s", line.data());
		move(getcury(stdscr) + 1, max_x - minmaxavg_size);
	}
	attroff(COLOR_PAIR(2));

	move(old_row, old_col);
} // void print_minmaxavg()
