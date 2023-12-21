package test4;

import static java.lang.System.exit;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-26-日-16:06
 * @projectName: IntelliJ IDEA-test4
 * @classNAME: demo4
 * @description: JannLeo
 */
//有一座东西向的桥，只能容纳一个人，桥的东边有20个人（记为E1,E2,…,E20）
// 和桥的西边有20个人（记为W1,W2,…,W20），编写Java应用程序让这些人到达对岸，
// 每个人用一个线程表示，桥为共享资源，在过桥的过程中输出谁正在过桥
// （不同人之间用逗号隔开）。运行10次，分别统计东边和西边的20人先到达对岸的次数。
// 要求采用实现Runnable接口和Thread类的构造方法的方式创建线程，
// 而不是通过Thread类的子类的方式。在报告中附上程序截图、运行结果截图和详细的文字说明。
class Bridge{
    int X_flag=0;
    int D_flag=0;
    static int []occur=new int[40];
    String []name=new String[40];
    Bridge(){
        for(int i=0;i<40;i++){
            occur[i]=0;
            if(i<=19){
                name[i]="E"+(i);
            }
            else{
                name[i]="W"+(i-20);
            }
        }
    }
    public synchronized void cross(){

        for(int i=0;i<40;i++){
            if(Thread.currentThread().getName().equals(name[i])){
                if(occur[i]==0){
                    occur[i]++;
                }
                else{
                    try {
//                        Thread.sleep(100);
                        wait();
                        notifyAll();
//                        return;
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }

        }
        if(X_flag<20&&D_flag<20) {
                if (Thread.currentThread().getName().contains("E")) {

                    D_flag++;
                } else {
                    X_flag++;
                }
                System.out.print(Thread.currentThread().getName() + "正在过桥,");
            try {
                Thread.sleep(500);
//                System.out.println();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        else{
            if(X_flag>=20||D_flag>=20) {
                System.out.println("");
                if(D_flag>X_flag){
                    System.out.println("东家胜出！东边人过去了"+D_flag+"个" +
                            "，西边人过去了"+X_flag+"个");
                    exit(0);
                }
                else{
                    System.out.println("西家胜出！东边人过去了"+D_flag+"个" +
                            "，西边人过去了"+X_flag+"个");

                    exit(0);
                }
            }
        }


    }
}

class People implements Runnable{
    Bridge B;
    People(Bridge BB){
        B=BB;
    }
    public void run(){
        while(B.X_flag<20&&B.D_flag<20)
            B.cross();

    }
}
public class demo4 {
    public static void main(String[] args) {
            Thread []dong=new Thread[20];
            Thread []xi=new Thread[20];
            String []named=new String[20];
            String []namex=new String[20];
            Bridge  b=new Bridge();
            People p =new People(b);
            for(int i=0;i<20;i++){
                named[i]="E"+i;
                namex[i]="W"+i;
                dong[i]=new Thread(p);
                xi[i]=new Thread(p);
                dong[i].setName(named[i]);
                xi[i].setName(namex[i]);
                dong[i].start();
                try {
                    Thread.sleep(200);
//                System.out.println();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                xi[i].start();

            }



    }
}
