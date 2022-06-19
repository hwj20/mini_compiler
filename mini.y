%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"
#include "obj.h"

int yylex();
void yyerror(char* msg);

%}

%union
{
	char character;
	char *string;
	SYM *sym;
	TAC *tac;
	EXP	*exp;
}

%token INT EQ NE LT LE GT GE UMINUS IF THEN ELSE FI WHILE DO DONE CONTINUE FUNC PRINT RETURN
%token <string> INTEGER IDENTIFIER TEXT
%token SELFADD SELFSUB GOTO


%left EQ NE LT LE GT GE
%left '+' '-'
%left '*' '/'
%right UMINUS

%type <tac> program function_declaration_list function_declaration function parameter_list variable_list statement assignment_statement print_statement print_list print_item return_statement null_statement if_statement while_statement call_statement block declaration statement_list error  
%type <exp> argument_list expression_list expression call_expression 
%type <sym> function_head
%type <tac> label_statement goto_statement self_statement


%%

program : function_declaration_list
{
	tac_last=$1;
	tac_complete();
}
;

function_declaration_list : function_declaration
| function_declaration_list function_declaration
{
	$$=join_tac($1, $2);
}
;

function_declaration : function
| declaration
;

declaration : INT variable_list ';'
{
	$$=$2;
}
;

variable_list : IDENTIFIER
{
	$$=declare_var($1);
}               
| variable_list ',' IDENTIFIER
{
	$$=join_tac($1, declare_var($3));
}               
;

function : function_head '(' parameter_list ')' block
{
	$$=do_func($1, $3, $5);
	scope_local=0; /* Leave local scope. */
	sym_tab_local=NULL; /* Clear local symbol table. */
	check_label(label_tab);
}
| error
{
	error("Bad function syntax");
	$$=NULL;
}
;

function_head : IDENTIFIER
{
	$$=declare_func($1);
	scope_local=1; /* Enter local scope. */
	sym_tab_local=NULL; /* Init local symbol table. */
}
;

parameter_list : '&' IDENTIFIER
{
	$$=declare_addr_para($2);
}
| IDENTIFIER
{
	$$=declare_para($1);
}               
| parameter_list ',' '&' IDENTIFIER
{
	$$=join_tac($1, declare_addr_para($4));
}               

| parameter_list ',' IDENTIFIER
{
	$$=join_tac($1, declare_para($3));
}               
|
{
	$$=NULL;
}
;

statement : assignment_statement ';'
| call_statement ';'
| return_statement ';'
| print_statement ';'
| null_statement ';'
| self_statement ';'
| goto_statement ';'
| label_statement ':'
| if_statement
| while_statement
| declaration
| block
| error
{
	error("Bad statement syntax");
	$$=NULL;
}
;

self_statement : IDENTIFIER SELFADD{
	EXP *t1=mk_exp(NULL, get_var($1), NULL);
	EXP *t2=mk_exp(NULL, mk_const(1), NULL);
	EXP *t3 = do_bin(TAC_ADD,t1,t2);
	$$ = do_assign(get_var($1),t3);
}
|IDENTIFIER SELFSUB{
	EXP *t1=mk_exp(NULL, get_var($1), NULL);
	EXP *t2=mk_exp(NULL, mk_const(1), NULL);
	EXP *t3 = do_bin(TAC_SUB,t1,t2);
	$$ = do_assign(get_var($1),t3);
}
|SELFADD IDENTIFIER {
	EXP *t1=mk_exp(NULL, get_var($2), NULL);
	EXP *t2=mk_exp(NULL, mk_const(1), NULL);
	EXP *t3 = do_bin(TAC_ADD,t1,t2);
	$$ = do_assign(get_var($2),t3);
}
|SELFSUB IDENTIFIER {
	EXP *t1=mk_exp(NULL, get_var($2), NULL);
	EXP *t2=mk_exp(NULL, mk_const(1), NULL);
	EXP *t3 = do_bin(TAC_SUB,t1,t2);
	$$ = do_assign(get_var($2),t3);
}
;

