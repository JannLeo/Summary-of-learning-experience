package test2;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-05-日-16:59
 * @projectName: IntelliJ IDEA-test2
 * @classNAME: 的mo
 * @description: JannLeo
 */
abstract class Human{
    String name;
    public void Human(String name1){
        name=name1;
    }
    public abstract double sayHi();
}
public class demo2_1 {
    public static void main(String[] args) {
        String liujn="Jann Leo";
        Human ljn=new Human() {
            public double sayHi(){
                System.out.println(name+",hello!");
                return 0.0;
            }
        };
        ljn.Human(liujn);
        ljn.sayHi();
    }
}
