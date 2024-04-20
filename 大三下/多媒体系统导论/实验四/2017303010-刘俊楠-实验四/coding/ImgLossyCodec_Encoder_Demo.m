%%file ImgLossyCodec_Encoder_Demo.m
function ImgLossyCodec_Encoder_Demo(filename, ratio, diffmode)
%close all, clear all
%% �����ѹ��ͼ��ԭʼ����
filename = 'Lenna.png';
% filename = 'Weeki_Wachee_spring.jpg';
%��ȡͼ��
img_rgb = imread(filename);
%��ͼƬ�Ŵ�1/ratio ��
img_rgb = imresize(img_rgb, 1/ratio);
%h������ w:���� d������ Ϊrgbͼ��Ĵ�С  �ú����Ǽ���ͼ������в���
[h, w, d] = size(img_rgb);
%�����������1
if d > 1 
    %rgbתycbcr
    img_yuv = rgb2ycbcr(img_rgb);
end
%�û�ָ��ѹ���̶�
qf=50;
% �������·��
stream_path = 'stream';
%��� stream_path ������·���е��ļ��У��� ~isdir(stream_path)  ���� 0������û�д����ļ��У����� 1������������ת��䴴���ļ��С�
if ~isdir(stream_path)
    mkdir(stream_path);
end
% �ļ������� [filepath,name,ext] = fileparts(filename) ����ָ���ļ���·�����ơ��ļ�������չ����
[pathstr, name,ext] = fileparts(filename);
%% ��ͼ��ĸ���ͨ�����е������룬ÿ��ͨ�����htree.bin��stream.bin�����ļ���
tic %tic ��¼��ǰʱ��
size_dict=0; % huffman tree���ļ��Ĵ�С(Byte)
size_bitstream=0; % ���ɵ������ļ����ܴ�С(Byte)

if d == 1 %���ͨ��=1
    flag=0;
    %sprintf�����ݸ�ʽ��Ϊbin��htreefile
    htreefile = sprintf('%s\\%s_m%d_htree.bin',stream_path,name,diffmode);
    %sprintf�����ݸ�ʽ��Ϊbin��streamfile
    streamfile =sprintf('%s\\%s_m%d_stream.bin',stream_path,name,diffmode);
    %����encode_channel.m�ĺ��� ��rgbͼ��Huffman���������ļ���������������ļ�����ֵ���������������
    [size_dict, size_bitstream,f_c]=encode_channel(img_rgb, htreefile,streamfile, diffmode,d,flag,qf);
    [~,ww1]=size(f_c);
    ff_c(1,1:ww1)=f_c;
else
    flag=1;
    %ch1�ӵ�һ��ѭ������d��
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
disp(sprintf('Encoding time�� %6.4f s', toc));
disp(sprintf('Dict size�� %d Bytes', size_dict));
disp(sprintf('Code size�� %d Bytes', size_bitstream));
%%Calculation of compression ratio
B0 = numel(img_rgb);
B1 = size_dict+size_bitstream;
compressionratio=B0/B1;
disp(sprintf('Orginal�� %d Bytes; Compressed�� %d Bytes; Compression ratio��%6.2f \r\n ----------------',B0, B1, compressionratio));
%% ��ͼ��ĸ���ͨ�����е������룬ÿ��ͨ�����Ƚ�����Ӧ��htree.bin�ļ�������HuffmanTreeB0,�ٶ�stream.bin�ļ����н�����ؽ���
tic
size_dict=0; % ��ȡ��huffman tree���ļ���С(Byte)
size_bitstream=0; % ��ȡ�������ļ����ܴ�С(Byte)
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
disp(sprintf('Decoding time�� %6.4f s', toc));
if d~=1
    mse_yuv= sum((double(img_yuv(:))-double(img_yuv_rec(:))).^2)/numel(img_yuv);
end
mse_rgb= sum((double(img_rgb(:))-double(img_rec(:))).^2)/numel(img_rgb);
%���漸�д����ж��Ǹ�yuv��ʱ����û�����ݶ�ʧ�������4:4:4�Ͳ�Ӧ���ж�ʧ��������0 
%�������ǽ����˶��β�������������4:2:0������һ���ᶪʧ��������ע�͵���
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