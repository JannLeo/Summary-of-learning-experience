package test2_1;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-06-日-21:32
 * @projectName: IntelliJ IDEA-test2_1
 * @classNAME: demo2_4
 * @description: JannLeo
 */
interface Human{
    static public StringBuilder  name=new StringBuilder();
    public void Human(String name1);
    public abstract double sayHi();
}
class Chinese implements Human {
    public void Human(String name1){
        name.delete(0, name.capacity());
        name.append(name1);
    }
    public double sayHi(){

        System.out.println(name+"，你好！");
        return 0.0;
    }
}
class Japanese implements Human {
    public void Human(String name1){
        name.delete(0, name.capacity());
        name.append(name1);
    }
    public double sayHi(){
        System.out.println(name+"，こんにちは！");
        return 0.0;
    }
}
class English implements Human {
    public void Human(String name1){
        name.delete(0, name.capacity());
        name.append(name1);
    }
    public double sayHi(){
        System.out.println(name+"，hi！");
        return 0.0;
    }
}
public class demo2_4 {
    public static void main(String[] args) {
        Human[] human=new Human[3];
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
