package test3_3_3;

import java.io.*;
import java.net.InetSocketAddress;
import java.net.Socket;
public class Tcpclient {
    private static final String SERVERIP = "127.0.0.1";
    private static final int SERVERPORT = 55555;
    private static final int CLIENTPORT = 66666;
    public static void main(String[] args) {
        // 用来接受传输过来的字符
        byte[] buf = new byte[100];
        Socket s = new Socket();
        try {
            // 建立连接
            s.connect(new InetSocketAddress(SERVERIP,SERVERPORT), CLIENTPORT);
            System.out.println("server connection successfully");
            InputStream is = s.getInputStream();//获取输入流
            // 接收传输来的文件名
            int len = is.read(buf);
            String fileName = new String(buf,0,len);
            System.out.println("received filename："+fileName);
            System.out.println("saved as："+"1"+fileName);
            //接收传输来的文件
            FileOutputStream fos = new FileOutputStream("C:\\Users\\11440\\Desktop\\作业与课件\\大二下\\计算机网络\\实验三\\1test.txt");
            int data;
            while(-1!=(data = is.read()))
            {
                fos.write(data);
            }
            is.close();
            s.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}