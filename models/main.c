#include <stdio.h>
#include <string.h>
#include "bpu.h"

FILE *trace_fp;
char *line = NULL;
size_t len = 0;

// Print out the Usage information to stderr
void usage()
{
  fprintf(stderr, "Usage: predictor <options> [<trace>]\n");
  fprintf(stderr, "       bunzip -kc trace.bz2 | predictor <options>\n");
  fprintf(stderr, " Options:\n");
  fprintf(stderr, " --help       Print this message\n");
  fprintf(stderr, " --verbose    Print predictions on stdout\n");
  fprintf(stderr, " --hlen:<N>     Branch prediction scheme:\n");
}

// Process an option and update the predictor
// configuration variables accordingly
// Returns True if Successful
int handle_option(char *arg)
{
  if (!strncmp(arg, "--hlen:", 7)) 
  {
    sscanf(arg+7, "%d", &hlen);
  } 
  else if (!strcmp(arg, "--verbose")) 
  {
    verbose = 1;
  } 
  else 
  {
    return 0;
  }

  return 1;
}

// Reads a line from the input stream and extracts the
// PC and Outcome of a branch
// Returns True if Successful 
int read_branch(uint32_t *pc, uint8_t *outcome)
{
  if (getline(&line, &len, trace_fp) == -1)
  {
    return 0;
  }

  uint32_t tmp;
  sscanf(line, "0x%x %d\n", pc, &tmp);
  *outcome = tmp;

  return 1;
}

int main(int argc, char *argv[])
{
  // Set defaults
  trace_fp = stdin;
  verbose = 0;

  // Process cmdline arguments
  for (int i = 1; i < argc; ++i)
  {
    if (!strcmp(argv[i], "--help"))
    {
      usage();
      exit(0);
    }
    else if (!strncmp(argv[i], "--",2))
    {
      if (!handle_option(argv[i]))
      {
        printf("Unrecognized option %s\n", argv[i]);
        usage();
        exit(1);
      }
    }
    else
    {
      // Use as input file
      trace_fp = fopen(argv[i], "r");
    }
  }

  // Initialize predictor
  uint32_t pc;
  uint8_t outcome, prediction;
  int branch_count = 0;
  int mispred_count = 0;
  initialize();

  // Reach each branch from the trace
  while (read_branch(&pc, &outcome)) {
    branch_count++;

    // Make a prediction and compare with actual outcome
    prediction = predict(pc);
    if (prediction != outcome)
    {
      mispred_count++;
    }
    if (verbose != 0)
    {
      printf ("%d\n", prediction);
    }

    // Train the predictor
    update(pc, outcome);
  }

  // Print out the mispredict statistics
  printf("Branches:        %10d\n", branch_count);
  printf("Incorrect:       %10d\n", mispred_count);
  float mispredict_rate = 100*((float)mispred_count / (float)branch_count);
  printf("Misprediction Rate: %7.3f\n", mispredict_rate);

  // Cleanup
  fclose(trace_fp);
  free(line);

  return 0;
}