package localhosttemp;
import java.net.InetAddress;
public class lochost {



	    public static void main(String[] args) throws Exception
	    {
	        InetAddress host = InetAddress.getLocalHost();
	        System.out.println("���ػ���IP��ַ��"+host.getHostAddress());
	        System.out.println("���ػ������ƣ�"+host.getHostName());
	    }

	
}
