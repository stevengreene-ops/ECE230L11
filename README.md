# Lab 11 - Counters and Dividers

In this lab, we learned how to make clock dividers from two types of counters.

## Rubric

| Item | Description | Value |
| ---- | ----------- | ----- |
| Summary Answers | Your writings about what you learned in this lab. | 25% |
| Question 1 | Your answers to the question | 25% |
| Question 2 | Your answers to the question | 25% |
| Question 3 | Your answers to the question | 25% |

## Names

## Summary

In this lab, we built two counters, one using modulo counters, and another using ripple counters using previously built T-flip flops, D-flip flops, and out full adder from lab 6. In order to build the modulo counter, we had to run bits and clocks through 3 D-flip flops, and connect those to our full adder so that the flip flops would hold the bits as the full adders counted up 6 bits. 

For the simple ripple counter, we connected a clock to 3 T-flip flops, then routed the Q outputs of the T-flip flops to the clock of the next flip flop, where the reset and clocks of both counters correspond to btnC and btnU, and we should be able to see the outputs of the ring counter from LED[2:0], and the modulo counter from LED[5:3]. 

## Lab Questions

### 1 - Why does the Modulo Counter actually divide clocks by 2 * Count?

The modulo counter divides the clock frequency by 2 x N because it only toggles its output state once it reaches the target count N. A single full clock cycle requires two transitions, one from low to high and one from high back to low. Since the modulo counter takes N input pulses to complete a transition, it has to count to N twice to complete a full cycle.

### 2 - Why does the ring counter's output go to all 1s on the first clock cycle?

The ripple counter would show all 1's on the first clock cycle if it hasn't been cleared using the reset signal (btnU). Because flip-flops have an unknown state when it's powered, it can default to a high-state in simulation. Also, because the output of one stage acts like the clock for the next, any initial instability or reset signal that's low-active can cause the sequence to start from a state where all the bits are high before the first downward ripple starts. 

### 3 - What width of ring counter would you use to get to an output of ~1KHz?
To get an output of ~1KHz, you could use a 17-bit ripple counter if you have the output = input/2^n. 

