import java.io.*;
import java.util.*;
class Edge {
    public int p;
    public int q;
    public Edge(){}
    public Edge(int p, int q) 
    {
        this.p = p;
        this.q = q;
    }
}

public class exp_5 {
    public static final int largeRow = 150;
    public static final int largeCow = 150;

    public static int[] ancestor = new int[largeRow];
    public static int[] level = new int[largeRow];
    public static int[] father = new int[largeRow];
    public static int[][] deal = new int[largeCow][3];
    public static int[] daibiao = new int[largeRow * 2];
    public static int sum;


    public static void add(int p, int q) {
        E[sum] = new Edge(q, daibiao[p]);
        daibiao[p] = sum;
        sum = sum + 1;
    }

    public static Edge[] E = new Edge[largeRow * 2];
    
    public static int search(int v) {

        int jieguo;

        if (v == ancestor[v])
            jieguo = v;
        else
        {
            ancestor[v] = exp_5.search(ancestor[v]);
            jieguo = ancestor[v];
        }
        return jieguo;
    }

    public static void Union(int p, int q, int i) {
        int p_father = exp_5.search(p);
        int q_father = exp_5.search(q);
        if (p_father != q_father) {
            exp_5.add(p, q);
            exp_5.add(q, p);
            deal[i][0] = 1;
        }
        ancestor[p_father] = q_father;
    }

    public static void dfs(int u) {
        int i = daibiao[u];
        while (i >= 0) 
        {
            int v = E[i].p;
            if (level[v] == 0) {
                level[v] = level[u] + 1;
                father[v] = u;
                exp_5.dfs(v);
            }
            i = E[i].q;
        }

    }

    public static void dealpq(int p, int q) {
        p = exp_5.search(p);
        q = exp_5.search(q);
        while (p != q) {
            if (level[p] > level[q]) {
                ancestor[p] = q;
                p = exp_5.search(father[p]);
            } else {
                ancestor[q] = p;
                q = exp_5.search(father[q]);
            }
        }
    }

    public static void main(String[] args){

        Scanner input = new Scanner(System.in);
        System.out.println("请把mediumG.txt拷贝输入：");
        int row = input.nextInt();
        int cow = input.nextInt();

        for (int i = 0; i < cow; ++i) {

            int p = input.nextInt();
            int q = input.nextInt();
            deal[i+1][0] = 0;
            deal[i+1][1] = p;
            deal[i+1][2] = q;
        }
        

        for (int i = 0; i < largeRow * 2; ++i) {daibiao[i] = -1;}
        long startTime = System.currentTimeMillis();
        sum = 0;
        for (int i = 0; i < row+1; ++i) {
            ancestor[i] = i;
            level[i] = 0;
        }
        
        for (int i = 1; i < cow+1; ++i) {
            exp_5.Union(deal[i][1], deal[i][2], i);
        }
        for (int i = 0; i < row+1; ++i) {
            if (level[i] == 0) {
                level[i] = 1;
                father[i] = i;
                exp_5.dfs(i);
                
            }
        }
        for (int i = 0; i < row+1; i++)
            ancestor[i] = i;
        for (int i = 0; i < cow; ++i) {
            if (deal[i+1][0] == 0) {
                exp_5.dealpq(deal[i+1][1], deal[i+1][2]);
            }
        }
        boolean found = false;
        for (int i = 0; i < row + 1; ++i) {
            if (i == exp_5.search(i) && i != father[i]) {
                System.out.print("桥：");
                System.out.print(i);
                System.out.print(" ");
                System.out.println(father[i]);
                found = true;
            }
        }
        long endTime = System.currentTimeMillis();
        if(!found)
            System.out.println("没有桥！");
        System.out.print("耗时：");
        System.out.print(endTime - startTime);
        System.out.println(" ms");
    }
}
