package test3_3_2;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.net.*;
import javax.swing.*;

public class Tcpclient extends JFrame implements ActionListener {
    private JButton jButton;//"发送”按钮
    private JButton clean;
    private JButton exit;
    private JTextField jTextField;//输入框
    private JTextArea jTextArea;//聊天窗口
    private JScrollPane jScrollPane;//聊天窗口的滚动条
    private DatagramSocket DS;//套接字
    private final InetAddress address;//UDP数据包发送位置的ip
    private final int port;//DP数据包发送位置的端口

    //构造函数。初始化UI，和一些必要的信息
    public Tcpclient() throws UnknownHostException, SocketException {
        jButton = new JButton("发送");
        clean= new JButton("清空");
        exit=new JButton("退出");
        jTextField = new JTextField();
        jTextArea = new JTextArea();
        jScrollPane = new JScrollPane(jTextArea);
        address = InetAddress.getByName("Localhost");
        port = 9999;
        DS = new DatagramSocket();
        setTitle("客户端");
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
                    DatagramPacket Data = new DatagramPacket(dd, dd.length, address,9999);
                    DS.send(Data);
                    //将发送出的内容回显在聊天对话框中
                    jTextArea.append("客户端：" + str + '\n');
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
        jTextArea.setDisabledTextColor(Color.MAGENTA);
        add(jScrollPane, BorderLayout.CENTER);
        add(panel, BorderLayout.SOUTH);
        setVisible(true);

        //启动客户端
        start();
    }
    void start() {
        try {
            //连接成功，向服务器端发送提示信息
            String str = "[客户端连接完成！]";
            //数据缓冲区
            byte[] data;
            data = str.getBytes();
            //创建一个UDP数据包，并指定目的地ip=127.0.0.1、端口=9999
            DatagramPacket DP0 = new DatagramPacket(data, data.length, address, port);
            //向目的地发送UDP数据包。使服务器端能从该UDP数据包中获得客户端的地址
            DS.send(DP0);
            //无限循环接收服务器端发来的UDP数据包
            while (true) {
                //数据缓冲区
                byte[] dd = new byte[1024];
                //创建一个UDP数据包，并指定接收从地址为ip=127.0.0.1、端口=9999发来的数据
                DatagramPacket DP = new DatagramPacket(dd, dd.length, address, port);
                //接受从服务器端发来的UDP数据包
                DS.receive(DP);
                //获取该数据包的内容，并将其显示在聊天窗口
                String s = new String(DP.getData());
                jTextArea.append("服务器端：" + s + '\n');
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //监听“发送”按钮，当按钮按下时，执行该方法
    public void actionPerformed(ActionEvent e) {
        try {
            //在输入框内获取要发送的内容
            String str = jTextField.getText();
            //数据缓冲区
            byte[] dd = str.getBytes();
            //创建一个UDP数据包，并指定目的地ip=127.0.0.1、端口=9999
            DatagramPacket Data = new DatagramPacket(dd, dd.length, address, port);
            //向目的地发送数据包
            DS.send(Data);
            //将发送出的内容回显在聊天对话框中
            jTextArea.append("客户端：" + str + '\n');
            //信息发出后清空输入框
            jTextField.setText(null);
        } catch (Exception ee) {
            ee.printStackTrace();
        }
    }

    public static void main(String[] args) throws IOException {
        new Tcpclient();
    }
}