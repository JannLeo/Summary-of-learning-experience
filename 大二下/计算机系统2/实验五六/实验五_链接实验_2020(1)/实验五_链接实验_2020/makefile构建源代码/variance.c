#include "variance.h"
//ƽ��������ȡ��
int variance_ceil(double a, double b)
{
	return (int)ceil(add(a,b) * sub(a,b));
}

//ƽ��������ȡ��
int variance_floor(double a, double b)
{
	return (int)floor(add(a,b) * sub(a,b));
}
