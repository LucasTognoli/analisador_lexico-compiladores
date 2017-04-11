#!/bin/bash 

echo Compilando LEX
lex lex.l

echo Construindo LEX
cc lex.yy.c -ll

echo Compilando C
gcc scanner.c lex.yy.c -o scanner2

echo Rodando C
./scanner2 < "sample.pas"
