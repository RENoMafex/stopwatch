#ifndef STOPWATCH_HPP
#define STOPWATCH_HPP

#include <ncurses.h>
#include <iostream>
#include <string>
#include <string_view>
#include <chrono>
#include <shortint.hpp>
#include <functional>
#include <thread>

namespace stopwatch{
	using clock = std::chrono::steady_clock;

	/// @brief Initializes ncurses
	/// @return Timepoint of initialization
	clock::time_point init();

	/// @brief short alias for std::this_thread::sleep_for()
	/// @param µs microseconds to sleep
	void delayMicros(u64 µs);

	/// @brief Generates output to display
	/// @param start Timepoint of begin
	/// @return hours:mins:seconds:milliseconds, 2 digits for minutes and seconds, 3 digits for milliseconds
	std::string_view make_output(clock::time_point start);

}

#endif
