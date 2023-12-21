package demo1;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−12-月-24-日-16:14
 * @projectName: IntelliJ IDEA-demo1
 * @classNAME: test1_client2
 * @description: JannLeo
 */

//客户端2类 继承JFrame与Runnable actionlistener接口
public class test1_client2 extends JFrame implements Runnable, ActionListener
{
    //输出信息框，录入用户输出的消息
    JTextField outMessage = new JTextField(12);
    //输入信息框，显示服务端发来的消息
    JTextArea inMessage = new JTextArea(12,20);
    //发送按钮
    JButton b = new JButton("发送数据");
    //端口初始化
    int portnum=50000;
    test1_client2()
    {
        //客户端名称
        super("I AM client2");

        //对按钮添加监听
        b.addActionListener(this);

        //设置窗口大小与是否可见
        setSize(320,200); setVisible(true);

        //设置面板与相关组件排布
        JPanel p = new JPanel();
        p.add(outMessage);
        p.add(b);
        Container con = getContentPane();
        con.add(new JScrollPane(inMessage), BorderLayout.CENTER);
        con.add(p, BorderLayout.NORTH);

        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        validate();

        //创建该类新线程
        Thread thread = new Thread(this);
        thread.start(); //线程负责接收数据
    }
    public void actionPerformed(ActionEvent event)
    {
        // 单击按钮发送数据
        byte b[] = outMessage.getText().trim().getBytes();
        try
        {
            InetAddress address = InetAddress.getByName("127.0.0.1");
            //设置发送目的端口为服务端端口即5678
            DatagramPacket data = new DatagramPacket(b,b.length,address,5678);
            //利用自身设置的端口发送
            DatagramSocket mail = new DatagramSocket(portnum);

            mail.send(data);
            //端口每次变化一次
            portnum++;
        }
        catch(Exception e){}
    }
    public void run()
    {  // 接收数据
        DatagramPacket pack = null;
        DatagramSocket mail = null;
        byte b[] = new byte[8192];
        try
        {
            //接收服务端发来的4321端口的消息
            pack = new DatagramPacket(b,b.length);
            mail = new DatagramSocket(4321);
        }
        catch(Exception e){}

        //循环监听消息并打印
        while(true)
        {
            try
            {

                mail.receive(pack);
                String message = new String(pack.getData(),0,pack.getLength());
                inMessage.append("收到数据来自：" + pack.getAddress());
                inMessage.append("\n收到数据是：" + message);
                inMessage.append("\n收到端口是："+pack.getPort()+"\n");
                inMessage.setCaretPosition(inMessage.getText().length());
            }
            catch(Exception e){}
        }
    }
    public static void main(String args[])
    {
        new test1_client2();
    }
}
