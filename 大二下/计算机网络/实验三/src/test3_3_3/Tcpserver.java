package test3_3_3;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;



public class Tcpserver implements Runnable{

    // 服务器监听端口 55555
    private static final int MONITORPORT  = 55555;
    private Socket s ;

    public Tcpserver(Socket s) {
        super();
        this.s = s;
    }

    public static void server()
    {
        try {
            // 创建服务器socket
            ServerSocket serverSocket = new ServerSocket(MONITORPORT);
            int i=0;
            while(true)
            {
                i++;
                // 接收到一个客户端连接之后，创建一个新的线程进行服务
                // 并将联通的socket传给该线程
                Socket s = serverSocket.accept();
                System.out.println("server "+i+" start,connect  client1 successfully");

                new Thread(new Tcpserver(s)).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {
        Tcpserver.server();
    }



    @Override
    public void run() {
        byte[] buf = new byte[100];
        OutputStream os=null;
        FileInputStream fins=null;
        try {
            os = s.getOutputStream();
            // 文件名
            String fileName = "test.txt";

            System.out.println("the filename to  transfer: "+fileName);
            //先将文件名传输过去
            os.write(fileName.getBytes());
            System.out.println("begin to transfer filename");
            //将文件传输过去
            // 获取文件
            fins = new FileInputStream("C:\\Users\\11440\\Desktop\\作业与课件\\大二下\\计算机网络\\实验三\\test.txt");
            int data;
            // 通过fins读取文件，并通过os将文件传输
            while(-1!=(data = fins.read()))
            {
                os.write(data);
            }
            System.out.println("transfer end");


        } catch (IOException e) {
            e.printStackTrace();
        }finally
        {
            try {
                if(fins!=null) fins.close();
                if(os!=null)	os.close();
                this.s.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }

    }

}
