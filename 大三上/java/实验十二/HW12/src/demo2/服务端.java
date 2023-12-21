package demo2;

import java.io.*;
import java.net.*;
import java.util.Random;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−12-月-26-日-10:38
 * @projectName: IntelliJ IDEA-demo2
 * @classNAME: 服务端
 * @description: JannLeo
 */
//Question类继承Runnable接口 用于另一个线程计算时间
class Question1  {
    public boolean []flag;//flag标记题目使用情况
    public int num;//题目选择的序号
    public Test1 test=new Test1();//提取txt文件中的题目类
    public int danxuan=0,duoxuan=0,panduan=0;//已经出的三类题目的数量
    Question1(){
        //初始化
        flag=new boolean[30];
        for(int i=0;i<20;i++){
            flag[i]=false;
        }
    }

    //返回所选题目序号
    void getThreadinfo(){
        //随机数类
        Random random = new Random();
        //num取0-29的随机数
        num = random.nextInt(30);
        //判断题目是否被使用或者某类题数量是否到达五
        while (flag[num]||(num<10&&danxuan>=5)||
                (num<20&&num>9&&duoxuan>=5)||
                (num>19&&panduan>=5)) {
            num = random.nextInt(30);
            if(danxuan==5&&duoxuan==5&&panduan==5){
                System.out.println("结束");
                break;
            }
        }
        //标记题目被使用
        flag[num] = true;
        return ;
    }
    //返回test类里面返回的选项
    String getA(){
        return test.option[num][0];
    }
    String getB(){
        return test.option[num][1];
    }
    String getC(){
        return test.option[num][2];
    }
    String getD(){
        return test.option[num][3];
    }

    //返回题目序号
    int getNum(){
        if(num<10){
            danxuan++;
        }
        else if(num<20){
            duoxuan++;
        }
        else if(num>19){
            panduan++;
        }
        flag[num]=true;
        return num;
    }
    //返回题目序号
    int getnumm(){
        return num;
    }
}
//Test类用于提取文件内容
class Test1{
    //题目题干
    String []text;
    //题目选项
    String [][]option;
    //题目类型
    public int []kind;
    //题目答案
    String []answer;
    Test1(){
        //初始化并且获取文件内容
        text=new String[30];
        option=new String[30][];
        kind=new int[30];
        answer=new String[30];
        int tk=0,ok=0;//tk为当前题目序号，ok为当前选项序号
        File file = new File("D:/作业与课件/大三上/java/实验十/Question.txt");
        //尝试扫描文件内容
        try (FileInputStream stream = new FileInputStream(file);
             InputStreamReader streamReader = new InputStreamReader(stream);
             BufferedReader reader = new BufferedReader(streamReader) ) {
            //初始化line  用于得到扫描内容
            String line = "";
            //设置line按行扫描
            while((line = reader.readLine()) != null) {
                //题目中单选题字样为单选题
                if (line.contains("单选题")) {
                    option[tk]=new String[4];
                    //设置类型为0，说明为单选题
                    kind[tk]=0;
                    text[tk]=line;
                    System.out.println(line);
                } else if (line.contains("A.")
                        ||line.contains("B.")
                        ||line.contains("C.")
                        ||line.contains("D.")) {
                    //存储选项
                    option[tk][ok]=line;
                    ok++;
                    System.out.println(line);

                } else if (line.contains("答案")) {
                    // 去掉答案：设置剩下的为答案并存储
                    line=line.replaceFirst("答案：","");
                    answer[tk]=line;
                    tk++;
                    ok=0;
                    System.out.println(line);
                    //题目中带有多选题字样为多选题
                }else if(line.contains("多选题")){
                    option[tk]=new String[4];
                    kind[tk]=1;
                    text[tk]=line;
                    System.out.println(line);
                    //题目中带有判断题字样为判断题
                }else if(line.contains("判断题")){
                    option[tk]=new String[2];
                    kind[tk]=2;
                    text[tk]=line;
                    System.out.println(line);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
public class 服务端 extends Thread  {
    Question1 a=new Question1();
    Socket socket;
    DataOutputStream out = null;
    DataInputStream in = null;
    服务端(Socket t)
    {
        //初始化socket字
        socket = t;
        try
        {
            in = new DataInputStream(socket.getInputStream());
            out = new DataOutputStream(socket.getOutputStream());
        }
        catch (IOException e){}
    }


    public void run() {

        // 接收数据
        while(true)
        {
            String aa;
            try
            {
                aa = in.readUTF(); //堵塞状态，除非读取到信息
                int num=a.getnumm();
                if(!aa.equals("START!")){

                    a.getNum();
                    //判断正误
                    if(aa.equals(a.test.answer[num])){
                        out.writeUTF("回答正确！答案为："+a.test.answer[num]+"\n");
                    }
                    else{

                        out.writeUTF("回答错误！答案为："+a.test.answer[num]+"\n");
                    }
                }
                System.out.println(aa);
                a.getThreadinfo();
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                //获取题目编号，并发送编号给客户端
                num=a.getnumm();
                out.writeInt(num);
                int kindd=a.test.kind[num];

                //发送题目给客户端
                String str;
                if(kindd==1||kindd==0) {
                    str = a.test.text[num] + "\n" + a.test.option[num][0]+"\n"+
                            a.test.option[num][1]+"\n"+ a.test.option[num][2]+"\n"+ a.test.option[num][3]+ "\n";
                }
                else{
                    str = a.test.text[num] + "\n" + a.test.option[num][0]+"\n"+
                            a.test.option[num][1]+ "\n";
                }
                System.out.println("str="+str);
                out.writeUTF(str);

                System.out.println("单选多选判断数量"+ a.danxuan+" "+a.duoxuan+" "+ a.panduan);

            }
            catch (IOException e)
            {
                System.out.println("客户离开");
                break;
            }
        }

    }

    public static void main(String[] args) {
        ServerSocket server = null;
        Socket socketAtServer = null;
        while(true) // 不断轮询监听客户端发来的消息
        {
            try
            {
                server = new ServerSocket(5678);
            }
            catch(IOException e1)
            {
                System.out.println("正在监听");   //ServerSocket对象不能重复创建
            }
            try
            {
                socketAtServer = server.accept();
                System.out.println("客户的地址:" + socketAtServer.getInetAddress());
            }
            catch (IOException e)
            {
                System.out.println("正在等待客户");
            }
            if(socketAtServer!=null)
            {
                new 服务端(socketAtServer).start(); //为每个客户启动一个专门的线程
            }
            else
            {
                continue;
            }
        }
    }
}



