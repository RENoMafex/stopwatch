#include <ncurses.h>
#include <iostream>
#include <string>

#pragma region redefines
#ifdef KEY_ENTER
#undef KEY_ENTER
#endif
#ifdef KEY_SPACE
#undef KEY_SPACE
#endif
#define KEY_ENTER 10
#define KEY_SPACE 32
#pragma endregion

int main(){

}
