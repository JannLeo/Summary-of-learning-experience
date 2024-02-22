### Week 17 Study Summary

- Currently, there are circuit diagrams for Myoware 1.0 and physical models for Myoware 2.0:

  ![image-20240218195312806](17week_summarize.assets/image-20240218195312806.png)



<img src="file://D:\homeworkandppt\master\毕设\每周学习心得\15week\Muscle Sensor.assets\image-20240203160516727.png?lastModify=1708285573" alt="image-20240203160516727" style="zoom:50%;" />

- The energy of the electromyogram (EMG) signal is between approximately 5Hz and 500Hz. Different frequency sine waves can be used at extremes and intervals to test the circuit for amplitude, phase, offset, and distortion. Various circuit analysis functions in Multisim can also be used to generate Bode plots and check transient responses.
- The AD8619 on MyoWare 2.0 should be the Instrumentation Amplifier. Therefore, the AD8619ARUZ amplifier is used in the Instrumentation Amplifier section, followed by constructing the high-pass filter, full-wave rectifier, differential amplifier, and integral amplifier according to the circuit diagram (as shown below).
- ![image-20240221195209507](17week_summarize.assets/image-20240221195209507.png)

- After looking at many EMG circuit-related circuit diagrams in MultisimLive, I found an issue: if we want to simultaneously measure multiple EMG sensors, we do not need to understand the internal workings of the EMG sensors. Since the connections between EMGs are made through TRS lines connected to the Arduino, if we need to connect more than 6 EMG sensors simultaneously, we should change the number of TRS connections suitable for the Arduino expansion board rather than altering the internals of the EMG sensors. The following image shows the Arduino TRS expansion board:

  <img src="17week_summarize_ch.assets/image-20240220210319632.png" alt="image-20240220210319632" style="zoom: 50%;" />

  As shown below, in this board, only positions 0-5 are used to transmit signals using A0-A5, while the remaining ports, such as those marked by the red box on the right, may still have potential uses.

  <img src="17week_summarize_ch.assets/image-20240220211232667.png" alt="image-20240220211232667" style="zoom: 33%;" />

- The 2-13 PIN ports in the image correspond to the 2-13 interfaces in the image below, these 12 interfaces on the board should not have been used before and theoretically should be expandable.

  ![RedBoard Plus Graphical Datasheet](file://D:\homeworkandppt\master\毕设\每周学习心得\14week\5-6week.assets\RedBoard_Plus_Graphical_Datasheet.jpg?lastModify=1708545333)

- Circuit diagrams related to EMG circuits can be found online at [emg circuit - Multisim Live](https://www.multisim.com/content/qx6NXfCixrxW7yPSZsbA2Q/emg-circuit/)

- ![image-20240220203946047](17week_summarize.assets/image-20240220203946047.png)

