import com.baidu.translate.demo.TransApi;
import com.iflytek.voicecloud.webapi.demo.WebITS;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
class PatternWindow extends JFrame implements
         ActionListener, KeyListener
{
    //文本框类，分别为输入文本框、百度翻译文本框、讯飞翻译文本框、两者翻译相同的单词文本框
    JTextArea inputText,showText,showtextydy,same_s;
    //用于正则筛选api返回结果的两个变量
    JTextField patternText,patternText2;
    Pattern p,p1; //模式对象
    Matcher m,m1; //匹配对象
    String a;//用于保存需要翻译的字符串
    public static final String APP_ID = "20211203001017984";//百度翻译的appid
    public static final String SECURITY_KEY = "_u8OZfa0GJLhy1kopzMt";//百度翻译的key
    PatternWindow()
    {
        //创建输入文本框并监听按键
        inputText = new JTextArea();
        inputText.addKeyListener(this);
        //创建百度翻译文本框
        showText = new JTextArea();
        //创建讯飞翻译文本框
        showtextydy=new JTextArea();
        //创建两翻译比对的文本框
        same_s=new JTextArea();

        JLabel inputlaber=new JLabel("请输入待翻译中文：");
        JLabel outputlaberb=new JLabel("百度翻译结果：");
        JLabel outputlabery=new JLabel("讯飞翻译结果：");
        JLabel same=new JLabel("两者相同点：");

        //创建两者api的正则筛选
        patternText = new JTextField("\"dst\":\"(.+)\"");
        patternText.addActionListener(this);
        patternText2 = new JTextField("\"dst\":\"(.+)\",\"src");
        patternText2.addActionListener(this);

        //设置换行
        inputText.setLineWrap(true);
        showText.setLineWrap(true);
        showtextydy.setLineWrap(true);
        same_s.setLineWrap(true);

        //设置布局类型为GridLayout 并且设置成4行2列
        JPanel panel = new JPanel();
        panel.setLayout(new GridLayout(4, 2));
        panel.add(new JScrollPane(inputlaber));
        panel.add(new JScrollPane(inputText));
        panel.add(new JScrollPane(outputlaberb));
        panel.add(new JScrollPane(showText));
        panel.add(new JScrollPane(outputlabery));
        panel.add(new JScrollPane(showtextydy));
        panel.add(new JScrollPane(same));
        panel.add(new JScrollPane(same_s));
        add(panel, BorderLayout.CENTER);

        validate();

        //设置窗口大小、位置
        setBounds(120, 120, 600, 600);
        //设置可见
        setVisible(true);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    }
    public void keyTyped(KeyEvent e){

    }
    public void keyPressed(KeyEvent e){
        //如果按下回车键，就清空后三个文本框，然后执行连接api翻译的函数hangdleText
        if(e.getKeyCode()==KeyEvent.VK_ENTER){
            showText.setText("");
            showtextydy.setText("");
            same_s.setText("");
            hangdleText();
        }
    }
    public void keyReleased(KeyEvent e){

    }
    public void hangdleText()
    {
        TransApi api = new TransApi(APP_ID, SECURITY_KEY);//创建百度翻译api的对象
        WebITS ss = new WebITS();//创建讯飞翻译api对象

        //初始化文本框
        showText.setText(null);
        showtextydy.setText(null);

        //获取输入框字符串
        String s = inputText.getText();
        this.a=s;

        //api.getTransResult 自动检测需要翻译的文字所用的语言，翻译成英文
        String aa=api.getTransResult(s,"auto","en");
        p = Pattern.compile(patternText.getText()); //初始化模式对象
        m = p.matcher(aa);

        //设置两个返回的翻译字符串
        String a2="",a1;

        //执行讯飞翻译的相关方法，获得翻译结果
        try {
            a2=ss.main(a);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("error!"+a2);
        }

        //当百度翻译api有结果时
        while(m.find())
        {
            //对百度翻译api进行提取、分割，得到已翻译完成的字符串，并且显示到文本框中
            a1=m.group();
            a1=a1.substring(7,a1.length()-1);
            showText.append(a1+"\n");

            //对讯飞翻译api进行提取、分割，得到已翻译完成的字符串，并且显示到文本框中
            p1=Pattern.compile(patternText2.getText()); //初始化模式对象
            m1 = p1.matcher(a2);
            while(m1.find()){
                a2=m1.group();
                a2=a2.substring(7,a2.length()-7);
                showtextydy.append(a2+"\n");

                //对两个翻译得到的字符串进行分割、比较，并显示相同的单词到文本框中
                String[] sstr=a1.split(" ");
                String[] sstr1=a2.split(" ");
                for(int i=0;i<sstr.length;i++){
                    for(int j=0;j<sstr1.length;j++){
                        if(sstr[i].equals(sstr1[j])){
                            same_s.append(sstr[i]+" ");
                        }
                    }
                }

            }
        }
    }
    public void actionPerformed(ActionEvent e)
    {
        hangdleText();
    }
}

public class Main {
    // 在平台申请的APP_ID 详见 http://api.fanyi.baidu.com/api/trans/product/desktop?req=developer
    public static void main(String[] args) {
        new PatternWindow();

    }
}
