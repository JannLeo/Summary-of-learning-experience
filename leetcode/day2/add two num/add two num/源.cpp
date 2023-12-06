#include <iostream>
using namespace std;

 struct ListNode {
    int val;
    ListNode *next;
     ListNode() : val(0), next(nullptr) {}
     ListNode(int x) : val(x), next(nullptr) {}
     ListNode(int x, ListNode *next) : val(x), next(next) {}
  };

 class Solution {
 public:
     ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
         ListNode* l3 =new ListNode(0);
         ListNode* l4 = NULL;
         l3->val = 0;
         l4 = l3;
         while (l1 || l2) {
             if (!l1) {
                 l1 = new ListNode(0);
             }
             else if (!l2) {
                 l2 = new ListNode(0);
             }
             l3->val = l1->val + l2->val + l3->val;
             if (l3->val >= 10) {
                 l3->val -= 10;
                 l3->next = new ListNode(1);
                 
             }
             else if (l1->next || l2->next) {
                 l3->next = new ListNode(0);
             }
             l3 = l3->next;
            l1 = l1->next;
            l2 = l2->next;
             
         }
         return l4;
     }
 };
 void main() {
     ListNode* l1 = new ListNode(1);
     ListNode* head = l1;
     l1->next = new ListNode(8);
     
     l1 = head;
     ListNode* l2 = new ListNode(0);
     /*head = l2;
     l2->next = new ListNode(9);
     l2 = l2->next;
     l2->next = new ListNode(9);
     l2 = l2->next;
     l2->next = new ListNode(9);
     l2 = head;*/
     Solution a;
     ListNode *l3 = a.addTwoNumbers(l1, l2);


 }