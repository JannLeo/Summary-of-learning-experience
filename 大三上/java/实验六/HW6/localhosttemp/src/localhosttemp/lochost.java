package localhosttemp;
import java.net.InetAddress;
public class lochost {



	    public static void main(String[] args) throws Exception
	    {
	        InetAddress host = InetAddress.getLocalHost();
	        System.out.println("本地机的IP地址："+host.getHostAddress());
	        System.out.println("本地机的名称："+host.getHostName());
	    }

	
}
