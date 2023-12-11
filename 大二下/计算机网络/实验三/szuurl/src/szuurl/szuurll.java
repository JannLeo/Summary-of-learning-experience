package szuurl;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.*;
import java.io.*;
import java.util.Random;
public class szuurll {
	public static class URLtemp
    {
        public static void main(String []aregs)throws Exception
        {
        	URL url = new
                    URL("https://www.szu.edu.cn");
            InputStream inputStream = url.openStream();
            int count =0;
            int a =0 ;
            //connection打开地址
            HttpURLConnection urlConnection=(HttpURLConnection) url.openConnection();
            //获取文件的后缀
            String[] split=url.getFile().split("\\.");
            //获取流
            InputStream inpp=urlConnection.getInputStream();

            //写入流
            Random ran=new Random();
            FileOutputStream fifi=new FileOutputStream("UrlDown"+ran.nextInt(1000)+"."+split[split.length-1]);

            //写入
            byte[] buff=new byte[65535];
            int length;
            while((length=inpp.read(buff))!=-1){
                fifi.write(buff,0,length);
            }
            while (a>-1)
            {
                a=inputStream.read();//以字节为单位读入
                count++;
            }

            System.out.println("内容大小："+ count+"字节");
            fifi.close();
            inpp.close();
            urlConnection.disconnect();//断开连接
//	            //下载地址与下载
//	            URL url=new
//	                    URL("http://www.szu.edu.cn");
//	            //获取文件的后缀
//	            String[] split=url.getFile().split("\\.");
//	            //connection打开地址
//	            HttpURLConnection urlConnection=(HttpURLConnection) url.openConnection();
//	            //获取流
//	            InputStream inpp=urlConnection.getInputStream();
//	
//	            //写入流
//	            Random ran=new Random();
//	            FileOutputStream fifi=new FileOutputStream("UrlDown"+ran.nextInt(1000)+"."+split[split.length-1]);
//	
//	            //写入
//	            byte[] buff=new byte[65535];
//	            int length;
//	            while((length=inpp.read(buff))!=-1){
//	                fifi.write(buff,0,length);
//	            }
//	
//	            InputStream in=url.openStream();
//	            InputStream inputStream=url.openStream();
//	            int number=0;
//	            int a=0;
//	            while(a>-1)
//	            {
//	                a=inputStream.read();
//	                number++;
//	            }
//	            System.out.println(("已下载"+number+"字节"));
//	            //关闭流
//	            fifi.close();
//	            inpp.close();
//	            urlConnection.disconnect();//断开连接
        }
    }
}

