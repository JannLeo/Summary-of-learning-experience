package test2;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-05-日-17:23
 * @projectName: IntelliJ IDEA-test2
 * @classNAME: demo2_2
 * @description: JannLeo
 */
class Chinese extends Human{
    public double sayHi(){
        System.out.println(name+"，你好！");
        return 0.0;
    }
}
class Japanese extends Human{
    public double sayHi(){
        System.out.println(name+"，こんにちは！");
        return 0.0;
    }
}
class English extends Human{
    public double sayHi(){
        System.out.println(name+"，hi！");
        return 0.0;
    }
}

public class demo2_2 {
    public static void main(String[] args) {
        String name="刘俊楠";
        //创建各个语言的类的对象
        Chinese name_china=new Chinese();
        Japanese name_japan=new Japanese();
        English name_eng=new English();
        //为各个语言的对象中的变量name赋值
        name_china.Human(name);
        name_japan.Human(name);
        name_eng.Human(name);
        //运行各个对象的sayHi方法
        name_china.sayHi();
        name_japan.sayHi();
        name_eng.sayHi();
    }
}
