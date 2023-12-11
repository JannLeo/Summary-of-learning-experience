package test3_3_1;
import java.net.*;
import java.io.*;
import java.text.SimpleDateFormat;

public class tcpserver {
    public  static void  main(String[] args)throws Exception{
        try{
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式

            //建立套接字
            ServerSocket server=new ServerSocket(4700);
            //监听
            Socket socket=server.accept();
            //建立连接
            InputStreamReader sysin=new InputStreamReader(System.in);
            BufferedReader sysbuf=new BufferedReader(sysin);

            InputStreamReader socin=new InputStreamReader(socket.getInputStream());
            BufferedReader socbuf=new BufferedReader(socin);

            PrintWriter socout=new PrintWriter(socket.getOutputStream());
            //通信
            System.out.println("client:"+socbuf.readLine());
            String readline=sysbuf.readLine();
            while(!readline.equals("bye")){

                socout.println(readline);
                socout.flush();
                System.out.println("server:"+readline);
                String rsps=socbuf.readLine();

                if(!rsps.equals("Exit")) {//如果ok就结束

                    System.out.println("client:" + rsps);
                    readline = sysbuf.readLine();
                }
                else {
                    socout.println("Bye");
                    socout.flush();
                    System.out.println("Bye");
                    break;
                }


            }

            //关闭io与socket
            socout.close();
            socin.close();
            server.close();
        }catch (Exception e){
            System.out.println("error"+e);
        }
    }
}
