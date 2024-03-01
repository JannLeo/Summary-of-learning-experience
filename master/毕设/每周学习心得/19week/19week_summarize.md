# 19Week Summarize

- Operational amplifier or "op amp"

  - Suppose we want to multiply an input by a number to produce another voltage that we will refer to as the output.
  - Or we have several input and we with to add them together as the output voltage.

- Ideal op amp

  - It has two input terminals and one output terminals.
    - ![image-20240229161444745](19week_summarize.assets/image-20240229161444745.png)
  - It also has two terminals for providing power to the device.
    - ![image-20240229161400683](19week_summarize.assets/image-20240229161400683.png)
  - Current can never flow into or out of the input terminals. But the Current can flow into or out of the output terminals.
    - ![image-20240229161847988](19week_summarize.assets/image-20240229161847988.png)
- The output voltages only are in between the voltages of the two power terminals. As the figure show above, the range of output voltages are from -12V to 12V. 
  - The op amp takes the voltage value of the "+" input and subtracts from it the voltage value of the "-" input.
    - ![image-20240229162357486](19week_summarize.assets/image-20240229162357486.png)
  - The op amp will take this difference between the two input voltages and multiple it by a very large number (Open loop magnification).
  - Using the Oscilloscope connect with the output of the op amp (B) and the "+" of the input (A) as follows:
    - ![image-20240229163435246](19week_summarize.assets/image-20240229163435246.png)
  - We can see when the "+" input is slightly lower than the "+" input, the op amp will try to make the output voltage equal to the largest negative number it is capable of producing. 
  - In this picture, the Channel_B is connect with the output, and the Channel_A is connect with the "+" input, we can see the output voltage is a very large negative voltage around -954kV while the channel_A is just 1.216 mV, which is just since the V2 is 0.001Vms and V3 is 0.002Vms.
    - ![image-20240229163639773](19week_summarize.assets/image-20240229163639773.png)
  - As the figure shown below, when the "+" side of the input add the resistance R1 and the R2 with negative feedback circuit, if the voltage of V2 is less than V3, then part of the voltage amplified from output will come back to the "+" side input. In conclusion, both "+" and "-" side voltage will become the same level finally since the negative feedback circuit.
    - ![](19week_summarize.assets/image-20240229204438366.png)
  - On the contrary, when the voltage of the V2 is larger than the V3, the voltage of the A and B still the same finally ( As shown in below figure). Because the negative feedback always forces the op amp's two terminals to  always be at almost the same voltage value.
    - ![image-20240229204609369](19week_summarize.assets/image-20240229204609369.png)