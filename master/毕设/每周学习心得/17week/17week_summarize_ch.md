#### 17 Week Summarize

当看了许多MultisimLive里面的emg circuit相关的电路图后，我发现了一个问题:如果我们想要实现多个EMG传感器的同时测量的工作的话，并不需要了解EMG传感器的内部。因为EMG之间的连接是通过TRS线连接到Arduino上面的，所以我们如果需要大于6个EMG传感器的同时连接使用的话，我们应该更改适用于Arduino扩展版的TRS的连接数量而不是更改EMG传感器的内部。下图是Arduino的TRS扩展板：

<img src="17week_summarize_ch.assets/image-20240220210319632.png" alt="image-20240220210319632" style="zoom: 50%;" />

在这块板子中，只有0-5号位被A0-A5用来传递信号，而剩下的诸如右边红色框框标注的口我认为还是有可能有使用的可能。

<img src="17week_summarize_ch.assets/image-20240220211232667.png" alt="image-20240220211232667" style="zoom: 33%;" />

