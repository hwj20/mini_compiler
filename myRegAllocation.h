int get_first_val_reg(SYM *c);
int get_first_reg(SYM *c);
int get_second_val_reg(SYM *b, int first_reg);
int get_second_reg(SYM *b, int first_reg);
void spill_one(int r);
void load_val_of_addr(int r);
void clear_desc(int r);
void insert_desc(int r, SYM *n, int mod);
void spill_all(void);
void flush_all(void);
void load_reg(int r, SYM *n);