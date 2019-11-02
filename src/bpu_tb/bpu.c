#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define XLEN 64
#define HLEN 8
#define BTB_BITS 8
#define OFFSET 2

#define HLEN_MASK(n) (n & ((1 << HLEN) - 1))
#define BTB_ADDR_MASK(n) ((uint64_t)n & ((1 << BTB_BITS) - 1))
#define BTB_TAG_MASK(n) ( ( (uint64_t)n >> BTB_BITS ) & \
                        ( ( (uint64_t)1 << (XLEN - BTB_BITS) ) - 1 ) )

// Typedefs
typedef struct
{
  int valid;
  int counter;
} pht_entry;

typedef struct
{
  int valid;
  int tag;
  //int target; NO WAY TO INCLUDE TARGET??
} btb_entry;

// Function declarations
int predict(int *bht, pht_entry *pht, btb_entry *btb, uint64_t *pc, int *index);
void update(int *bht, pht_entry *pht, btb_entry *btb, uint64_t *pc, int *index,int *taken);

int main(void)
{
  FILE *trace_fp;
  char *line = NULL;
  size_t len = 0;
  uint64_t pc;
  int taken, pred_taken;
  int index;
  int branch_count = 0;
  int mispred_count = 0;
  
  // Define structures
  int bht[HLEN] = {0};
  pht_entry pht[1 << HLEN] = {0, 0};
  btb_entry btb[1 << BTB_BITS] = {0, 0};

  // Read trace
  trace_fp = fopen("trace_bool.txt", "r");
  if (trace_fp == NULL)
  {
    exit(EXIT_FAILURE);
  }

  while (getline(&line, &len, trace_fp) != -1)
  {
    sscanf(line, "%x %d", &pc, &taken);
    pred_taken = predict(bht, pht, btb, &pc, &index);
    branch_count++;
    if (pred_taken != taken)
    {
      mispred_count++;
    }
    update(bht, pht, btb, &pc, &index, &taken);
  }

  // Print results
  printf("Total number of branches: %d\n", branch_count);
  printf("Accuracy rate: %.2f%\n", 100 * (float)(branch_count - mispred_count) / branch_count);

  return 0;
}

// Function definitions
int predict(int *bht, pht_entry *pht, btb_entry *btb, uint64_t *pc, int *index)
{
  uint64_t offset_pc = *pc >> OFFSET;

  // gshare
  *index = HLEN_MASK(offset_pc) ^ HLEN_MASK(*bht);
  int taken = (pht[*index].counter > 1) && (pht[*index].valid == 1);

  // btb
  int hit = (btb[BTB_ADDR_MASK(offset_pc)].valid) && \
            (btb[BTB_ADDR_MASK(offset_pc)].tag == BTB_TAG_MASK(offset_pc));

  return taken && hit;
}

void update(int *bht, pht_entry *pht, btb_entry *btb, uint64_t *pc, int *index,int *taken)
{
  uint64_t offset_pc = *pc >> OFFSET;

  // gshare
  *bht = HLEN_MASK(*bht) >> 1;
  if (*taken)
  {
    *bht |= 1 << (HLEN - 1);
  }

  pht[*index].valid = 1;
  if (*taken)
  {
    if (++pht[*index].counter > 3)
    {
      pht[*index].counter = 3;
    }
  }
  else
  {
    if (--pht[*index].counter < 0)
    {
      pht[*index].counter = 0;
    }
  }
  
  // btb
  if (*taken)
  {
    btb[BTB_ADDR_MASK(offset_pc)].valid = 1;
    btb[BTB_ADDR_MASK(offset_pc)].tag = BTB_TAG_MASK(offset_pc);
  }
  
}