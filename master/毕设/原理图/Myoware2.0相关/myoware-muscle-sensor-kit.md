# MyoWare 肌肉传感器套件

> 原文：<https://learn.sparkfun.com/tutorials/myoware-muscle-sensor-kit>

## 介绍

**Note:** This tutorial was written for MyoWare v1.0\. For the latest tutorial for the MyoWare Muscle Sensor v2.0, check out the tutorial [Getting Started with the MyoWare 2.0 Muscle Sensor Ecosystem](https://learn.sparkfun.com/tutorials/getting-started-with-the-myoware-20-muscle-sensor-ecosystem).

正如[之前](https://www.sparkfun.com/news/1831)宣布的，Advancer Technologies 开始了 Kickstarter 活动，以生产他们的[肌肉传感器 v3](https://www.sparkfun.com/products/13027) 板的更新版本。

[![MyoWare Muscle Sensor](img/405a3fd2e86c7795ab9e110a70ec3073.png)](https://www.sparkfun.com/products/retired/13723) 

### [肌器肌肉传感器](https://www.sparkfun.com/products/retired/13723)

[Retired](https://learn.sparkfun.com/static/bubbles/ "Retired") SEN-13723

使用我们的肌肉来控制事物是我们大多数人习惯的方式。我们按按钮，拉杠杆，移动…

9 **Retired**[Favorited Favorite](# "Add to favorites") 80[Wish List](# "Add to wish list")

MyoWare 肌肉传感器(AT-04-001)是 Advancer Technologies 公司的最新肌电图(EMG)传感器。下面是对 [MyoWare 产品线](https://www.sparkfun.com/search/results?term=myoware)及其使用方法的概述。

[https://www.youtube.com/embed/DOFtN67y1j0/?autohide=1&border=0&wmode=opaque&enablejsapi=1](https://www.youtube.com/embed/DOFtN67y1j0/?autohide=1&border=0&wmode=opaque&enablejsapi=1)

### 所需材料

要将接头引脚焊接到 MyoWare 屏蔽上，您需要进行一些焊接。焊接工具(包括[烙铁](https://www.sparkfun.com/products/9507)和[焊料](https://www.sparkfun.com/products/9325))是任何电子工作台的必备工具。斜切刀可用于收割台。

[![Diagonal Cutters](img/d37a4718d955534cb2346c1be77cf87d.png)](https://www.sparkfun.com/products/8794) 

将**添加到您的[购物车](https://www.sparkfun.com/cart)中！**

### [斜切刀](https://www.sparkfun.com/products/8794)

[In stock](https://learn.sparkfun.com/static/bubbles/ "in stock") TOL-08794

迷你斜切刀。这些是很棒的小刀具！这是夹住引线和额外焊尾的必备工具。4 英寸长。

$2.753[Favorited Favorite](# "Add to favorites") 15[Wish List](# "Add to wish list")****[![Solder Lead Free - 100-gram Spool](img/7b08ea50c5c651e0ff07ff059946777a.png)](https://www.sparkfun.com/products/9325) 

将**添加到您的[购物车](https://www.sparkfun.com/cart)中！**

### [无铅焊料- 100 克线轴](https://www.sparkfun.com/products/9325)

[In stock](https://learn.sparkfun.com/static/bubbles/ "in stock") TOL-09325

这是带有水溶性树脂芯的无铅焊料的基本线轴。0.031 英寸规格，100 克。这是一个好主意…

$9.957[Favorited Favorite](# "Add to favorites") 33[Wish List](# "Add to wish list")****[![Soldering Iron - 30W (US, 110V)](img/9244563a05c8c398ff1ab18608118b63.png)](https://www.sparkfun.com/products/9507) 

将**添加到您的[购物车](https://www.sparkfun.com/cart)中！**

### [烙铁- 30W(美国，110V)](https://www.sparkfun.com/products/9507)

[33 available](https://learn.sparkfun.com/static/bubbles/ "33 available") TOL-09507

这是一个非常简单的固定温度，快速加热，30W 110/120 VAC 烙铁。我们真的很喜欢使用更贵的 iro…

$10.957[Favorited Favorite](# "Add to favorites") 21[Wish List](# "Add to wish list")**************Note:** While not required, the [Break Away Headers - 40-pin Male Long Centered, PTH, 0.1"](https://www.sparkfun.com/products/12693) and a breadboard can be useful to help in soldering female header pins to the shields. The 1x3 [straight breakaway headers](https://www.sparkfun.com/products/116) included can also be helpful in soldering the boards provided in the MyoWare Muscle Sensor Kit. Just make sure to insert the longer end of the header into a breadboard to secure the pins.

### 推荐阅读

在开始之前，您可能会发现以下链接很有用:

[](https://learn.sparkfun.com/tutorials/how-to-solder-through-hole-soldering) [### 如何焊接:通孔焊接](https://learn.sparkfun.com/tutorials/how-to-solder-through-hole-soldering) This tutorial covers everything you need to know about through-hole soldering.[Favorited Favorite](# "Add to favorites") 70

## 肌件肌肉传感器

新版本意味着新功能。下面是添加到 [MyoWare 肌肉传感器板](https://www.sparkfun.com/products/13723)的新功能的明细:

**单电源** — MyoWare 不需要电压电源！与以前的传感器不同，它现在可以直接插入 3.3V - 5V 开发板。

**嵌入式电极连接器** —电极现在可以直接卡在 MyoWare 上，摆脱了那些讨厌的电缆，使 MyoWare 可以佩戴！

**原始肌电图输出** —这是研究生的普遍要求，MyoWare 现在有了原始肌电图波形的辅助输出。

**极性保护电源引脚** —客户的首要要求是增加一些保护，这样当电源意外反向连接时，传感器芯片不会烧毁。

**开/关开关** —说到烧坏电路板，Advancer Technologies 还增加了一个板载电源开关，这样您可以更容易地测试电源连接。这对于省电也很方便。

**LED 指示灯** — Advancer Technologies 增加了两个板载 LED，一个让您知道 MyoWare 何时通电，另一个在您的肌肉弯曲时会变亮。

更多信息请看[官方 MyoWare 肌肉传感器数据表](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/datasheet.pdf)。

### 什么是肌电图？

肌电图用于记录肌肉的电活动。

### 嵌入式电极连接器

嵌入式电极连接器允许您将电路板直接粘贴到目标肌肉上，避免了电线的麻烦。

[![MyoWare embedded snap connectors](img/7f046bece967a547c7a08f503850d6ec.png)](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/MyoWareAttachement.jpg)*Embedded electrode connectors*

嵌入式卡扣连接器与我们的[生物医学感应垫(10 片装)](https://www.sparkfun.com/products/12969)配合良好。

## 电缆的输入套管

有些情况下，您可能希望将感应垫安装在远离其他硬件的地方。对于这些情况，我们出售 [MyoWare 电缆屏蔽](https://www.sparkfun.com/products/13687)。

[![MyoWare Cable Shield](img/4b52fdede281bb17eba54218e3ab46a5.png)](https://www.sparkfun.com/products/retired/14109) 

### [肌器电缆屏蔽](https://www.sparkfun.com/products/retired/14109)

[Retired](https://learn.sparkfun.com/static/bubbles/ "Retired") DEV-14109

MyoWare 肌肉传感器现在被设计成可佩戴的，允许您连接[生物医学传感器垫](https://www.sparkfu…

**Retired**[Favorited Favorite](# "Add to favorites") 12[Wish List](# "Add to wish list")

电缆屏蔽提供了一个插孔，您可以在此处连接三电极电缆。

[![Sensor Cable - Electrode  Pads (3 connector)](img/03b2e88c4bf449f3d51dda9128995beb.png)](https://www.sparkfun.com/products/12970) 

将**添加到您的[购物车](https://www.sparkfun.com/cart)中！**

### [【传感器电缆-电极片(3 个连接器)](https://www.sparkfun.com/products/12970)

[In stock](https://learn.sparkfun.com/static/bubbles/ "in stock") CAB-12970

这是简单的带电极板引线的三导体传感器电缆。这些电缆长 24 英寸，采用 3.5 毫米奥迪…

$5.509[Favorited Favorite](# "Add to favorites") 37[Wish List](# "Add to wish list")** **可以将感应垫连接到屏蔽的 3.5 毫米 TRS 插孔连接器上，而不是直接连接到 MyoWare 肌肉传感器上。两组触点将连接在一起，因此确保每个参考[R]、末端[E]和中间[M]引脚仅使用一个焊盘。

**Note:** The cable color codes can vary depending on the manufacturer. If you are seeing unusual sensor readings and the MyoWare is not responding to a muscle group, try testing the pinout by using a [multimeter set to measure continuity](https://learn.sparkfun.com/tutorials/how-to-use-a-multimeter#continuity). Below is a table that references the cable connections for each version of the cable shield. The current version was redesigned to match [Myoware's user manual (page 7)](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/MyoWareDatasheet.pdf) and the electrode cable that is sold in SparkFun's catalog:

| 相对于仰视图的引脚排列 | v10[[DEV-13687](https://www.sparkfun.com/products/retired/13687) | v11[[DEV-14109](https://www.sparkfun.com/products/14109) |
| 引用[R] | 蓝色 | 黑色 |
| 结束[E] | 红色 | 蓝色 |
| 中间[M] | 黑色 | 红色 |

[![](img/a279f158265c89f6a2fb82de1fd3018d.png "MyoWare Bottom View")](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/14109-04rev.jpg)

## 电源屏蔽

[MyoWare Power Shield](https://www.sparkfun.com/products/13684) 被设计成可以容纳两个纽扣电池，例如一些标准的 [CR2032s](https://www.sparkfun.com/products/338) 。

[![MyoWare Power Shield](img/d226ad17fba36fbf1f995fc1bd9c8973.png)](https://www.sparkfun.com/products/retired/13684) 

### [肌器力量盾](https://www.sparkfun.com/products/retired/13684)

[Retired](https://learn.sparkfun.com/static/bubbles/ "Retired") DEV-13684

MyoWare Power Shield 设计为使用两个标准 CR2032 纽扣电池为 MyoWare 肌肉传感器供电。我们有…

1 **Retired**[Favorited Favorite](# "Add to favorites") 14[Wish List](# "Add to wish list")

它们并联连接，以扩展标称 3.0V 的容量。需要注意的一点是，由于电池的尺寸，远程电缆头无法通过。如果您需要访问这些连接，必须将此电源屏蔽堆叠在需要访问的电路板上方。

电池供电允许更干净的信号，也消除了对电网产生危险电流路径的可能性。

## 原始护盾

MyoWare Proto Shield 将所有信号传递给一点 protoboard。用这个区域焊接你能想到的任何定制电路。

[![MyoWare Proto Shield](img/ac4a599b3254695dc2f4e70295d8e58f.png)](https://www.sparkfun.com/products/13709) 

将**添加到您的[购物车](https://www.sparkfun.com/cart)中！**

### [肌器神盾](https://www.sparkfun.com/products/13709)

[In stock](https://learn.sparkfun.com/static/bubbles/ "in stock") BOB-13709

这是 MyoWare Proto Shield，一个用于 MyoWare 肌肉传感器的简单原型板。有了这个盾牌，你就可以…

$2.95 $1.031[Favorited Favorite](# "Add to favorites") 13[Wish List](# "Add to wish list")** **电缆屏蔽层和 Proto 屏蔽层两端各有两排 3 针电镀通孔。标准的“0.1”接头用于将它们与其他电路板堆叠在一起。使用公头和母头的组合，这可以减小堆叠板的轮廓。

## LED 屏蔽罩

对于那些寻求信号电平大显示的用户，我们提供了 [MyoWare LED Shield](https://www.sparkfun.com/products/13688) 。

[![MyoWare LED Shield](img/896e06cb1c6f3be68296e307e151d1c4.png)](https://www.sparkfun.com/products/13688) 

将**添加到您的[购物车](https://www.sparkfun.com/cart)中！**

### [明器引盾](https://www.sparkfun.com/products/13688)

[In stock](https://learn.sparkfun.com/static/bubbles/ "in stock") DEV-13688

MyoWare LED 防护罩旨在与[myo ware Muscle Sensor](https://www . spark fun . com/products/13723)配对。蓝光…

$26.95 $13.481[Favorited Favorite](# "Add to favorites") 15[Wish List](# "Add to wish list")** **LED 屏蔽提供了一个大的 10 段条形图，对应于所测量的肌肉信号水平。这个盾牌很可能是堆叠中最上面的那块。焊接一些 1x3 公接头，并将其插入传感器板。电源由 LED 罩提供，但由传感器上的电源开关控制。一旦堆叠完成，扣上一些电极，将传感器贴在目标肌肉上。

[![MyoWare LED Shield on an arm](img/9025ddfab86a8e77543ea8010b79faa0.png)](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/arm.jpg)*MyoWare LED Shield on an arm*

测量到的肌肉活动越多，发光二极管的位置就越高。在上图中,“MIN”标签附近的两个分段被点亮，如果测量的电压增加，左边的分段将开始点亮，直到到达最后一个标有“MAX”的分段。led 足够亮，可以在全光下看到，但在弱光下真的发光很好。

[![MyoWare LED Shield in the dark](img/9fd1f10cd8a389da3be2e57bfd4de787.png)](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/dark.jpg)*MyoWare LED Shield in the dark*

## 把所有的放在一起

如上所述，有两种方式将感应垫附着到用户身上。它们可以直接连接到传感器板上，也可以通过 MyoWare 电缆屏蔽层连接到电缆末端。

在下图中，最左边的电极连接应该连接到被测肌肉群的末端。同样，电缆颜色代码可能因制造商而异。相对于当前的 MyoWare Shield 和 SparkFun 目录中销售的电极电缆，这相当于使用连接到标有 e 的引脚的蓝色绝缘导线。右侧的中间肌肉电极在连接到标有 m 的引脚的电缆上的红色卡扣处断开。参考电极与连接到标有 r 的引脚的黑色卡扣具有连续性。

[![MyoWare sensor layout](img/b061bf3000cd0596313efcea245ea9f8.png)](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/topSensor.jpg)*MyoWare sensor layout*

如上图所示，有三排三个 0.1 英寸间隔的电镀通孔。右边是电源+Vs 和地，以及经过处理的输出信号(孔 1、2 和 3)。

沿着靠近中间肌肉电极扣的长边是用于远程电极连接的通孔(孔 4、5 和 6)。

另一端是三个“输出”。孔 7 是原始的、未处理的 EMG 信号。孔 8 是开关电源。电源通过孔 1 进入电路板，进行切换，然后从孔 8 返回(如果你相信[无源符号约定](https://en.wikipedia.org/wiki/Passive_sign_convention) (PSC))。孔 9 是开关电源的接地参考。

屏蔽物带有对这些针的各种支持。一些防护罩，如电源防护罩不支持远程连接。如果你需要接触这些引脚，使用或能通过这些引脚的电路板必须放在堆叠的较低位置。电缆屏蔽和 Proto 屏蔽都具有这种连接能力。

[![MyoWare Power Shield top view](img/c3b0c588b521454640a2a9ab70f54275.png)](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/topPower.jpg "Provides power to system")

*MyoWare Power Shield(俯视图)*

[![MyoWare LED Shield top view](img/f6bf20be0f24630817db9fde53ba9b68.png)](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/topLED.jpg)

*MyoWare LED 防护罩(俯视图)*

[![MyoWare Cable Shield bottom view](img/81584efbe6da202c099cee490fc8500e.png)](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/topCable.jpg "Allows remote sensors")

*MyoWare 电缆屏蔽(仰视图)*

[![MyoWare Proto Shield top view](img/de938febe25d5912a5f44a190c54c6c6.png)](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/topProto.jpg "Prototyping area for custom projects")

*MyoWare Proto Shield(俯视图)*

**Danger!** The power shield and the LED shield both provide power, but at slightly different voltages. Don't use both of these shields at the same time.

注意电缆和原型护盾上的第二排孔。这允许使用标准的 0.1 英寸接头或可堆叠式接头堆叠多个屏蔽层。

[![Break Away Headers - Straight](img/e594356c79a2a5062af8a654531060bc.png)](https://www.sparkfun.com/products/116) 

将**添加到您的[购物车](https://www.sparkfun.com/cart)中！**

### [破开头球——直击](https://www.sparkfun.com/products/116)

[In stock](https://learn.sparkfun.com/static/bubbles/ "in stock") PRT-00116

一排标题-打破适应。40 个引脚，可切割成任何尺寸。用于定制 PCB 或通用定制接头。

$1.7520[Favorited Favorite](# "Add to favorites") 133[Wish List](# "Add to wish list")****[![Female Headers](img/2bed883e9755d1524a00790f72b1c7cc.png)](https://www.sparkfun.com/products/115) 

将**添加到您的[购物车](https://www.sparkfun.com/cart)中！**

### [女标题](https://www.sparkfun.com/products/115)

[In stock](https://learn.sparkfun.com/static/bubbles/ "in stock") PRT-00115

单排 40 孔，内螺纹接头。可以用一把钢丝钳切割成合适的尺寸。标准 0.1 英寸间距。我们广泛使用它们…

$1.758[Favorited Favorite](# "Add to favorites") 71[Wish List](# "Add to wish list")****[![Stackable Header - 3 Pin (Female, 0.1")](img/04f1669e5e3d81871663d63e6b97a18f.png)](https://www.sparkfun.com/products/13875) 

将**添加到您的[购物车](https://www.sparkfun.com/cart)中！**

### [【可堆叠接头- 3 针(母，0.1”)](https://www.sparkfun.com/products/13875)

[In stock](https://learn.sparkfun.com/static/bubbles/ "in stock") PRT-13875

这是一个简单的 3 针阴性 PTH 接头。该割台的配置非常适合与[MyoWare …配合使用

$0.75[Favorited Favorite](# "Add to favorites") 8[Wish List](# "Add to wish list")****** ******### 选项 1

列出的接头为用户提供了一些将屏蔽堆叠在一起的选项。我们发现用母接头填充 MyoWare 传感器和屏蔽更容易。如果使用随套件提供的可堆叠接头，您可能需要使用[对角切割器](https://www.sparkfun.com/products/8794)从底部平齐切割长引线。以下是堆叠在 MyoWare 传感器上的电缆屏蔽的示例。

[![Cable Shield Stacked on tope of the MyoWare Sensor](img/7dab2b72fcebb10b8f1399a854fcfc88.png)](https://cdn.sparkfun.com/assets/learn_tutorials/4/9/1/MyowareCable_ShieldStackedMuscleSensor.jpg)**Note:** To make stacking easier, the MyoWare Muscle Sensor Kit includes 3-pin stackable headers. Using these on all of the shields allows for easy stacking in more configurations.

[![](img/592371380e39a6d665437b4866bb0f84.png "3 pin stackable header")](https://cdn.sparkfun.com/assets/parts/1/1/3/2/7/13875-02.jpg)

*3-Pin Stackable Header*

### 选项 2

也有可能在堆叠中使用公头引脚。如果使用套件中提供的零件，这些公接头可能会安装在底部堆叠上。在大多数情况下，底板应在外部底部行安装公接头，以与将堆叠在顶部的板配合。堆叠在顶部的电路板应具有面向公接头引脚的母接头。

**Note:** We have also included three 1x3 male headers in the kit. The normal use case will to be to put two of them on the LED shield, but some of you might want a clean top surface on the cable or proto shields so we thew in an extra one for this option.

## 资源和更进一步

感谢阅读。有关 MyoWare 产品线的更多信息，请访问以下链接。

*   【MyoWare 官方数据表
*   [感应垫数据表](https://cdn.sparkfun.com/datasheets/Sensors/Biometric/H124SG.pdf)
*   【Advancer Technologies 官方网站
    *   [DIY 导电织物电极](http://www.advancertechnologies.com/2013/03/diy-conductive-fabric-electrodes.html)
*   [Advancer Technologies GitHub 知识库](https://github.com/AdvancerTechnologies)
*   [MyoWare GitHub 存储库](https://github.com/AdvancerTechnologies/MyoWare_MuscleSensor)
*   [Arduino 示例代码](http://cdn.sparkfun.com/datasheets/Sensors/Biometric/MuscleSensor_Arduino.zip)

想了解更多酷的项目和想法，请查看以下 SparkFun 教程。

[](https://learn.sparkfun.com/tutorials/fingerprint-scanner-gt-521fxx-hookup-guide) [### 指纹扫描仪(GT-521Fxx)连接指南](https://learn.sparkfun.com/tutorials/fingerprint-scanner-gt-521fxx-hookup-guide) This tutorial provides information about how to connect to ADH-Tech's fingerprint scanner (GT-521F32) and how to use it with Hawley's FPS_GT511C3 library for Arduino.[Favorited Favorite](# "Add to favorites") 13[](https://learn.sparkfun.com/tutorials/sparkfun-pulse-oximeter-and-heart-rate-monitor-hookup-guide) [### SparkFun 脉搏血氧仪和心率监测器连接指南](https://learn.sparkfun.com/tutorials/sparkfun-pulse-oximeter-and-heart-rate-monitor-hookup-guide) Find out your oxygen saturation level or check out your heart rate using the MAX30101 biometric sensor and MAX32664 Biometric Hub via I2C![Favorited Favorite](# "Add to favorites") 7[](https://learn.sparkfun.com/tutorials/sparkfun-photodetector-max30101-hookup-guide) [### SparkFun 光电探测器(MAX30101)连接指南](https://learn.sparkfun.com/tutorials/sparkfun-photodetector-max30101-hookup-guide) The SparkFun Photodetector - MAX30101 (Qwiic) is the successor to the MAX30105 particle sensor, a highly sensitive optical sensor. This tutorial will get you started on retrieving the raw data from the MAX30101 sensor.[Favorited Favorite](# "Add to favorites") 0[](https://learn.sparkfun.com/tutorials/getting-started-with-the-myoware-20-muscle-sensor-ecosystem) [### MyoWare 2.0 肌肉传感器生态系统入门](https://learn.sparkfun.com/tutorials/getting-started-with-the-myoware-20-muscle-sensor-ecosystem) The MyoWare® 2.0 Muscle Sensor, an Arduino-compatible, all-in-one electromyography (EMG) sensor from Advancer Technologies. In this tutorial, we will go over the features and related shields to connect the sensor to a muscle group.[Favorited Favorite](# "Add to favorites") 0******************