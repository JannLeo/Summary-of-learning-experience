package test1_3;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-19-日-16:27
 * @projectName: IntelliJ IDEA-test3
 * @classNAME: demo3
 * @description: JannLeo
 */
import java.util.concurrent.*;
public class AccountWithoutSync {
    private static  Account account=new Account();
    public static void main(String[] args) {
        ExecutorService executor =Executors.newCachedThreadPool();
        for(int i=0;i<100;i++){
            executor.execute(new AddAPennyTask());
        }
        executor.shutdown();
        while(!executor.isTerminated()){
        }
        System.out.println("What is balance?"+account.getBalance());
    }
    private static class AddAPennyTask implements Runnable{
        public void run(){
            account.deposit(1);
//            System.out.println(Thread.currentThread().getName()
//                    +" balance="+account.getBalance());
        }
    }
    private static  class Account{
        private int balance=0;
        public int getBalance(){
            return balance;
        }
        public void deposit(int amount){
            int newBalance =balance+amount;
            try{
                Thread.sleep(5);
            }
            catch(InterruptedException ex){

            }
            balance=newBalance;
        }
    }
}
