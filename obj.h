
/* register */
#define R_UNDEF -1
#define R_FLAG 0
#define R_IP 1
#define R_BP 2
#define R_JP 3
#define R_TP 4 // return value
#define R_TEMP 5
#define R_GEN 6
#define R_NUM 16

/* frame */
#define FORMAL_OFF -4 /* first formal parameter */
#define OBP_OFF 0	  /* dynamic chain */
#define RET_OFF 4	  /* ret address */
#define LOCAL_OFF 8	  /* local var */

#define MODIFIED 1
#define UNMODIFIED 0

#define ARM_PC "PC"
#define ARM_SP "sp"
#define ARM_LR 30
#define ARM_FP 29
#define ARM_TMP 0 // TODO bad for efficiency or lead to some bugs
#define ARM_GEN 1
#define ARM_NUM 29

struct rdesc /* Reg descriptor */
{
	struct sym *var; /* Variable in reg */
	int modified;	 /* If needs spilling */
} rdesc[32];

typedef struct Stack
{
	int top;
	int arr[100];
} Stack;

int para_offset;   // for actual tac
int frame_top;	   // top of frame
int before_frame;  // for formal tac
int local_offset;  // for local var
int static_offset; // for static var

Stack my_stack;

void tac_obj();
