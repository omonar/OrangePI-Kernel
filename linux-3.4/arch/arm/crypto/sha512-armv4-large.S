#define __ARM_ARCH__ __LINUX_ARM_ARCH__
@ ====================================================================
@ Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
@ project. The module is, however, dual licensed under OpenSSL and
@ CRYPTOGAMS licenses depending on where you obtain it. For further
@ details see http://www.openssl.org/~appro/cryptogams/.
@ ====================================================================

@ SHA512 block procedure for ARMv4. September 2007.

@ This code is ~4.5 (four and a half) times faster than code generated
@ by gcc 3.4 and it spends ~72 clock cycles per byte [on single-issue
@ Xscale PXA250 core].
@
@ July 2010.
@
@ Rescheduling for dual-issue pipeline resulted in 6% improvement on
@ Cortex A8 core and ~40 cycles per processed byte.

@ February 2011.
@
@ Profiler-assisted and platform-specific optimization resulted in 7%
@ improvement on Coxtex A8 core and ~38 cycles per byte.


@ Byte order [in]dependence. =========================================
@
@ Originally caller was expected to maintain specific *dword* order in
@ h[0-7], namely with most significant dword at *lower* address, which
@ was reflected in below two parameters as 0 and 4. Now caller is
@ expected to maintain native byte order for whole 64-bit values.
@ ====================================================================

#include <linux/linkage.h>
#include <asm/assembler.h>

#ifdef __ARMEL__
# define LO 0
# define HI 4
# define WORD64(hi0,lo0,hi1,lo1)	.word	lo0,hi0, lo1,hi1
#else
# define HI 0
# define LO 4
# define WORD64(hi0,lo0,hi1,lo1)	.word	hi0,lo0, hi1,lo1
#endif

.text

.type	K512,%object
.align	5
K512:
WORD64(0x428a2f98,0xd728ae22, 0x71374491,0x23ef65cd)
WORD64(0xb5c0fbcf,0xec4d3b2f, 0xe9b5dba5,0x8189dbbc)
WORD64(0x3956c25b,0xf348b538, 0x59f111f1,0xb605d019)
WORD64(0x923f82a4,0xaf194f9b, 0xab1c5ed5,0xda6d8118)
WORD64(0xd807aa98,0xa3030242, 0x12835b01,0x45706fbe)
WORD64(0x243185be,0x4ee4b28c, 0x550c7dc3,0xd5ffb4e2)
WORD64(0x72be5d74,0xf27b896f, 0x80deb1fe,0x3b1696b1)
WORD64(0x9bdc06a7,0x25c71235, 0xc19bf174,0xcf692694)
WORD64(0xe49b69c1,0x9ef14ad2, 0xefbe4786,0x384f25e3)
WORD64(0x0fc19dc6,0x8b8cd5b5, 0x240ca1cc,0x77ac9c65)
WORD64(0x2de92c6f,0x592b0275, 0x4a7484aa,0x6ea6e483)
WORD64(0x5cb0a9dc,0xbd41fbd4, 0x76f988da,0x831153b5)
WORD64(0x983e5152,0xee66dfab, 0xa831c66d,0x2db43210)
WORD64(0xb00327c8,0x98fb213f, 0xbf597fc7,0xbeef0ee4)
WORD64(0xc6e00bf3,0x3da88fc2, 0xd5a79147,0x930aa725)
WORD64(0x06ca6351,0xe003826f, 0x14292967,0x0a0e6e70)
WORD64(0x27b70a85,0x46d22ffc, 0x2e1b2138,0x5c26c926)
WORD64(0x4d2c6dfc,0x5ac42aed, 0x53380d13,0x9d95b3df)
WORD64(0x650a7354,0x8baf63de, 0x766a0abb,0x3c77b2a8)
WORD64(0x81c2c92e,0x47edaee6, 0x92722c85,0x1482353b)
WORD64(0xa2bfe8a1,0x4cf10364, 0xa81a664b,0xbc423001)
WORD64(0xc24b8b70,0xd0f89791, 0xc76c51a3,0x0654be30)
WORD64(0xd192e819,0xd6ef5218, 0xd6990624,0x5565a910)
WORD64(0xf40e3585,0x5771202a, 0x106aa070,0x32bbd1b8)
WORD64(0x19a4c116,0xb8d2d0c8, 0x1e376c08,0x5141ab53)
WORD64(0x2748774c,0xdf8eeb99, 0x34b0bcb5,0xe19b48a8)
WORD64(0x391c0cb3,0xc5c95a63, 0x4ed8aa4a,0xe3418acb)
WORD64(0x5b9cca4f,0x7763e373, 0x682e6ff3,0xd6b2b8a3)
WORD64(0x748f82ee,0x5defb2fc, 0x78a5636f,0x43172f60)
WORD64(0x84c87814,0xa1f0ab72, 0x8cc70208,0x1a6439ec)
WORD64(0x90befffa,0x23631e28, 0xa4506ceb,0xde82bde9)
WORD64(0xbef9a3f7,0xb2c67915, 0xc67178f2,0xe372532b)
WORD64(0xca273ece,0xea26619c, 0xd186b8c7,0x21c0c207)
WORD64(0xeada7dd6,0xcde0eb1e, 0xf57d4f7f,0xee6ed178)
WORD64(0x06f067aa,0x72176fba, 0x0a637dc5,0xa2c898a6)
WORD64(0x113f9804,0xbef90dae, 0x1b710b35,0x131c471b)
WORD64(0x28db77f5,0x23047d84, 0x32caab7b,0x40c72493)
WORD64(0x3c9ebe0a,0x15c9bebc, 0x431d67c4,0x9c100d4c)
WORD64(0x4cc5d4be,0xcb3e42b6, 0x597f299c,0xfc657e2a)
WORD64(0x5fcb6fab,0x3ad6faec, 0x6c44198c,0x4a475817)
.size	K512,.-K512

