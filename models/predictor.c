#include <stdio.h>
#include "predictor.h"

// Define global variables
int hLen;
int btbBits;
int verbose;

// Define data structures
uint32_t history;

typedef struct
{
  uint8_t valid;
  uint8_t counter;
} pht_t;
pht_t *pht;

typedef struct
{
  uint8_t valid;
  uint64_t tag;
  // uint64_t target;
} btb_t;
btb_t *btb;

uint32_t hMask;
uint32_t btbAddressMask;
uint64_t btbTagMask;

// Function definitions
void initialize()
{
  // Global history register
  history = 0;

  // PHT
  size_t phtSize = 1 << hLen;
  pht = (pht_t*) malloc(sizeof(pht_t) * phtSize);

  for (size_t i = 0; i < phtSize; i++)
  {
    pht[i].valid = 0;

    #ifdef ALTERNATE
      if (i % 2)
        pht[i].counter = 2;
      else
        pht[i].counter = 1;
    #else
      pht[i].counter = INIT_2BC;
    #endif
  }

  // BTB
  if (btbBits != 0)
  {
    size_t btbSize = 1 << btbBits;
    btb = (btb_t*) malloc(sizeof(btb_t) * btbSize);

    for (size_t i = 0; i < btbSize; i++)
    {
      btb[i].valid = 0;
      btb[i].tag = 0;
    }
  }
  else
    btb = NULL;  

  // Masks
  hMask = (1 << hLen) - 1;
  btbAddressMask = (1 << btbBits) - 1;
  btbTagMask = (1 << (sizeof(uint64_t) - btbBits)) - 1;
}

uint8_t predict(uint64_t pc)
{
  uint32_t maskedHistory = history & hMask;
  uint32_t maskedPc = (pc >> 2) & hMask;
  uint32_t index = maskedHistory ^ maskedPc;
  uint64_t btbAddress = (pc >> 2) & btbAddressMask;
  uint64_t btbTag = (pc >> (btbBits + 2)) & btbTagMask;

  #ifdef USE_VALID
    if (pht[index].counter > 1 && pht[index].valid)
  #else
    if (pht[index].counter > 1)
  #endif
  {
    if (btb == NULL)
      return TAKEN;
    else
    {
      if (btb[btbAddress].valid && btb[btbAddress].tag == btbTag)
        return TAKEN;
      else
        return NOT_TAKEN;
    }
  }
  else
  {
    return NOT_TAKEN;
  }
}

void update(uint64_t pc, uint8_t outcome)
{
  uint32_t maskedHistory = history & hMask;
  uint32_t maskedPc = (pc >> 2) & hMask;
  uint32_t index = maskedHistory ^ maskedPc;
  uint64_t btbAddress = (pc >> 2) & btbAddressMask;
  uint64_t btbTag = (pc >> (btbBits + 2)) & btbTagMask;

  pht[index].valid = 1;
  
  if (outcome == TAKEN)
  {
    // Shift history
    history = (history << 1) | 1;
    history &= hMask;

    // Update PHT
    if (pht[index].counter < 3)
    {
      pht[index].counter++;
    } 
  }
  else
  {
    // Shift history
    history = history << 1;
    history &= hMask;

    // Update PHT
    if (pht[index].counter > 0)
    {
      pht[index].counter--;
    } 
  }

  if (btb != NULL)
  {
    btb[btbAddress].valid = 1;
    btb[btbAddress].tag = btbTag;
  }
  
}