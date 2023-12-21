package test2;

import java.security.PublicKey;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-06-日-21:17
 * @projectName: IntelliJ IDEA-test2
 * @classNAME: demo2_3
 * @description: JannLeo
 */
public class HumanTest {
    public static void main(String[] args) {
       Human [] human=new Human [3];
       String name="刘俊楠";
       human[0]=new Chinese();
       human[1]=new Japanese();
       human[2]=new English();
       for(int i=0;i<3;i++){
           human[i].Human(name);
           human[i].sayHi();
       }

    }
}
