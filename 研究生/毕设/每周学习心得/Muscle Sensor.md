## MyoWare 2.0 Muscle Sensor

Define：是一个兼容Arduino的一体化肌电图（EMG）传感器。

<img src="Muscle%20Sensor.assets/image-20240203160516727.png" alt="image-20240203160516727" style="zoom:67%;" />

MyoWare 肌电传感器是怎么工作的？ 见图(How Myoware Works.png)

#### 放大器

[AD8619 数据手册和产品信息 |ADI公司 (analog.com)](https://www.analog.com/en/products/ad8619.html?doc=AD8613_8617_8619.pdf)

- <img src="Muscle%20Sensor.assets/image-20240204184405014.png" alt="image-20240204184405014" style="zoom: 25%;" /><img src="Muscle%20Sensor.assets/image-20240204184616113.png" alt="image-20240204184616113" style="zoom:33%;" />

AD8619是四极微功率轨对轨输入和输出放大器，具有低电源电流、低输入电压和低电流噪声的特点。

这些部件完全指定工作在1.8 V至5v单电源，或±0.9 V和±2.5 V双电源。低噪声、极低输入偏置电流和低功耗的结合使得AD8613/AD8617/AD8619在便携式和环路供电仪器中特别有用。

- 失调电压：2.2 mV（最大值）
- 低输入偏置电流：1 pA（最大值）
- 单电源供电：1.8 V至5.5 V
- 低噪声：22 nV/√Hz
- 微功耗：在整个温度范围内，放大器最大值为 50 μA
- 无相位反转
- 单位增益稳定
- 符合汽车应用要求

#### 微调电位器

<img src="Muscle%20Sensor.assets/image-20240204190958839.png" alt="image-20240204190958839" style="zoom:25%;" />

用于手动调整包络信号的增益（需要用螺丝刀来调整，并且需要断开顶部屏蔽层才能访问电位计），在原始信号和整流信号中它的放大倍数都是200不会变，只有包络信号的时候他才会根据R变化

- **Raw (RAW):** G = 200   
- **Rectified (RECT):** G = 200
- **Envelope (ENV):** G = 200 * (R / 1 kΩ), where R is the resistance of the gain potentiometer in kΩ

#### 三种信号的区别

![Raw, Rectified, and Envelope Signal Output, Power Spectrum](Muscle%20Sensor.assets/Raw_Rectified_Envelope_Signal_Power_Spectrum_Graphic_MyoWare_2.0_Advanced_User_Guide.jpg)

原始信号：有正有负，未经修改的信号变成输出，通常用于分析系统性能或行为。

整流信号：去除了负信号，或者是负振幅部分转换成正半轴来输出，通常会把负部分信号变成0。 用于提取直流成分

包络信号：提取信号的包络（振幅的慢速变化部分）而得到的输出，通常表示信号的主要特征而忽略高频部分的细节。用于调制解调。

#### PTH焊盘

<img src="Muscle%20Sensor.assets/18977-MyoWare_2.0_Muscle_Sensor_PTH_Pins.jpg" alt="PTH Pads" style="zoom: 50%;" />

包括VIN GND ENV RECT RAW REF 口，方便用于焊接来连接这些接口

#### 发光二极管

<img src="Muscle%20Sensor.assets/18977-MyoWare_2.0_Muscle_Sensor_Trimpot_LEDs.jpg" alt="LEDs" style="zoom: 50%;" />

包括两个LED

- VIN：当接电的时候VIN就会亮起
- ENV：当ENV引脚有活动的时候ENV会亮起

#### 卡扣连接器

<img src="Muscle%20Sensor.assets/18977-MyoWare_2.0_Muscle_Sensor_Top_Snaps.jpg" alt="顶部卡扣连接器" style="zoom:50%;" />

- **GND** - MyoWare 2.0 肌肉传感器的接地。
- **VIN** - MyoWare 2.0 肌肉传感器的电压输入。
- **ENV** - 包络信号范围介于 0-VIN 之间。将其连接到微控制器上的 ADC

### 参比电极端口

<img src="Muscle%20Sensor.assets/18977-MyoWare_2.0_Muscle_Sensor_Reference_Cable_Housing.jpg" alt="参考连接器" style="zoom: 50%;" /><img src="Muscle%20Sensor.assets/18977-MyoWare_2.0_Muscle_Sensor_Reference_Pin_Jumper.jpg" alt="参考跳线" style="zoom:50%;" />



当引脚无法到达目标位置的时候可以使用该端口去连接电缆然后测量，但是需要切断那个跳线。