#include<iostream>
using namespace std;
void setmimaku(string *a) {
	cout << "���ɵ���ĸ��Ϊ��" << endl;
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
	//lΪ��¼���Ķ�Ӧ��ĸ���������kΪ��¼��Կ��Ӧ��ĸ�������
	//flagΪ�ո���
	int k = 0, l = 0, flag = 0;
	string mi;
	//miΪ���ɵ�����
	for (int i = 0;i < mingwen.length();i++) {
		//�ж��Ƿ�Ϊ��ĸ
		if (mingwen[i] >= 'a' && mingwen[i] <= 'z') {
			for (int j = 0;j < 26;j++) {
				//����ĸ����Ѱ����Կ��Ӧ������k
				if (i < miyao.length()) {
					if (a[j][0] == miyao[i]) {
						k = j;
					}
				}
				else {
					//�����ո������Ӱ��
					int p = i - miyao.length() - flag;
					if (p>= 0) {
						//Ѱ������Կ��ȵ���ĸ�������k
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
				//Ѱ�����Ķ�Ӧ������
				if (a[0][j] == mingwen[i]) {
					l = j;
				}
			}
			//��ȡ����ӵ�������
			mi += a[k][l];
		}
		else {
			//�����Ϊ��ĸ��ո�
			mi += ' ';
			flag++;
		}
	}
	cout << "���ܺ��ַ���Ϊ��" << mi << endl;
}
int main() {
	string str = "shenzhen university";
	string* s;
	s = new string[26];
	setmimaku(s);
	string key = "liujunnan";
	mima(s, str, key);
}