ENTRY(sha512_block_data_order)
	adr	r3,sha512_block_data_order		@ sha512_block_data_order
	add	r2,r1,r2,lsl#7			@ len to point at the end of inp
	stmdb	sp!,{r4-r12,lr}
	sub	r14,r3,#sha512_block_data_order-K512	@ K512
	sub	sp,sp,#9*8

	ldr	r7,[r0,#32+LO]
	ldr	r8,[r0,#32+HI]
	ldr	r9, [r0,#48+LO]
	ldr	r10, [r0,#48+HI]
	ldr	r11, [r0,#56+LO]
	ldr	r12, [r0,#56+HI]
.Loop:
	str	r9, [sp,#48+0]
	str	r10, [sp,#48+4]
	str	r11, [sp,#56+0]
	str	r12, [sp,#56+4]
	ldr	r5,[r0,#0+LO]
	ldr	r6,[r0,#0+HI]
	ldr	r3,[r0,#8+LO]
	ldr	r4,[r0,#8+HI]
	ldr	r9, [r0,#16+LO]
	ldr	r10, [r0,#16+HI]
	ldr	r11, [r0,#24+LO]
	ldr	r12, [r0,#24+HI]
	str	r3,[sp,#8+0]
	str	r4,[sp,#8+4]
	str	r9, [sp,#16+0]
	str	r10, [sp,#16+4]
	str	r11, [sp,#24+0]
	str	r12, [sp,#24+4]
	ldr	r3,[r0,#40+LO]
	ldr	r4,[r0,#40+HI]
	str	r3,[sp,#40+0]
	str	r4,[sp,#40+4]

.L00_15:
#ifndef CONFIG_DCACHE_WORD_ACCESS
	ldrb	r3,[r1,#7]
	ldrb	r9, [r1,#6]
	ldrb	r10, [r1,#5]
	ldrb	r11, [r1,#4]
	ldrb	r4,[r1,#3]
	ldrb	r12, [r1,#2]
	orr	r3,r3,r9,lsl#8
	ldrb	r9, [r1,#1]
	orr	r3,r3,r10,lsl#16
	ldrb	r10, [r1],#8
	orr	r3,r3,r11,lsl#24
	orr	r4,r4,r12,lsl#8
	orr	r4,r4,r9,lsl#16
	orr	r4,r4,r10,lsl#24
#else
	ldr	r3,[r1,#4]
	ldr	r4,[r1],#8
#ifdef __ARMEL__
	rev	r3,r3
	rev	r4,r4
#endif
#endif
	@ Sigma1(x)	(ROTR((x),14) ^ ROTR((x),18)  ^ ROTR((x),41))
	@ LO		lo>>14^hi<<18 ^ lo>>18^hi<<14 ^ hi>>9^lo<<23
	@ HI		hi>>14^lo<<18 ^ hi>>18^lo<<14 ^ lo>>9^hi<<23
	mov	r9,r7,lsr#14
	str	r3,[sp,#64+0]
	mov	r10,r8,lsr#14
	str	r4,[sp,#64+4]
	eor	r9,r9,r8,lsl#18
	ldr	r11,[sp,#56+0]			@ h.lo
	eor	r10,r10,r7,lsl#18
	ldr	r12,[sp,#56+4]			@ h.hi
	eor	r9,r9,r7,lsr#18
	eor	r10,r10,r8,lsr#18
	eor	r9,r9,r8,lsl#14
	eor	r10,r10,r7,lsl#14
	eor	r9,r9,r8,lsr#9
	eor	r10,r10,r7,lsr#9
	eor	r9,r9,r7,lsl#23
	eor	r10,r10,r8,lsl#23			@ Sigma1(e)
	adds	r3,r3,r9
	ldr	r9,[sp,#40+0]			@ f.lo
	adc	r4,r4,r10				@ T += Sigma1(e)
	ldr	r10,[sp,#40+4]			@ f.hi
	adds	r3,r3,r11
	ldr	r11,[sp,#48+0]			@ g.lo
	adc	r4,r4,r12				@ T += h
	ldr	r12,[sp,#48+4]			@ g.hi

	eor	r9,r9,r11
	str	r7,[sp,#32+0]
	eor	r10,r10,r12
	str	r8,[sp,#32+4]
	and	r9,r9,r7
	str	r5,[sp,#0+0]
	and	r10,r10,r8
	str	r6,[sp,#0+4]
	eor	r9,r9,r11
	ldr	r11,[r14,#LO]			@ K[i].lo
	eor	r10,r10,r12				@ Ch(e,f,g)
	ldr	r12,[r14,#HI]			@ K[i].hi

	adds	r3,r3,r9
	ldr	r7,[sp,#24+0]			@ d.lo
	adc	r4,r4,r10				@ T += Ch(e,f,g)
	ldr	r8,[sp,#24+4]			@ d.hi
	adds	r3,r3,r11
	and	r9,r11,#0xff
	adc	r4,r4,r12				@ T += K[i]
	adds	r7,r7,r3
	ldr	r11,[sp,#8+0]			@ b.lo
	adc	r8,r8,r4				@ d += T
	teq	r9,#148

	ldr	r12,[sp,#16+0]			@ c.lo
	orreq	r14,r14,#1
	@ Sigma0(x)	(ROTR((x),28) ^ ROTR((x),34) ^ ROTR((x),39))
	@ LO		lo>>28^hi<<4  ^ hi>>2^lo<<30 ^ hi>>7^lo<<25
	@ HI		hi>>28^lo<<4  ^ lo>>2^hi<<30 ^ lo>>7^hi<<25
	mov	r9,r5,lsr#28
	mov	r10,r6,lsr#28
	eor	r9,r9,r6,lsl#4
	eor	r10,r10,r5,lsl#4
	eor	r9,r9,r6,lsr#2
	eor	r10,r10,r5,lsr#2
	eor	r9,r9,r5,lsl#30
	eor	r10,r10,r6,lsl#30
	eor	r9,r9,r6,lsr#7
	eor	r10,r10,r5,lsr#7
	eor	r9,r9,r5,lsl#25
	eor	r10,r10,r6,lsl#25			@ Sigma0(a)
	adds	r3,r3,r9
	and	r9,r5,r11
	adc	r4,r4,r10				@ T += Sigma0(a)

	ldr	r10,[sp,#8+4]			@ b.hi
	orr	r5,r5,r11
	ldr	r11,[sp,#16+4]			@ c.hi
	and	r5,r5,r12
	and	r12,r6,r10
	orr	r6,r6,r10
	orr	r5,r5,r9				@ Maj(a,b,c).lo
	and	r6,r6,r11
	adds	r5,r5,r3
	orr	r6,r6,r12				@ Maj(a,b,c).hi
	sub	sp,sp,#8
	adc	r6,r6,r4				@ h += T
	tst	r14,#1
	add	r14,r14,#8
	tst	r14,#1
	beq	.L00_15
	ldr	r9,[sp,#184+0]
	ldr	r10,[sp,#184+4]
	bic	r14,r14,#1
.L16_79:
	@ sigma0(x)	(ROTR((x),1)  ^ ROTR((x),8)  ^ ((x)>>7))
	@ LO		lo>>1^hi<<31  ^ lo>>8^hi<<24 ^ lo>>7^hi<<25
	@ HI		hi>>1^lo<<31  ^ hi>>8^lo<<24 ^ hi>>7
	mov	r3,r9,lsr#1
	ldr	r11,[sp,#80+0]
	mov	r4,r10,lsr#1
	ldr	r12,[sp,#80+4]
	eor	r3,r3,r10,lsl#31
	eor	r4,r4,r9,lsl#31
	eor	r3,r3,r9,lsr#8
	eor	r4,r4,r10,lsr#8
	eor	r3,r3,r10,lsl#24
	eor	r4,r4,r9,lsl#24
	eor	r3,r3,r9,lsr#7
	eor	r4,r4,r10,lsr#7
	eor	r3,r3,r10,lsl#25

	@ sigma1(x)	(ROTR((x),19) ^ ROTR((x),61) ^ ((x)>>6))
	@ LO		lo>>19^hi<<13 ^ hi>>29^lo<<3 ^ lo>>6^hi<<26
	@ HI		hi>>19^lo<<13 ^ lo>>29^hi<<3 ^ hi>>6
	mov	r9,r11,lsr#19
	mov	r10,r12,lsr#19
	eor	r9,r9,r12,lsl#13
	eor	r10,r10,r11,lsl#13
	eor	r9,r9,r12,lsr#29
	eor	r10,r10,r11,lsr#29
	eor	r9,r9,r11,lsl#3
	eor	r10,r10,r12,lsl#3
	eor	r9,r9,r11,lsr#6
	eor	r10,r10,r12,lsr#6
	ldr	r11,[sp,#120+0]
	eor	r9,r9,r12,lsl#26

	ldr	r12,[sp,#120+4]
	adds	r3,r3,r9
	ldr	r9,[sp,#192+0]
	adc	r4,r4,r10

	ldr	r10,[sp,#192+4]
	adds	r3,r3,r11
	adc	r4,r4,r12
	adds	r3,r3,r9
	adc	r4,r4,r10
	@ Sigma1(x)	(ROTR((x),14) ^ ROTR((x),18)  ^ ROTR((x),41))
	@ LO		lo>>14^hi<<18 ^ lo>>18^hi<<14 ^ hi>>9^lo<<23
	@ HI		hi>>14^lo<<18 ^ hi>>18^lo<<14 ^ lo>>9^hi<<23
	mov	r9,r7,lsr#14
	str	r3,[sp,#64+0]
	mov	r10,r8,lsr#14
	str	r4,[sp,#64+4]
	eor	r9,r9,r8,lsl#18
	ldr	r11,[sp,#56+0]			@ h.lo
	eor	r10,r10,r7,lsl#18
	ldr	r12,[sp,#56+4]			@ h.hi
	eor	r9,r9,r7,lsr#18
	eor	r10,r10,r8,lsr#18
	eor	r9,r9,r8,lsl#14
	eor	r10,r10,r7,lsl#14
	eor	r9,r9,r8,lsr#9
	eor	r10,r10,r7,lsr#9
	eor	r9,r9,r7,lsl#23
	eor	r10,r10,r8,lsl#23			@ Sigma1(e)
	adds	r3,r3,r9
	ldr	r9,[sp,#40+0]			@ f.lo
	adc	r4,r4,r10				@ T += Sigma1(e)
	ldr	r10,[sp,#40+4]			@ f.hi
	adds	r3,r3,r11
	ldr	r11,[sp,#48+0]			@ g.lo
	adc	r4,r4,r12				@ T += h
	ldr	r12,[sp,#48+4]			@ g.hi

	eor	r9,r9,r11
	str	r7,[sp,#32+0]
	eor	r10,r10,r12
	str	r8,[sp,#32+4]
	and	r9,r9,r7
	str	r5,[sp,#0+0]
	and	r10,r10,r8
	str	r6,[sp,#0+4]
	eor	r9,r9,r11
	ldr	r11,[r14,#LO]			@ K[i].lo
	eor	r10,r10,r12				@ Ch(e,f,g)
	ldr	r12,[r14,#HI]			@ K[i].hi

	adds	r3,r3,r9
	ldr	r7,[sp,#24+0]			@ d.lo
	adc	r4,r4,r10				@ T += Ch(e,f,g)
	ldr	r8,[sp,#24+4]			@ d.hi
	adds	r3,r3,r11
	and	r9,r11,#0xff
	adc	r4,r4,r12				@ T += K[i]
	adds	r7,r7,r3
	ldr	r11,[sp,#8+0]			@ b.lo
	adc	r8,r8,r4				@ d += T
	teq	r9,#23

	ldr	r12,[sp,#16+0]			@ c.lo
	orreq	r14,r14,#1
	@ Sigma0(x)	(ROTR((x),28) ^ ROTR((x),34) ^ ROTR((x),39))
	@ LO		lo>>28^hi<<4  ^ hi>>2^lo<<30 ^ hi>>7^lo<<25
	@ HI		hi>>28^lo<<4  ^ lo>>2^hi<<30 ^ lo>>7^hi<<25
	mov	r9,r5,lsr#28
	mov	r10,r6,lsr#28
	eor	r9,r9,r6,lsl#4
	eor	r10,r10,r5,lsl#4
	eor	r9,r9,r6,lsr#2
	eor	r10,r10,r5,lsr#2
	eor	r9,r9,r5,lsl#30
	eor	r10,r10,r6,lsl#30
	eor	r9,r9,r6,lsr#7
	eor	r10,r10,r5,lsr#7
	eor	r9,r9,r5,lsl#25
	eor	r10,r10,r6,lsl#25			@ Sigma0(a)
	adds	r3,r3,r9
	and	r9,r5,r11
	adc	r4,r4,r10				@ T += Sigma0(a)

	ldr	r10,[sp,#8+4]			@ b.hi
	orr	r5,r5,r11
	ldr	r11,[sp,#16+4]			@ c.hi
	and	r5,r5,r12
	and	r12,r6,r10
	orr	r6,r6,r10
	orr	r5,r5,r9				@ Maj(a,b,c).lo
	and	r6,r6,r11
	adds	r5,r5,r3
	orr	r6,r6,r12				@ Maj(a,b,c).hi
	sub	sp,sp,#8
	adc	r6,r6,r4				@ h += T
	tst	r14,#1
	add	r14,r14,#8
	ldreq	r9,[sp,#184+0]
	ldreq	r10,[sp,#184+4]
	beq	.L16_79
	bic	r14,r14,#1

	ldr	r3,[sp,#8+0]
	ldr	r4,[sp,#8+4]
	ldr	r9, [r0,#0+LO]
	ldr	r10, [r0,#0+HI]
	ldr	r11, [r0,#8+LO]
	ldr	r12, [r0,#8+HI]
	adds	r9,r5,r9
	str	r9, [r0,#0+LO]
	adc	r10,r6,r10
	str	r10, [r0,#0+HI]
	adds	r11,r3,r11
	str	r11, [r0,#8+LO]
	adc	r12,r4,r12
	str	r12, [r0,#8+HI]

	ldr	r5,[sp,#16+0]
	ldr	r6,[sp,#16+4]
	ldr	r3,[sp,#24+0]
	ldr	r4,[sp,#24+4]
	ldr	r9, [r0,#16+LO]
	ldr	r10, [r0,#16+HI]
	ldr	r11, [r0,#24+LO]
	ldr	r12, [r0,#24+HI]
	adds	r9,r5,r9
	str	r9, [r0,#16+LO]
	adc	r10,r6,r10
	str	r10, [r0,#16+HI]
	adds	r11,r3,r11
	str	r11, [r0,#24+LO]
	adc	r12,r4,r12
	str	r12, [r0,#24+HI]

	ldr	r3,[sp,#40+0]
	ldr	r4,[sp,#40+4]
	ldr	r9, [r0,#32+LO]
	ldr	r10, [r0,#32+HI]
	ldr	r11, [r0,#40+LO]
	ldr	r12, [r0,#40+HI]
	adds	r7,r7,r9
	str	r7,[r0,#32+LO]
	adc	r8,r8,r10
	str	r8,[r0,#32+HI]
	adds	r11,r3,r11
	str	r11, [r0,#40+LO]
	adc	r12,r4,r12
	str	r12, [r0,#40+HI]

	ldr	r5,[sp,#48+0]
	ldr	r6,[sp,#48+4]
	ldr	r3,[sp,#56+0]
	ldr	r4,[sp,#56+4]
	ldr	r9, [r0,#48+LO]
	ldr	r10, [r0,#48+HI]
	ldr	r11, [r0,#56+LO]
	ldr	r12, [r0,#56+HI]
	adds	r9,r5,r9
	str	r9, [r0,#48+LO]
	adc	r10,r6,r10
	str	r10, [r0,#48+HI]
	adds	r11,r3,r11
	str	r11, [r0,#56+LO]
	adc	r12,r4,r12
	str	r12, [r0,#56+HI]

	add	sp,sp,#640
	sub	r14,r14,#640

	teq	r1,r2
	bne	.Loop

	add	sp,sp,#8*9				@ destroy frame
	ldmia	sp!,{r4-r12,pc}
ENDPROC(sha512_block_data_order)
.asciz	"SHA512 block transform for ARMv4, CRYPTOGAMS by <appro@openssl.org>"
