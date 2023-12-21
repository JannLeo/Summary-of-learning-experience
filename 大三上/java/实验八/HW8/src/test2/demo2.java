package test2;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-19-日-16:40
 * @projectName: IntelliJ IDEA-test2
 * @classNAME: demo2
 * @description: JannLeo
 */
class Num implements Runnable {
    String name1, name2;
    Month month;

    Num(String s1, String s2,Month mon) {
        name1 = s1;
        name2 = s2;
        month = mon;
    }

    public void run() {
            while(true)
            {
                if(!month.flag)
                {
                    month.printint();
                }
                else
                {
                    month.printmonth();
                }
                if(month.num>12||(month.num==12&&month.flag==true)){
                    break;
                }
            }

    }
}
class Month{
    String []month1=new String[13];
    static int num;
    public boolean flag = false;
    Month(int n){
        num=n;
        month1[0]="";
        month1[1]="OneJanuary";
        month1[2]="TwoFebruary";
        month1[3]="ThreeMarch";
        month1[4]="FourApril";
        month1[5]="FiveMay";
        month1[6]="SixJune";
        month1[7]="SevenJuly";
        month1[8]="EightAugust";
        month1[9]="NineSeptember";
        month1[10]="TenOctober";
        month1[11]="ElevenNovember";
        month1[12]="TwelveDecember";

    }
    public synchronized void printint(){
        if(flag)
            try{this.wait();}catch(InterruptedException e){}
        System.out.print(num);
        flag = true;
        this.notify();
    }
    public synchronized void printmonth(){
        if(!flag)
            try{this.wait();}catch(InterruptedException e){}
        System.out.print(month1[num]);
        num++;
        flag = false;
        this.notify();
    }

}

public class demo2 {
    public static void main(String[] args) {
        String s1="int",s2="month";
        Month mn=new Month(1);

        Num num=new Num(s1,s2,mn);

        Thread integ=new Thread(num);
        Thread month=new Thread(num);

        integ.setName(s1);
        month.setName(s2);

        integ.start();
        month.start();
    }
}
