%%file encode_channel.m 
function [size_dict, size_bitstream,yy]=encode_channel(img, htreefile,streamfile, diffmode,chl,flag,qf)
        %对传进来的ycbcr图像转换成double
        img_ycbcr = double(img);
        %计算yuv图像的行数和列数
        [row,col,~]=size(img_ycbcr);
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
        %二维运算公式 
        T = dctmtx(8);%基函数
        %@(block_struct)装饰器函数.@(block_struct)后面加上修改的函数
        % block_struct.data表示传入的数据,也就是图片或者矩阵,
        % 然后加上相关的参数.他会返回一个函数
        dct = @(block_struct) T* block_struct.data*T';

        %qf为影响scaling factor放缩因素的大小的值
        if qf>=50
            scaling_factor= (100-qf)/50;
        else
            scaling_factor=(50/qf);
        end
        %如果放缩因素不等于0，则放缩量化表，否则不放缩，量化表为全1
        if scaling_factor ~= 0
            CbCr_Table=round(CbCr_Table*scaling_factor);
            Y_Table=round(Y_Table*scaling_factor);
        else
            CbCr_Table=Q1;
            Y_Table=Q1;
        end
        CbCr_Table=double(CbCr_Table);
        Y_Table=double(Y_Table);
    %% 信号源的统计特性分析
    if ~diffmode %如果差分=0 进行AC系数编码
        %设置zigzag分块方法
        zigzagg=@(block_struct)zigzag(block_struct.data,8,8);
        if(chl==1)%当层数为1时  也就是y通道
            Y(:,:)=img_ycbcr(:,:);
            %对灰度图像区分，因为灰度图像-128化0均值不划算，超过128像素太少
            if flag~=0
                Y_B=double(Y-128);
                %分块dct
                Y_B = blockproc((Y_B),[8 8],dct);
            else
                Y_B = blockproc((Y),[8 8],dct);
            end
            %量化
            f_y=blockproc(Y_B,[8,8],@(block_struct)block_struct.data./Y_Table);
            %向0取整
            f_y=fix(f_y);
            YCbCr_f(:,:)=f_y;
            %分块zigzag
            z_y=blockproc(f_y,[8,8],zigzagg);
            z_y=z_y';%转置 因为reshape函数是按列计算的
            [h1,w1]=size(z_y);
            z_y=reshape(z_y,[w1,h1]);
            z_y=z_y';%再转回来
            [Height1,~] = size(z_y);
            %进行RLC编码
            r_c=[];
            for i=1:8:Height1
                r_c_temp=RLCcode(z_y(i:i+7,:),8*64,chl);
                r_c=[r_c,r_c_temp];
            end
            [~,ww1]=size(r_c);
            %计算size位数，并且存储value值
            f_c=[];
            for i=2:2:ww1
                r_c_num=r_c(1,i);
                f_c=[f_c,r_c_num];
                numm=0;
                while r_c_num~=0
                    r_c_num=fix(r_c_num/2);
                    numm=numm+1;
                end
                r_c(1,i)=numm;
            end

            
            for i=1:1:row
                for j=1:1:col
                    yy((i-1)*row+j)=YCbCr_f(i,j);
                end
            end
        end
        if(chl==2)
            U(:,:)=img_ycbcr(:,:);
            for i=1:2:row-1 %从第一行起对行隔行扫描 上限为row-1行数
                for j=1:2:col-1 %对列隔列扫描  上限为col-1列数
                    newU((i+1)/2,(j+1)/2)=double(img_ycbcr(i,j)); 
                end
            end
            newU_B=double(newU-128);
            newU_B = blockproc((newU_B),[8 8],dct);
            f_U=blockproc(newU_B,[8,8],@(block_struct)block_struct.data./CbCr_Table);
            f_U=fix(f_U);
            YCbCr_f(:,:)=f_U;

            z_u=blockproc(f_U,[8,8],zigzagg);
            z_u=z_u';
            [h1,w1]=size(z_u);
            z_u=reshape(z_u,[w1,h1]);
            z_u=z_u';
            [Height2,Width2] = size(z_u);
            r_c=[];
            for i=1:8:Height2
                r_c_temp=RLCcode(z_u(i:i+7,:),8*32,chl);
                r_c=[r_c,r_c_temp];
            end
            [~,ww1]=size(r_c);
            f_c=[];
            for i=2:2:ww1
                r_c_num=r_c(1,i);
                f_c=[f_c,r_c_num];
                numm=0;
                while r_c_num~=0
                    r_c_num=fix(r_c_num/2);
                    numm=numm+1;
                end
                r_c(1,i)=numm;
            end
            for i=1:1:row/2
                for j=1:1:col/2
                    yy((i-1)*row/2+j)=YCbCr_f(i,j);
                end
            end
        end
        if(chl==3)
             V(:,:)=img_ycbcr(:,:);
            for i=2:2:row
                for j=1:2:col-1 
                    newV(i/2,(j+1)/2)=double(img_ycbcr(i,j)); 
                end
            end
            newV_B=double(newV-128);
            newV_B = blockproc((newV_B),[8 8],dct);
            f_V=blockproc(newV_B,[8,8],@(block_struct)block_struct.data./CbCr_Table);
            f_V=fix(f_V);
            YCbCr_f(:,:)=f_V;

            z_v=blockproc(f_V,[8,8],zigzagg);
            z_v=z_v';
            [h1,w1]=size(z_v);
            z_v=reshape(z_v,[w1,h1]);
            z_v=z_v';
            [Height3,Width3] = size(z_v);
            r_c=[];
            for i=1:8:Height3
                r_c_temp=RLCcode(z_v(i:i+7,:),8*32,chl);
                r_c=[r_c,r_c_temp];
            end
            [~,ww1]=size(r_c);
            f_c=[];
            for i=2:2:ww1
                r_c_num=r_c(1,i);
                f_c=[f_c,r_c_num];
                numm=0;
                while r_c_num~=0
                    r_c_num=fix(r_c_num/2);
                    numm=numm+1;
                end
                r_c(1,i)=numm;
            end
            for i=1:1:row/2
                for j=1:1:col/2
                    yy((i-1)*row/2+j)=YCbCr_f(i,j);
                end
            end
        end

    %对于没选择差分的情况即diffmode=~0
    %我们应该选择DC系数的方法来进行压缩编码
    else
        %y通道情况下
        if(chl==1)
            Y(:,:)=img_ycbcr(:,:);
            %对于rgb图像，-128的0均值处理后进行dct，否则gray仅仅进行dct
            if flag~=0
                Y_B=double(Y-128);
                Y_B = blockproc((Y_B),[8 8],dct);
            else
            Y_B = blockproc((Y),[8 8],dct);
            end
        
            f_y=blockproc(Y_B,[8,8],@(block_struct)block_struct.data./Y_Table);
            f_y=fix(f_y);
            YCbCr_f(:,:)=f_y;
            %初始化d_c：用于存储dc系数，r_c：存储size
            d_c=zeros(row*col/64);
            r_c=zeros(1,row*col/64);
            kk=1;
            %分块进行dc系数计算以及size计算
            for i=1:8:row
                for j=1:8:col
                    numm=(Y_B(i,j));
                    numm1=0;
                    while(numm~=0)
                       numm=fix(numm/2);
                       numm1=numm1+1;
                    end
                    r_c(1,kk)=numm1;
                    d_c(kk)=uint8(Y_B(i,j));
                    kk=kk+1;
                end
            end
