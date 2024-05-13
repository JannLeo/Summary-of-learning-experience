# ELEC5620M Mini-Project Repository

This is the blank repository in which you must incrementally commit your code.

- LT24驱动代码解析（201715540）
  - LT24_initData变量
    - 该变量是用于初始化LCD屏幕的，对LCD的相关寄存器进行配置，主要在LT24_initialise函数中用到。
  - LT24_initialise函数
    - 该函数参数有三个，分别分析如下：
      - cntrlBase：void* 类型，意思是控制器的基址，主要用于对LCD屏幕的配置。
      - pCtx ： PLT24Ctx_t*指针类型，该变量主要是表示的LT24的上下文指针。
      - dataBase： void*类型，该类型主要表示的是数据的基址，主要用于LCD屏幕的使用。
    - 

