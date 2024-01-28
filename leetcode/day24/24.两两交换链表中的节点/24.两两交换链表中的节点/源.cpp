#include<iostream>
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
    void exchangenode(ListNode* p, ListNode* lastp) {
        if (p->next) {
            // lastp->p->p1->
            ListNode* p1 = p->next;
            lastp->next = p1;
            p->next = p1->next;
            p1->next = p;
            // lastp->p1->p->
            if (p->next) {
                exchangenode(p->next, p);
            }
            else {
                return;
            }
        }
        //return;
    }
    ListNode* swapPairs(ListNode* head) {
        if (!head)
            return NULL;
        else if (!head->next) {
            return head;
        }
        ListNode* result = head->next;
        if (head->next) {
            // head->headnext->...
            // head->p->pnext
            ListNode* p = head->next;
            head->next = p->next;
            p->next = head;
            // p -> head-> pnext
            if (head->next)
                exchangenode(head->next, head);
        }
        return result;
    }
};