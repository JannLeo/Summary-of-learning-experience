package test1;



/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-12-日-16:17
 * @projectName: IntelliJ IDEA-test1
 * @classNAME: demo1
 * @description: JannLeo
 */
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

public class demo1 {
    public static void main(String[] args) {
        Date []time=new Date[5];
        String timee;
        Scanner scanner=new Scanner(System.in);
        for(int i=0;i<5;i++) {
            timee=scanner.next();
            try {
                time[i]=new SimpleDateFormat("yyyy年MM月dd日HH时mm分ss秒").parse(timee);
            } catch (ParseException e) {
                e.printStackTrace();
                System.out.println("error");
            }
        }
        for(int i=1;i<5;i++){
            long timedifference= Math.abs(time[i].getTime()-time[i-1].getTime());
            long day=timedifference/(1000*3600*24);
            timedifference %= (1000*3600*24);
            long hours=(timedifference)/(1000*3600);
            timedifference %= (1000*3600);
            long minute=(timedifference)/(1000*60);
            timedifference %= (1000*60);
            long seconds=(timedifference)/1000;
            System.out.println("相差时间为: "+day+"日"+hours+"时"+minute+
                    "分"+seconds+"秒");
        }

    }
}
/*
2021年11月12日01时01分01秒
2077年1月23日11时11分02秒
2099年1月23日11时11分02秒
2100年1月23日11时11分02秒
2200年1月23日11时11分02秒

 */