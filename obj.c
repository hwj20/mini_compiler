#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"
#include "obj.h"
#include "myRegAllocation.h"

// a simple stack algorithm, but not uesed
void clear(Stack *s)
{
	s->top = 0;
};
int pop(Stack *s)
{
	return s->arr[s->top--];
};
void push(Stack *s, int val)
{
	s->arr[++s->top] = val;
};

void asm_bin(char *op, SYM *a, SYM *b, SYM *c)
{
	int reg1 = get_first_reg(b); /* Result register */
	// TODO reduce register cost
	int reg2 = get_second_reg(c, reg1); /* One more register */

	printf("	%s x%u,x%u,x%u\n", op, reg1, reg1, reg2);

	/* Delete c from the descriptors and insert a */
	clear_desc(reg1);
	insert_desc(reg1, a, MODIFIED);
}

int cmp_label_count = 0;
int func_var_count[1000], func_para_count[1000], func_var_top = 0, func_para_top = 0, now_func_num = 0;
void asm_cmp(int op, SYM *a, SYM *b, SYM *c)
{
	int reg1 = get_first_reg(b);		/* Result register */
	int reg2 = get_second_reg(c, reg1); /* One more register */

	printf("	SUB x%u,x%u,x%u\n", reg1, reg1, reg2);
	printf("	CMP x%u, 0\n", reg1);

	char tmp_label_1[100];
	char tmp_label_2[100];
	sprintf(tmp_label_1, "CMP_LABEL_%u_BEGIN", cmp_label_count);
	sprintf(tmp_label_2, "CMP_LABEL_%u_END", cmp_label_count++);

	switch (op)
	{
	case TAC_EQ:
		printf("	MOV x%u,0\n", reg1);
		printf("	BNE %s\n", tmp_label_2);
		printf("	MOV x%u,1 \n %s:\n", reg1, tmp_label_2);
		break;

	case TAC_NE:
		printf("	MOV x%u,0\n", reg1);
		printf("	BEQ %s\n", tmp_label_2);
		printf("	MOV x%u,1 \n %s:\n", reg1, tmp_label_2);
		break;

	case TAC_LT:
		printf("	MOV x%u,0\n", reg1);
		printf("	BGE %s\n", tmp_label_2);
		printf("	MOV x%u,1 \n %s:\n", reg1, tmp_label_2);
		break;

	case TAC_LE:
		printf("	MOV x%u,0\n", reg1);
		printf("	BGT %s\n", tmp_label_2);
		printf("	MOV x%u,1 \n %s:\n", reg1, tmp_label_2);
		break;

	case TAC_GT:
		printf("	MOV x%u,0\n", reg1);
		printf("	BLE %s\n", tmp_label_2);
		printf("	MOV x%u,1 \n %s:\n", reg1, tmp_label_2);
		break;

	case TAC_GE:
		printf("	MOV x%u,0\n", reg1);
		printf("	BLT %s\n", tmp_label_2);
		printf("	MOV x%u,1 \n %s:\n", reg1, tmp_label_2);
		break;
	}

	/* Delete c from the descriptors and insert a */
	clear_desc(reg1);
	insert_desc(reg1, a, MODIFIED);
}

void asm_copy(SYM *a, SYM *b)
{
	int reg1 = get_first_reg(b); /* Load b into a register */
	int reg2 = get_second_val_reg(a, reg1);
	if (a->type == SYM_ADDR)
	{
		printf("	MOV x%u, x%u\n", ARM_TMP, reg2);
		// printf("	STO (R%u), x%u\n", R_TEMP, reg1);
		printf("	STR x%u, [x%u]\n", reg1, ARM_TMP);
	}
	else
		insert_desc(reg1, a, MODIFIED); /* Indicate a is there */
}

void asm_cond(char *op, SYM *a, char *l)
{
	spill_all();

	if (a != NULL)
	{
		int r;

		for (r = ARM_GEN; r < ARM_NUM; r++) /* Is it in reg? */
		{
			if (rdesc[r].var == a)
				break;
		}

		if (r < ARM_NUM)
			printf("	CMP x%u, 0\n", r);
		else
			printf("	CMP x%u, 0\n", get_first_reg(a)); /* Load into new register */
	}

	printf("	%s %s\n", op, l);
}

