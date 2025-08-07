#ifndef POWER_HPP
#define POWER_HPP

#include <type_traits>
#include "shortint.hpp"

#define sc_(T,x) static_cast<T>(x)


template<typename baseT, typename expT>
inline unsigned long power(baseT base, expT exponent){
	static_assert(std::is_integral_v<baseT> && std::is_integral_v<expT>, "This function only works with integers");
	unsigned long result = 1;
	while (exponent != 0) {
		if (exponent % 2) result *= sc_(decltype(result), base);
		exponent /= 2;
		base *= base;
	}
	return sc_(unsigned long, result);
}

#undef sc_
#endif
