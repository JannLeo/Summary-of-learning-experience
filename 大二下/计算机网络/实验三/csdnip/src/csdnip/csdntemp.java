package csdnip;
import java.net.InetAddress;
import java.net.UnknownHostException;
public class csdntemp {
	public static void main(String[] args) throws Exception {

        try {
            String csdnhost = "www.csdn.net";
            InetAddress csaddress[] = InetAddress.getAllByName(csdnhost);
            int number = csaddress.length;
            System.out.println("csdn IP����Ϊ��" + number);
            for (InetAddress address : csaddress)
                System.out.println("csdn IP��ַΪ��" + address);
        } catch (UnknownHostException e) {
            e.printStackTrace();


        }
    }
}
