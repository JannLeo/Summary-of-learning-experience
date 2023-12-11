package test3_3_1;
import java.net.*;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;


public class tcpclient {
    public static void main(String[] args)throws Exception{
        try{
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式

            //创建socket
            Socket socket=new Socket(InetAddress.getLocalHost(),4700);
            //建立连接
            InputStreamReader sysin=new InputStreamReader(System.in);
            BufferedReader sysbuf=new BufferedReader(sysin);

            InputStreamReader socin=new InputStreamReader(socket.getInputStream());
            BufferedReader socbuf=new BufferedReader(socin);

            PrintWriter socout=new PrintWriter(socket.getOutputStream());

            //进行通信
            String readline=sysbuf.readLine();
            while(!readline.equals("Bye")){
                //客户向服务器发
                if(readline.equals("Time")){
                    System.out.println(df.format(new Date()));// new Date()为获取当前系统时间
                }
                socout.println(readline);//写入socket
                socout.flush();
                System.out.println("client:"+readline);
                String rsps=socbuf.readLine();
                if(!rsps.equals("Bye")) {//如果ok就结束

                    System.out.println("server:" + rsps);
                    readline = sysbuf.readLine();
                }
                else {
                    socout.println("Bye");
                    socout.flush();
                    System.out.println("Bye");
                    break;
                }
//                System.out.println("server:"+socbuf.readLine());
//
//                readline=sysbuf.readLine();


            }
            //关闭socket与io
            socout.close();
            socin.close();
            socket.close();

        }catch(Exception e){
            System.out.println("Error:"+e);
        }
    }
}
