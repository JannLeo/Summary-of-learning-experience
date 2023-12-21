package test7;


import java.util.*;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-07-日-16:38
 * @projectName: IntelliJ IDEA-test7
 * @classNAME: demo7
 * @description: JannLeo
 */
class Country{
    String name;
    long GDP2020;
    long COVID19;
    Country(long C){COVID19=C;}
    Country(String n ,long g,long c){
        name=n;
        GDP2020=g;
        COVID19=c;
    }
}
class MyKey implements Comparable{
    long number=0;
    MyKey(long nu){
        number=nu;
    }
    public int compareTo(Object o1){
        MyKey mykey1=(MyKey) o1;
        if(this.number>mykey1.number){
            return 1;
        }
        else if(this.number<mykey1.number){
            return -1;

        }
        else
            return 0;

    }
}
public class demo7 {
    public static void main(String[] args) {
        Country [] country=new Country[10];
        Scanner s1=new Scanner(System.in);
        for(int i=0;i<10;i++){
            String name;
            long GDP,COVID;
            name=s1.next();
            GDP=s1.nextLong();
            COVID=s1.nextLong();
            country[i]=new Country(name,GDP,COVID);
        }
        TreeMap<MyKey, Country> countryTreeMap1= new TreeMap<MyKey,Country >();
        for(int i=0;i<10;i++){
            countryTreeMap1.put(new MyKey(country[i].COVID19),country[i]);
        }
        Collection <Country> collection=countryTreeMap1.values();
        Iterator<Country> iter =collection.iterator();
        System.out.println("排序结果为（根据新冠确诊人数升序）：");
        while(iter.hasNext()){
            Country te=iter.next();
            System.out.println("国家名称："+te.name+"  GDP："+te.GDP2020+"  新冠确诊人数："+te.COVID19);
        }
    }
}
/*
美国 20932750 44918565
中华人民共和国 14722837 124924
日本 5048688 1706675
德国 3803014 4284354
英国 2710970 8006660
印度 2708770 33893002
法国 2598907 7038701
意大利 1884935 4689341
加拿大 1643408 1647142
韩国 1630871 323379
法国 2598907 7038701
意大利 1884935 4689341
加拿大 1643408 1647142
韩国 1630871 323379

 */
