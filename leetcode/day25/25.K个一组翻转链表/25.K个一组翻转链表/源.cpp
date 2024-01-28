#include <iostream>
#include <vector>
using namespace std;

struct ListNode {
	int val;
	ListNode* next;
	ListNode() : val(0), next(nullptr) {}
	ListNode(int x) : val(x), next(nullptr) {}
	ListNode(int x, ListNode* next) : val(x), next(next) {}
	
};
void reverselist(ListNode* head,ListNode* hlast,ListNode* lastnode, int k) {
	ListNode* temp = lastnode;
	while (head != lastnode) {
		ListNode* hnext = head->next;
		hlast->next = hnext;
		head->next = temp->next;
		temp->next = head;
		// 2 3 1 4 5
		// hnext->...->temp->head->...
		head = hnext;
	}
	return;
}
ListNode* reverseKGroup(ListNode* head, int k) {
	if (!head)
		return NULL;
	ListNode* p = head;
	ListNode* result=head;
	bool flag = 1;
	int times = 0;
	int temp = k - 1;
	while (temp--) {
		if (p->next) {
			p = p->next;
		}
		else {
			flag = 0;
		}
	}
	if (flag) {
		result = p;
		while (head != p) {
			// 2
			ListNode* hnext = head->next;
			head->next = p->next;
			p->next = head;
			head = hnext;
		}
	}
	// 3 2 1 4 5 6 7 8 9 10
	temp = k - 1;
	while (temp--) {
		if (p->next&&p->next->next) {
			p = p->next->next;
			head = head->next;
		}
		else {
			flag = 0;
		}
	}
	if (p->next)
		p = p->next;
	else
		flag = 0;
	// 3 2 1 4 5 6 7 8 9
	while (flag) {
		reverselist(head->next, head, p, k);
		// 3 2 1 6 5 4 7 8 9
		temp = k-1;
		while (temp--) {
			if (p->next && p->next->next) {
				p = p->next->next;
				head = head->next;
			}
			else {
				flag = 0;
			}
		}
		head = head->next;
		if (p->next)
			p = p->next;
		else
			flag = 0;
	}
	return result;
}

void main() {
	ListNode head, * tail = &head;
	int k = 3;
	tail->next = new ListNode(1);
	tail = tail->next;
	tail->next = new ListNode(2);
	tail = tail->next;
	tail->next = new ListNode(3);
	tail = tail->next;
	/*tail->next = new ListNode(4);
	tail = tail->next;
	tail->next = new ListNode(5);
	tail = tail->next;
	tail->next = new ListNode(6);
	tail = tail->next;
	tail->next = new ListNode(7);
	tail = tail->next;
	tail->next = new ListNode(8);
	tail = tail->next;
	tail->next = new ListNode(9);
	tail = tail->next;
	tail->next = new ListNode(10);
	tail = tail->next;*/
	reverseKGroup(head.next, k);
}