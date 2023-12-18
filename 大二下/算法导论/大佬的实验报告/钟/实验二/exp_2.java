import java.util.*;

class Point implements Comparable<Point> {
    public final int compareTo(Point otherInstance) {
        if (lessThan(otherInstance)) {
            return -1;
        } else if (otherInstance.lessThan(this)) {
            return 1;
        }

        return 0;
    }

    public double x;
    public double y;

    public boolean lessThan(Point p2) {
        return x < p2.x;
    }
    public Point(){}

    public Point(double x, double y)
    {
        this.x = x;
        this.y = y;
    }
}

public class exp_2 {
    public static final int N = 9999999;
    public static Point[] v = new Point[N];
    public static Point[] v2 = new Point[N];

    public static double juli(Point a, Point b)
    {
        return Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2));
    }


    public static double violence(int n) {
        double minimun = Double.POSITIVE_INFINITY;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                minimun = Math.min(minimun, exp_2.juli(v[i], v[j]));
            }
        }
        return minimun;
    }

    
    public static double DandC(int left, int right) // 分治
	{
		if (left == right)
			return Double.POSITIVE_INFINITY;
		if (right - left == 1)
		{
            if (v[left].y > v[right].y)
            {
                Point p = v[left];
                v[left] = v[right];
                v[right] = p;
            }
			return exp_2.juli(v[left], v[right]);
		}
		int m = (left + right) / 2;   //m 为中间值
		double minl = exp_2.DandC(left, m);   //左边最小距离
		double minr = exp_2.DandC(m + 1, right);  //右边最小距离
		double min = Math.min(minl, minr);   //左右最小距离
		int i = left;
		int j = m + 1;
		int sum = 0;
		while (i <= m || j <= right)
		{
			while (j <= right && (i > m || v[i].y >= v[j].y))  //
				v2[sum++] = v[j++];
			while (i <= m && (j > right || v[j].y >= v[i].y))
				v2[sum++] = v[i++];
		}
        i = left;
        j = 0;
		while (i <= right)
			v[i++] = v2[j++];
		j = 0;
		for (i = left; i <= right; i++)
		{
			if (Math.abs(v[i].x - v[m].x) < min) //如果pi的x在区域内
			{
				v2[j++] = v[i];
			}
		}
		for (i = 0; i < j; i++)
		{
			int k = i + 1;
			while (k < j && v2[k].y - v2[i].y < min)
				min = Math.min(min, exp_2.juli(v2[i], v2[k++]));
		}
		return min;
	}

    public static void main(String[] args)
	{
		System.out.print("输入1：蛮力法，2：分治法：");
		System.out.print("\n");
		int flag;
		int n;
        int time_of_test = 20;
        Scanner scanner = new Scanner(System.in);
		flag = scanner.nextInt();
		System.out.print("输入规模：");
		System.out.print("\n");
        n = scanner.nextInt();
		double sum = 0;
		while (time_of_test > 0) 
		{

			for (int i = 0; i < n; i++)
            {
                v[i] = new Point(Math.random(),Math.random());
			}

			long start = System.currentTimeMillis();

			if(flag == 1)
			{
				System.out.print("最短距离：");
				System.out.print(exp_2.violence(n));
				System.out.print("\n");
				break;
			} 
				
			else
			{
                Arrays.sort(v);
				System.out.print("最短距离：");
				System.out.print(exp_2.DandC(0, n - 1));
				System.out.print("\n");				
			}

			
			long end = System.currentTimeMillis();
			System.out.print("运行时间");
			System.out.print(end - start);
			System.out.print("ms");
			System.out.print("\n");
            sum += end - start;
            time_of_test--;
		}
		System.out.print("平均运行时间：");
		System.out.print(sum / 10);
		System.out.print("ms");
		System.out.print("\n");
	}
}
