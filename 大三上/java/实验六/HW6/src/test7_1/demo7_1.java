package test7_1;


import java.util.*;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-07-日-18:31
 * @projectName: IntelliJ IDEA-test7
 * @classNAME: demo7_1
 * @description: JannLeo
 */
class Country1{
    String name;
    long GDP2020;
    long COVID19;
    Country1(long c){COVID19=c;}
    Country1(String n ,long g,long c){
        name=n;
        GDP2020=g;
        COVID19=c;
    }

}

public class demo7_1 {
    public static void main(String[] args) {
        Country1 [] country1=new Country1[10];
        Scanner s1=new Scanner(System.in);
        for(int i=0;i<10;i++){
            String name;
            long GDP,COVID;
            name=s1.next();
            GDP=s1.nextLong();
            COVID=s1.nextLong();
            country1[i]=new Country1(name,GDP,COVID);
        }
        TreeMap<Country1,Country1> countryTreeMap1= new TreeMap<Country1, Country1>(new Comparator<Country1>() {
            @Override
            public int compare(Country1 o1, Country1 o2) {
                if(o1.COVID19>o2.COVID19){
                    return 1;
                }
                else if(o1.COVID19<o2.COVID19){
                    return -1;

                }
                else
                    return 0;
            }
        });
        for(int i=0;i<10;i++){
            countryTreeMap1.put(new Country1(country1[i].COVID19),country1[i]);
        }
        Collection <Country1> collection=countryTreeMap1.values();
        Iterator<Country1> iter =collection.iterator();
        System.out.println("排序结果为（根据新冠确诊人数升序）：");
        while(iter.hasNext()){
            Country1 te=iter.next();
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