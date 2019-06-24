#include <stdio.h>
#include <stdint.h>

#define SEED 0x1u

int main ()
{
  uint32_t seed = SEED;
  uint32_t lfsr = seed;
  uint32_t bit;
  uint32_t counter = 0;
  uint32_t freq[16];

  float cur_chi = 0;
  float final_chi = 0;

  int i = 0;
  for(; i < 16; ++i)
    freq[i] = 0;

  do
  {
    bit = ((lfsr >> 0) ^ (lfsr >> 1) ^ (lfsr >> 2) ^ (lfsr >> 7));
    bit &= 0x1u;
    lfsr = (lfsr >> 1) | (bit << 23);
    freq[lfsr >> 20] += 1;
    counter++;
  } while(counter != 0x00FFFFFF);

  for(i = 0; i < 16; ++i)
  {
    printf("[%d] Freq Observada: %d\n", i, freq[i]);
    cur_chi = (freq[i] - 1048576.0);
    cur_chi *= cur_chi;
    cur_chi /= 1048576.0;
    final_chi += cur_chi;
  }

  printf("Chi: %f\n", final_chi);


  return 0;
}
