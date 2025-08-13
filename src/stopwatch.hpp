#ifndef STOPWATCH_HPP
#define STOPWATCH_HPP

#include <ncurses.h>
#include <iostream>
#include <string>
#include <string_view>
#include <chrono>
#include <shortint.hpp>
#include <thread>
#include <vector>
#include <array>
#include <tuple>
#include "power.hpp"

#define sc_(T,x) static_cast<T>(x)

/// @brief Holding utility functions and types.
namespace stopwatch{
	/// @brief a vector of pairs with a string and a Timepoint
	typedef std::vector<std::pair<std::string_view, std::chrono::milliseconds>> checkpoints_t;
	using clock = std::chrono::steady_clock;

	/// @brief Initializes ncurses
	/// @return Timepoint of initialization
	clock::time_point init();

	/// @brief short alias for std::this_thread::sleep_for(microseconds(µs))
	/// @param µs microseconds to sleep
	void delayMicros(u64 µs);

	/// @brief Generates output to display
	/// @param start Timepoint of begin
	/// @return hours:mins:seconds.milliseconds, 2 digits for minutes and seconds, 3 digits for milliseconds
	std::string_view make_output(clock::time_point start);

	/// @brief Restores std::chrono::steady_clock::time_point from a std::string
	/// @param output the string, which holds the time_point (format: "[0-9]+:[0-9]{2}:[0-9]{2}.[0-9]{3}" order: "h min sec ms")
	/// @return Timepoint
	clock::time_point get_input(std::string_view output);

	/// @brief adds a checkpoint to the vector
	/// @param checkpoints the checkpoints object, in which the checkpoint should be added
	void trig_checkpoint(checkpoints_t &checkpoints, clock::time_point start);

}
#endif
