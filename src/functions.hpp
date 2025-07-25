#ifndef FUNCTIONS_HPP
#define FUNCTIONS_HPP

#include "structs.hpp"
#include <chrono>
#include <shortint.hpp>
#include <thread>
#include <iostream>
#include <atomic>

inline std::atomic_bool stop_flag = false;

namespace localFunctions{
	TimerDisplay make_disp(std::chrono::steady_clock::time_point start);
	void delay(u64 µs);
	TimerDisplay stopwatch(std::chrono::steady_clock::time_point start);
}

namespace localOverloads{
	std::ostream& operator<<(std::ostream& os, const TimerDisplay& timer_display);
}

// ANSI Escape sequence to clear current line.
constexpr std::string_view reset_line = "\033[2K\033[0G";

// ANSI Escape sequence to go 1 line up
constexpr std::string_view up_line = "\033[1A";

//ANSI Escape sequence to clear formatting
constexpr std::string_view reset = "\033[0m";

// ANSI Escape sequence for **BOLD** text
constexpr std::string_view bold = "\033[1m";

#endif

