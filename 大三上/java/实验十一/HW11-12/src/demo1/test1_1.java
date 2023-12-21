package demo1;
import java.io.*;
/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−12-月-18-日-15:51
 * @projectName: IntelliJ IDEA-demo1
 * @classNAME: test1_1
 * @description: JannLeo
 */
//建立Watches类，用来提取文中的userid与productid与summary
class Watches{
    public static final int MAX=100000;//假设商品信息有10万个
    String []userid;//userid数组
    String []product;//productid数组
    String []summary;//summary数组
    int num=0;//读取到的商品数量
    Watches(){
        //初始化
        userid=new String[MAX];
        product=new String[MAX];
        summary=new String[MAX];
    }
    void sort(int num){
        this.num=num;//读取到的商品数量
        //对userid进行选择排序
        for(int i=0;i<num;i++){
            for(int j=i+1;j<num;j++){
                if(userid[i].compareTo(userid[j])>0){
                    String a,b,c;
                    a=userid[i];
                    b=product[i];
                    c=summary[i];
                    userid[i]=userid[j];
                    product[i]=product[j];
                    summary[i]=summary[j];
                    userid[j]=a;
                    product[j]=b;
                    summary[j]=c;
                }
            }
        }
        //对userid相同的不同productid进行冒泡排序
        for(int i=0;i<num;i++){
            System.out.println(i);
            for(int j=0;j<num-1;j++){
                if(userid[j].equals(userid[j+1])){
                    if(product[j].compareTo(product[j+1])>0){
                        String a,b,c;
                        a=userid[j];
                        b=product[j];
                        c=summary[j];
                        userid[j]=userid[j+1];
                        product[j]=product[j+1];
                        summary[j]=summary[j+1];
                        userid[j+1]=a;
                        product[j+1]=b;
                        summary[j+1]=c;
                    }
                }
            }
        }
    }
}

public class test1_1 {
    static int i=0;//读取到商品的序号
    public static void main(String[] args) {
        //初始化类
        Watches watches=new Watches();
        //读文件
        try {
            FileReader fr=new FileReader("D:\\作业与课件\\大三上\\java\\实验十一\\Watches.txt");
            BufferedReader input=new BufferedReader(fr);
            String s=null;//记载读取到的string
            //未结尾时一直循环读取
            while(true){
                try {
                    if (!((s=input.readLine())!=null)) break;//按行读取
                } catch (IOException e) {
                    e.printStackTrace();
                }
                //读取userid
                if(s.contains("review/userId:")){
                    String a=s.substring(14);
                    watches.userid[i]=a;
                }
                //读取productid
                else if(s.contains("product/productId:")){
                    String a=s.substring(18);
                    watches.product[i]=a;
                }
                //读取summary
                else if(s.contains("review/summary:")){
                    String a=s.substring(15);
                    watches.summary[i]=a;
                    i++;
                }

            }
            //关闭文件流，否则读取不完全
            try {
                input.close();
                fr.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        //对读取到的string进行排序
        watches.sort(i);
        //将watches类的三个变量整合为一个str数组
        String []str=new String[i];
        for(int j=0;j<i;j++){
            str[j]=watches.userid[j]+";"+watches.product[j]+";"+watches.summary[j];
        }
        //将str写入review文件
        try {
            FileWriter fw=new FileWriter("D:\\作业与课件\\大三上\\java\\实验十一\\review.txt");
            BufferedWriter output=new BufferedWriter(fw);
            for(int j=0;j<i;j++){
                output.write(str[j]);
                output.newLine();
            }
            output.flush(); output.close();
            fw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
