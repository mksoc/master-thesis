#ifndef BPU_H
#define BPU_H

#include <stdint.h>
#include <stdlib.h>

// Useful defines
#define XLEN      64
#define TAKEN     1
#define NOT_TAKEN 0

// Declare global variable
extern int hlen;     // global history length
extern int verbose;  // print each prediction

// Function prototypes
void initialize();
uint8_t predict(uint32_t pc);
void update(uint32_t pc, uint8_t outcome);

#endif