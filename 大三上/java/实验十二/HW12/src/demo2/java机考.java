package demo2;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−12-月-24-日-17:14
 * @projectName: IntelliJ IDEA-demo2
 * @classNAME: java机考
 * @description: JannLeo
 */
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.net.*;
import java.util.Date;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


//Question类继承Runnable接口 用于另一个线程计算时间
class Question implements Runnable {
    public boolean []flag;//flag标记题目使用情况
    public int num;//题目选择的序号
    public Test test;//提取txt文件中的题目类
    public long time;//计算得的总计时间
    public static long startTime;//程序开始时间
    public long startQuestionTime;//正在做的题目开始时间
    public long endTime;//运行时的时间
    public int danxuan=0,duoxuan=0,panduan=0;//已经出的三类题目的数量
    Question(){
        //初始化
        flag=new boolean[30];
        for(int i=0;i<20;i++){
            flag[i]=false;
        }
    }

    //获取当前总计时间
    long gettime(){
        endTime= new Date().getTime();
        time=(endTime-startTime)/1000;
        return time;
    }
    //按秒更新时间,并且提取文件中内容,更新题目信息
    public void run(){
        test=new Test();
        while(true) {

            gettime();

            if(WindowLayered.flagg)
                update();
            if(danxuan==5&&duoxuan==5&&panduan==5)
                break;
        }
    }
    //返回所选题目序号
    String gettimu(int num){
        this.num=num;
        flag[num]=true;
        return test.text[num];
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
    //返回test里面截取到的答案
    String getanswer(){ return test.answer[num];}
    //返回当前题目所用时间
    long getQuestionTime(){
        return (endTime-startQuestionTime)/1000;
    }
    //初始化当前题目开始时间
    void recordstarttime(){ startQuestionTime= new Date().getTime();}
    //返回题目序号
    int getNum(){
        return num;
    }
    //返回题目类型
    int getkind(){
        return test.kind[num];
    }
    void update(){
        //更新题目信息
        WindowLayered.jradio1.setText(WindowLayered.question.getA());
        WindowLayered.jradio2.setText(WindowLayered.question.getB());
        if(WindowLayered.question.getNum()<20){
            WindowLayered.jradio3.setText(WindowLayered.question.getC());
            WindowLayered.jradio4.setText(WindowLayered.question.getD());
            WindowLayered.jcb3.setText(WindowLayered.question.getC());
            WindowLayered.jcb4.setText(WindowLayered.question.getD());
        }
        WindowLayered.jcb1.setText(WindowLayered.question.getA());
        WindowLayered.jcb2.setText(WindowLayered.question.getB());
        WindowLayered.J1.setText("总共用时："+WindowLayered.question.time);
        WindowLayered.J2.setText("该题剩余时间："+(20-(WindowLayered.question.getQuestionTime())));
        WindowLayered.J3.setText("正确答案："+WindowLayered.question.test.answer[WindowLayered.question.getNum()]);
        WindowLayered.J4.setText("已做单选题数："+WindowLayered.question.danxuan);
        WindowLayered.J5.setText("已做多选题数："+WindowLayered.question.duoxuan);
        WindowLayered.J6.setText("已做判断题数："+WindowLayered.question.panduan);
        WindowLayered.J7.setText("单选题正确数："+WindowLayered.dui_danxuan);
        WindowLayered.J8.setText("多选题正确数："+WindowLayered.dui_duoxuan);
        WindowLayered.J9.setText("判断题正确数："+WindowLayered.dui_panduan);
        WindowLayered.J10.setText("总分数："+20);
        WindowLayered.J11.setText("当前分数数："+(WindowLayered.dui_duoxuan*2+WindowLayered.dui_danxuan+WindowLayered.dui_panduan));
        WindowLayered.J12.setText("上一题对错："+WindowLayered.flag);
    }
}
//Test类用于提取文件内容
class Test{
    //题目题干
    String []text;
    //题目选项
    String [][]option;
    //题目类型
    public int []kind;
    //题目答案
    String []answer;
    Test(){
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
//WindowLayered为设置窗口格式等，继承了JFrame并且使用鼠标事件监听按钮点击
class WindowLayered extends JFrame implements ActionListener
{
    //四个box装载做题信息，主要是所用时间、当前使用时间、答案、上一题是否正确、等等信息
    public static Box baseBox, boxV1, boxV2,boxV3,boxV4;
    //主要用于创建线程使用的类
    public static Question question=new Question();
    //设置单选按钮
    public static JFrame frame = new JFrame("联机版Java简易机考程序");
    //设置面板
    public static Container cont = frame.getContentPane();
    //设置单选按键组
    public static ButtonGroup group=new ButtonGroup();
    //设置JPanel
    public static JPanel pan = new JPanel();
    //设置线程，用于更新时间，获取题目
    public static Thread a1=new Thread(question);
    //判断上一题是否正确
    public static boolean flag=false;
    //记录三类题目正确数量
    public static int dui_danxuan=0,dui_duoxuan=0,dui_panduan=0;
    //记录当前是第几题
    public static int times=1;
    //设置多个JLabel、用于装载进入JPanel中，记录题目信息
    public static JLabel J1,J2,J3,J4,J5,J6,J7,J8,J9,J10,J11,J12;
    //设置单选按钮
    public static JRadioButton jradio1,jradio2,jradio3,jradio4;
    //设置多选按钮组
    public static JCheckBox jcb1,jcb2,jcb3,jcb4;
    //设置提交按钮
    public static JButton button = new JButton("提交");
    //设置字体
    public static Font font=new Font(Font.DIALOG,Font.PLAIN,18);
    //设置服务端返回的文字显示的文本框
    public static JTextArea inMessage = new JTextArea(12,20);
    //建立socket字
    public static Socket socket = null;
    //服务端输入
    public static DataInputStream in = null;
    //本端（客户端）输出
    public static DataOutputStream out = null;
    //与服务端连接按钮
    public static JButton connection=new JButton("连接");
    //建立线程池
    public static ExecutorService fixedThreadPool = Executors.newFixedThreadPool(3);
    //本题答案
    public static String answer="";
    //本题序号
    public static int num;
    public static boolean flagg=false;
    public static boolean actionPerformed_flag=false;
    WindowLayered(){
        super("I AM client1");
        socket = new Socket();

        //开始线程
        fixedThreadPool.execute(a1);

        // 当前线程睡眠0.1s等待读取文件
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        //初始化题目信息
        connection.addActionListener(this);
        button.addActionListener(this);
        button.setEnabled(false);
        J1=new JLabel("总共用时："+question.time);
        J2=new JLabel("该题剩余时间："+(20-question.gettime()%(times*20)));
        J3=new JLabel("正确答案："+question.test.answer[question.getNum()]);
        J4=new JLabel("已做单选题数："+question.danxuan);
        J5=new JLabel("已做多选题数："+question.duoxuan);
        J6=new JLabel("已做判断题数："+question.panduan);
        J7=new JLabel("单选题正确数："+dui_danxuan);
        J8=new JLabel("多选题正确数："+dui_duoxuan);
        J9=new JLabel("判断题正确数："+dui_panduan);
        J10=new JLabel("总分数："+20);
        J11=new JLabel("当前分数数："+(dui_duoxuan*2+dui_danxuan+dui_panduan));
        J12=new JLabel("上一题对错："+flag);
        //初始化按钮，并获取选项
        jradio1 = new JRadioButton(question.getA());
        jradio2 = new JRadioButton(question.getB());
        jradio3 = new JRadioButton(question.getC());
        jradio4 = new JRadioButton(question.getD());
        jcb1 = new JCheckBox(question.getA()); // 定义一个复选框
        jcb2 = new JCheckBox(question.getB()); // 定义一个复选框
        jcb3 = new JCheckBox(question.getC()); // 定义一个复选框
        jcb4 = new JCheckBox(question.getD()); // 定义一个复选框

        //设置字体
        jradio4.setFont(font);
        jradio3.setFont(font);
        jradio2.setFont(font);
        jradio1.setFont(font);
        button.setFont(font);
        jcb1.setFont(font);
        jcb2.setFont(font);
        jcb3.setFont(font);
        jcb4.setFont(font);
        J1.setFont(font);
        J2.setFont(font);
        J3.setFont(font);
        J4.setFont(font);
        J5.setFont(font);
        J6.setFont(font);
        J7.setFont(font);
        J8.setFont(font);
        J9.setFont(font);
        J10.setFont(font);
        J11.setFont(font);
        J12.setFont(font);

        //设置box
        baseBox = Box.createHorizontalBox();
        baseBox.add(J1);
        baseBox.add(Box.createHorizontalStrut(10));
        baseBox.add(J2);
        baseBox.add(Box.createHorizontalStrut(10));
        baseBox.add(J3);
        boxV2 = Box.createHorizontalBox();
        boxV2.add(J4);
        boxV2.add(Box.createHorizontalStrut(10));
        boxV2.add(J5);
        boxV2.add(Box.createHorizontalStrut(10));
        boxV2.add(J6);

        boxV1 = Box.createHorizontalBox();
        boxV1.add(J7);
        boxV1.add(Box.createHorizontalStrut(10));
        boxV1.add(J8);
        boxV1.add(Box.createHorizontalStrut(10));
        boxV1.add(J9);

        boxV3 = Box.createHorizontalBox();
        boxV3.add(J10);
        boxV3.add(Box.createHorizontalStrut(10));
        boxV3.add(J11);
        boxV3.add(Box.createHorizontalStrut(10));
        boxV3.add(J12);

        boxV4 = Box.createVerticalBox();
        boxV4.add(baseBox);
        boxV4.add(Box.createVerticalStrut(8));
        boxV4.add(boxV2);
        boxV4.add(Box.createVerticalStrut(8));
        boxV4.add(boxV1);
        boxV4.add(Box.createVerticalStrut(8));
        boxV4.add(boxV3);

        //设置单选按钮组
        group.add(jradio1);
        group.add(jradio2);
        group.add(jradio3);
        group.add(jradio4);

        //设置border存储题目提干
        pan.repaint();

        //按照类型设置排版样式
        JPanel p = new JPanel();
        cont.add(connection,BorderLayout.EAST);
        cont.add(inMessage, BorderLayout.SOUTH);
        inMessage.setPreferredSize(new Dimension(0, 200));
        cont.add(p, BorderLayout.NORTH);





        //设置窗口大小
        frame.setSize(1200, 1000);
        frame.setVisible(true);

        // ---
        validate();

        // ---
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        while(true) {
            System.out.println("循环");
            if (question.panduan == 5 && question.duoxuan == 5 && question.danxuan == 5) {
                //题目数达到15后更改截止画面
                end();
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                break;
            }
            if (flagg) {
                while (times <= 15) {
                    if (((question.getQuestionTime())) >= 20) {
                        System.out.println("Times Up!");
                        actionPerformed_flag = true;
                        //发送题目信息并更新
                        send();
//                    update();
                        actionPerformed_flag = false;
                    } else
                        //当没到达一直更新
                        while ((question.getQuestionTime()) <= 19) {
                            if (question.panduan == 5 && question.duoxuan == 5 && question.danxuan == 5) {
                                break;
                            }
                            update();
                            //若到达15题则中断

                        }
                }
            }

        }



    }
    public void actionPerformed(ActionEvent event) {
        if (event.getSource() == connection) {
            try {
                if (socket.isConnected()) {
                } else {
                    //设置开始时间
                    Question.startTime = new Date().getTime();
                    //初始化题目开始时间
                    question.recordstarttime();

                    //设置socket连接端口为5678
                    InetAddress address = InetAddress.getByName("127.0.0.1");
                    InetSocketAddress socketAddress = new InetSocketAddress(address, 5678);
                    socket.connect(socketAddress);

                    in = new DataInputStream(socket.getInputStream());
                    out = new DataOutputStream(socket.getOutputStream());
                    //发送start示意服务端发送题目
                    out.writeUTF("START!");
                    //设置提交按钮为可选
                    button.setEnabled(true);
                    try {
                        //读取题目编号
                        num=in.readInt();
                        System.out.println("num="+num);
                        String message;
                        //读取题目信息
                        message=in.readUTF();
                        inMessage.append(message);
                        inMessage.setCaretPosition((inMessage.getText()).length());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    //获取题目
                    pan.setBorder(BorderFactory.createTitledBorder(question.gettimu(num)));
                    //设置JPanel字体
                    ((javax.swing.border.TitledBorder) pan.getBorder()).setTitleFont(font);
                    //选择题
                    if (question.getkind() == 0) {
                        //定义排版样式
                        pan.setLayout(new GridLayout(6, 0));
                        //单选按钮
                        pan.add(jradio1);
                        pan.add(jradio2);
                        pan.add(jradio3);
                        pan.add(jradio4);
                        pan.add(boxV4);
                        pan.add(button);

                        cont.add(pan);
                        //多选题
                    } else if (question.getkind() == 1) {
                        //定义排版样式
                        pan.setLayout(new GridLayout(6, 0));
                        //多选按钮
                        pan.add(jcb1);
                        pan.add(jcb2);
                        pan.add(jcb3);
                        pan.add(jcb4);
                        pan.add(boxV4);
                        pan.add(button);
                        cont.add(pan);
                        //判断题
                    } else if (question.getkind() == 2) {
                        //定义排版样式
                        pan.setLayout(new GridLayout(6, 0));
                        pan.add(jradio1);
                        pan.add(jradio2);
                        pan.add(boxV4);
                        pan.add(button);
                        cont.add(pan);
                    }
                    flagg=true;

                }
            } catch (IOException ee) {
                System.out.println(ee);
                socket = new Socket();
            }
        }
        if (event.getSource() == button) {
            //若按下提交按钮则发送消息给服务端
                send();
        }
    }



    void update(){
        //更新题目信息
        jradio1.setText(question.getA());
        jradio2.setText(question.getB());
        if(question.getNum()<20){
            jradio3.setText(question.getC());
            jradio4.setText(question.getD());
            jcb3.setText(question.getC());
            jcb4.setText(question.getD());
        }
        jcb1.setText(question.getA());
        jcb2.setText(question.getB());
        J1.setText("总共用时："+question.time);
        J2.setText("该题剩余时间："+(20-(question.getQuestionTime())));
        J3.setText("正确答案："+question.test.answer[question.getNum()]);
        J4.setText("已做单选题数："+question.danxuan);
        J5.setText("已做多选题数："+question.duoxuan);
        J6.setText("已做判断题数："+question.panduan);
        J7.setText("单选题正确数："+dui_danxuan);
        J8.setText("多选题正确数："+dui_duoxuan);
        J9.setText("判断题正确数："+dui_panduan);
        J10.setText("总分数："+20);
        J11.setText("当前分数数："+(dui_duoxuan*2+dui_danxuan+dui_panduan));
        J12.setText("上一题对错："+flag);
    }
    boolean correct(){
        //判断当前选项是否正确
        answer="";
        if(jradio1.isSelected()||jcb1.isSelected()){
            answer+="A";
        }
        if(jradio2.isSelected()||jcb2.isSelected()){
            answer+="B";
        }
        if(jradio3.isSelected()||jcb3.isSelected()){
            answer+="C";
        }
        if(jradio4.isSelected()||jcb4.isSelected()){
            answer+="D";
        }
        System.out.println(answer);
        if(answer.equals(question.getanswer())){
            return true;
        }
        return false;
    }
    void reset(){

        //重设排版，并重新获取信息
        question.recordstarttime();
        if (question.getkind() == 0) {
            //定义排版样式
            pan.removeAll();

            jcb1.setSelected(false);
            jcb2.setSelected(false);
            jcb3.setSelected(false);
            jcb4.setSelected(false);

            group.clearSelection();

            pan.add(jradio1);
            pan.add(jradio2);
            pan.add(jradio3);
            pan.add(jradio4);
            pan.add(boxV4);
            pan.add(button);

            cont.add(pan);

        } else if (question.getkind() == 1) {
            pan.removeAll();

            group.clearSelection();

            jcb1.setSelected(false);
            jcb2.setSelected(false);
            jcb3.setSelected(false);
            jcb4.setSelected(false);
            //定义排版样式

            pan.add(jcb1);
            pan.add(jcb2);
            pan.add(jcb3);
            pan.add(jcb4);
            pan.add(boxV4);
            pan.add(button);

            cont.add(pan);
        } else if (question.getkind() == 2) {
            //定义排版样式
            pan.removeAll();

            jcb1.setSelected(false);
            jcb2.setSelected(false);
            jcb3.setSelected(false);
            jcb4.setSelected(false);

            group.clearSelection();

            pan.add(jradio1);
            pan.add(jradio2);
            pan.add(boxV4);
            pan.add(button);

            cont.add(pan);
        }
    }
    void end(){
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        //答题结束输出结果
        getContentPane().removeAll();
        inMessage.setText(null);
        inMessage.append("答题结束，您的总分为："
                +(dui_duoxuan*2+dui_danxuan+dui_panduan));
        inMessage.setCaretPosition((inMessage.getText()).length());
        System.out.println("答题结束，您的总分为："
                +(dui_duoxuan*2+dui_danxuan+dui_panduan));
        JLabel j1=new JLabel("答题结束，谢谢！您的总分为: "
                +(dui_duoxuan*2+dui_danxuan+dui_panduan));
        pan.setBorder(BorderFactory.createTitledBorder(""));
        pan.setLayout(new GridLayout(1, 0));
        j1.setFont(font);
        cont.setLayout(null);
        pan.removeAll();
        pan.add(j1);
        cont.add(pan);

    }
    void send(){
        //判断是否结束
        if(question.duoxuan==5&&question.danxuan==5&&question.panduan==5){
            end();
            return;
        }
        //清空消息栏
        inMessage.setText(null);
        //发送题目信息并处理
        times++;
        correct();
        try {
            System.out.println("写回答案");
            //发送客户所选答案给服务端
            out.writeUTF(answer);
                String message;
                //读取服务端返回的答案解析，并将其显示在输入文本框
                message = in.readUTF();
                System.out.println("读判断正错");
                inMessage.append(message);
                inMessage.setCaretPosition((inMessage.getText()).length());
                //读取下一道题目的编号
                num = in.readInt();
                System.out.println("读数字");
                System.out.println("num=" + num);

                //读取题目并将其显示在输入文本框
                message = in.readUTF();
                System.out.println("读题目");
                inMessage.append(message);
                inMessage.setCaretPosition((inMessage.getText()).length());

        } catch (IOException e) {
            e.printStackTrace();
        }
        if(question.getkind()==0){
            question.danxuan++;
            if(correct()){
                //题目正确则添加正确次数，flag为true表示该题正确
                dui_danxuan++;
                flag=true;
            }
            else
                flag=false;
        }
        else if(question.getkind()==1){
            question.duoxuan++;
            if(correct()) {
                dui_duoxuan++;
                flag=true;
            }
            else
                flag=false;
        }
        else if(question.getkind()==2){
            question.panduan++;
            if(correct()) {
                dui_panduan++;
                flag=true;
            }
            else
                flag=false;
        }
        //设置border更新题干
        pan.setBorder(BorderFactory.createTitledBorder(question.gettimu(num)));
        //设置border字体
        ((javax.swing.border.TitledBorder) pan.getBorder()).setTitleFont(font);
        pan.repaint();
        //重设排版
        reset();
    }

}

public class java机考 {
    //main函数里创建匿名类WindowLayered
    public static void main(String[] args) {
        WindowLayered a=new WindowLayered();

    }
}