%             f_y=blockproc(Y_B,[8,8],@(block_struct)block_struct.data./Y_Table);
%             f_y=fix(f_y);
%             YCbCr_f(:,:)=f_y;
               
            

            for i=1:1:row
                for j=1:1:col
                    yy((i-1)*row+j)=YCbCr_f(i,j);
                end
            end
        end
        if(chl==2)
            
            for i=1:2:row-1 %从第一行起对行隔行扫描 上限为row-1行数
                for j=1:2:col-1 %对列隔列扫描  上限为col-1列数
                    newU((i+1)/2,(j+1)/2)=double(img_ycbcr(i,j)); 
                end
            end
            newU_B=double(newU-128);
            newU_B = blockproc((newU_B),[8 8],dct);
            f_U=blockproc(newU_B,[8,8],@(block_struct)block_struct.data./CbCr_Table);
            f_U=fix(f_U);
            YCbCr_f(:,:)=f_U;
%             f_U=blockproc(newU_B,[8,8],@(block_struct)block_struct.data./CbCr_Table);
%             f_U=fix(f_U);
%             YCbCr_f(:,:)=f_U;
            d_c=zeros(row*col/64);
            r_c=zeros(1,row*col/64);
            kk=1;
            for i=1:8:row/2
                for j=1:8:col/2
                    numm=(newU_B(i,j));
                    numm1=0;
                    while(numm~=0)
                       numm=fix(numm/2);
                       numm1=numm1+1;
                    end
                    r_c(1,kk)=numm1;
                    d_c(kk)=uint8(newU_B(i,j));
                    kk=kk+1;
                end
            end
            
            for i=1:1:row/2
                for j=1:1:col/2
                    yy((i-1)*row/2+j)=YCbCr_f(i,j);
                end
            end
        end
        if(chl==3)
             
            for i=2:2:row
                for j=1:2:col-1 
                    newV(i/2,(j+1)/2)=double(img_ycbcr(i,j)); 
                end
            end
            newV_B=double(newV-128);
            newV_B = blockproc((newV_B),[8 8],dct);
            f_V=blockproc(newV_B,[8,8],@(block_struct)block_struct.data./CbCr_Table);
            f_V=fix(f_V);
            YCbCr_f(:,:)=f_V;
