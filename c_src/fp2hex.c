/*
*  <fp2hex.c>
*  Author : Yosuke Ide <yosuke.ide@keio.jp>
*/

#include <stdio.h>

union double_long {
	double fpd;
	float fps;
	long intl;
};

int main(void)
{
	union double_long dl;
	double dtmp;
	float stmp;
	int mode;
	printf("double:0\n");
	printf("single:1\n");
	printf("> ");
	scanf("%d", &mode);

	if ( mode == 0 ) {
		printf("convert double precision float to hex\n");
		while (1) {
			printf("double : ");
			if ( scanf("%lf", &dtmp) == EOF) {
				break;
			}
			dl.fpd = dtmp;
			printf("hex : 0x%16lx\n", dl.intl);
		}
	} else {
		printf("convert single precision float to hex\n");
		while ( 1 ) {
			printf("single : ");
			if ( scanf("%f", &stmp) == EOF ) {
				break;
			}
			dl.fps = stmp;
			printf("hex : 0x%8lx\n", dl.intl);
		}
	}
	printf("\nExit...\n");
	return 0;
}
