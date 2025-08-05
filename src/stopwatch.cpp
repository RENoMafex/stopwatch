#include "stopwatch.hpp"

stopwatch::clock::time_point stopwatch::init() {
	initscr();
	noecho();
	cbreak();
	clear();
	return stopwatch::clock::now();
}

void stopwatch::delayMicros(u64 µs){
	std::this_thread::sleep_for(std::chrono::microseconds(µs));
}

std::string_view stopwatch::make_output(clock::time_point start) {
	namespace c = std::chrono;
	using sv = std::string_view;
	using str = std::string;

	auto now = clock::now();
	str ms  = std::to_string(static_cast<u16>(c::duration_cast<c::milliseconds>(now - start).count() % 1000));
	str sec = std::to_string(static_cast<u16>(c::duration_cast<c::seconds>(now - start).count() % 60));
	str min = std::to_string(static_cast<u16>(c::duration_cast<c::minutes>(now - start).count() % 60));
	str hrs = std::to_string(static_cast<u16>(c::duration_cast<c::hours>(now - start).count()));

	while (ms.length() < 3) {
		ms.insert(ms.begin(), '0');
	}

	while (sec.length() < 2) {
		sec.insert(sec.begin(), '0');
	}

	while (min.length() < 2) {
		min.insert(min.begin(), '0');
	}

	return sv{hrs + ":" + min + ":" + sec + ":" + ms};
} // stopwatch::make_output()
