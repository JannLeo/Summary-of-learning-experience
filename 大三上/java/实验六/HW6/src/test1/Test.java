package test1;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-05-日-16:06
 * @projectName: IntelliJ IDEA-test1
 * @classNAME: demo1
 * @description: JannLeo
 */
public class Test {
    public static void main(String[] args) {
        //定义string s并赋值为Java
        String s="Java";
        //创建一个StringBuilder类型的对象builder 并且赋值为s
        StringBuilder builder = new StringBuilder(s);
        //对change方法，引入参数s与builder
        change(s,builder);
        //输出s与builder
        System.out.println(s);
        System.out.println(builder);
    }
    private static void change(String s, StringBuilder builder){
        //对string类型的s增添字符串
        s=s+" and HTML";
        //对stringbuilder类型的builder增添字符串
        builder.append(" and HTML");
    }
}
//                           程序1
//        //匹配字符串中是否有ABC （空格）的字符串，有则返回true
//        System.out.println("Hi,ABC,good".matches("ABC "));
//        //匹配字符串中是否包含ABC的子串，有则返回true
//        System.out.println("Hi,ABC,good".matches(".*ABC.*"));
//        //若字符串中有,;则将其替换成#，反之则不替换
//        System.out.println("A,B;C".replaceAll(",;","#"));
//        //若字符串中有，或者；则将其替换成#
//        System.out.println("A,B;C".replaceAll("[,;]","#"));
//        //若字符串中有,或者;则将字符串分开放进字符数组
//        String[] tokens = "A,B;C".split("[,;]");
//        for(int i=0;i<tokens.length;i++){
//            //按切割结果输出切割后的字符串
//            System.out.println(tokens[i]+" ");
//        }
//                       程序2
//    public static void main(String[] args) {
//        //定义一个string 对象s 并对其赋值
//        String s ="Hi, Good Morning";
//        //输出在m方法下参数为s的返回值
//        System.out.println(m(s));
//    }
//    public static int m(String s){
//        //初始化一个计数变量count
//        int count = 0;
//        for(int i=0;i<s.length();i++){
//            //对传进来的string类型的s遍历
//            // 如果有大写字母就count++
//            if(Character.isUpperCase(s.charAt(i)))
//                count++;
//        }
//        //返回计数结果
//        return count;
//    }
