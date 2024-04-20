%%file ImgLossyCodec_Encoder_Demo.m
function ImgLossyCodec_Encoder_Demo(filename, ratio, diffmode)
%close all, clear all
%% 读入待压缩图像原始数据
filename = 'Lenna.png';
% filename = 'Weeki_Wachee_spring.jpg';
%获取图像
img_rgb = imread(filename);
%将图片放大1/ratio 倍
img_rgb = imresize(img_rgb, 1/ratio);
%h：列数 w:行数 d：层数 为rgb图像的大小  该函数是计算图像的行列层数
[h, w, d] = size(img_rgb);
%如果层数大于1
if d > 1 
    %rgb转ycbcr
    img_yuv = rgb2ycbcr(img_rgb);
end
%用户指定压缩程度
qf=50;
% 码流存放路径
stream_path = 'stream';
%如果 stream_path 是搜索路径中的文件夹，则 ~isdir(stream_path)  返回 0。否则没有创建文件夹，返回 1，进入条件跳转语句创建文件夹。
if ~isdir(stream_path)
    mkdir(stream_path);
end
% 文件名解析 [filepath,name,ext] = fileparts(filename) 返回指定文件的路径名称、文件名和扩展名。
[pathstr, name,ext] = fileparts(filename);
%% 对图像的各个通道进行单独编码，每个通道输出htree.bin和stream.bin两个文件。
tic %tic 记录当前时间
size_dict=0; % huffman tree的文件的大小(Byte)
size_bitstream=0; % 生成的码流文件的总大小(Byte)

if d == 1 %如果通道=1
    flag=0;
    %sprintf将数据格式化为bin给htreefile
    htreefile = sprintf('%s\\%s_m%d_htree.bin',stream_path,name,diffmode);
    %sprintf将数据格式化为bin给streamfile
    streamfile =sprintf('%s\\%s_m%d_stream.bin',stream_path,name,diffmode);
    %调用encode_channel.m的函数 将rgb图像、Huffman树二进制文件、输出流二进制文件、差分当做参数发给函数
    [size_dict, size_bitstream,f_c]=encode_channel(img_rgb, htreefile,streamfile, diffmode,d,flag,qf);
    [~,ww1]=size(f_c);
    ff_c(1,1:ww1)=f_c;
else
    flag=1;
    %ch1从第一层循环到第d层
    ff_c=zeros(3,262144);
    for chl=1:d
        htreefile =sprintf('%s\\%s_chl%d_m%d_htree.bin',stream_path,name,chl,diffmode);
        streamfile =sprintf('%s\\%s_chl%d_m%d_stream.bin',stream_path,name,chl,diffmode);
        [size_dict_chl,size_bitstream_chl,f_c]=encode_channel(img_yuv(:,:,chl), htreefile, streamfile,diffmode,chl,flag,qf);
        size_dict=size_dict+size_dict_chl;
        size_bitstream=size_bitstream+size_bitstream_chl;
        [~,ww1]=size(f_c);
        ff_c(chl,1:ww1)=f_c;
    end
end
disp(sprintf('Image Encoding Finshed'));
disp(sprintf('Encoding time： %6.4f s', toc));
disp(sprintf('Dict size： %d Bytes', size_dict));
disp(sprintf('Code size： %d Bytes', size_bitstream));
%%Calculation of compression ratio
B0 = numel(img_rgb);
B1 = size_dict+size_bitstream;
compressionratio=B0/B1;
disp(sprintf('Orginal： %d Bytes; Compressed： %d Bytes; Compression ratio：%6.2f \r\n ----------------',B0, B1, compressionratio));
%% 对图像的各个通道进行单独解码，每个通道首先解析相应的htree.bin文件，生成HuffmanTreeB0,再对stream.bin文件进行解码和重建。
tic
size_dict=0; % 读取的huffman tree的文件大小(Byte)
size_bitstream=0; % 读取的码流文件的总大小(Byte)
img_yuv_rec=zeros(h,w,d);
if d == 1
htreefile = sprintf('%s\\%s_m%d_htree.bin',stream_path,name,diffmode);
streamfile =sprintf('%s\\%s_m%d_stream.bin',stream_path,name,diffmode);
img_rec = decode_channel(htreefile, streamfile, diffmode, [h, w],1,ff_c(1,:),flag,qf);
else
for chl=1:d
    htreefile =sprintf('%s\\%s_chl%d_m%d_htree.bin',stream_path,name,chl,diffmode);
    streamfile =sprintf('%s\\%s_chl%d_m%d_stream.bin',stream_path,name,chl,diffmode);
    img_yuv_rec_chl = decode_channel(htreefile, streamfile, diffmode,[h, w],chl,ff_c(chl,:),flag,qf);
    img_yuv_rec(:,:,chl) = double(img_yuv_rec_chl);
end
img_yuv_rec = uint8(img_yuv_rec);
img_rec = ycbcr2rgb(img_yuv_rec);
end
disp(sprintf('Image Decoding Finshed'));
disp(sprintf('Decoding time： %6.4f s', toc));
if d~=1
    mse_yuv= sum((double(img_yuv(:))-double(img_yuv_rec(:))).^2)/numel(img_yuv);
end
mse_rgb= sum((double(img_rgb(:))-double(img_rec(:))).^2)/numel(img_rgb);
%下面几行代码判断那个yuv的时候有没有数据丢失，如果是4:4:4就不应该有丢失，所以是0 
%但是我是进行了二次采样，将其变成了4:2:0，所以一定会丢失，所以我注释掉了
% if mse_yuv
% disp('Image Lossy Compression Failed!')
% else
% disp('Image Lossy Compression Success!')
% end
subplot(121),imshow(img_rgb), title(sprintf('original: %s', name))
if(d~=1)
subplot(122),imshow(img_rec), title(sprintf('MSE YUV: %6.2f; RGB: %6.2f',mse_yuv, mse_rgb))
else
    subplot(122),imshow(img_rec), title(sprintf('MSE YUV: %6.2f', mse_rgb))
end
% imwrite(img_rec,'compressed_img.jpg');