void asm_return(SYM *a)
{
	if (a != NULL) /* return value */
	{
		spill_one(ARM_TMP);
		load_reg(ARM_TMP, a);
		return;
	}

	int return_offset = pop(&my_stack);
	// printf("	LDR x%u,[%s+4]\n", ARM_TMP, ARM_SP); /* return address */
	printf("	LDP x%u, x%u, [%s], %u\n", ARM_FP, ARM_LR, ARM_SP, return_offset);
	printf("	ret \n"); /* return */
}
void asm_str(SYM *s)
{
	char *t = s->name; /* The text */
	int i;

	printf("L%u:\n", s->label); /* Label for the string */
	printf("	.string \"");	/* Label for the string */

	for (i = 1; t[i + 1] != 0; i++)
	{
		if (t[i] == '\\')
		{
			switch (t[++i])
			{
			case 'n':
				printf("%c,", '\n');
				break;

			case '\"':
				printf("%c,", '\"');
				break;
			}
		}
		else
			printf("%c", t[i]);
	}

	printf("\"\n"); /* End of string */
}
void asm_static(void)
{
	int i;

	printf("STATIC:\n");
	printf("	.8byte 0");
	for (int i = 0; i < static_offset / 8; i++)
		printf(",0 ");
	printf("\n");
}

void asm_head()
{

	SYM *sl;

	printf(".section .rodata\n");
	printf("L_PRINT_INT:\n .string \"%%d\\n\" \n");

	for (sl = sym_tab_global; sl != NULL; sl = sl->next)
	{
		if (sl->type == SYM_TEXT)
			asm_str(sl);
	}
	char head[] =
		"	# head\n"
		".text\n"
		".type main, %function\n"
		".global main\n";

	puts(head);
}

void asm_lib()
{
	char lib[] =
		"\nPRINTN:\n"
		"	STP x29,x30, [sp,-16]!\n"
		"	ADD x29,sp,16\n"
		"	LDR w1, [x29,8]\n"
		"	ADR x0, L_PRINT_INT\n"
		"	bl printf\n"
		"	LDP x29,x30, [sp], 16\n"
		"	ret\n"
		""
		"\nPRINTS:\n"
		"	STP x29,x30, [sp,-16]!\n"
		"	ADD x29,sp,16\n"
		"	LDR x0,[x29,8]\n"
		"	bl printf\n"
		"	LDP x29,x30, [sp], 16\n"
		"	ret\n"
		""

		"\n"
		"EXIT:\n"
		"	ret\n";

	puts(lib);
}

