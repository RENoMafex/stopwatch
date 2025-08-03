#include <chrono>
#include <iostream>
#include <string_view>
#include <csignal>
#include <atomic>

// #include "stopwatch_utils.hpp"
#include "shortint.hpp"

#define unused [[maybe_unused]]

std::atomic<bool>stop_flag = false;


int main(unused int argc, unused char** argv){
	std::signal(SIGINT, [](int){stop_flag = true;});

	std::cout << "00:00:00.000";
}
