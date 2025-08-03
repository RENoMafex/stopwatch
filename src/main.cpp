#include <chrono>
#include <iostream>
#include <string_view>
#include <csignal>
#include <atomic>

#include "my_atomics.hpp"

int main(int argc, char** argv){
	std::signal(SIGINT, [](int){stop_flag = true;});

}
