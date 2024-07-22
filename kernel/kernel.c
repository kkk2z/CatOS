#include "kernel.h"

void kernel_main(void) {
    terminal_initialize();
    terminal_writestring("Hello, kernel World!\n");
    // 他の初期化コードや機能の呼び出し
}
