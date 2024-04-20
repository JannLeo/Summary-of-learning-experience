%lec4exp7
close all, clear all
%% 读入待压缩图像原始数据
filename = 'Lenna.png';%读入lenna图像
%filename = 'Weeki_Wachee_spring.jpg';
ratio = 1;%比率为1
ImgLossyCodec_Encoder_Demo(filename, ratio, 0)%参数为文件名，比率，diffmode值