int call_label_count = 0;
void asm_code(TAC *c)
{
	int r;
	int saved_para;

	switch (c->op)
	{
	case TAC_UNDEF:
		error("cannot translate TAC_UNDEF");
		return;

	case TAC_ADD:
		asm_bin("ADD", c->a, c->b, c->c);
		return;

	case TAC_SUB:
		asm_bin("SUB", c->a, c->b, c->c);
		return;

	case TAC_MUL:
		asm_bin("MUL", c->a, c->b, c->c);
		return;

	case TAC_DIV:
		asm_bin("DIV", c->a, c->b, c->c);
		return;

	case TAC_NEG:
		asm_bin("SUB", c->a, mk_const(0), c->b);
		return;

	case TAC_EQ:
	case TAC_NE:
	case TAC_LT:
	case TAC_LE:
	case TAC_GT:
	case TAC_GE:
		asm_cmp(c->op, c->a, c->b, c->c);
		return;

	case TAC_COPY:
		asm_copy(c->a, c->b);
		return;

	case TAC_GOTO:
		// printf("spill all\n");
		spill_all();
		asm_cond("B", NULL, c->a->name);
		return;

	case TAC_IFZ:
		asm_cond("BEQ", c->b, c->a->name);
		return;

	case TAC_LABEL:
		flush_all();
		printf("%s:\n", c->a->name);
		return;

	case TAC_ACTUAL:
		r = get_first_reg(c->a);
		// printf("	MOV x%u, %s\n",ARM_TMP, ARM_SP);

		para_offset += 8;
		printf("	STR x%u, [%s,-%d]\n", r, ARM_SP, para_offset);
		// printf("%d\n", para_offset);
		return;
	case TAC_ACTUAL_ADDR:
		para_offset += 8;
		printf("	ADD x%u, x%u,%d\n", ARM_TMP, ARM_FP, -c->a->offset);
		printf("	STR x%u, [%s,-%d]\n", ARM_TMP, ARM_SP, para_offset);
		return;

	case TAC_CALL:
		flush_all();
		// char call_label[100];
		// sprintf(call_label, "CALL_LABEL_%u", call_label_count++);
		// oon += 4;
		// printf("	MOV x%u,%s,32\n", ARM_TMP, ARM_PC); /* return addr: 4*8=32 */
		// printf("	STO (R2+%d),R4\n", tof + oon); /* store return addr */
		// printf("	STO x%u, [%s+%d]\n", ARM_TMP, ARM_SP, tof + oon); /* store return addr */
		// oon += 4;
		printf("	SUB %s,%s,%d\n", ARM_SP, ARM_SP, para_offset + (para_offset % 16)); /* load new bp */
		printf("	BL %s\n", (char *)c->b);											/* jump to new func */
		printf("	ADD %s,%s,%d\n", ARM_SP, ARM_SP, para_offset + (para_offset % 16)); /* load new bp */
		// printf("%s\n", call_label);
		// push(my_stack, call_label);
		if (c->a != NULL)
			insert_desc(ARM_TMP, c->a, MODIFIED);
		para_offset = 0;

		return;

	case TAC_BEGINFUNC:
		/* We reset the top of stack, since it is currently empty apart from the link information. */
		scope_local = 1;
		before_frame = (func_para_count[++now_func_num] % 2) * 8;
		frame_top = 0;
		local_offset = 0;
		int scope_offset = func_var_count[now_func_num] * 8 + 16; // the space for var and fp, return addr
		scope_offset += (scope_offset % 16);					  // align to 16
		push(&my_stack, scope_offset);
		printf("	STP x%u, x%u, [%s, -%d]!\n", ARM_FP, ARM_LR, ARM_SP, scope_offset);
		printf("	ADD x%u, %s, %d\n", ARM_FP, ARM_SP, scope_offset); // change FP as the top frame addr

		return;

	case TAC_FORMAL:
		c->a->store = 1; /* parameter is special local var */
		c->a->offset = -before_frame;
		before_frame += 8;
		return;

	case TAC_FORMAL_ADDR:
		c->a->store = 1; /* parameter is special local var */
		c->a->offset = -before_frame;
		c->a->type = SYM_ADDR;
		before_frame += 8;
		return;

	case TAC_VAR:
		// if (c->a->name[0] == '_' && c->a->name[1] == 't')
		// {
		// 	return;
		// }
		if (scope_local)
		{
			c->a->store = 1; /* local var */
			c->a->offset = local_offset;
			local_offset += 8;
		}
		else
		{
			c->a->store = 0; /* global var */
			c->a->offset = static_offset;
			static_offset += 8;
		}
		return;

	case TAC_RETURN:
		flush_all();
		asm_return(c->a);
		return;

	case TAC_ENDFUNC:
		asm_return(NULL);
		scope_local = 0;
		return;

	default:
		/* Don't know what this one is */
		error("unknown TAC opcode to translate");
		return;
	}
}

void asm_pre(TAC *c)
{
	switch (c->op)
	{
	case TAC_BEGINFUNC /* constant-expression */:
		/* code */
		func_var_count[++func_var_top] = 0;
		func_para_count[++func_para_top] = 0;
		break;
	case TAC_VAR:
		// if (c->a->name[0] == '_' && c->a->name[1] == 't')
		// {
		// 	return;
		// }
		func_var_count[func_var_top]++;
		break;
	case TAC_FORMAL_ADDR:
	case TAC_FORMAL:
		func_para_count[func_para_top]++;
		break;
	default:
		break;
	}
}

void tac_obj()
{
	para_offset = 0;
	frame_top = 0;
	before_frame = 0;
	local_offset = 0;
	static_offset = 8;
	call_label_count = 0;
	cmp_label_count = 0;
	clear(&my_stack);

	int r;
	for (r = 0; r < ARM_NUM; r++)
		rdesc[r].var = NULL;				 // define register desc
	insert_desc(0, mk_const(0), UNMODIFIED); /* R0 holds 0 */

	asm_head();

	TAC *cur;
	// preprocess the var in  func
	for (cur = tac_first; cur != NULL; cur = cur->next)
	{
		asm_pre(cur);
	}
	for (cur = tac_first; cur != NULL; cur = cur->next)
	{
		printf("\n	# ");
		tac_print(cur);
		printf("\n");
		asm_code(cur);
	}
	asm_lib();
	printf(".section .data\n");
	asm_static();
}
