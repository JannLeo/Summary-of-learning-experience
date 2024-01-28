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
//void exchangenode() {
//
//}
void exchangenode(ListNode * p,ListNode* lastp) {
	if (p->next) {
		//2->1->  3->4
		// lastp->p->p1->p1next
		ListNode* p1 = p->next;
		lastp->next = p1;
		// lastp->p1
		// p->p1->..
		p->next = p1->next;
		p1->next = p;
		// 2 1 4 3
		// lastp->p1->p->
		if (p->next) {
			exchangenode(p->next, p);
		}
		else {
			return;
		}
	}
}
ListNode* swapPairs(ListNode* head) {
	if (!head)
		return NULL;
	else if (!head->next) {
		return head;
	}
	ListNode* result = head->next;
	if (head->next) {
		//1->2->3->4
		// head->headnext->...
		ListNode* p = head->next;
		// head->p->pnext
		head->next = p->next;
		p->next = head;
		//2->1->3->4
		// p -> head-> pnext
		if(head->next)
			exchangenode(head->next,head);
	}
	return result;
}
void main() {
	ListNode head, *tail = &head;
	tail->next = new ListNode(1);
	tail = tail->next;
	tail->next = new ListNode(2);
	tail = tail->next;
	tail->next = new ListNode(3);
	tail = tail->next;
	tail->next = new ListNode(4);
	tail = tail->next;
	ListNode* a=swapPairs(head.next);
}