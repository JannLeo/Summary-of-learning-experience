package test5;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-07-日-14:21
 * @projectName: IntelliJ IDEA-test5
 * @classNAME: demo5
 * @description: JannLeo
 */

import java.util.Map.Entry;
public class demo5 {
    public static <integer> void main(String[] args) {
        String article="About Shenzhen University (SZU) is committed to excellence in teaching, research and social service. Sticking to the motto of “self-reliance, self-discipline, self-improvement”, the University is dedicated to serving the Shenzhen Special Economic Zone (SEZ), demonstrating China’s reform and opening up and pioneering change in higher education.\n" +
                "SZU, which is based in Shenzhen, China’s first Special Economic Zone and a key city in the Guangdong-Hong Kong-Macau Greater Bay Area, is distinctively known as an Experimental University in higher education with its reforms in the sector acknowledged in Mainland China.\n" +
                "Established in 1983, SZU received support from top Chinese universities including Peking University, Tsinghua University and Renmin University of China in the founding of new schools. In the past decades, the University has undergone rapid growth and has become a comprehensive university with complete disciplines, top-ranked academic and research institutes and awe-inspiring faculty. SZU faculty members are engaged with teaching and research for the betterment of society. They are devoted to seeking solutions to pressing global challenges and promoting innovation.\n" +
                "SZU offers a wide array of undergraduate and graduate programs and provides students with an interdisciplinary and inclusive multicultural learning environment. Students in SZU enjoy the plenty resources and facilities of both the SEZ and the University, pursue academic excellence and discover new interests and opportunities in a fast-changing era.\n" +
                "SZU is an integral part of the SEZ, a thriving technology and innovation hub. With four campuses in Yuehai, Canghai, Lihu and Luohu, the University vigorously conducts leading researches in various fields and collaborates with high-tech enterprises in the community for technology transfer. SZU strives to provide a high-quality and effective education and develop in each SZU member the ability and passion to innovate and contribute to social progress and development, and encourages talented young people to start entrepreneurship in SZU. Our alumni including Tencent have founded dozens of innovative companies with significant influence.\n" +
                "SZU is accelerating its pace toward internationalization, providing a variety of global learning opportunities. The University has established partnerships with numbers of overseas universities to offer exceptional exchange programs, joint degree programs, research collaborations, and a variety of other forms of collaborations with international partners. Students from all over the world are welcomed in SZU. In the city noted for its urban vitality and natural beauty, students can explore the most attractive parts of China, pursue their passion and develop their interests, perspectives and abilities.";
        HashMap<String, Integer> map= new HashMap<String,Integer>();
        Pattern p;
        Matcher m;
        p=Pattern.compile("\\w+");
        m=p.matcher(article);
        while(m.find()){
            String str=m.group();
            str=str.toLowerCase(Locale.ROOT);
            if(map.containsKey(str)){
                int i=map.get(str)+1;
                map.remove(str);
                map.put(str,i);
            }
            else{
                int i =1;
                map.put(str,i);
            }
        }

        List<Map.Entry<String, Integer>> list = new ArrayList<Map.Entry<String, Integer>>(map.entrySet());
        Collections.sort(list, new Comparator<Map.Entry<String, Integer>>() {
            @Override
            public int compare(Entry<String, Integer> o1, Entry<String, Integer> o2) {
                //return o1.getValue().compareTo(o2.getValue());
                return o2.getValue().compareTo(o1.getValue());
            }
        });
        int flag=0;
        for (Map.Entry<String, Integer> mapping : list) {
            if(flag<50) {
                flag++;
                System.out.print(mapping.getKey() + " ");
                if(flag%10==0){
                    System.out.println(" ");
                }
            }
            else
                break;
        }
    }
}
