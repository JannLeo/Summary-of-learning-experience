package test2;

import sun.reflect.generics.tree.Tree;

import java.math.BigDecimal;
import java.util.*;

/**
 * @version 1.0
 * @author: 刘俊楠
 * @create: 2021-年−11-月-14-日-20:03
 * @projectName: IntelliJ IDEA-test2
 * @classNAME: demo2
 * @description: JannLeo
 */

class Matrix{
    HashMap<Integer,HashMap<Integer,Integer>> matrix;
    int row;
    int column;
    Matrix(HashMap<Integer,HashMap<Integer,Integer>> m,int r,int c){matrix=m; row=r;column=c;}
    HashMap<Integer,HashMap<Integer,Integer>> add(Matrix m1) {
        Iterator it1;
        Iterator it2;
        Map.Entry mp1;
        Map.Entry mp2;
        HashMap<Integer, HashMap<Integer, Integer>> add_result = new HashMap<>();
        for (int i = 0; i < row; i++) {
            add_result.put(i, new HashMap<>());
        }
        for (int i = 0; i < row; i++) {
            it1 = this.matrix.get(i).entrySet().iterator();
            it2 = m1.matrix.get(i).entrySet().iterator();
            if (it1.hasNext() && it2.hasNext()) {
                mp1 = (Map.Entry) it1.next();
                mp2 = (Map.Entry) it2.next();
                while (true) {
                    int m1_key=(int) mp1.getKey();
                    int m2_key=(int) mp2.getKey();
                    int m1_value=(int) mp1.getValue();
                    int m2_value=(int) mp2.getValue();
                    if (m1_key ==m2_key) {
                        add_result.get(i).put(m1_key, m1_value +m2_value);
                        if (it1.hasNext() && it2.hasNext()) {
                            mp2 = (Map.Entry) it2.next();
                            mp1 = (Map.Entry) it1.next();
                        }else break;

                        } else if (m1_key < m2_key) {
                            add_result.get(i).put(m1_key, m1_value);
                            if (it1.hasNext()) mp1 = (Map.Entry) it1.next();
                            else break;
                        } else {
                            add_result.get(i).put(m2_key, m2_value);
                            if (it1.hasNext()) mp2 = (Map.Entry) it2.next();
                            else break;
                        }
                        if (it2.hasNext()) {
                            do {
                                mp2 = (Map.Entry) it2.next();
                                add_result.get(i).put(m2_key, m2_value);
                            } while ((it2.hasNext()));
                        }
                        if (it1.hasNext()) {
                            do {
                                mp1 = (Map.Entry) it1.next();
                                add_result.get(i).put(m1_key, m1_value);
                            } while (it1.hasNext());
                        }

                    }
                }
            }

        return add_result;
    }
    HashMap<Integer,HashMap<Integer,Integer>> mul(Matrix m1){

        HashMap<Integer,HashMap<Integer,Integer>> mul_result=new HashMap<>();
        Iterator it1;
        Iterator it2;
        Map.Entry mp1;
        Map.Entry mp2;
        for(int i=0;i<row;i++){
            mul_result.put(i,new HashMap<>());
        }
        for(int i=0;i<row;i++){
            for(int j=0;j<column;j++) {
                int result=0;
                it1 = this.matrix.get(i).entrySet().iterator();
                it2 = m1.matrix.get(j).entrySet().iterator();
                if (it1.hasNext() && it2.hasNext()) {
                    mp1 = (Map.Entry) it1.next();
                    mp2 = (Map.Entry) it2.next();

                    while (true) {
                        int m1_key=(int) mp1.getKey();
                        int m2_key=(int) mp2.getKey();
                        int m1_value=(int) mp1.getValue();
                        int m2_value=(int) mp2.getValue();
                        if(m1_key == m2_key)  {
                            result += m1_value * m2_value;
                            if (it1.hasNext() && it2.hasNext()) {
                                mp2 = (Map.Entry) it2.next();
                                mp1 = (Map.Entry) it1.next();
                            } else break;

                        } else if (m1_key < m2_key) {
                            if (it1.hasNext()) mp1 = (Map.Entry) it1.next();
                            else break;

                        } else{
                            if (it2.hasNext()) mp2 = (Map.Entry) it2.next();
                            else break;

                        }
                    }

                }
                if (result != 0) {
                    mul_result.get(i).put(j,result);
                }


            }
        }
        return mul_result;
    }
    void print(){
        Iterator  it = this.matrix.entrySet().iterator();
        Iterator it1;
        while(it.hasNext()){
            Map.Entry e=(Map.Entry) it.next();
            it1=((HashMap<Integer,Integer>)e.getValue()).entrySet().iterator();
            int flag=-1;
            while(it1.hasNext()){
                Map.Entry e1=(Map.Entry)it1.next();
                for(int i=0;i<((int)e1.getKey()-flag-1);i++){
                    System.out.print("0 ");
                }
                flag=(int)e1.getKey();
                System.out.print(e1.getValue()+" ");
            }
            for(int i=0;i<this.matrix.size()-flag-1;i++){
                System.out.print("0 ");
            }
            System.out.println();
        }



    }
}

