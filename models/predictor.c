#include <stdio.h>
#include "predictor.h"

// Define global variables
int hlen;
int verbose;

// Define data structure
uint32_t history;
uint32_t *pht;
uint32_t hmask;

// Function definitions
void initialize()
{
  history = 0;

  size_t pht_size = 1 << hlen;
  pht = (uint32_t*) malloc(sizeof(uint32_t) * pht_size);
  for (int i = 0; i < pht_size; i++)
  {
    if (ALTERNATE)
    {
      if (i % 2)
        pht[i] = 2;
      else
        pht[i] = 1;
    }
    else
      pht[i] = 1;
  }

  hmask = (1 << hlen) - 1;
  
}

uint8_t predict(uint32_t pc)
{
  uint32_t masked_history = history & hmask;
  uint32_t masked_pc = pc & hmask;
  uint32_t index = masked_history ^ masked_pc;
  uint32_t prediction = pht[index];

  if (prediction > 1)
  {
    return TAKEN;
  }
  else
  {
    return NOT_TAKEN;
  }
}

void update(uint32_t pc, uint8_t outcome)
{
  uint32_t masked_history = history & hmask;
  uint32_t masked_pc = pc & hmask;
  uint32_t index = masked_history ^ masked_pc;
  
  if (outcome == TAKEN)
  {
    // Shift history
    history = (history << 1) | 1;
    history &= hmask;

    // Update PHT
    if (pht[index] < 3)
    {
      pht[index]++;
    } 
  }
  else
  {
    // Shift history
    history = history << 1;
    history &= hmask;

    // Update PHT
    if (pht[index] > 0)
    {
      pht[index]--;
    } 
  }
}