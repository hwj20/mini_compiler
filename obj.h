/* register */
#define R_UNDEF -1
#define R_FLAG 0
#define R_IP 1
#define R_BP 2
#define R_JP 3
#define R_TP 4
#define R_SSP 5
#define R_GEN 6
#define R_NUM 16

/* frame */
#define FORMAL_OFF -4 /* first formal parameter */
#define OBP_OFF 0	  /* dynamic chain */
#define RET_OFF 4	  /* ret address */
#define LOCAL_OFF 8	  /* local var */

#define MODIFIED 1
#define UNMODIFIED 0

struct rdesc /* Reg descriptor */
{
	struct sym *var; /* Variable in reg */
	int modified;	 /* If needs spilling */
} rdesc[R_NUM];

int tos; /* top of static */
int tof; /* top of frame */
int oof; /* offset of formal */
int oon; /* offset of next frame */
int gfs;
int max_gfs;

void tac_obj();
