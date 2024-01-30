//
//  for_list1_10.c
//
//  Prints out the numbers 1 to 10
//
//  Created by M. Califano on 25/09/2015.

// include standard i/o library for scanf and printf
#include <stdio.h>
#include <stdlib.h>
//
//int* twoSum(int* nums, int numsSize, int target, int* returnSize) {
//    returnSize = (int*)malloc(2 * sizeof(int));
//    for (int i = 0; i < numsSize; i++) {
//        for (int j = i + 1; j < numsSize; j++) {
//            if (nums[i] + nums[j] == target) {
//                returnSize[0] = i;
//                returnSize[1] = j;
//                return returnSize;
//            }
//        }
//    }
//}
//int main(void) {
//
//    int i;   // counter for the number of loops
//    int sum[4] = { 2,7,11,15 };
//    int target = 9;
//    int size[2];
//    int* p;
//    p=twoSum(sum, 4, target, size);
//    printf("%d %d", p[0], p[1]);
//   
//
//    return 0;
//
//}
void main() {
	int j;
	unsigned int bignum = 999999999;
	unsigned int num2;
	int number[10] = { 9,9,9,9,9,9,9,9,9,9 };
	while (1) {



		bignum--;
		num2 = bignum;
		for (j = 1; j <= 9; j++) {

			number[10 - j] = num2 % 10;
			num2 /= 10;
		}

		for (unsigned int i = 0; i < 10; i++) {
			printf("%u ", number[i]);
		}
		printf("\n");
		_sleep(100);

	}
			
			
}