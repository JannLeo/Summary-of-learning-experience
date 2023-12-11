package test3_3_2;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.net.*;
import javax.swing.*;

public class Tcpserver extends JFrame   {

    private JButton jButton;//"发送”按钮
    private JButton clean;
    private JButton exit;
    private JTextField jTextField;//输入框
    private JTextArea jTextArea;//聊天窗口
    private JScrollPane jScrollPane;//聊天窗口的滚动条
    private DatagramSocket DS;//套接字
    private SocketAddress address;//UDP数据包要发送到的客户端的位置
    private final int port;//监听的端口号

    public Tcpserver() throws IOException {//构造函数。初始化UI，和一些必要的信息

        jButton = new JButton("发送");
        clean= new JButton("清空");
        exit=new JButton("退出");
        jTextField = new JTextField();
        jTextArea = new JTextArea();
        jScrollPane = new JScrollPane(jTextArea);
        address = null;
        port = 9999;
        DS = new DatagramSocket(port);//监听端口9999

        setTitle("服务器端");
        setSize(300, 370);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JPanel panel = new JPanel(new BorderLayout());
        panel.add(jTextField, BorderLayout.CENTER);
        exit.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
            }
        });
        clean.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                jTextArea.setText(null);

            }
        });
        jButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                try {
                    //在输入框内获取要发送的内容
                    String str = jTextField.getText();
                    //数据缓冲区
                    byte[] dd = str.getBytes();
                    //创建一个UDP数据包，并指定目的地为————address
                    DatagramPacket Data = new DatagramPacket(dd, dd.length, address);
                    DS.send(Data);
                    //将发送出的内容回显在聊天对话框中
                    jTextArea.append("服务器端：" + str + '\n');
                    //信息发出后清空输入框
                    jTextField.setText(null);
                } catch (Exception ee) {
                    ee.printStackTrace();
                }
            }
        });
        panel.add(exit, BorderLayout.SOUTH);
        panel.add(clean, BorderLayout.WEST);
        panel.add(jButton, BorderLayout.EAST);
        jTextArea.setEnabled(false);
        jTextArea.setDisabledTextColor(Color.BLUE);
        add(jScrollPane, BorderLayout.CENTER);
        add(panel, BorderLayout.SOUTH);
        setVisible(true);

        //启动服务器端
        start();
    }

    void start() {//启动服务器端
        try {
            //无限循环接收客户端发来的UDP数据包
            while (true) {
                //数据缓冲区
                byte[] data = new byte[1024];
                //创建一个UDP数据包
                DatagramPacket DP = new DatagramPacket(data, data.length);
                //接受从客户端发来的UDP数据包
                DS.receive(DP);
                //从数据包中获取客户端的地址
                address=DP.getSocketAddress();
                ////获取该数据包的内容，并将其显示在聊天窗口
                String str = new String(DP.getData());
                jTextArea.append("客户端：" + str + '\n');
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

//    public void actionPerformed(ActionEvent e)
//
//    }



    public static void main(String[] args) throws IOException {
        new Tcpserver();
    }
}