block : '{' statement_list '}'
{
	$$=$2;
}               
;

statement_list : statement
| statement_list statement
{
	$$=join_tac($1, $2);
}               
;

assignment_statement : IDENTIFIER '=' expression
{
	$$=do_assign(get_var($1), $3);
	tmp_init();                ////////////////////////////////////////////////////////////////////////
}
;

expression : expression '+' expression
{
	$$=do_bin(TAC_ADD, $1, $3);
}
| expression '-' expression
{
	$$=do_bin(TAC_SUB, $1, $3);
}
| expression '*' expression
{
	$$=do_bin(TAC_MUL, $1, $3);
}
| expression '/' expression
{
	$$=do_bin(TAC_DIV, $1, $3);
}
| '-' expression  %prec UMINUS
{
	$$=do_un(TAC_NEG, $2);
}
| expression EQ expression
{
	$$=do_cmp(TAC_EQ, $1, $3);
}
| expression NE expression
{
	$$=do_cmp(TAC_NE, $1, $3);
}
| expression LT expression
{
	$$=do_cmp(TAC_LT, $1, $3);
}
| expression LE expression
{
	$$=do_cmp(TAC_LE, $1, $3);
}
| expression GT expression
{
	$$=do_cmp(TAC_GT, $1, $3);
}
| expression GE expression
{
	$$=do_cmp(TAC_GE, $1, $3);
}
| '(' expression ')'
{
	$$=$2;
}               
| INTEGER
{
	$$=mk_exp(NULL, mk_const(atoi($1)), NULL);
}
| '&' IDENTIFIER
{
	$$=mk_exp(NULL, get_var($2), NULL);
	$$->convey_addr = true;
}
| IDENTIFIER
{
	$$=mk_exp(NULL, get_var($1), NULL);
}
|IDENTIFIER SELFADD{
	SYM *tmp;
	TAC *u1;
	if(next_tmp > tmp_max){
		tmp = mk_tmp();
		u1 = mk_tac(TAC_VAR,tmp,NULL,NULL);
	}else{
		tmp = mk_tmp();
		u1 = NULL;
	}
	EXP *u2 = mk_exp(NULL,get_var($1),NULL);
	TAC *u3 = do_assign(tmp,u2);
	u3 = join_tac(u1,u3);
	EXP *t1 = mk_exp(NULL, get_var($1), NULL);
	EXP *t2 = mk_exp(NULL, mk_const(1), NULL);
	EXP *t3 = do_bin(TAC_ADD,t1,t2);
	TAC *t4 = do_assign(get_var($1),t3);
	t4 = join_tac(u3,t4);
	$$ = mk_exp(NULL,tmp,t4);
}
|IDENTIFIER SELFSUB{
	SYM *tmp;
	TAC *u1;
	if(next_tmp > tmp_max){
		tmp = mk_tmp();
		u1 = mk_tac(TAC_VAR,tmp,NULL,NULL);
	}else{
		tmp = mk_tmp();
		u1 = NULL;
	}
	EXP *u2 = mk_exp(NULL,get_var($1),NULL);
	TAC *u3 = do_assign(tmp,u2);
	u3 = join_tac(u1,u3);
	EXP *t1 = mk_exp(NULL, get_var($1), NULL);
	EXP *t2 = mk_exp(NULL, mk_const(1), NULL);
	EXP *t3 = do_bin(TAC_SUB,t1,t2);
	TAC *t4 = do_assign(get_var($1),t3);
	t4 = join_tac(u3,t4);
	$$ = mk_exp(NULL,tmp,t4);
}
|SELFADD IDENTIFIER {
	EXP *t1 = mk_exp(NULL, get_var($2), NULL);
	EXP *t2 = mk_exp(NULL, mk_const(1), NULL);
	EXP *t3 = do_bin(TAC_ADD,t1,t2);
	TAC *t4 = do_assign(get_var($2),t3);
	$$ = mk_exp(NULL,t4->a,t4);
}
|SELFSUB IDENTIFIER {
	EXP *t1 = mk_exp(NULL, get_var($2), NULL);
	EXP *t2 = mk_exp(NULL, mk_const(1), NULL);
	EXP *t3 = do_bin(TAC_SUB	,t1,t2);
	TAC *t4 = do_assign(get_var($2),t3);
	$$ = mk_exp(NULL,t4->a,t4);
}
| call_expression
{
	$$=$1;
}               
| error
{
	error("Bad expression syntax");
	$$=mk_exp(NULL, NULL, NULL);
}
;

