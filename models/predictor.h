#ifndef BPU_H
#define BPU_H

#include <stdint.h>
#include <stdlib.h>

// Conditional compilation directives
// #define ALTERNATE
// #define USE_VALID

// Useful defines
#define TAKEN     1
#define NOT_TAKEN 0
#define INIT_2BC  0

// Declare global variable
extern int hLen;      // global history length
extern int btbBits;   // BTB index bits
extern int verbose;   // print each prediction

// Function prototypes
void initialize();
uint8_t predict(uint64_t pc);
void update(uint64_t pc, uint8_t outcome);

#endif