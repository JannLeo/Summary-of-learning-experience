function [output] = RLCcode(arr,length,chl)
    %DLCCODE 此处显示有关此函数的摘要
    %   行
    l=1;
    if(chl==1)
        ss=64;
    else
        ss=32;
    end
    for k=1:1:length/ss
        %列
        %每组zigzag
        num=0;
        for i=2:1:ss
            if(i==ss&&arr(k,i)==0)
                output(l)=0;
                l=l+1;
                output(l)=0;
                l=l+1;
                break;
            end
            if(i==2&&arr(k,1)==0)
                if(arr(k,i)==0)
                    num=num+1;
                else
                    output(l)=num;
                    l=l+1;
                    output(l)=arr(k,i);
                    l=l+1;
                    num=0;
                end
                continue;
            end
            if(arr(k,i)==0)
                num=num+1;
            elseif(arr(k,i)~=0)
                output(l)=num;
                l=l+1;
                output(l)=arr(k,i);
                l=l+1;
                num=0;
            end
        end
    end
    
end

