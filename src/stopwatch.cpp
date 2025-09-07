#include "stopwatch.hpp"

stopwatch::clock::time_point stopwatch::init() {
	initscr();
	noecho();
	cbreak();
	clear();
	curs_set(0);
	return stopwatch::clock::now();
}

void stopwatch::delayMicros(u64 µs){
	std::this_thread::sleep_for(std::chrono::microseconds(µs));
}

std::string stopwatch::make_output(clock::time_point start) {
	namespace c = std::chrono;
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

	return str{hrs + ":" + min + ":" + sec + "." + ms};
} // stopwatch::make_output()

std::string stopwatch::make_output(const checkpoints_t& checkpoints) {
	using str = std::string;

	str ms  = std::to_string(checkpoints.back() % 1000);
	str sec = std::to_string((checkpoints.back() / 1000) % 60);
	str min = std::to_string((checkpoints.back() / 60000) % 60);
	str hrs = std::to_string((checkpoints.back() / 3600000));

	while (ms.length() < 3) {
		ms.insert(ms.begin(), '0');
	}

	while (sec.length() < 2) {
		sec.insert(sec.begin(), '0');
	}

	while (min.length() < 2) {
		min.insert(min.begin(), '0');
	}

	return str{hrs + ":" + min + ":" + sec + "." + ms};
}

void stopwatch::trig_checkpoint(checkpoints_t &checkpoints, clock::time_point start) {
	using namespace std::chrono;
	auto now = clock::now();
	auto ms = static_cast<u64>(duration_cast<milliseconds>(now - start).count());

	if (checkpoints.empty()) [[unlikely]] { //first run only
		checkpoints.push_back(ms);
	} else [[likely]] {
		u64 all = 0;
		for (auto checkpoint : checkpoints) {all += checkpoint;}
		checkpoints.push_back(ms - all);
	}
} //trig_checkpoint()

// UNUSED
/* stopwatch::clock::time_point stopwatch::get_input(std::string_view output) {
	int hr = 0, min = 0, sec = 0, ms = 0;
	size_t end_hr = output.find(":"), end_min = output.find(":", end_hr), end_sec = output.find(".", end_min), end_ms = output.size();
	auto str_hr = output.substr(0, end_hr);
	auto str_min = output.substr(end_hr, end_min);
	auto str_sec = output.substr(end_min, end_sec);
	auto str_ms = output.substr(end_sec, end_ms);
	for (size_t i = 0; i < str_hr.length(); i++) {
		char c = str_hr[i];
		c -= '0';
		hr += sc_(int, sc_(u64, c) * power(10, str_hr.length() - i));
	}
	for (size_t i = 0; 0 < str_min.length(); i++) {
		char c = str_min[i];
		c -= '0';
		min += sc_(int, sc_(u64, c) * power(10, str_min.length() - i));
	}
	for (size_t i = 0; i < str_sec.length(); i++) {
		char c = str_sec[i];
		c -= '0';
		sec += sc_(int, sc_(u64, c) * power(10, str_sec.length() - i));
	}
	for (size_t i = 0 ; i < str_ms.length(); i++) {
		char c = str_ms[i];
		c -= '0';
		ms += sc_(int, sc_(u64, c) * power(10, str_ms.length() - i));
	}
} // get_input() */
