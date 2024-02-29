# 18th Week Summarize



![image-20240228092559901](18week%20Summarize.assets/image-20240228092559901.png)

如上图，是Instrumentation Amplifier的电路图，我使用Multisim将其电路图部署到应用上后如下图所示：

![](18week%20Summarize.assets/image-20240228221833394.png)

可以看到整体而言这个电路的放大效果并没有多大，但是计算后发现对于U1，它是一个非反相放大器，增益是由R1,R4和RG决定，计算后发现是1+R4/RG = 1+ 10k/500 = 21,而U2是一个反相放大器，增益由R2和R3设置，由于相等所以是-1. 而U3仅仅是作为一个缓冲器，那么这里就很奇怪了，总增益应该是-21，但是通过示波器并不能看到信号的增大。