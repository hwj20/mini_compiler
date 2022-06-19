/* type of symbol */
#define SYM_UNDEF 0
#define SYM_VAR 1
#define SYM_FUNC 2
#define SYM_TEXT 3
#define SYM_INT 4
#define SYM_LABEL 5
#define SYM_ADDR 6

/* type of tac */
#define TAC_UNDEF 0		   /* undefine */
#define TAC_ADD 1		   /* a=b+c */
#define TAC_SUB 2		   /* a=b-c */
#define TAC_MUL 3		   /* a=b*c */
#define TAC_DIV 4		   /* a=b/c */
#define TAC_EQ 5		   /* a=(b==c) */
#define TAC_NE 6		   /* a=(b!=c) */
#define TAC_LT 7		   /* a=(b<c) */
#define TAC_LE 8		   /* a=(b<=c) */
#define TAC_GT 9		   /* a=(b>c) */
#define TAC_GE 10		   /* a=(b>=c) */
#define TAC_NEG 11		   /* a=-b */
#define TAC_COPY 12		   /* a=b */
#define TAC_GOTO 13		   /* goto a */
#define TAC_IFZ 14		   /* ifz b goto a */
#define TAC_BEGINFUNC 15   /* function begin */
#define TAC_ENDFUNC 16	   /* function end */
#define TAC_LABEL 17	   /* label a */
#define TAC_VAR 18		   /* int a */
#define TAC_FORMAL 19	   /* formal a */
#define TAC_ACTUAL 20	   /* actual a */
#define TAC_CALL 21		   /* a=call b */
#define TAC_RETURN 22	   /* return a */
#define TAC_ACTUAL_ADDR 23 /* formal_addr a */
#define TAC_FORMAL_ADDR 24 /* formal_addr a */
#include "stdbool.h"

/* struct */
typedef struct sym
{
	/*
		type:SYM_VAR name:abc value:98 offset:-1
		type:SYM_VAR name:bcd value:99 offset:4
		type:SYM_LABEL name:L1/max
		type:SYM_INT value:1
		type:SYM_FUNC name:max address:1234
		type:SYM_TEXT name:"hello" label:10
	*/
	int type;
	int store; /* 0:global, 1:local */
	char *name;
	int offset;
	int value;
	int label;
	bool convey_addr;
	struct tac *address; /* SYM_FUNC */
	struct sym *next;
} SYM;

typedef struct tac /* TAC instruction node */
{
	struct tac *next; /* Next instruction */
	struct tac *prev; /* Previous instruction */
	int op;			  /* TAC instruction */
	SYM *a;
	SYM *b;
	SYM *c;
} TAC;

typedef struct exp /* Parser expression */
{
	struct exp *next; /* For argument lists */
	TAC *tac;		  /* The code */
	SYM *ret;		  /* Where the result is */
	bool convey_addr;
} EXP;

/* global var */
int yylineno, scope_local, next_tmp,tmp_max,next_label;  //tmp_max : the count of _t that is already defined
SYM *sym_tab_global, *sym_tab_local;
TAC *tac_first, *tac_last;

/* function */
void tmp_init();
void tac_init();
void tac_complete();
void tac_dump();
void tac_print(TAC *i);
SYM *mk_const(int n);
SYM *mk_text(char *text);
SYM *mk_addr(int addr);
TAC *mk_tac(int op, SYM *a, SYM *b, SYM *c);
EXP *mk_exp(EXP *next, SYM *ret, TAC *code);
TAC *join_tac(TAC *c1, TAC *c2);
SYM *get_var(char *name);
SYM *declare_func(char *name);
TAC *declare_var(char *name);
TAC *declare_para(char *name);
TAC *do_func(SYM *name, TAC *args, TAC *code);
TAC *do_assign(SYM *var, EXP *exp);
TAC *do_call(char *name, EXP *arglist);
TAC *do_lib(char *name, SYM *arg);
TAC *do_if(EXP *exp, TAC *stmt);
TAC *do_test(EXP *exp, TAC *stmt1, TAC *stmt2);
TAC *do_while(EXP *exp, TAC *stmt);
EXP *do_bin(int binop, EXP *exp1, EXP *exp2);
EXP *do_cmp(int binop, EXP *exp1, EXP *exp2);
EXP *do_un(int unop, EXP *exp);
EXP *do_call_ret(char *name, EXP *arglist);
void error(char *str);
TAC *declare_addr_para(char *name);
