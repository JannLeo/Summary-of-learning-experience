%%file decode_channel.m
function img = decode_channel(htreefile, streamfile, diffmode, imgsize,ch1,f_c,flag,qf)
    %% 读取码流文件
    dict_d = readhtree(htreefile);
    bitstream_d = readstreamfile(streamfile);
    dhsig = huffmandeco(bitstream_d,dict_d);
    [~,ww1]=size(dhsig);
    T = dctmtx(8);%基函数
        %二维运算公式 
        %@(block_struct)装饰器函数.@(block_struct)后面加上修改的函数
        % block_struct.data表示传入的数据,也就是图片或者矩阵,
        % 然后加上相关的参数.他会返回一个函数
     Y_Table=[ 16  11  10  16  24  40  51  61 ; 
	            12  12  14  19  26  58  60  55 ; 
	            14  13  16  24  40  57  69  56 ; 
	            14  17  22  29  51  87  80  62 ; 
	            18  22  37  56  68 109 103  77 ; 
	            24  35  55  64  81 104 113  92 ; 
	            49  64  78  87 103 121 120 101 ; 
	            72  92  95  98 112 100 103  99 ];%亮度量化表
         
    CbCr_Table=[17  18  24  47  99  99  99  99 ; 
            18  21  26  66  99  99  99  99 ;
            24  26  56  99  99  99  99  99 ; 
            47  66  99  99  99  99  99  99 ; 
            99  99  99  99  99  99  99  99 ; 
            99  99  99  99  99  99  99  99 ; 
            99  99  99  99  99  99  99  99 ; 
            99  99  99  99  99  99  99  99 ];%色差量化表
    Q1=[1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1];%全1量化矩阵
    %qf是用户选择的压缩质量
    %Q1是全1量化矩阵
    if qf>=50
        scaling_factor= (100-qf)/50;
    else
        scaling_factor=(50/qf);
    end
    if scaling_factor ~= 0
        CbCr_Table=round(CbCr_Table*scaling_factor);
        Y_Table=round(Y_Table*scaling_factor);
    else
        CbCr_Table=Q1;
        Y_Table=Q1;
    end
    CbCr_Table=double(CbCr_Table);
    Y_Table=double(Y_Table);
    idct=@(block_struct) T'* block_struct.data*T;
    kk=1;
    dh=[];
    for i=1:2:ww1
        for j=1:1:dhsig(1,i)
            dh=[dh,0];
        end
        dh=[dh,f_c(1,kk)];
        kk=kk+1;
    end
    YCbCr_f=zeros(imgsize(1),imgsize(2));
    f_cc=f_c(1,1:imgsize(1)*imgsize(2)/4);
    %对三个通道反量化
    if(ch1==1)
        diffimg = reshape(f_c, imgsize(1), imgsize(2));
        diffimg=diffimg';
%         [row,col,~]=size(diffimg);
        f_y=blockproc(diffimg(:,:),[8,8],@(block_struct)block_struct.data.*Y_Table);
        f_y=fix(f_y);
        f_y=blockproc((f_y),[8 8],idct);
        if(flag==1)
            f_y=uint8(f_y+128);
        else
            f_y=uint8(f_y);
        end
        f_y(f_y<0)=0;
        f_y(f_y>255)=255;
        YCbCr_f(:,:)=f_y;
        if flag==0
            img=uint8(YCbCr_f);
        else
            img=(YCbCr_f);
        end
    end
    if(ch1==2)
        diffimg = reshape(f_cc, (imgsize(1))/2, (imgsize(2))/2);
        diffimg=diffimg';
        [row,col,~]=size(diffimg);
        f_U=blockproc(diffimg(:,:),[8,8],@(block_struct)block_struct.data.*CbCr_Table);
        f_U=fix(f_U);
        f_U=blockproc((f_U),[8 8],idct);
        f_U=uint8(f_U+128);
        f_U(f_U<0)=0;
        f_U(f_U>255)=255;
        for i=1:row
            for j=1:col
                YCbCr_f(2*i-1,2*j-1)=f_U(i,j);
                YCbCr_f(2*i,2*j-1)=f_U(i,j);
                YCbCr_f(2*i-1,2*j)=f_U(i,j);
                YCbCr_f(2*i,2*j)=f_U(i,j);
            end
        end
        img=YCbCr_f;
    end
    if(ch1==3)
        diffimg = reshape(f_cc,(imgsize(1))/2, (imgsize(2))/2);
        diffimg=diffimg';
        [row,col,~]=size(diffimg);
        f_V=blockproc(diffimg(:,:),[8,8],@(block_struct)block_struct.data.*CbCr_Table);
        f_V=fix(f_V);
        f_V=blockproc((f_V),[8 8],idct);
        f_V=uint8(f_V+128);
        f_V(f_V<0)=0;
        f_V(f_V>255)=255;
        %恢复出YCBCR图像
        for i=1:row
            for j=1:col
                YCbCr_f(2*i-1,2*j-1)=f_V(i,j);
                YCbCr_f(2*i,2*j-1)=f_V(i,j);
                YCbCr_f(2*i-1,2*j)=f_V(i,j);
                YCbCr_f(2*i,2*j)=f_V(i,j); 
            end
        end
        img=YCbCr_f;
    end
end