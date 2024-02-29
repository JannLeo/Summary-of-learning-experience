# 18th Week Summarize



![image-20240228092559901](18week%20Summarize.assets/image-20240228092559901.png)

As shown in the above diagram, this is the circuit diagram of an Instrumentation Amplifier. I deployed this circuit diagram using Multisim, and the result is shown in the following image:

![](18week%20Summarize.assets/image-20240228221833394.png)

Overall, it can be seen that the amplification effect of this circuit is not significant. However, upon calculation, it was found that for U1, it functions as a non-inverting amplifier, with the gain determined by R1, R4, and RG. The calculated gain is 1+R4/RG = 1+ 10k/500 = 21. On the other hand, U2 functions as an inverting amplifier, with the gain set by R2 and R3, which are equal, resulting in a gain of -1. U3 serves as a buffer amplifier only. Therefore, it is puzzling that the overall gain should be -21, yet the signal amplification is not observable through the oscilloscope.

