
./out/branch_predictor.out:     ファイル形式 elf32-mist32


セクション .text の逆アセンブル:

00000000 <_start>:
   0:	0d 40 00 00 	wl16	r0,0x0
   4:	0d 60 00 0f 	wh16	r0,0xf
   8:	1c 00 00 00 	srspw	r0
   c:	14 30 00 1a 	br	74 <target>,#al

00000010 <mem_print>:
  10:	0d 40 02 08 	wl16	r16,0x8
  14:	0d 60 02 02 	wh16	r16,0x2
  18:	10 a0 00 10 	st32	r0,r16
  1c:	14 40 03 e0 	b	rret,#al

00000020 <error>:
  20:	0d 40 03 20 	wl16	r25,0x0
  24:	0d 60 03 22 	wh16	r25,0x2
  28:	0e c0 03 40 	lil	r26,0
  2c:	10 a0 03 59 	st32	r26,r25
  30:	0d 40 03 30 	wl16	r25,0x10
  34:	0d 60 03 22 	wh16	r25,0x2
  38:	10 a0 03 79 	st32	r27,r25
  3c:	0d 40 03 2c 	wl16	r25,0xc
  40:	0d 60 03 22 	wh16	r25,0x2
  44:	10 a0 03 99 	st32	r28,r25
  48:	0d 40 03 34 	wl16	r25,0x14
  4c:	0d 60 03 22 	wh16	r25,0x2
  50:	10 a0 03 b9 	st32	rglobl,r25
  54:	0d 40 03 38 	wl16	r25,0x18
  58:	0d 60 03 22 	wh16	r25,0x2
  5c:	10 a0 03 d9 	st32	rbase,r25

00000060 <finish>:
  60:	0d 40 03 24 	wl16	r25,0x4
  64:	0d 60 03 22 	wh16	r25,0x2
  68:	0e c0 03 41 	lil	r26,1
  6c:	10 a0 03 59 	st32	r26,r25
  70:	14 30 00 00 	br	70 <finish+0x10>,#al

00000074 <target>:
  74:	0d c0 00 c0 	clr	r6
  78:	0d c0 00 e0 	clr	rtmp
  7c:	1a 80 00 00 	srfrcr
  80:	1a c0 00 00 	srfrchr	r0
  84:	1a a0 00 20 	srfrclr	r1
  88:	00 d0 00 e0 	cmp	rtmp,0
  8c:	14 31 00 01 	br	90 <lat0>,#eq

00000090 <lat0>:
  90:	1a 80 00 00 	srfrcr
  94:	1a c0 00 40 	srfrchr	r2
  98:	1a a0 00 60 	srfrclr	r3
  9c:	20 40 00 a3 	move	r5,r3
  a0:	00 20 00 a1 	sub	r5,r1
  a4:	0d c0 00 80 	clr	r4
  a8:	00 00 00 c5 	add	r6,r5
  ac:	1a 80 00 00 	srfrcr
  b0:	1a c0 00 00 	srfrchr	r0
  b4:	1a a0 00 20 	srfrclr	r1
  b8:	00 d0 00 e0 	cmp	rtmp,0
  bc:	14 31 00 01 	br	c0 <lat1>,#eq

000000c0 <lat1>:
  c0:	1a 80 00 00 	srfrcr
  c4:	1a c0 00 40 	srfrchr	r2
  c8:	1a a0 00 60 	srfrclr	r3
  cc:	20 40 00 a3 	move	r5,r3
  d0:	00 20 00 a1 	sub	r5,r1
  d4:	0d c0 00 80 	clr	r4
  d8:	00 00 00 c5 	add	r6,r5
  dc:	1a 80 00 00 	srfrcr
  e0:	1a c0 00 00 	srfrchr	r0
  e4:	1a a0 00 20 	srfrclr	r1
  e8:	00 d0 00 e0 	cmp	rtmp,0
  ec:	14 31 00 01 	br	f0 <lat2>,#eq

000000f0 <lat2>:
  f0:	1a 80 00 00 	srfrcr
  f4:	1a c0 00 40 	srfrchr	r2
  f8:	1a a0 00 60 	srfrclr	r3
  fc:	20 40 00 a3 	move	r5,r3
 100:	00 20 00 a1 	sub	r5,r1
 104:	0d c0 00 80 	clr	r4
 108:	00 00 00 c5 	add	r6,r5
 10c:	1a 80 00 00 	srfrcr
 110:	1a c0 00 00 	srfrchr	r0
 114:	1a a0 00 20 	srfrclr	r1
 118:	00 d0 00 e0 	cmp	rtmp,0
 11c:	14 31 00 01 	br	120 <lat3>,#eq

00000120 <lat3>:
 120:	1a 80 00 00 	srfrcr
 124:	1a c0 00 40 	srfrchr	r2
 128:	1a a0 00 60 	srfrclr	r3
 12c:	20 40 00 a3 	move	r5,r3
 130:	00 20 00 a1 	sub	r5,r1
 134:	0d c0 00 80 	clr	r4
 138:	00 00 00 c5 	add	r6,r5

0000013c <lat_average>:
 13c:	08 30 00 c2 	shr	r6,0x2
 140:	20 40 00 06 	move	r0,r6
 144:	00 10 00 02 	add	r0,2
 148:	20 40 01 60 	move	r11,r0
 14c:	0d c0 01 00 	clr	r8
 150:	0d 40 05 00 	wl16	r8,0x20
 154:	0d c0 00 00 	clr	r0
 158:	0d c0 00 20 	clr	r1

0000015c <lp0>:
 15c:	1a 80 00 00 	srfrcr
 160:	1a c0 00 40 	srfrchr	r2
 164:	1a a0 00 60 	srfrclr	r3
 168:	20 40 00 a3 	move	r5,r3
 16c:	00 20 00 a1 	sub	r5,r1
 170:	0d c0 00 80 	clr	r4
 174:	20 40 00 05 	move	r0,r5
 178:	20 70 03 e2 	movepc	rret,8
 17c:	14 30 ff a5 	br	10 <mem_print>,#al
 180:	1a 80 00 00 	srfrcr
 184:	1a c0 00 00 	srfrchr	r0
 188:	1a a0 00 20 	srfrclr	r1
 18c:	00 30 01 01 	sub	r8,1
 190:	14 38 ff f3 	br	15c <lp0>,#geu
 194:	14 30 ff b3 	br	60 <finish>,#al

セクション .assert の逆アセンブル:

00020000 <CHECK_FLAG>:
   20000:	00 00 00 01 	add	r0,r1

00020004 <CHECK_FINISH>:
   20004:	00 00 00 00 	add	r0,r0

00020008 <CHECK_LOG>:
   20008:	00 00 00 00 	add	r0,r0

0002000c <ERROR_TYPE>:
   2000c:	00 00 00 00 	add	r0,r0

00020010 <ERROR_NUMBER>:
   20010:	00 00 00 00 	add	r0,r0

00020014 <ERROR_RESULT>:
   20014:	00 00 00 00 	add	r0,r0

00020018 <ERROR_EXPECT>:
   20018:	00 00 00 00 	add	r0,r0

セクション .stack の逆アセンブル:

000f0000 <STACK_INDEX>:
   f0000:	00 00 00 00 	add	r0,r0
