win_bison.exe -d .\mini.y
win_flex.exe .\mini.l
 gcc .\lex.yy.c  .\mini.tab.c .\tac.c -o test.exe