public class demo2_1 {
    public static void main(String[] args) {
        HashMap<Integer,HashMap<Integer,Integer>> m1_temp=new HashMap<>();
        HashMap<Integer,HashMap<Integer,Integer>> m2_temp=new HashMap<>();
        HashMap<Integer,HashMap<Integer,Integer>> m2_2_temp=new HashMap<>();
        HashMap<Integer,HashMap<Integer,Integer>> m_add_result=new HashMap<>();
        HashMap<Integer,HashMap<Integer,Integer>> m_substract_result=new HashMap<>();
        Scanner scanner=new Scanner(System.in);
        int m1_row=0,m1_column=0,m2_row=0,m2_column=0,m1_nonzero=0,m2_nonzero=0;
        double m1_rate=0,m2_rate=0;
        while(true){
            try {
                System.out.println("请输入矩阵1行数、列数以及非零元素个数");
                m1_row = scanner.nextInt();
                m1_column = scanner.nextInt();
                m1_nonzero = scanner.nextInt();
                System.out.println("请输入矩阵2行数、列数以及非零元素个数");
                m2_row = scanner.nextInt();
                m2_column = scanner.nextInt();
                m2_nonzero = scanner.nextInt();
                m1_rate = 1 - ((double)m1_nonzero / (m1_row * m1_column));
                m2_rate = 1 - ((double)m2_nonzero / (m2_row * m2_column));
                BigDecimal m1   =   new   BigDecimal(m1_rate);
                double   m1_r   =   m1.setScale(2,   BigDecimal.ROUND_HALF_UP).doubleValue();
                BigDecimal m2   =   new   BigDecimal(m2_rate);
                double   m2_r   =   m2.setScale(2,   BigDecimal.ROUND_HALF_UP).doubleValue();
                if (m1_r > 0.05 || m2_r > 0.05 || m1_row != m2_row || m1_column != m2_column) {
                    throw new Exception();
                }
                else
                    break;
            }catch(Exception e){
                System.out.println("矩阵输入错误，请重新输入！");
            }
        }
        for(int i=0;i<m1_row;i++){
            m1_temp.put(i,new HashMap<>());
            m2_temp.put(i,new HashMap<>());
            m2_2_temp.put(i,new HashMap<>());
            m_add_result.put(i,new HashMap<>());
            m_substract_result.put(i,new HashMap<>());
        }
        HashMap<Integer,Integer> temp_1=new HashMap<>(),temp_2=new HashMap<>();
        System.out.println("请输入矩阵1：");
        for(int i=0;i<m1_row;i++){
            for(int j=0;j<m1_column;j++) {
                int num = scanner.nextInt();
                if (num != 0) {
                    temp_1.put(j, num);
                    m1_temp.get(i).put(j,num);
                }
            }
        }
        System.out.println("请输入矩阵2：");
        for(int i=0;i<m2_row;i++){
            for(int j=0;j<m2_column;j++) {
                int num = scanner.nextInt();
                if (num != 0) {
                    m2_2_temp.get(j).put(i,num);
                    temp_2.put(j, num);
                    m2_temp.get(i).put(j,num);
                }
            }
        }
        Matrix m1=new Matrix(m1_temp,m1_row,m1_column);
        Matrix m2=new Matrix(m2_temp,m2_row,m2_column);
        Matrix m2_1=new Matrix(m2_2_temp,m2_row,m2_column);
        System.out.println("矩阵1为：");
        m1.print();
        System.out.println("矩阵2为：");
        m2.print();
        m_add_result=m1.add(m2);
        m_substract_result=m1.mul(m2_1);
        Matrix m_add=new Matrix(m_add_result,m1_row,m2_column);
        Matrix m_substract=new Matrix(m_substract_result,m1_row,m2_column);
        System.out.println("矩阵相加结果为：");
        m_add.print();
        System.out.println("矩阵相乘结果为：");
        m_substract.print();


    }
}

