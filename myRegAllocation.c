#define GET_RAND_REG 0
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"
#include "obj.h"
#include "myRegAllocation.h"

/* Get the first reg as a destination reg. */
void spill_one(int r)
{
    if ((rdesc[r].var != NULL) && rdesc[r].modified)
    {
        if (rdesc[r].var->store == 1) /* local var */
        {
            // if (rdesc[r].var->offset >= 0)
            // printf("	STO (R%u+%d),R%u\n", R_BP, rdesc[r].var->offset, r);
            printf("	STR x%u, [x%u,%d]\n", r, ARM_FP, -rdesc[r].var->offset);
            // else
            // printf("	STO (R%u%d),R%u\n", R_BP, rdesc[r].var->offset, r);
            // printf("	STR x%u, [x%u,%d]\n", r, ARM_FP, -rdesc[r].var->offset);
        }
        else /* global var */
        {
            // printf("	LOD R%u,STATIC\n", R_TP);
            // printf("	STO (R%u+%d),R%u\n", R_TP, rdesc[r].var->offset, r);
            printf("    adr x%u, STATIC\n", ARM_TMP);
            printf("    STR x%u, [x%u,%d]\n", r, ARM_TMP, rdesc[r].var->offset);
        }
        rdesc[r].modified = UNMODIFIED;
    }
}

int get_first_val_reg(SYM *c)
{
    int r;
    for (r = ARM_GEN; r < ARM_NUM; r++) /* Already in a register */
    {
        if (rdesc[r].var == c)
        {
            spill_one(r);
            return r;
        }
    }

#if GET_RAND_REG
    r = rand() % (ARM_NUM - 1 - ARM_GEN) + ARM_GEN;
    // bool isVis[ARM_NUM];
    // memset(isVis, 0, sizeof isVis);
    int used = 0;
    while (true)
    {
        if (rdesc[r].var == NULL)
        {
            load_reg(r, c);
            return r;
        }
        else if (!rdesc[r].modified)
        {
            if (!rdesc[r].modified) /* Unmodifed register */
            {
                clear_desc(r);
                load_reg(r, c);
                return r;
            }
        }
        else
        {
            used++;
            r = rand() % (ARM_NUM - 1 - ARM_GEN) + ARM_GEN;
            if (used == ARM_NUM - ARM_GEN)
            {
                break;
            }
        }
    }
#else
    for (r = ARM_GEN; r < ARM_NUM; r++)
    {
        if (rdesc[r].var == NULL) /* Empty register */
        {
            load_reg(r, c);
            return r;
        }
    }

    for (r = ARM_GEN; r < ARM_NUM; r++)
    {
        if (!rdesc[r].modified) /* Unmodifed register */
        {
            clear_desc(r);
            load_reg(r, c);
            return r;
        }
    }
#endif

    spill_one(ARM_GEN); /* Modified register */
    clear_desc(ARM_GEN);
    load_reg(ARM_GEN, c);
    return ARM_GEN;
}
int get_first_reg(SYM *c)
{
    int r = get_first_val_reg(c);
    if (c->type == SYM_ADDR)
        load_val_of_addr(r);
    return r;
}

/* Get the second reg as a source reg. Exclude the first reg. */
int get_second_val_reg(SYM *b, int first_reg)
{
    int r;
    for (r = ARM_GEN; r < ARM_NUM; r++)
    {
        if (rdesc[r].var == b) /* Already in register */
            return r;
    }
#if GET_RAND_REG
    r = rand() % (ARM_NUM - 1 - ARM_GEN) + ARM_GEN;
    // bool isVis[ARM_NUM];
    // memset(isVis, 0, sizeof isVis);
    int used = 0;
    while (true)
    {
        if (rdesc[r].var == NULL)
        {
            load_reg(r, b);
            return r;
        }
        else if (!rdesc[r].modified)
        {
            if (!rdesc[r].modified && r != first_reg) /* Unmodifed register */
            {
                clear_desc(r);
                load_reg(r, b);
                return r;
            }
        }
        else
        {
            used++;
            r = rand() % (ARM_NUM - 1 - ARM_GEN) + ARM_GEN;
            if (used == ARM_NUM - ARM_GEN)
            {
                break;
            }
        }
    }
#else

    for (r = ARM_GEN; r < ARM_NUM; r++)
    {
        if (rdesc[r].var == NULL) /* Empty register */
        {
            load_reg(r, b);
            return r;
        }
    }

    for (r = ARM_GEN; r < ARM_NUM; r++)
    {
        if (!rdesc[r].modified && (r != first_reg)) /* Unmodifed register */
        {
            clear_desc(r);
            load_reg(r, b);
            return r;
        }
    }

#endif
    for (r = ARM_GEN; r < ARM_NUM; r++)
    {
        if (r != first_reg) /* Modified register */
        {
            spill_one(r);
            clear_desc(r);
            load_reg(r, b);
            return r;
        }
    }
}
int get_second_reg(SYM *b, int first_reg)
{
    int r = get_second_val_reg(b, first_reg);
    if (b->type == SYM_ADDR)
        load_val_of_addr(r);
    return r;
}

void load_val_of_addr(int r)
{
    printf("	LDR x%u, [x%u]\n", r, r);
}

void clear_desc(int r)
{
    rdesc[r].var = NULL;
}

void insert_desc(int r, SYM *n, int mod)
{
    /* Search through each register in turn looking for "n". There should be at most one of these. */
    int or ; /* Old descriptor */
    for (or = ARM_GEN; or < ARM_NUM; or ++)
    {
        if (rdesc[or].var == n)
        {
            /* Found it, clear it and break out of the loop. */
            clear_desc(or);
            break;
        }
    }

    /* Insert "n" in the new descriptor */

    rdesc[r].var = n;
    rdesc[r].modified = mod;
}
void spill_all(void)
{
    int r;
    for (r = ARM_GEN; r < ARM_NUM; r++)
        spill_one(r);
}

void flush_all(void)
{
    int r;

    spill_all();

    for (r = ARM_GEN; r < ARM_NUM; r++)
        clear_desc(r);

    clear_desc(ARM_TMP); /* Clear result register */
}

void load_reg(int r, SYM *n)
{
    int s;

    /* Look for a register */
    for (s = 0; s < ARM_NUM; s++)
    {
        if (rdesc[s].var == n)
        {
            printf("	MOV x%u,x%u\n", r, s);
            insert_desc(r, n, rdesc[s].modified);
            return;
        }
    }

    /* Not in a reg. Load appropriately */
    switch (n->type)
    {
    case SYM_INT:
        printf("	MOV x%u,%d\n", r, n->value);
        break;

    case SYM_ADDR:
    case SYM_VAR:
        if (n->store == 1) /* local var */
        {
            // if ((n->offset) >= 0)
            printf("	LDR x%u,[x%u,%d]\n", r, ARM_FP, -n->offset);
            // else
            //     printf("	LDR x%u,[%s,-%d]\n", r, ARM_SP, -(n->offset));
        }
        else /* global var */
        {
            printf("	ADR x%u,STATIC\n", ARM_TMP);
            printf("	LDR x%u,[x%u,%d]\n", r, ARM_TMP, n->offset);
        }
        break;

    case SYM_TEXT:
        printf("	ADR x%u,L%u\n", r, n->label);
        break;
    }

    insert_desc(r, n, UNMODIFIED);
}