#include<iostream>
using namespace std;
void setmimaku(string *a) {
	cout << "生成的字母表为：" << endl;
	for (int i = 0;i < 26;i++) {
		for (int j = 0;j < 26;j++) {
			if ('a' + i + j <= 'z') {
				a[i]+= 'a' + i + j;
			}
			else {
				a[i]+= 'a'+(('a' + i + j)- 'z')-1;
			}
			cout << a[i][j];
		}
		cout << endl;
	}

}
void mima(string *a,string mingwen,string miyao) {
	//l为记录明文对应字母表的列数，k为记录秘钥对应字母表的行数
	//flag为空格数
	int k = 0, l = 0, flag = 0;
	string mi;
	//mi为生成的密文
	for (int i = 0;i < mingwen.length();i++) {
		//判断是否为字母
		if (mingwen[i] >= 'a' && mingwen[i] <= 'z') {
			for (int j = 0;j < 26;j++) {
				//在字母表中寻找秘钥对应的行数k
				if (i < miyao.length()) {
					if (a[j][0] == miyao[i]) {
						k = j;
					}
				}
				else {
					//消除空格带来的影响
					int p = i - miyao.length() - flag;
					if (p>= 0) {
						//寻找与秘钥相等的字母表的行数k
						if (a[j][0] == miyao[i - miyao.length() - flag]) {
							k = j;
						}
					}
					else {
						if (a[j][0] == miyao[miyao.length() - flag]) {
							k = j;
						}
					}
				}
				//寻找明文对应的列数
				if (a[0][j] == mingwen[i]) {
					l = j;
				}
			}
			//求取结果加到密文中
			mi += a[k][l];
		}
		else {
			//如果不为字母则空格
			mi += ' ';
			flag++;
		}
	}
	cout << "加密后字符串为：" << mi << endl;
}
int main() {
	string str = "shenzhen university";
	string* s;
	s = new string[26];
	setmimaku(s);
	string key = "liujunnan";
	mima(s, str, key);
}