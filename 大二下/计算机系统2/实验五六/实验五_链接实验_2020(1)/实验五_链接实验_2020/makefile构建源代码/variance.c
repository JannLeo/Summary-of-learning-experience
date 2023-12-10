#include "variance.h"
//平方差向上取整
int variance_ceil(double a, double b)
{
	return (int)ceil(add(a,b) * sub(a,b));
}

//平方差向下取整
int variance_floor(double a, double b)
{
	return (int)floor(add(a,b) * sub(a,b));
}
