#include<iostream>
using namespace std;
string jiami(string a) {
	//加密方法
	//对于字符串a中
	for (int i = 0;i < a.length();i++) {
		//当遍历到字符串某个位置时其为字母时
		if (a[i] >= 'a' && a[i] <= 'z') {
			//如果其偏移5位后移出了字母范围
			if (a[i] + 5 > 'z') {
				//则将其从a开始重新计算
				a[i] = 'a' + (5-('z' - a[i])-1);
			}
			else {
				//否则字母直接偏移5位即可
				a[i] = a[i] + 5;
			}
		}
	}
	return a;
}

int main() {
	//设定明文为 shenzhen university
	string str = "shenzhen university";
	//向加密方法传入明文，并且得到返回的密文
	string s=jiami(str);
	//输出结果
	cout << "加密结果为: " << s << endl;
}