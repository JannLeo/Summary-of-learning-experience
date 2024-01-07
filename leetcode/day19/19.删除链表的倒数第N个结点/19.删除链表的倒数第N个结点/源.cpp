#include <iostream>


using namespace std;


  //Definition for singly-linked list.
struct ListNode {
    int val;
    struct ListNode *next;
    ListNode() {
        int val = 0;
        next = NULL;
    }
};
//struct ListNode* removeNthFromEnd(struct ListNode* head, int n) {
//    struct ListNode* temp;
//    struct ListNode* remove;
//    struct ListNode* last;
//    temp = head;
//    remove = head;
//    last = head;
//    int num = 0;
//    while (temp) {
//        if (num >= n) {
//            remove = remove->next;
//            if (num > n)
//                last = last->next;
//        }
//        temp = temp->next;
//        num++;
//    }
//    if (!num)
//        return NULL;
//    // {1,2}  2
//    if (last == remove) {
//        head = remove->next;
//    }
//
//    last->next = remove->next;
//    return head;
//
//}
struct ListNode* removeNthFromEnd(struct ListNode* head, int n) {
    struct ListNode* temp;
    struct ListNode* last=new ListNode(0, head);
    temp = head;
    last = head;
    for (int i = 0; i < n; i++) {
        temp = temp->next;
    }
    while (temp) {
        last = last->next;
        temp = temp->next;
    }
    last->next = last->next->next;
    return head;
    
}

void main() {
    
    int sz;
    sz = 2;
    int* h = new int[sz] {1,2};
    int n = 2;
    ListNode* head=new ListNode;
    head->val = h[0];
    head->next = NULL;
    ListNode* temp = head;
    for (int i = 1; i < sz; i++) {
        ListNode* htemp=new ListNode;
        htemp->val = h[i];
        temp->next = htemp;
        temp = htemp;
    }
    delete h;
    
    removeNthFromEnd(head, n);
    temp = head;
    while (temp != nullptr) {
        cout << temp->val << " ";
        ListNode* nextNode = temp->next;
        delete temp;
        temp = nextNode;
    }
}