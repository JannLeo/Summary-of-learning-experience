package test4;

import java.util.Scanner;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-06-日-22:31
 * @projectName: IntelliJ IDEA-test4
 * @classNAME: demo4
 * @description: JannLeo
 */
public class demo4 {
    public static void main(String[] args) {
        for(int i=0;i<10;i++){
            System.out.println("请输入字符串：");
            Scanner str_in = new Scanner(System.in);
            String str=str_in.nextLine();
            String regex_int = "\\d+";
            String regex_A = "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]+";
            String regex_a = "[abcdefghijklmnopqrstuvwxyz]+";
            String newStr_int=str.replaceAll(regex_A,"");
            newStr_int=newStr_int.replaceAll(regex_a,"");
            String newStr_A=str.replaceAll(regex_int,"");
            newStr_A=newStr_A.replaceAll(regex_a,"");
            String newStr_a=str.replaceAll(regex_int,"");
            newStr_a=newStr_a.replaceAll(regex_A,"");
            System.out.println("字符串中的数字组合为："+newStr_int);
            System.out.println("字符串中的大写字母组合为："+newStr_A);
            System.out.println("字符串中的小写字母组合为："+newStr_a);
        }
    }
}