%             f_V=blockproc(newV_B,[8,8],@(block_struct)block_struct.data./CbCr_Table);
%             f_V=fix(f_V);
%             YCbCr_f(:,:)=f_V;
            d_c=zeros(row*col/64);
            r_c=zeros(1,row*col/64);
            kk=1;
            for i=1:8:row/2
                for j=1:8:col/2
                    numm=(newV_B(i,j));
                    numm1=0;
                    while(numm~=0)
                       numm=fix(numm/2);
                       numm1=numm1+1;
                    end
                    r_c(1,kk)=numm1;
                    d_c(kk)=uint8(newV_B(i,j));
                    kk=kk+1;
                end
            end
            
            for i=1:1:row/2
                for j=1:1:col/2
                    yy((i-1)*row/2+j)=YCbCr_f(i,j);
                end
            end
        end
    end


    
        [prob,symbols] = hist(r_c,[min(r_c):1:max(r_c)]);% compute the histogram.
        prob = prob/numel(r_c);
        %% 赫夫曼编码
        dict = huffmandict(symbols,prob); %huffman tree
        bitstream = huffmanenco(r_c,dict);
        %% 保存为码流文件（注意文件尺寸）
        size_dict = savehtree(htreefile, dict);
        size_bitstream = savestreamfile(streamfile, bitstream);
    end

        
        
        
        
%         %zigzag
%         zigzagg=@(block_struct)zigzag(block_struct.data,8,8);
%         z_y=blockproc(f_y,[8,8],zigzagg);
%         z_u=blockproc(f_U,[8,8],zigzagg);
%         z_v=blockproc(f_V,[8,8],zigzagg);
%         %获取图像的高和宽
%         [Height1,Width1] = size(z_y);
%         z_y=RLCcode(z_y,Height1*Width1);
%         [Height2,Width2] = size(z_u);
%         z_u=RLCcode(z_u,Height2*Width2);
%         [Height3,Width3] = size(z_v);
%         z_v=RLCcode(z_v,Height3*Width3);

        
        
