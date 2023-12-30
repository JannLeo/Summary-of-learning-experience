#include<iostream>
using namespace std;
int main() {
	int t;
	cin >> t;
	int* a = new int[t];
	int* b = new int[t-1];
	for (int i = 0;i < t;i++) {
		cin >> a[i];
		b[i] = false;
	}
	for (int i = 1;i < t;i++) {
		int temp = a[i];
		int j;
		for (int j = 0;j < i;j++) {
			if (temp < a[j]) {
				for (int k = i;k > j;k--) {
					a[k] = a[k - 1];
				}
				a[j] = temp;
				break;
			}
		}
		for (int k = 0;k < t;k++) {
			cout << a[k] << " ";
		}
		cout << endl;
	}
	
	
}
