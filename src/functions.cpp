#include "functions.hpp"

namespace localFunctions{

	TimerDisplay make_disp(std::chrono::steady_clock::time_point start){
		using namespace std::chrono;
		TimerDisplay result;
		steady_clock::time_point now = steady_clock::now();

		result.ms = std::to_string(static_cast<u16>(duration_cast<milliseconds>(now - start).count() % 1000));
		result.sec = std::to_string(static_cast<u16>(duration_cast<seconds>(now - start).count() % 60));
		result.min = std::to_string(static_cast<u16>(duration_cast<minutes>(now - start).count() % 60));
		result.hrs = std::to_string(static_cast<u16>(duration_cast<hours>(now - start).count () % 60));
		
		while (result.ms.length() < 3) {
			result.ms.insert(result.ms.begin(), '0');
		}

		while (result.sec.length() < 2) {
			result.sec.insert(result.sec.begin(), '0');
		}

		while (result.min.length() < 2) {
			result.min.insert(result.min.begin(), '0');
		}

		return result;
	}

	void delay(u64 µs){
		using namespace std::chrono;
		microseconds mics(µs);
		std::this_thread::sleep_for(mics);
	}



	TimerDisplay stopwatch(std::chrono::steady_clock::time_point start) {
		using namespace localOverloads;
		TimerDisplay now;
		while(true){
			now = make_disp(start);
			if(stop_flag == true) break;
			std::cout << ANSI::reset_line << now << std::flush;
			delay(500);
		}
		return now;
	}
} //namespace localFunctions

namespace localOverloads{
	std::ostream& operator<<(std::ostream& os, const TimerDisplay& timer_display) {
		os << timer_display.hrs << ":" << timer_display.min << ":" << timer_display.sec << "." << timer_display.ms;
		return os; 
	}
} // namespace localOverloads
