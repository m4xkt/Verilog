.text
.globl _start
.globl _finish

_start:
    li x5, 11 #задаём переменную
    li x7, 0
    addi x7, x5, 9 #результат работы блока addi с входными x5 и x7
    nop
    li x11, 0
    mv x11, x7 #пишем результат x7 в переменную x11

_finish:
    j _finish #бесконечный цикл
    nop