argument_list           :
{
	$$=NULL;
}
| expression_list
;

expression_list : expression
{
	tmp_init(); ////////////////////////////////////////////
}
|  expression_list ',' expression
{
	tmp_init(); /////////////////////////////////////////////////
	$3->next=$1;
	$$=$3;
}
;

print_statement : PRINT '(' print_list ')'
{
	$$=$3;
}               
;

print_list : print_item
| print_list ',' print_item
{
	$$=join_tac($1, $3);
}               
;

print_item : expression
{
	$$=join_tac($1->tac,
	do_lib("PRINTN", $1->ret));
	tmp_init();  ////////////////////////////////////////////////
}
| TEXT
{
	$$=do_lib("PRINTS", mk_text($1));
}
;

return_statement : RETURN expression
{
	TAC *t=mk_tac(TAC_RETURN, $2->ret, NULL, NULL);
	t->prev=$2->tac;
	$$=t;
	tmp_init();/////////////////////////////////////////////////
}               
;

null_statement : CONTINUE
{
	$$=NULL;
}               
;

label_statement : IDENTIFIER
{
	SYM* t = lookup_sym(label_tab,$1);
	if(t == NULL){
		t = mk_label($1);
		insert_sym(&label_tab,t);
		$$ = mk_tac(TAC_LABEL, t, NULL, NULL);
	}else if(t->type == TAC_UD_LABEL){
		t->type = TAC_LABEL;
		$$ = mk_tac(TAC_LABEL, t, NULL, NULL);
	}else{
		error("the label has already been declared!");
	}
}
;

goto_statement : GOTO IDENTIFIER
{
	SYM* t = lookup_sym(label_tab,$2);
	if(t == NULL) {
		t = mk_label($2);
		t->type = TAC_UD_LABEL;
		insert_sym(&label_tab,t);
	}
	$$ = do_goto(t);
}
;

if_statement : IF '(' expression ')' block
{
	$$=do_if($3, $5);
	tmp_init();/////////////////////////////////////////////////
}
| IF '(' expression ')' block ELSE block
{
	$$=do_test($3, $5, $7);
	tmp_init();/////////////////////////////////////////////////
}
;

while_statement : WHILE '(' expression ')' block
{
	$$=do_while($3, $5);
	tmp_init();/////////////////////////////////////////////////
}               
;

call_statement : IDENTIFIER '(' argument_list ')'
{
	$$=do_call($1, $3);
}
;

call_expression : IDENTIFIER '(' argument_list ')'
{
	$$=do_call_ret($1, $3);
}
;

%%

void yyerror(char* msg) 
{
	fprintf(stderr, "%s: line %d\n", msg, yylineno);
	exit(0);
}

int main(int argc,   char *argv[])
{
	if(argc != 2)
	{
		printf("usage: %s filename\n", argv[0]);
		exit(0);
	}
	
	char *input, *output;

	input = argv[1];
	if(freopen(input, "r", stdin)==NULL)
	{
		printf("error: open %s failed\n", input);
		return 0;
	}

	output=(char *)malloc(strlen(input)+10);
	strcpy(output,input);
	strcat(output,".s");

	if(freopen(output, "w", stdout)==NULL)
	{
		printf("error: open %s failed\n", output);
		return 0;
	}

	tac_init();

	yyparse();

	tac_obj();

	return 0;
}
