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
            //connection�򿪵�ַ
            HttpURLConnection urlConnection=(HttpURLConnection) url.openConnection();
            //��ȡ�ļ��ĺ�׺
            String[] split=url.getFile().split("\\.");
            //��ȡ��
            InputStream inpp=urlConnection.getInputStream();

            //д����
            Random ran=new Random();
            FileOutputStream fifi=new FileOutputStream("UrlDown"+ran.nextInt(1000)+"."+split[split.length-1]);

            //д��
            byte[] buff=new byte[65535];
            int length;
            while((length=inpp.read(buff))!=-1){
                fifi.write(buff,0,length);
            }
            while (a>-1)
            {
                a=inputStream.read();//���ֽ�Ϊ��λ����
                count++;
            }

            System.out.println("���ݴ�С��"+ count+"�ֽ�");
            fifi.close();
            inpp.close();
            urlConnection.disconnect();//�Ͽ�����
//	            //���ص�ַ������
//	            URL url=new
//	                    URL("http://www.szu.edu.cn");
//	            //��ȡ�ļ��ĺ�׺
//	            String[] split=url.getFile().split("\\.");
//	            //connection�򿪵�ַ
//	            HttpURLConnection urlConnection=(HttpURLConnection) url.openConnection();
//	            //��ȡ��
//	            InputStream inpp=urlConnection.getInputStream();
//	
//	            //д����
//	            Random ran=new Random();
//	            FileOutputStream fifi=new FileOutputStream("UrlDown"+ran.nextInt(1000)+"."+split[split.length-1]);
//	
//	            //д��
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
//	            System.out.println(("������"+number+"�ֽ�"));
//	            //�ر���
//	            fifi.close();
//	            inpp.close();
//	            urlConnection.disconnect();//�Ͽ�����
        }
    }
}

