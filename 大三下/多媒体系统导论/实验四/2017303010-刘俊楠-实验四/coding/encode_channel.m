%%file encode_channel.m 
function [size_dict, size_bitstream,yy]=encode_channel(img, htreefile,streamfile, diffmode,chl,flag,qf)
        %�Դ�������ycbcrͼ��ת����double
        img_ycbcr = double(img);
        %����yuvͼ�������������
        [row,col,~]=size(img_ycbcr);
        Y_Table=[ 16  11  10  16  24  40  51  61 ; 
	            12  12  14  19  26  58  60  55 ; 
	            14  13  16  24  40  57  69  56 ; 
	            14  17  22  29  51  87  80  62 ; 
	            18  22  37  56  68 109 103  77 ; 
	            24  35  55  64  81 104 113  92 ; 
	            49  64  78  87 103 121 120 101 ; 
	            72  92  95  98 112 100 103  99 ];%����������
        CbCr_Table=[17  18  24  47  99  99  99  99 ; 
	            18  21  26  66  99  99  99  99 ;
	            24  26  56  99  99  99  99  99 ; 
	            47  66  99  99  99  99  99  99 ; 
	            99  99  99  99  99  99  99  99 ; 
	            99  99  99  99  99  99  99  99 ; 
	            99  99  99  99  99  99  99  99 ; 
	            99  99  99  99  99  99  99  99 ];%ɫ��������
        Q1=[1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1];%ȫ1��������
        %��ά���㹫ʽ 
        T = dctmtx(8);%������
        %@(block_struct)װ��������.@(block_struct)��������޸ĵĺ���
        % block_struct.data��ʾ���������,Ҳ����ͼƬ���߾���,
        % Ȼ�������صĲ���.���᷵��һ������
        dct = @(block_struct) T* block_struct.data*T';

        %qfΪӰ��scaling factor�������صĴ�С��ֵ
        if qf>=50
            scaling_factor= (100-qf)/50;
        else
            scaling_factor=(50/qf);
        end
        %����������ز�����0����������������򲻷�����������Ϊȫ1
        if scaling_factor ~= 0
            CbCr_Table=round(CbCr_Table*scaling_factor);
            Y_Table=round(Y_Table*scaling_factor);
        else
            CbCr_Table=Q1;
            Y_Table=Q1;
        end
        CbCr_Table=double(CbCr_Table);
        Y_Table=double(Y_Table);
    %% �ź�Դ��ͳ�����Է���
    if ~diffmode %������=0 ����ACϵ������
        %����zigzag�ֿ鷽��
        zigzagg=@(block_struct)zigzag(block_struct.data,8,8);
        if(chl==1)%������Ϊ1ʱ  Ҳ����yͨ��
            Y(:,:)=img_ycbcr(:,:);
            %�ԻҶ�ͼ�����֣���Ϊ�Ҷ�ͼ��-128��0��ֵ�����㣬����128����̫��
            if flag~=0
                Y_B=double(Y-128);
                %�ֿ�dct
                Y_B = blockproc((Y_B),[8 8],dct);
            else
                Y_B = blockproc((Y),[8 8],dct);
            end
            %����
            f_y=blockproc(Y_B,[8,8],@(block_struct)block_struct.data./Y_Table);
            %��0ȡ��
            f_y=fix(f_y);
            YCbCr_f(:,:)=f_y;
            %�ֿ�zigzag
            z_y=blockproc(f_y,[8,8],zigzagg);
            z_y=z_y';%ת�� ��Ϊreshape�����ǰ��м����
            [h1,w1]=size(z_y);
            z_y=reshape(z_y,[w1,h1]);
            z_y=z_y';%��ת����
            [Height1,~] = size(z_y);
            %����RLC����
            r_c=[];
            for i=1:8:Height1
                r_c_temp=RLCcode(z_y(i:i+7,:),8*64,chl);
                r_c=[r_c,r_c_temp];
            end
            [~,ww1]=size(r_c);
            %����sizeλ�������Ҵ洢valueֵ
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
            for i=1:2:row-1 %�ӵ�һ������и���ɨ�� ����Ϊrow-1����
                for j=1:2:col-1 %���и���ɨ��  ����Ϊcol-1����
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

    %����ûѡ���ֵ������diffmode=~0
    %����Ӧ��ѡ��DCϵ���ķ���������ѹ������
    else
        %yͨ�������
        if(chl==1)
            Y(:,:)=img_ycbcr(:,:);
            %����rgbͼ��-128��0��ֵ��������dct������gray��������dct
            if flag~=0
                Y_B=double(Y-128);
                Y_B = blockproc((Y_B),[8 8],dct);
            else
            Y_B = blockproc((Y),[8 8],dct);
            end
        
            f_y=blockproc(Y_B,[8,8],@(block_struct)block_struct.data./Y_Table);
            f_y=fix(f_y);
            YCbCr_f(:,:)=f_y;
            %��ʼ��d_c�����ڴ洢dcϵ����r_c���洢size
            d_c=zeros(row*col/64);
            r_c=zeros(1,row*col/64);
            kk=1;
            %�ֿ����dcϵ�������Լ�size����
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
            
            for i=1:2:row-1 %�ӵ�һ������и���ɨ�� ����Ϊrow-1����
                for j=1:2:col-1 %���и���ɨ��  ����Ϊcol-1����
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
        %% �շ�������
        dict = huffmandict(symbols,prob); %huffman tree
        bitstream = huffmanenco(r_c,dict);
        %% ����Ϊ�����ļ���ע���ļ��ߴ磩
        size_dict = savehtree(htreefile, dict);
        size_bitstream = savestreamfile(streamfile, bitstream);
    end

        
        
        
        
%         %zigzag
%         zigzagg=@(block_struct)zigzag(block_struct.data,8,8);
%         z_y=blockproc(f_y,[8,8],zigzagg);
%         z_u=blockproc(f_U,[8,8],zigzagg);
%         z_v=blockproc(f_V,[8,8],zigzagg);
%         %��ȡͼ��ĸߺͿ�
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
        
%         %������ͨ��������
%         f_y=blockproc(f_y,[8,8],@(block_struct)block_struct.data.*Y_Table);
%         
%         f_y=fix(f_y);
%         f_U=blockproc(f_U,[8,8],@(block_struct)block_struct.data.*CbCr_Table);
%         f_U=fix(f_U);
%         f_V=blockproc(f_V,[8,8],@(block_struct)block_struct.data.*CbCr_Table);
%         f_V=fix(f_V);
%     
%         idct=@(block_struct) T'* block_struct.data*T;
%         %������ͨ����DCT�任
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
%         %�ָ���YCBCRͼ��
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
    
        

    


    



%     %% �ź�Դ��ͳ�����Է���
%     if diffmode %�����֡�0
%         %����������yuv�ļ�ת����double����
%         img = double(img);
%         %��ȡͼ��ĸߺͿ�
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
%     %% �շ�������
%     dict = huffmandict(symbols,prob); %huffman tree
%     bitstream = huffmanenco(sig,dict);
%     %% ����Ϊ�����ļ���ע���ļ��ߴ磩
%     size_dict = savehtree(htreefile, dict);
%     size_bitstream = savestreamfile(streamfile, bitstream);
% end