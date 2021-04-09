/*
*  <hex2fp.c>
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
	int mode;
	long hex;
	printf("double -> 0\n");
	printf("single -> 1\n");
	printf("mode -> ");
	scanf("%d", &mode);

	if ( mode == 0 ) {
		printf("convert hex to double precision fp\n");
		while ( 1 ) {
			printf("hex : 0x");
			if ( scanf("%lx", &hex) == EOF ) {
				break;
			}
			dl.intl = hex;
			printf("double: [%le]\n", dl.fpd);
		}
	} else {
		printf("convert hex to single precision fp\n");
		while ( 1 ) {
			printf("hex : 0x");
			if ( scanf("%lx", &hex) == EOF ) {
				break;
			}
			dl.intl = hex;
			printf("single : [%le]\n", dl.fps);
		}
	}

	printf("\nExit...\n");
	return 0;
}
