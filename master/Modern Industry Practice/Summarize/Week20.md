- #### What work did you carry out that week on the mini-project?那一周你在小项目上做了什么工作?

- In this week (week 20), I finished the draft in phase 2 and give a presentation with my teammates. I have introduced the Aim of the system, Function and Block Diagram of the System and Function of EMG Subsystem and so on. The details as follows:

  - **Aim of the System**: The overall goal of （按）this system is to first solve the employment problem of people with disabilities in the third world to reduce inequality, （按）increase food production by controlling drone irrigation to reduce hunger, （按）and provide better health testing and higher-end employment for people with disabilities.
  - **Function and Block Diagram of the System**: Let’s first explain the following functions that the entire system wants to achieve. This diagram is similar to the system’s Overall Block Diagram principle. First, EMG receives human muscle signals. EMG amplifies the signals and then transmits the signals to the computer through WIFI. The computer uses MATLAB Process and identify the body status information, and then upload the electromyographic signal to the cloud server through the network. The cloud server transmits it to the irrigation UAV and detect UAV through the Mqtt protocol to realize drone irrigation. This is just a rough look at the system.
  - **Function of EMG Subsystem: **The first subsystem of the system is the electromyography system. We first simulate the connection of the myoelectric sensor: the myoelectric sensor has three electrodes, two are test electrodes and one is the reference electrode. Once they are connected to their respective locations, we will use a differential amplifier to remove the noise and focus only on the differences in the muscle signals. Once we get this signal, we enter MATLAB. In MATLAB, we will simulate the functions of the high-pass filter, differential amplifier, lead-lag rectifier and integrating amplifier in sequence, and finally obtain an envelope electromyographic output.
  - **Pre-processing and feature extraction of EMG signals**: Before that, we must first solve the pre-processing of the EMG signal. In order to deal with the problem in the frequency domain, we prefer to use FFT to pre-process the EMG signal. There are many benefits to using FFT, including helping to analyse and filter out noise, and also analysing the frequency characteristics of muscle activity to identify muscle fatigue, as well as the fast and effective characteristics we are all familiar with.
  - **Comparison between SVM and neural network**: After solving the signal pre-processing, in order to realize the recognition of different muscle parts, we must identify the muscle patterns of different parts in a targeted manner. Naturally, we will think of using neural networks to solve the signal recognition problem. However, in the traditional sense The neural network algorithm on the Internet requires a large number of data sets. After comparison, we chose the Support vector machine (SVM), which can be implemented with only a small number of data sets, to identify myoelectric signals.

  #### Is your group mini-project proceeding on schedule and is everyone making a useful contribution?你的小组小项目是否按计划进行，每个人是否都做出了有益的贡献?•

- We have successfully finish the production of the ppt and give a satisfied presentation. The  division of labor among the four team members for the presentation is as follows:

  - CL and LF mainly focus on Part 1: Selected Technology and its importance and Part 2:Importance of promoting the employment of people with disabilities.
  - I mainly focus on PART 3:System Explanation and part of the part 4 : Function of EMG Subsystem.
  - ZZ mainly focus on Part 4 :Function of UAV Subsystem.

  #### To what extent you feel that you have achieved the learning outcomes* for this module?你觉得你在多大程度上达到了本模块的学习成果* ?•

  

  #### Which learning experiences had the biggest impact on you and why?哪些学习经历对你影响最大，为什么?

- When I was making the ppt and discuss division of labour. I felt it is difficult for me to cooperate with others because I afraid  others cannot meet the requirement in my mind. However, when we finish the presentation I found the performance my teammates showing is even better than me. I realize that the core of teamwork is trusting one’s team members and delegating authority appropriately.

  #### How do you think what you have learned in this module can affect your career and professional practice going forwards?你认为你在这个模块中学到的东西会如何影响你未来的职业和专业实践?

  Through this week's work, I realized that through this presentation, I discovered how to complete a work efficiently through teamwork, which is a very important ability for future work.

  #### What did you find particularly interesting that week in the lecture and online content and what are the different opinions on any emerging topic raised? 在那一周的讲座和在线内容中，你发现了什么特别有趣的地方?对于新出现的话题，你有什么不同的看法?

  这周的讲座主要讲的是创新，我认为要有创新首先要有需求，就比如说最近的AI和机器人，就是人民日益增长的美好生活需要和不平衡不充分的发展之间的矛盾所催生下的产物，就是美国为首的西方资本主义国家发展到了一个周期之后为了挣脱经济危机规律所做的押宝，美欧国家认为科技革命发生在AI、机器人以及民用星际航行，这两者结合可以消除人口老龄化带来的种种问题，而中国为首的第三世界国家押宝新能源，大力发展新能源汽车、光伏以及高端制造业，他们认为AI与机器人能发展的重要条件就是能源。最近NVIDIA GTC 2024的演讲非常的振奋人心，我们人类仿佛又来到了科技革命的黎明。但是我们是不是走错了方向呢，是不是在硅基生命的路上越走越远了，这些都不得而知，我甚至开始惧怕创新。

  This week’s lecture is mainly about innovation. I believe that in order to have innovation, there must first be demand. For example, recent AI and robots are the result of the contradiction between people’s growing needs for a better life and unbalanced and inadequate development. The product of this is the bet made by Western capitalist countries led by the United States in order to break away from the law of economic crisis after a cycle of development. The United States and European countries believe that the technological revolution will occur in AI, robots and civilian interstellar navigation. The combination of the two can eliminate the aging of the population. The various problems brought about by globalization, while third world countries led by China are betting on new energy and vigorously developing new energy vehicles, photovoltaics and high-end manufacturing. They believe that an important condition for the development of AI and robots is energy. The recent NVIDIA GTC 2024 speech was very exciting. We humans seem to have reached the dawn of the technological revolution again. But we don’t know whether we are going in the wrong direction, whether we are going further and further down the road to silicon-based life, and I am even starting to fear innovation.











