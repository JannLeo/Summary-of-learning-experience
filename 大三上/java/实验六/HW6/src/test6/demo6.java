package test6;

import java.util.HashSet;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-07-日-16:11
 * @projectName: IntelliJ IDEA-test6
 * @classNAME: demo6
 * @description: JannLeo
 */
public class demo6 {
    public static void main(String[] args) {
        String name1="张三";
        String name2="李四";
        String name3="王五";
        HashSet<String> A=new HashSet<String>();
        HashSet<String> B=new HashSet<String>();
        A.add(name1);
        A.add(name2);
        B.add(name2);
        B.add(name3);
        Object []s1 =A.toArray();
        System.out.println("A社团人员为：");
        for(int i=0;i<s1.length;i++){
            System.out.println(s1[i]);
        }
        Object []s2 =B.toArray();
        System.out.println("B社团人员为：");
        for(int i=0;i<s2.length;i++){
            System.out.println(s2[i]);
        }
        HashSet<String> TempSet=new HashSet<String>();
        TempSet.addAll(A);
        TempSet.retainAll(B);
        Object []s3 =TempSet.toArray();
        System.out.println("同时参加A、B社团人员为：");
        for(int i=0;i<s3.length;i++){
            System.out.println(s3[i]);
        }

    }
}
