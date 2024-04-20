function [output] = zigzag(img,row,col)
    %zigzag
    i=1;
    j=1;
    lasti=1;
    lastj=1;
    k=1;
    flag=0;
    while(k<=row*col)
        if(k==row*col)
            output(k)=img(row,col);
            break;
        end
        %左下到右上 右移一格
        if((i==1&&j==1)||(lasti-1==i&&lastj+1==j&&i==1&&j~=col))
            output(k)=img(i,j);
            lastj=j;
            lasti=i;
            j=j+1;
            k=k+1;
            flag=0;
        elseif (i-1==lasti&&j+1==lastj&&j==1&&i~=row)
            output(k)=img(i,j);
            lasti=i;
            lastj=j;
            i=i+1;
            k=k+1;
            flag=1;
        elseif (i-1==lasti&&j+1==lastj&&i==row)
            output(k)=img(i,j);
            lasti=i;
            lastj=j;
            j=j+1;
            k=k+1;
            flag=1;
        elseif(j-1==lastj&&i+1==lasti&&j==col)
            output(k)=img(i,j);
            lasti=i;
            lastj=j;
            i=i+1;
            k=k+1;
            flag=0;
        elseif(flag==0)
            output(k)=img(i,j);
            lasti=i;
            lastj=j;
            i=i+1;
            j=j-1;
            k=k+1;
        elseif (flag==1)
            output(k)=img(i,j);
            lasti=i;
            lastj=j;
            i=i-1;
            j=j+1;
            k=k+1;
        end
    end
end

