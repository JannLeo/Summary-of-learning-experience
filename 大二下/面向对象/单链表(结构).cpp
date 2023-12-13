#include<iostream>
#include<string>
#include<stdlib.h>
#include<algorithm>
using namespace std;
struct SNode{
	int e;
	SNode *next;
	
};
void creatList(SNode*&head,int*value,int n){
	SNode *p=head;
	for(int i=0;i<n;i++)
	{
		SNode*s=new SNode{value[i],NULL};
		p->next=s;
		p=s;
	}

	
}
void insertList(SNode*head,int pos,int value){
	
	SNode*p=head;
	for(int i=1;i<=pos-1;i++)
	{
		p=p->next;
	}
	SNode* m=new SNode{value,NULL};
	m->next=p->next;
	p->next=m;
	
	head->e++;
	
	
	
	
	
}
void printList(SNode *head){
	SNode *p=head->next;
	while(p->next)
	{
		cout<<p->e<<" ";
		p=p->next;
	}
	cout<<p->e<<endl;
	
}
void removeNode(SNode *head, int pos)
{
	
	SNode*p=head;	
	SNode*q;
	for(int j=1;j<=pos-1;j++)
 		p=p->next;
 	q=p->next;
 	p->next=q->next;
 	delete q;
 
 	head->e--;
}
void deleteList(SNode *head)
{
	SNode*p;
 	while(head->next){
 		p=head->next;
 		head->next=p->next;
 		delete p;
	 }
	 delete head;
}
int main()
{
	int t;
	cin>>t;
	while(t--)
	{
		int n;
		cin>>n;
		SNode *head=new SNode{n,NULL};
		int *value;
		value=(int*)calloc(n,sizeof(int));
		for(int i=0;i<n;i++){
			cin>>value[i]; 
		}
		creatList(head,value,n);
		printList(head);
		int time;
		cin>>time;
		while(time--)
		{
			int dtime,numb;
			cin>>dtime>>numb;
			if(dtime<1||dtime>(head->e)+1)
			{
				cout<<"error"<<endl;
				continue;
			}
			insertList(head,dtime,numb);
			printList(head);
		}
		int dtime;
		cin>>dtime;
		while(dtime--)
		{
			int numb;
			cin>>numb;
			if(numb<1||numb>head->e)
			{
				cout<<"error"<<endl;
				continue;
			}
			removeNode(head,numb);
			printList(head); 
			}
			deleteList(head);	
	}
}
