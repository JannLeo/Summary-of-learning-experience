#include <iostream>
#include <vector>
#include <queue>
using namespace std;
struct ListNode {
	int val;
	ListNode* next;
	ListNode() : val(0), next(nullptr) {}
	ListNode(int x) : val(x), next(nullptr) {}
	ListNode(int x, ListNode* next) : val(x), next(next) {}
};
ListNode* combinetoone(ListNode* p1,ListNode* p2) {
	ListNode* head=new ListNode();
	if (!p1 && !p2)
		return NULL;
	if (!p1) {
		return head = p2;
	}
	else if (!p2) {
		return head = p1;
	}
	if (p1->val > p2->val) {
		head->val = p2->val;
		p2 = p2->next;
	}
	else {
		head->val = p1->val;
		p1 = p1->next;
	}
	ListNode* p3 = head;
	while (p1 && p2) {
		if (p1->val > p2->val) {
			p3->next = new ListNode(p2->val);
			p2 = p2->next;
		}
		else {
			p3->next = new ListNode(p1->val);
			p1 = p1->next;
		}
		p3 = p3->next;
	}
	if (!p1) {
		p3->next=p2;
	}
	else if (!p2) {
		p3->next = p1;
	}
	return head;
}
ListNode* dividelists(vector<ListNode*> lists,int left,int right) {	
	if (left == right)
		return lists[left];
	if (left > right)
		return NULL;
	int mid = (left + right) / 2;
	ListNode* p1=dividelists(lists, left, mid);
	ListNode* p2= dividelists(lists, mid+1, right);
	return combinetoone(p1, p2);
}

//ListNode* mergeKLists(vector<ListNode*>& lists) {
//	if (lists.size() == 0) {
//		return NULL;
//	}
//	else if (lists.size() == 1) {
//		return lists[0];
//	}
//
//	//分治法
//	return dividelists(lists, 0, lists.size() - 1);
//}


//优先队列做法

struct status {
	int val;
	ListNode* p;
	bool operator < (const status& temp) const {
		return val > temp.val;
	}
};
priority_queue <status> q;
ListNode* mergeKLists(vector<ListNode*>& lists) {
	for (auto node : lists) {
		if (node)q.push({ node->val ,node });
	}
	ListNode head, * tail = &head;
	while (!q.empty()) {
		auto f = q.top(); q.pop();
		tail->next = f.p;
		tail = tail->next;
		if (f.p->next) q.push({ f.p->next->val,f.p->next });

	}
	return head.next;
}
void main() {
	//初始化
	ListNode* p = new ListNode();
	p->val = 1;
	p->next = new ListNode(4);
	p->next->next = new ListNode(5);
	ListNode* p2 = new ListNode();
	p2->val = 1;
	p2->next = new ListNode(3);
	p2->next->next = new ListNode(4);
	ListNode* p3 = new ListNode();
	p3->val = 2;
	p3->next = new ListNode(6);
	vector<ListNode*> lists;
	lists.push_back(p);
	lists.push_back(p2);
	lists.push_back(p3);
	ListNode* result = mergeKLists(lists);

}