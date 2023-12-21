package test3;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-24-日-21:06
 * @projectName: IntelliJ IDEA-test3
 * @classNAME: demo3
 * @description: JannLeo
 */
//编写Java应用程序实现如下功能：创建工作线程，模拟银行现金账户取款操作。
// 多个线程同时执行取款操作时，如果不使用同步处理，会造成账户余额混乱，
// 要求使用syncrhonized关键字同步代码块，
// 以保证多个线程同时执行取款操作时，
// 银行现金账户取款的有效和一致。要求采用实现Runnable接口
// 和Thread类的构造方法的方式创建线程，而不是通过Thread类的子类的方式。
// 在报告中附上程序截图、运行结果截图和详细的文字说明。
class Bank{
    String s1;
    String th_s,th_s1;
    int balance;
    Bank(String s,int b){
        s1=s;
        balance=b;
        System.out.println(s1+"用户银行当前账户余额为"+balance);
    }
    public synchronized void deposit(){
        if(Thread.currentThread().getName()==th_s) {
            try {
                this.wait();
            } catch (InterruptedException e) {
            }
            if (th_s1 == Thread.currentThread().getName()) {
                try {
                    this.wait();
                } catch (InterruptedException e) {
                }
            }
        }
        if(balance>=10) {
            balance-=10;
            System.out.println(Thread.currentThread().getName() + "线程向"
                    + s1 + "用户取钱了！ 当前银行余额为：" + balance);
            this.notifyAll();
            if(th_s!=Thread.currentThread().getName()) {
                th_s1 = th_s;
                th_s = Thread.currentThread().getName();
            }
        }
    }
}
class quqian implements Runnable{
    Bank b;
    quqian(Bank b){
        this.b=b;
    }
    public void run(){
        while(b.balance>10){
            b.deposit();
        }
    }
}
public class demo3 {
    public static void main(String[] args) {
        String s1="刘俊楠",s2="资本家",s3="小偷",s4="生活";
        Bank b=new Bank(s1,100);

        quqian q=new quqian(b);

        Thread a1=new Thread(q);
        Thread a2=new Thread(q);
        Thread a3=new Thread(q);

        a1.setName(s2);
        a2.setName(s3);
        a3.setName(s4);

        a1.start();
        a2.start();
        a3.start();
    }
}
