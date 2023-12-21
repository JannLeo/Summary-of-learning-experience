package demo1;
import java.io.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−12-月-18-日-19:16
 * @projectName: IntelliJ IDEA-demo1
 * @classNAME: test1_2
 * @description: JannLeo
 */
//Xiangsi类计算并存储用户邻接id数组userid以及其对应的Jaccard index数组xiangsidu
class XiangSi implements Runnable{//Runnable多线程实现
    String []userid;
    double []xiangsidu;
    String userid1;//当前要比对的userid
    int locate=-1;//userid所在name数组的位置
    XiangSi(){
        //初始化
        userid=new String[10];
        xiangsidu=new double[10];
        for(int i=0;i<10;i++){
            xiangsidu[i]=-1;
        }
    }
    //设置要比对的userid与其位置
    void Setuse(String use,int l){
        userid1=use;
        locate=l;
    }
    //比较计算出来的Jaccard index与目前userid邻接数组的大小
    void Compare(double flag,int ff){
        for(int i=0;i<10;i++){
            if(flag>xiangsidu[i]){
                for(int j=9;j>i;j--){
                    userid[j]=userid[j-1];
                    xiangsidu[j]=xiangsidu[j-1];
                }
                xiangsidu[i]=flag;
                userid[i]=test1_2.name[ff];
                break;
            }
        }
    }
    //线程运行遍历并计算其Jaccard index
    public void run(){
        double flag=0;//存储Jaccard index
        for(int i=0;i<test1_2.map.size();i++) {
            if (i != locate) {
                //利用HashSet的集合运算来计算Jaccard index
                HashSet <String>a=new HashSet<>();
                HashSet <String>b=new HashSet<>();
                HashSet <String>c=new HashSet<>();
                HashSet <String>e=new HashSet<>();
                a=test1_2.map.get(userid1);//当前要比较的userid对应的商品   设置为A
                b=test1_2.map.get(test1_2.name[i]);//该循环遍历到的userid对应的商品 设置为B
                if(a.equals(b))
                    flag=1;
                else {
                    c=(HashSet<String>)a.clone();
                    e=(HashSet<String>)a.clone();
                    e.addAll(b); //e=AUB
                    c.retainAll(b);//c=A∩B
                    if(a.size()==0){
                        flag=0;
                    }
                    else
                        //flag=(AUB-A∩B)/AUB
                        flag = (double)c.size() / e.size();
                }
                //根据计算出来的Jaccard index进行比较
                Compare(flag, i);
            }
        }
    }
}
public class test1_2 {
    public static String []name;//存储遍历得到的不同的用户名
    public static String []use;//存储不重复的用户名
    public static String []xsd;//存储use数组对应的商品id
    public static LinkedHashMap<String,HashSet<String>> map=new LinkedHashMap<>();//存储不同用户名对应所拥有的商品id
    public static void main(String[] args) {
        //初始化
        xsd=new String[68356];
        use=new String[68356];
        //用于正则匹配
        Pattern p;
        Matcher m;
        //读文件，进行提取userid与productID
        try {
            FileReader fr = null;
            fr = new FileReader("D:\\作业与课件\\大三上\\java\\实验十一\\review.txt");
            BufferedReader input = new BufferedReader(fr);
            String s = null;
            int ii=0;
            while (true) {
                try {
                    if (!((s = input.readLine()) != null)) break;
                } catch (IOException e) {
                    e.printStackTrace();
                }
                p=Pattern.compile("(.*); ");
                m=p.matcher(s);
                if(m.find()){
                    int tt=m.group().indexOf(";",1);
                    xsd[ii]=m.group().substring(tt+2,m.group().length()-2);//提取得到productID
                }
                int t=s.indexOf(";",1);
                s=s.substring(1,t);//提取得到userid
                use[ii]=s;
                HashSet<String> set=new HashSet<>();//初始化一个HashSet
                if(map.get(use[ii])!=null){
                    //如果LinkedHashMap的键（userid）对应的值（userid对应的商品集合）不为空
                    // 则将其提取出来加上当前的商品id并put回去
                    set=map.get(use[ii]);
                    set.add(xsd[ii]);
                    map.put(use[ii],set);
                }
                else{
                    //如果LinkedHashMap的键对应的值为空，直接set添加当前的productID并put进去即可
                    set.add(xsd[ii]);
                    map.put(use[ii],set);
                }
                ii++;
            }
            try {
                input.close();
                fr.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        //利用迭代器为name字符串数组赋值，使其存储不重复的userid
        name=new String[map.size()];
        Iterator<Map.Entry< String, HashSet<String> >> iterator = map.entrySet().iterator();
        int ff=0;
        while (iterator.hasNext()) {
            Map.Entry< String, HashSet<String> > entry = iterator.next();
            name[ff]=entry.getKey();
            ff++;
        }
        //利用线程计算当前userid对应的userNeighborhood
        try {
            FileWriter fw = new FileWriter("D:\\作业与课件\\大三上\\java\\实验十一\\userNeighborhood.txt");
            BufferedWriter output = new BufferedWriter(fw);
            for (int j = 0; j < map.size(); j++) {
                XiangSi x=new XiangSi();
                x.Setuse(name[j],j);
                Thread a=new Thread(x);
                a.start();
                while(a.isAlive()){}//线程未结束则一直循环等待
                //存储当前userid
                String ss=name[j];
                for(int i=0;i<10;i++){
                    //连接计算得到的userNeighborhood
                    ss=ss+";"+x.userid[i];
                }
                System.out.println(j);
                System.out.println(ss);
                output.write(ss);
                output.newLine();
            }
            output.flush();
            output.close();
            fw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

