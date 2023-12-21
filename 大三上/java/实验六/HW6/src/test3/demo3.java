package test3;

import sun.nio.cs.ext.MacHebrew;

import java.util.regex.Pattern;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-06-日-22:03
 * @projectName: IntelliJ IDEA-test3
 * @classNAME: demo3
 * @description: JannLeo
 */
import java.util.regex.Matcher;
public class demo3 {
    public static void main(String[] args) {
        double result=0;
        String menu="北京烤鸭：199.1元；西芹炒肉：11.8元；酸菜鱼：59.1元；铁板牛柳：32.1元";
        Pattern p;
        Matcher m;
        p= Pattern.compile("\\d+.\\d+");
        m=p.matcher(menu);
        while(m.find()){
            String str=m.group();

            result+=Double.valueOf(str);
        }
        System.out.println("总价格为："+result);

    }
}
