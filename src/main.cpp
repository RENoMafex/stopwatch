#include <chrono>
#include <iostream>
#include <string_view>
#include <csignal>
#include <atomic>

#include "structs.hpp"
#include "functions.hpp"

int main(int argc, char** argv){
	std::signal(SIGINT, [](int){stop_flag = true;});

	using namespace localOverloads;
	using namespace localFunctions;
	using clock = std::chrono::steady_clock;

	// initialize starting point
	clock::time_point start = clock::now();

	switch (argc){
		case 1:
			std::cout << "0:00:00.000\n" <<
			/*         */"Return = Set checkpoint\n" <<
			/*         */"CTRL+C = Stop stopwatch" << std::flush;

			//go back to the first line and start the stopwatch displaying cycle.
			std::cout << ANSI::up_line << ANSI::up_line << std::flush;
			stopwatch(start);

			std::cout << "\n\n" << ANSI::bold << "Stopped stopwatch at:\n" << stopwatch(start) << ANSI::reset << std::endl;

			return 0;

		default:
			std::cout << ANSI::bold << "Usage:" << ANSI::reset <<" \"" <<
			/*         */*argv << "\"\n" << ANSI::bold << "Note: " << ANSI::reset <<
			/*         */"Only works with terminals, that support ANSI-Sequences\n" << std::endl;

			return 1;
	}
}
