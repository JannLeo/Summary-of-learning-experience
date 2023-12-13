#include<iostream>
using namespace std;
struct Node{
	int e;
	Node *next;
};

void creatLIst(Node* head){
	//Node* p =head;
	int n,e;
	cin>>n;
	for(int i=1;i<=n;i++)
	{
		cin>>e;
		Node*s = new Node{e,NULL};
		s->next=head->next;
		head->next=s;
		head->e++; 
	}
}
//查找元素
void searchList(Node*head,int i)//查找第i个元素 
{
	if(i<1||i>head->e)
	{
		cout<<"error"<<endl;
		return;
	}
	Node*p=head;
	while(i--)
		p=p->next;
		cout<<p->e<<endl;
		return;
 } 
 Node* searchList(Node*head,int i)
{
	if(i<1||i>head->e)
	{
		cout<<"error"<<endl;
		return NULL;
	}
	Node*p=head;
	while(i--)
		p=p->next;
		cout<<p->e<endl;
		return p;
 } 
 //给定数值查找 
 Node* searchList(Node*head,int data)
{
	Node*p=head->next;
	while(p)
	if(p->e==data)
		return p;
	return NULL;
 } 
 //删除节点
 void deleteList(Node* head,int i){
 if(i<1||i>head->e)
 {
 	cout<<"error"<<endl;
 	return ;
 }
 Node*p=head;
 for(int j=1;j<i-1;j++)
 	p->next
 	Node*q=p->next;
 	p->next=q->next;
 	delete q;
 	head->e--;
 
}
//输出链表元素
void showList(Node* head)
{
	Node* p=head->next;
	while(p->next)
	{
		cout<<p->e<<" ";
		p=p->next;
	}
	cout<<p->e<<endl;
 } 
 //删除整个链表
 void destoryList(Node* head)
 {
 	Node*p;
 	while(head->next){
 		p=head->next;
 		head->next=p->next;
 		delete p;
	 }
	 delete head;
  } 
  int main()
  {
  	Node*head=new Node(0,NULL);
  	creatList(head);
  	showList(head);
  	insertList(head,3,100);
  	showList(head);
  	deleteList(head,2);
  	showList(head);
  	destoryList(head);
  	
  }
