package demo1;

import javax.swing.*;
import java.awt.*;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−12-月-24-日-16:15
 * @projectName: IntelliJ IDEA-demo1
 * @classNAME: test1_server1
 * @description: JannLeo
 */

import java.awt.event.*;
//服务端1类 继承JFrame与Runnable接口
public class test1_server1 extends JFrame implements Runnable
{
    //输出信息框，录入用户输出的消息
    JTextField outMessage = new JTextField(12);
    //输入信息框，显示服务端发来的消息
    JTextArea inMessage = new JTextArea(12,20);

    test1_server1()
    {
        //服务端名称
        super("I AM server1");



        //设置窗口大小与是否可见
        setBounds(350,100,320,200); setVisible(true);

        //设置面板与相关组件排布
        JPanel p = new JPanel();
        p.add(outMessage);
        Container con=getContentPane();
        con.add(new JScrollPane(inMessage), BorderLayout.CENTER);
        con.add(p,BorderLayout.NORTH);

        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        validate();

        //创建该类新线程
        Thread thread = new Thread(this);
        thread.start(); // 线程负责接收数据
    }


    public void run()
    {
        // 接收数据
        DatagramPacket pack = null;
        DatagramSocket mail = null;
        byte b[]=new byte[8192];
        try
        {
            //接收服务端发来的5678端口的消息
            pack = new DatagramPacket(b,b.length);
            mail = new DatagramSocket(5678);
        }
        catch(Exception e){}

        //循环监听消息并打印
        while(true)
        {
            try
            {

                mail.receive(pack);
                String message=new String(pack.getData(),0,pack.getLength());
                inMessage.append("收到数据来自："+pack.getAddress());
                inMessage.append("\n收到数据是："+message);
                inMessage.append("\n收到端口是："+pack.getPort()+"\n");
                inMessage.setCaretPosition(inMessage.getText().length());

                //如果端口>=50000则是来自客户端2的消息，需要把其转发给客户端1也就是1234端口
                if(pack.getPort()>=50000){
                    try
                    {
                        InetAddress address = InetAddress.getByName("127.0.0.1");
                        DatagramPacket data = new DatagramPacket(pack.getData(),pack.getData().length,address,1234);
                        mail.send(data);
                    }
                    catch(Exception e){}
                }
                //如果端口<=30000则是来自客户端1的消息，需要把其转发给客户端2也就是4321端口
                else if(pack.getPort()<=30000){
                    try
                    {
                        InetAddress address = InetAddress.getByName("127.0.0.1");
                        DatagramPacket data = new DatagramPacket(pack.getData(),pack.getData().length,address,4321);
                        mail.send(data);
                    }
                    catch(Exception e){}

                }
            }
            catch(Exception e){}
        }
    }
    public static void main(String args[])
    {
        new test1_server1();
    }
}

