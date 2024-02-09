#include <stdio.h>
#include <string.h>
#include <string>

int main() {

	/* define first_name */
	/* define last_name */
	char first_name[20];
	char last_name[20];
	int age = 0;
	printf("Please input First name.\n");
	scanf("%s", &first_name);
	printf("Please input Last name.\n");
	scanf("%s", &last_name);
	printf("Please input your age.\n");
	scanf("%d", &age);
	char name[100];   // define string for full name

	sprintf_s(name, "%s %s", first_name, last_name); //write first_name and last_name to name

	printf("My name is %s\n", name);
	printf("My age is %d\n", age);


	return 0;
}