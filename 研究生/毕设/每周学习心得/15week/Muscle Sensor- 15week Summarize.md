## MyoWare 2.0 Muscle Sensor

Definition: It is an integrated electromyography (EMG) sensor that is compatible with Arduino.

<img src="Muscle%20Sensor.assets/image-20240203160516727.png" alt="image-20240203160516727" style="zoom:67%;" />

How does the MyoWare muscle sensor work? 

<img src="Muscle%20Sensor-%2015week%20Summarize.assets/image-20240205180608967.png" alt="image-20240205180608967" style="zoom:200%;" />

#### Amplifier

[AD8619 Data Sheet and Product Information |ADI Company (analog.com)](https://www.analog.com/en/products/ad8619.html?doc=AD8613_8617_8619.pdf)

- <img src="Muscle%20Sensor.assets/image-20240204184405014.png" alt="image-20240204184405014" style="zoom: 25%;" /><img src="Muscle%20Sensor.assets/image-20240204184616113.png" alt="image-20240204184616113" style="zoom:33%;" />

The AD8619 is a quad low power rail-to-rail input and output amplifier characterized by low supply current, low input voltage, and low current noise.

These devices are fully specified to work at 1.8 V to 5v single supply, or ±0.9 V and ±2.5 V dual supply. The combination of low noise, ultra-low input bias current and low power consumption makes the AD8613/AD8617/AD8619 particularly useful in portable and loop-powered instruments.

- Offset Voltage: 2.2 mV (max)
- Low input bias current: 1 pA (max)
- Single supply: 1.8 V to 5.5 V
- Low noise: 22 nV/√Hz
- Ultra-low power consumption: at the entire temperature range, amplifier maximum is 50 μA
- No phase inversion
- Unit gain stable
- Meets automotive application requirements

#### Trimmer Potentiometer

<img src="Muscle%20Sensor.assets/image-20240204190958839.png" alt="image-20240204190958839" style="zoom:25%;" />

Used for manually adjusting the gain of the envelope signal (requires a screwdriver to adjust, and needs to disconnect the top shield to access the potentiometer), its magnification in the original signal and rectified signal is always 200 and will not change, only when the envelope signal is present will it change according to R.

- **Raw (RAW):** G = 200   
- **Rectified (RECT):** G = 200
- **Envelope (ENV):** G = 200 * (R / 1 kΩ), where R is the resistance of the gain potentiometer in kΩ

#### Differences Between Three Signals

![Raw, Rectified, and Envelope Signal Output, Power Spectrum](Muscle%20Sensor.assets/Raw_Rectified_Envelope_Signal_Power_Spectrum_Graphic_MyoWare_2.0_Advanced_User_Guide.jpg)

Raw signal: With positive and negative, the unmodified signal turns into output, usually used for analyzing system performance or behavior.

Rectified signal: Removed negative signals, or the negative amplitude part is converted to the positive half axis to output, usually turning the negative part of the signal into 0. Used for extracting DC component.

Envelope signal: The output derived from extracting the envelope (slow varying part of the amplitude) of the signal, usually represents the main characteristics of the signal while ignoring the details of the high-frequency part. Used for modulation/demodulation.

#### PTH Pads

<img src="Muscle%20Sensor.assets/18977-MyoWare_2.0_Muscle_Sensor_PTH_Pins.jpg" alt="PTH Pads" style="zoom: 50%;" />

Includes VIN GND ENV RECT RAW REF ports, which are convenient for soldering to connect these interfaces.

#### LEDs

<img src="Muscle%20Sensor.assets/18977-MyoWare_2.0_Muscle_Sensor_Trimpot_LEDs.jpg" alt="LEDs" style="zoom: 50%;" />

Includes two LEDs:

- VIN: Lights up when power is connected.
- ENV: Lights up when there is activity in the ENV pin.

#### Snap Connectors

<img src="Muscle%20Sensor.assets/18977-MyoWare_2.0_Muscle_Sensor_Top_Snaps.jpg" alt="Top Snap Connectors" style="zoom:50%;" />

- **GND** - The ground of the MyoWare 2.0 Muscle Sensor.
- **VIN** - The voltage input of MyoWare 2.0 Muscle Sensor.
- **ENV** - The envelope signal ranges between 0-VIN. It should be connected to the ADC on the microcontroller.

### Reference Electrode Port

<img src="Muscle%20Sensor.assets/18977-MyoWare_2.0_Muscle_Sensor_Reference_Cable_Housing.jpg" alt="Reference Connector" style="zoom: 50%;" /><img src="Muscle%20Sensor.assets/18977-MyoWare_2.0_Muscle_Sensor_Reference_Pin_Jumper.jpg" alt="Reference Jumper Wire" style="zoom:50%;" />

When the pin cannot reach the target location, this port can be used to connect the cable for measurement, but you need to cut the jumper wire.