%         [Height1,Width1] = size(f_y);
%         z_y=zigzag(f_y,Height1,Width1);
%         [Height2,Width2] = size(f_U);
%         z_u=zigzag(f_U,Height2,Width2);
%         [Height3,Width3] = size(f_V);
%         z_v=zigzag(f_V,Height3,Width3);
        
%         %对三个通道反量化
%         f_y=blockproc(f_y,[8,8],@(block_struct)block_struct.data.*Y_Table);
%         
%         f_y=fix(f_y);
%         f_U=blockproc(f_U,[8,8],@(block_struct)block_struct.data.*CbCr_Table);
%         f_U=fix(f_U);
%         f_V=blockproc(f_V,[8,8],@(block_struct)block_struct.data.*CbCr_Table);
%         f_V=fix(f_V);
%     
%         idct=@(block_struct) T'* block_struct.data*T;
%         %对三个通道反DCT变换
%         f_y=blockproc((f_y),[8 8],idct);
%         f_U=blockproc((f_U),[8 8],idct);
%         f_V=blockproc((f_V),[8 8],idct);
%         f_y=uint8(f_y+128);
%         f_U=uint8(f_U+128);
%         f_V=uint8(f_V+128);
%         f_y(f_y<0)=0;
%         f_U(f_U<0)=0;
%         f_V(f_V<0)=0;
%         f_y(f_y>255)=255;
%         f_U(f_U>255)=255;
%         f_V(f_V>255)=255;
%         
%         %恢复出YCBCR图像
%         YCbCr_f(:,:,1)=f_y;
%         for i=1:row/2
%             for j=1:col/2
%                 YCbCr_f(2*i-1,2*j-1,2)=f_U(i,j);
%                 YCbCr_f(2*i,2*j-1,2)=f_U(i,j);
%                 YCbCr_f(2*i-1,2*j,2)=f_U(i,j);
%                 YCbCr_f(2*i,2*j,2)=f_U(i,j);
%                 YCbCr_f(2*i-1,2*j-1,3)=f_V(i,j);
%                 YCbCr_f(2*i,2*j-1,3)=f_V(i,j);
%                 YCbCr_f(2*i-1,2*j,3)=f_V(i,j);
%                 YCbCr_f(2*i,2*j,3)=f_V(i,j); 
%             end
%         end
%         
%         e=img_ycbcr-double(YCbCr_f);
%         e=uint8(e);
%         
%         e=ycbcr2rgb(e);
%         YCbCr_f=ycbcr2rgb(YCbCr_f);
%         img=ycbcr2rgb(img);
%     
% %         imshow(img),title('original image');
% %         figure;
% %         imshow(YCbCr_f),title('compressed image');
% %         imwrite(YCbCr_f,'compressed_img.jpg');
% %         figure;
% %         imshow(e),title('error image');
       
%         for i=1:1:Height
%             for j=1:1:Width
%                 fprintf('cpress_f[%d][%d][1]=%d | z_y[%d][%d]=%d ! \r\n------------------------',row,col)
%             end
%         end
    
        

    


    



%     %% 信号源的统计特性分析
%     if diffmode %如果差分≠0
%         %将传进来的yuv文件转换成double类型
%         img = double(img);
%         %获取图像的高和宽
%         [Height,Width] = size(img);
%     
%         sig = img;
%         sig(:,2:Width) = img(:,2:Width)-img(:,1:Width-1);
%         sig = sig(:);
%     else
%         sig = double(img(:));
%     end
%     [prob,symbols] = hist(sig,[min(sig):1:max(sig)]);% compute the histogram.
%     prob = prob/numel(sig);
%     %% 赫夫曼编码
%     dict = huffmandict(symbols,prob); %huffman tree
%     bitstream = huffmanenco(sig,dict);
%     %% 保存为码流文件（注意文件尺寸）
%     size_dict = savehtree(htreefile, dict);
%     size_bitstream = savestreamfile(streamfile, bitstream);
% end