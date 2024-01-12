#include <iostream>

using namespace std;
  //Definition for singly-linked list.
  struct ListNode {
      int val;
      ListNode *next;
      ListNode() : val(0), next(nullptr) {}
      ListNode(int x) : val(x), next(nullptr) {}
      ListNode(int x, ListNode *next) : val(x), next(next) {}
  };
void DFS(ListNode* p1, ListNode* p2, ListNode* lastp1) {
    if (p2 == NULL)
        return;
    if (p1 == NULL) {
        lastp1->next = p2;
        return;
    }
    // 1  3  4
    // 2  3  4
    // lastp1:1 p3:2 p1:3  4 
    if (p1->val >= p2->val) {
        ListNode* p3 = new ListNode(p2->val);
        p3->next = lastp1->next;
        p3->next = p1;
        lastp1->next = p3;
        DFS(p1, p2->next, lastp1->next);
        
    }
    else {
        DFS(p1->next, p2, p1);
    }
}
ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {
    if (list1 == NULL)
        return list2;
    else if (list2 == NULL)
        return list1;
    if (list1->val > list2->val) {
        ListNode* p = list2;
        DFS(list2->next, list1, list2);
        return p;
    }
    else {
        ListNode* p = list1;
        DFS(list1->next, list2, list1);
        return p;
    }
}

void main() {
    int sz1 = 1;
    int sz2 = 3;

    int* ls1 = new int[sz1] {};
    int* ls2 = new int[sz2] {2, 3, 4};
    ListNode* head = new ListNode(ls1[0]);
    ListNode* p1 = head;
    ListNode* head2 = new ListNode(ls2[0]);
    ListNode* p2 = head2;
    for (int i = 1; i < sz1; i++) {
        p1->next = new ListNode(ls1[i]);
        p1 = p1->next;
    }
    for (int j = 1; j < sz2; j++) {
        p2->next = new ListNode(ls2[j]);
        p2 = p2->next;
    }
    //delete p1, p2;
    mergeTwoLists(head, head2);
}