#include<iostream>
using namespace std;
string jiami(string a) {
	//���ܷ���
	//�����ַ���a��
	for (int i = 0;i < a.length();i++) {
		//���������ַ���ĳ��λ��ʱ��Ϊ��ĸʱ
		if (a[i] >= 'a' && a[i] <= 'z') {
			//�����ƫ��5λ���Ƴ�����ĸ��Χ
			if (a[i] + 5 > 'z') {
				//�����a��ʼ���¼���
				a[i] = 'a' + (5-('z' - a[i])-1);
			}
			else {
				//������ĸֱ��ƫ��5λ����
				a[i] = a[i] + 5;
			}
		}
	}
	return a;
}

int main() {
	//�趨����Ϊ shenzhen university
	string str = "shenzhen university";
	//����ܷ����������ģ����ҵõ����ص�����
	string s=jiami(str);
	//������
	cout << "���ܽ��Ϊ: " << s << endl;
}