package test1_2;


import java.util.concurrent.*;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-19-日-16:20
 * @projectName: IntelliJ IDEA-test2
 * @classNAME: demo2
 * @description: JannLeo
 */
class PrintChar implements  Runnable{
    private char charToPrint;
    private int times;
    public PrintChar(char c,int t){
        charToPrint = c;
        times=t;
    }
    public void run(){
        for(int i=0;i<times;i++){
            System.out.print(charToPrint);
        }
    }
}
class PrintNum implements  Runnable{
    private int lastNum;
    public PrintNum(int n){
        lastNum=n;
    }
    public void run(){
        for(int i=1;i<=lastNum;i++){
            System.out.print(" "+ i);
        }
    }
}
public class ExecutorDemo {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(1);
        executor.execute(new PrintChar('a',100));
        executor.execute(new PrintChar('b',100));
        executor.execute(new PrintNum(100));
        executor.shutdown();
    }

}
