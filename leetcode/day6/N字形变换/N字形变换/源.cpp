#include <iostream>
#include <vector>
using namespace std;
string convert(string s, int numRows){
	string sc;
	if (s.size() == 1 || numRows == 1)
		return s;
	for (int i = 0; i < numRows; i++) {//����
		for (int j = i; j < s.size();) {//�ַ�������
			int interval = (numRows - 1) * 2;//����
			int middle = (numRows - (i + 1)) * 2;//�м���
			if (numRows - 1 == i)
				middle = interval;
			
			
			if (interval == middle) {
				sc += s[j];
				j += (interval);
			}
			else {
				sc += s[j];
				if(j+middle<s.size())
					sc += s[j + middle];
				j += interval;
			}
		}
	}
	return sc;
	
	
}
void main() {
	string s = "AA";
	int numRows = 2;
	cout << convert(s, numRows)<<endl;
}