#### **Weekly Team Report - 20th Week's Summary**

In this week (week 20), I finished the draft in phase 2 and give a presentation with my teammates. I have introduced the Aim of the system, Function and Block Diagram of the System and Function of EMG Subsystem and so on. The details as follows:

- **Aim of the System**: The overall goal of this system is to first solve the employment problem of people with disabilities in the third world to reduce inequality, increase food production by controlling drone irrigation to reduce hunger, and provide better health testing and higher-end employment for people with disabilities.
- **Function and Block Diagram of the System**: Let’s first explain the following functions that the entire system wants to achieve. This diagram is similar to the system’s Overall Block Diagram principle. First, EMG receives human muscle signals. EMG amplifies the signals and then transmits the signals to the computer through WIFI. The computer uses MATLAB Process and identify the body status information, and then upload the electromyographic signal to the cloud server through the network. The cloud server transmits it to the irrigation UAV and detect UAV through the Mqtt protocol to realize drone irrigation. This is just a rough look at the system.
- **Function of EMG Subsystem: **The first subsystem of the system is the electromyography system. We first simulate the connection of the myoelectric sensor: the myoelectric sensor has three electrodes, two are test electrodes and one is the reference electrode. Once they are connected to their respective locations, we will use a differential amplifier to remove the noise and focus only on the differences in the muscle signals. Once we get this signal, we enter MATLAB. In MATLAB, we will simulate the functions of the high-pass filter, differential amplifier, lead-lag rectifier and integrating amplifier in sequence, and finally obtain an envelope electromyographic output.
- **Pre-processing and feature extraction of EMG signals**: Before that, we must first solve the pre-processing of the EMG signal. In order to deal with the problem in the frequency domain, we prefer to use FFT to pre-process the EMG signal. There are many benefits to using FFT, including helping to analyse and filter out noise, and also analysing the frequency characteristics of muscle activity to identify muscle fatigue, as well as the fast and effective characteristics we are all familiar with.
- **Comparison between SVM and neural network**: After solving the signal pre-processing, in order to realize the recognition of different muscle parts, we must identify the muscle patterns of different parts in a targeted manner. Naturally, we will think of using neural networks to solve the signal recognition problem. However, in the traditional sense The neural network algorithm on the Internet requires a large number of data sets. After comparison, we chose the Support vector machine (SVM), which can be implemented with only a small number of data sets, to identify myoelectric signals.

We have successfully finish the production of the ppt and give a satisfied presentation. The  division of labor among the four team members for the presentation is as follows:

- CL and LF mainly focus on Part 1: Selected Technology and its importance and Part 2:Importance of promoting the employment of people with disabilities.
- I mainly focus on PART 3:System Explanation and part of the part 4 : Function of EMG Subsystem.
- ZZ mainly focus on Part 4 :Function of UAV Subsystem.

When I was making the ppt and discuss division of labour. I felt it is difficult for me to cooperate with others because I afraid  others cannot meet the requirement in my mind. However, when we finish the presentation I found the performance my teammates showing is even better than me. I realize that the core of teamwork is trusting one’s team members and delegating authority appropriately.

This week’s lecture is mainly about innovation. I believe that in order to have innovation, there must first be demand. For example, recent AI and robots are the result of the contradiction between people’s growing needs for a better life and unbalanced and inadequate development. The product of this is the bet made by Western capitalist countries led by the United States in order to break away from the law of economic crisis after a cycle of development. The United States and European countries believe that the technological revolution will occur in AI, robots and civilian interstellar navigation. The combination of the two can eliminate the aging of the population. The various problems brought about by globalization, while third world countries led by China are betting on new energy and vigorously developing new energy vehicles, photovoltaics and high-end manufacturing. They believe that an important condition for the development of AI and robots is energy. The recent NVIDIA GTC 2024 speech was very exciting. We humans seem to have reached the dawn of the technological revolution again. But we don’t know whether we are going in the wrong direction, whether we are going further and further down the road to silicon-based life, and I am even starting to fear innovation.