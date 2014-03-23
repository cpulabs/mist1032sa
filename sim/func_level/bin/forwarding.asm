
./out/forwarding.out:     ファイル形式 elf32-mist32


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
  74:	0d c0 00 00 	clr	r0
  78:	0d c0 00 20 	clr	r1
  7c:	0d c0 00 40 	clr	r2
  80:	0d c0 00 60 	clr	r3
  84:	0d c0 00 80 	clr	r4
  88:	0d c0 00 a0 	clr	r5
  8c:	0d c0 00 c0 	clr	r6
  90:	0d c0 00 e0 	clr	rtmp
  94:	0d c0 01 00 	clr	r8
  98:	0d c0 01 20 	clr	r9
  9c:	0d c0 01 40 	clr	r10
  a0:	0d c0 01 60 	clr	r11
  a4:	0d c0 01 80 	clr	r12
  a8:	0d c0 01 a0 	clr	r13
  ac:	0d c0 01 c0 	clr	r14
  b0:	0d c0 01 e0 	clr	r15
  b4:	0d c0 02 00 	clr	r16
  b8:	0d c0 02 20 	clr	r17
  bc:	0d c0 02 40 	clr	r18
  c0:	0d c0 02 60 	clr	r19
  c4:	0d c0 02 80 	clr	r20
  c8:	0d c0 02 a0 	clr	r21
  cc:	0d c0 02 c0 	clr	r22
  d0:	0d c0 02 e0 	clr	r23
  d4:	0d c0 03 00 	clr	r24
  d8:	0d c0 03 20 	clr	r25
  dc:	0d c0 03 40 	clr	r26
  e0:	0d c0 03 60 	clr	r27
  e4:	0d c0 03 80 	clr	r28
  e8:	0d c0 03 a0 	clr	rglobl
  ec:	0d c0 03 c0 	clr	rbase
  f0:	0d c0 03 e0 	clr	rret
  f4:	0d c0 03 c0 	clr	rbase
  f8:	0e c0 03 c1 	lil	rbase,1
  fc:	20 40 00 1e 	move	r0,rbase
 100:	00 10 00 00 	add	r0,0
 104:	00 00 00 20 	add	r1,r0
 108:	00 00 00 41 	add	r2,r1
 10c:	00 00 00 62 	add	r3,r2
 110:	00 00 00 83 	add	r4,r3
 114:	00 00 00 a4 	add	r5,r4
 118:	00 00 00 c5 	add	r6,r5
 11c:	00 00 00 e6 	add	rtmp,r6
 120:	00 00 01 07 	add	r8,rtmp
 124:	00 00 01 28 	add	r9,r8
 128:	00 00 01 49 	add	r10,r9
 12c:	00 00 01 6a 	add	r11,r10
 130:	00 00 01 8b 	add	r12,r11
 134:	00 00 01 ac 	add	r13,r12
 138:	00 00 01 cd 	add	r14,r13
 13c:	00 00 01 ee 	add	r15,r14
 140:	20 40 03 af 	move	rglobl,r15
 144:	20 70 03 e3 	movepc	rret,12
 148:	00 c0 03 be 	cmp	rglobl,rbase
 14c:	14 32 ff b5 	br	20 <error>,#ne
 150:	00 10 03 61 	add	r27,1
 154:	0d c0 00 00 	clr	r0
 158:	0d c0 00 20 	clr	r1
 15c:	0d c0 00 40 	clr	r2
 160:	0d c0 00 60 	clr	r3
 164:	0d c0 00 80 	clr	r4
 168:	0d c0 00 a0 	clr	r5
 16c:	0d c0 00 c0 	clr	r6
 170:	0d c0 00 e0 	clr	rtmp
 174:	0d c0 01 00 	clr	r8
 178:	0d c0 01 20 	clr	r9
 17c:	0d c0 01 40 	clr	r10
 180:	0d c0 01 60 	clr	r11
 184:	0d c0 01 80 	clr	r12
 188:	0d c0 01 a0 	clr	r13
 18c:	0d c0 01 c0 	clr	r14
 190:	0d c0 01 e0 	clr	r15
 194:	0d c0 03 c0 	clr	rbase
 198:	0e c0 03 d0 	lil	rbase,16
 19c:	00 10 00 01 	add	r0,1
 1a0:	20 40 00 20 	move	r1,r0
 1a4:	00 10 00 21 	add	r1,1
 1a8:	20 40 00 41 	move	r2,r1
 1ac:	00 10 00 41 	add	r2,1
 1b0:	20 40 00 62 	move	r3,r2
 1b4:	00 10 00 61 	add	r3,1
 1b8:	20 40 00 83 	move	r4,r3
 1bc:	00 10 00 81 	add	r4,1
 1c0:	20 40 00 a4 	move	r5,r4
 1c4:	00 10 00 a1 	add	r5,1
 1c8:	20 40 00 c5 	move	r6,r5
 1cc:	00 10 00 c1 	add	r6,1
 1d0:	20 40 00 e6 	move	rtmp,r6
 1d4:	00 10 00 e1 	add	rtmp,1
 1d8:	20 40 01 07 	move	r8,rtmp
 1dc:	00 10 01 01 	add	r8,1
 1e0:	20 40 01 28 	move	r9,r8
 1e4:	00 10 01 21 	add	r9,1
 1e8:	20 40 01 49 	move	r10,r9
 1ec:	00 10 01 41 	add	r10,1
 1f0:	20 40 01 6a 	move	r11,r10
 1f4:	00 10 01 61 	add	r11,1
 1f8:	20 40 01 8b 	move	r12,r11
 1fc:	00 10 01 81 	add	r12,1
 200:	20 40 01 ac 	move	r13,r12
 204:	00 10 01 a1 	add	r13,1
 208:	20 40 01 cd 	move	r14,r13
 20c:	00 10 01 c1 	add	r14,1
 210:	20 40 01 ee 	move	r15,r14
 214:	00 10 01 e1 	add	r15,1
 218:	20 40 03 af 	move	rglobl,r15
 21c:	20 70 03 e3 	movepc	rret,12
 220:	00 c0 03 be 	cmp	rglobl,rbase
 224:	14 32 ff 7f 	br	20 <error>,#ne
 228:	00 10 03 61 	add	r27,1
 22c:	0d c0 00 00 	clr	r0
 230:	0d c0 00 20 	clr	r1
 234:	0d c0 00 40 	clr	r2
 238:	0d c0 00 60 	clr	r3
 23c:	0d c0 00 80 	clr	r4
 240:	0d c0 00 a0 	clr	r5
 244:	0d c0 00 c0 	clr	r6
 248:	0d c0 00 e0 	clr	rtmp
 24c:	0d c0 01 00 	clr	r8
 250:	0d c0 01 20 	clr	r9
 254:	0d c0 01 40 	clr	r10
 258:	0d c0 01 60 	clr	r11
 25c:	0d c0 01 80 	clr	r12
 260:	0d c0 01 a0 	clr	r13
 264:	0d c0 01 c0 	clr	r14
 268:	0d c0 01 e0 	clr	r15
 26c:	0d c0 03 60 	clr	r27
 270:	0d c0 03 80 	clr	r28
 274:	0e c0 03 81 	lil	r28,1
 278:	18 00 00 00 	srspr	r0
 27c:	20 00 00 00 	nop
 280:	20 00 00 00 	nop
 284:	20 00 00 00 	nop
 288:	20 00 00 00 	nop
 28c:	20 00 00 00 	nop
 290:	20 00 00 00 	nop
 294:	20 00 00 00 	nop
 298:	20 00 00 00 	nop
 29c:	20 40 03 c0 	move	rbase,r0
 2a0:	00 30 03 c4 	sub	rbase,4
 2a4:	18 00 03 a0 	srspr	rglobl
 2a8:	00 30 03 a4 	sub	rglobl,4
 2ac:	20 70 03 e3 	movepc	rret,12
 2b0:	00 c0 03 be 	cmp	rglobl,rbase
 2b4:	14 32 ff 5b 	br	20 <error>,#ne
 2b8:	00 10 03 61 	add	r27,1
 2bc:	18 00 00 00 	srspr	r0
 2c0:	20 40 03 c0 	move	rbase,r0
 2c4:	20 00 00 00 	nop
 2c8:	20 00 00 00 	nop
 2cc:	20 00 00 00 	nop
 2d0:	20 00 00 00 	nop
 2d4:	20 00 00 00 	nop
 2d8:	20 00 00 00 	nop
 2dc:	20 00 00 00 	nop
 2e0:	20 00 00 00 	nop
 2e4:	1c 00 03 c0 	srspw	rbase
 2e8:	18 00 03 c0 	srspr	rbase
 2ec:	20 40 03 a0 	move	rglobl,r0
 2f0:	00 30 07 a0 	sub	rglobl,32
 2f4:	1c 00 03 a0 	srspw	rglobl
 2f8:	18 00 03 a0 	srspr	rglobl
 2fc:	00 10 07 a0 	add	rglobl,32
 300:	20 70 03 e3 	movepc	rret,12
 304:	00 c0 03 be 	cmp	rglobl,rbase
 308:	14 32 ff 46 	br	20 <error>,#ne
 30c:	00 10 03 61 	add	r27,1
 310:	0d c0 00 00 	clr	r0
 314:	0d c0 00 20 	clr	r1
 318:	0d c0 00 40 	clr	r2
 31c:	0d c0 00 60 	clr	r3
 320:	0d c0 00 80 	clr	r4
 324:	0d c0 00 a0 	clr	r5
 328:	0d c0 00 c0 	clr	r6
 32c:	0d c0 00 e0 	clr	rtmp
 330:	0d c0 01 00 	clr	r8
 334:	0d c0 01 20 	clr	r9
 338:	0d c0 01 40 	clr	r10
 33c:	0d c0 01 60 	clr	r11
 340:	0d c0 01 80 	clr	r12
 344:	0d c0 01 a0 	clr	r13
 348:	0d c0 01 c0 	clr	r14
 34c:	0d c0 01 e0 	clr	r15
 350:	0d c0 03 a0 	clr	rglobl
 354:	0d c0 03 c0 	clr	rbase
 358:	18 00 00 00 	srspr	r0
 35c:	20 40 00 20 	move	r1,r0
 360:	00 30 00 30 	sub	r1,16
 364:	1c 00 00 20 	srspw	r1
 368:	20 00 00 00 	nop
 36c:	20 00 00 00 	nop
 370:	20 00 00 00 	nop
 374:	20 00 00 00 	nop
 378:	20 00 00 00 	nop
 37c:	20 00 00 00 	nop
 380:	20 00 00 00 	nop
 384:	20 00 00 00 	nop
 388:	18 00 03 c0 	srspr	rbase
 38c:	1c 00 00 00 	srspw	r0
 390:	20 00 00 00 	nop
 394:	20 00 00 00 	nop
 398:	20 00 00 00 	nop
 39c:	20 00 00 00 	nop
 3a0:	20 00 00 00 	nop
 3a4:	20 00 00 00 	nop
 3a8:	20 00 00 00 	nop
 3ac:	20 00 00 00 	nop
 3b0:	20 40 00 20 	move	r1,r0
 3b4:	00 30 04 20 	sub	r1,32
 3b8:	1c 00 00 20 	srspw	r1
 3bc:	18 00 03 a0 	srspr	rglobl
 3c0:	00 10 03 b0 	add	rglobl,16
 3c4:	20 70 03 e3 	movepc	rret,12
 3c8:	00 c0 03 be 	cmp	rglobl,rbase
 3cc:	14 32 ff 15 	br	20 <error>,#ne
 3d0:	00 10 03 61 	add	r27,1
 3d4:	0d c0 00 00 	clr	r0
 3d8:	0d c0 00 20 	clr	r1
 3dc:	0d c0 00 40 	clr	r2
 3e0:	0d c0 00 60 	clr	r3
 3e4:	0d c0 00 80 	clr	r4
 3e8:	0d c0 00 a0 	clr	r5
 3ec:	0d c0 00 c0 	clr	r6
 3f0:	0d c0 00 e0 	clr	rtmp
 3f4:	0d c0 01 00 	clr	r8
 3f8:	0d c0 01 20 	clr	r9
 3fc:	0d c0 01 40 	clr	r10
 400:	0d c0 01 60 	clr	r11
 404:	0d c0 01 80 	clr	r12
 408:	0d c0 01 a0 	clr	r13
 40c:	0d c0 01 c0 	clr	r14
 410:	0d c0 01 e0 	clr	r15
 414:	18 00 03 c0 	srspr	rbase
 418:	11 00 03 c0 	push	rbase
 41c:	11 00 03 c0 	push	rbase
 420:	11 00 03 c0 	push	rbase
 424:	11 00 03 c0 	push	rbase
 428:	00 30 03 d0 	sub	rbase,16
 42c:	18 00 03 a0 	srspr	rglobl
 430:	20 70 03 e3 	movepc	rret,12
 434:	00 c0 03 be 	cmp	rglobl,rbase
 438:	14 32 fe fa 	br	20 <error>,#ne
 43c:	00 10 03 61 	add	r27,1
 440:	0d c0 00 00 	clr	r0
 444:	0d c0 00 20 	clr	r1
 448:	0d c0 00 40 	clr	r2
 44c:	0d c0 00 60 	clr	r3
 450:	0d c0 00 80 	clr	r4
 454:	0d c0 00 a0 	clr	r5
 458:	0d c0 00 c0 	clr	r6
 45c:	0d c0 00 e0 	clr	rtmp
 460:	0d c0 01 00 	clr	r8
 464:	0d c0 01 20 	clr	r9
 468:	0d c0 01 40 	clr	r10
 46c:	0d c0 01 60 	clr	r11
 470:	0d c0 01 80 	clr	r12
 474:	0d c0 01 a0 	clr	r13
 478:	0d c0 01 c0 	clr	r14
 47c:	0d c0 01 e0 	clr	r15
 480:	18 00 03 c0 	srspr	rbase
 484:	12 00 01 e0 	pop	r15
 488:	12 00 01 e0 	pop	r15
 48c:	12 00 01 e0 	pop	r15
 490:	12 00 01 e0 	pop	r15
 494:	00 10 03 d0 	add	rbase,16
 498:	18 00 03 a0 	srspr	rglobl
 49c:	20 70 03 e3 	movepc	rret,12
 4a0:	00 c0 03 be 	cmp	rglobl,rbase
 4a4:	14 32 fe df 	br	20 <error>,#ne
 4a8:	00 10 03 61 	add	r27,1
 4ac:	0d c0 00 00 	clr	r0
 4b0:	0d c0 00 20 	clr	r1
 4b4:	0d c0 00 40 	clr	r2
 4b8:	0d c0 00 60 	clr	r3
 4bc:	0d c0 00 80 	clr	r4
 4c0:	0d c0 00 a0 	clr	r5
 4c4:	0d c0 00 c0 	clr	r6
 4c8:	0d c0 00 e0 	clr	rtmp
 4cc:	0d c0 01 00 	clr	r8
 4d0:	0d c0 01 20 	clr	r9
 4d4:	0d c0 01 40 	clr	r10
 4d8:	0d c0 01 60 	clr	r11
 4dc:	0d c0 01 80 	clr	r12
 4e0:	0d c0 01 a0 	clr	r13
 4e4:	0d c0 01 c0 	clr	r14
 4e8:	0d c0 01 e0 	clr	r15
 4ec:	18 00 03 c0 	srspr	rbase
 4f0:	11 00 03 c0 	push	rbase
 4f4:	12 00 03 c0 	pop	rbase
 4f8:	11 00 03 c0 	push	rbase
 4fc:	12 00 03 c0 	pop	rbase
 500:	11 00 03 c0 	push	rbase
 504:	12 00 03 c0 	pop	rbase
 508:	11 00 03 c0 	push	rbase
 50c:	12 00 03 c0 	pop	rbase
 510:	18 00 03 a0 	srspr	rglobl
 514:	20 70 03 e3 	movepc	rret,12
 518:	00 c0 03 be 	cmp	rglobl,rbase
 51c:	14 32 fe c1 	br	20 <error>,#ne
 520:	00 10 03 61 	add	r27,1
 524:	0d c0 00 00 	clr	r0
 528:	0d c0 00 20 	clr	r1
 52c:	0d c0 00 40 	clr	r2
 530:	0d c0 00 60 	clr	r3
 534:	0d c0 00 80 	clr	r4
 538:	0d c0 00 a0 	clr	r5
 53c:	0d c0 00 c0 	clr	r6
 540:	0d c0 00 e0 	clr	rtmp
 544:	0d c0 01 00 	clr	r8
 548:	0d c0 01 20 	clr	r9
 54c:	0d c0 01 40 	clr	r10
 550:	0d c0 01 60 	clr	r11
 554:	0d c0 01 80 	clr	r12
 558:	0d c0 01 a0 	clr	r13
 55c:	0d c0 01 c0 	clr	r14
 560:	0d c0 01 e0 	clr	r15
 564:	0e c0 00 00 	lil	r0,0
 568:	0e c0 00 21 	lil	r1,1
 56c:	0e c0 00 42 	lil	r2,2
 570:	0e c0 00 63 	lil	r3,3
 574:	11 00 00 00 	push	r0
 578:	11 00 00 20 	push	r1
 57c:	11 00 00 40 	push	r2
 580:	11 00 00 60 	push	r3
 584:	20 00 00 00 	nop
 588:	20 00 00 00 	nop
 58c:	20 00 00 00 	nop
 590:	20 00 00 00 	nop
 594:	20 00 00 00 	nop
 598:	20 00 00 00 	nop
 59c:	20 00 00 00 	nop
 5a0:	20 00 00 00 	nop
 5a4:	12 00 00 80 	pop	r4
 5a8:	20 40 03 c3 	move	rbase,r3
 5ac:	20 40 03 a4 	move	rglobl,r4
 5b0:	20 70 03 e3 	movepc	rret,12
 5b4:	00 c0 03 be 	cmp	rglobl,rbase
 5b8:	14 32 fe 9a 	br	20 <error>,#ne
 5bc:	20 00 00 00 	nop
 5c0:	20 00 00 00 	nop
 5c4:	20 00 00 00 	nop
 5c8:	20 00 00 00 	nop
 5cc:	20 00 00 00 	nop
 5d0:	20 00 00 00 	nop
 5d4:	20 00 00 00 	nop
 5d8:	20 00 00 00 	nop
 5dc:	12 00 00 80 	pop	r4
 5e0:	20 40 03 c2 	move	rbase,r2
 5e4:	20 40 03 a4 	move	rglobl,r4
 5e8:	20 70 03 e3 	movepc	rret,12
 5ec:	00 c0 03 be 	cmp	rglobl,rbase
 5f0:	14 32 fe 8c 	br	20 <error>,#ne
 5f4:	20 00 00 00 	nop
 5f8:	20 00 00 00 	nop
 5fc:	20 00 00 00 	nop
 600:	20 00 00 00 	nop
 604:	20 00 00 00 	nop
 608:	20 00 00 00 	nop
 60c:	20 00 00 00 	nop
 610:	20 00 00 00 	nop
 614:	12 00 00 80 	pop	r4
 618:	20 40 03 c1 	move	rbase,r1
 61c:	20 40 03 a4 	move	rglobl,r4
 620:	20 70 03 e3 	movepc	rret,12
 624:	00 c0 03 be 	cmp	rglobl,rbase
 628:	14 32 fe 7e 	br	20 <error>,#ne
 62c:	20 00 00 00 	nop
 630:	20 00 00 00 	nop
 634:	20 00 00 00 	nop
 638:	20 00 00 00 	nop
 63c:	20 00 00 00 	nop
 640:	20 00 00 00 	nop
 644:	20 00 00 00 	nop
 648:	20 00 00 00 	nop
 64c:	12 00 00 80 	pop	r4
 650:	20 40 03 c0 	move	rbase,r0
 654:	20 40 03 a4 	move	rglobl,r4
 658:	20 70 03 e3 	movepc	rret,12
 65c:	00 c0 03 be 	cmp	rglobl,rbase
 660:	14 32 fe 70 	br	20 <error>,#ne
 664:	00 10 03 61 	add	r27,1
 668:	0d c0 00 00 	clr	r0
 66c:	0d c0 00 20 	clr	r1
 670:	0d c0 00 40 	clr	r2
 674:	0d c0 00 60 	clr	r3
 678:	0d c0 00 80 	clr	r4
 67c:	0d c0 00 a0 	clr	r5
 680:	0d c0 00 c0 	clr	r6
 684:	0d c0 00 e0 	clr	rtmp
 688:	0d c0 01 00 	clr	r8
 68c:	0d c0 01 20 	clr	r9
 690:	0d c0 01 40 	clr	r10
 694:	0d c0 01 60 	clr	r11
 698:	0d c0 01 80 	clr	r12
 69c:	0d c0 01 a0 	clr	r13
 6a0:	0d c0 01 c0 	clr	r14
 6a4:	0d c0 01 e0 	clr	r15
 6a8:	0e c0 00 00 	lil	r0,0
 6ac:	0e c0 00 21 	lil	r1,1
 6b0:	0e c0 00 42 	lil	r2,2
 6b4:	0e c0 00 63 	lil	r3,3
 6b8:	18 00 03 c0 	srspr	rbase
 6bc:	20 40 03 be 	move	rglobl,rbase
 6c0:	00 30 07 c0 	sub	rbase,32
 6c4:	1c 00 03 c0 	srspw	rbase
 6c8:	20 00 00 00 	nop
 6cc:	20 00 00 00 	nop
 6d0:	20 00 00 00 	nop
 6d4:	20 00 00 00 	nop
 6d8:	20 00 00 00 	nop
 6dc:	20 00 00 00 	nop
 6e0:	20 00 00 00 	nop
 6e4:	20 00 00 00 	nop
 6e8:	1c 00 03 a0 	srspw	rglobl
 6ec:	11 00 00 00 	push	r0
 6f0:	11 00 00 20 	push	r1
 6f4:	11 00 00 40 	push	r2
 6f8:	11 00 00 60 	push	r3
 6fc:	20 00 00 00 	nop
 700:	20 00 00 00 	nop
 704:	20 00 00 00 	nop
 708:	20 00 00 00 	nop
 70c:	20 00 00 00 	nop
 710:	20 00 00 00 	nop
 714:	20 00 00 00 	nop
 718:	20 00 00 00 	nop
 71c:	12 00 00 80 	pop	r4
 720:	20 40 03 c3 	move	rbase,r3
 724:	20 40 03 a4 	move	rglobl,r4
 728:	20 70 03 e3 	movepc	rret,12
 72c:	00 c0 03 be 	cmp	rglobl,rbase
 730:	14 32 fe 3c 	br	20 <error>,#ne
 734:	20 00 00 00 	nop
 738:	20 00 00 00 	nop
 73c:	20 00 00 00 	nop
 740:	20 00 00 00 	nop
 744:	20 00 00 00 	nop
 748:	20 00 00 00 	nop
 74c:	20 00 00 00 	nop
 750:	20 00 00 00 	nop
 754:	12 00 00 80 	pop	r4
 758:	20 40 03 c2 	move	rbase,r2
 75c:	20 40 03 a4 	move	rglobl,r4
 760:	20 70 03 e3 	movepc	rret,12
 764:	00 c0 03 be 	cmp	rglobl,rbase
 768:	14 32 fe 2e 	br	20 <error>,#ne
 76c:	20 00 00 00 	nop
 770:	20 00 00 00 	nop
 774:	20 00 00 00 	nop
 778:	20 00 00 00 	nop
 77c:	20 00 00 00 	nop
 780:	20 00 00 00 	nop
 784:	20 00 00 00 	nop
 788:	20 00 00 00 	nop
 78c:	12 00 00 80 	pop	r4
 790:	20 40 03 c1 	move	rbase,r1
 794:	20 40 03 a4 	move	rglobl,r4
 798:	20 70 03 e3 	movepc	rret,12
 79c:	00 c0 03 be 	cmp	rglobl,rbase
 7a0:	14 32 fe 20 	br	20 <error>,#ne
 7a4:	20 00 00 00 	nop
 7a8:	20 00 00 00 	nop
 7ac:	20 00 00 00 	nop
 7b0:	20 00 00 00 	nop
 7b4:	20 00 00 00 	nop
 7b8:	20 00 00 00 	nop
 7bc:	20 00 00 00 	nop
 7c0:	20 00 00 00 	nop
 7c4:	12 00 00 80 	pop	r4
 7c8:	20 40 03 c0 	move	rbase,r0
 7cc:	20 40 03 a4 	move	rglobl,r4
 7d0:	20 70 03 e3 	movepc	rret,12
 7d4:	00 c0 03 be 	cmp	rglobl,rbase
 7d8:	14 32 fe 12 	br	20 <error>,#ne
 7dc:	00 10 03 61 	add	r27,1
 7e0:	14 30 fe 20 	br	60 <finish>,#al

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
