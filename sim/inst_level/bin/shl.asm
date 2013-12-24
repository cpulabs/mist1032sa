
./out/shl.out:     ファイル形式 elf32-mist32


セクション .text の逆アセンブル:

00000000 <_start>:
       0:	0d 40 00 00 	wl16	r0,0x0
       4:	0d 60 00 0f 	wh16	r0,0xf
       8:	1c 00 00 00 	srspw	r0
       c:	14 30 00 18 	br	6c <check>,#al

00000010 <compare>:
      10:	00 c0 01 09 	cmp	r8,r9
      14:	14 41 03 e0 	b	rret,#eq

00000018 <error>:
      18:	0d 40 00 00 	wl16	r0,0x0
      1c:	0d 60 00 02 	wh16	r0,0x2
      20:	0e c0 00 20 	lil	r1,0
      24:	10 a0 00 20 	st32	r1,r0
      28:	0d 40 00 0c 	wl16	r0,0xc
      2c:	0d 60 00 02 	wh16	r0,0x2
      30:	10 a0 00 40 	st32	r2,r0
      34:	0d 40 00 08 	wl16	r0,0x8
      38:	0d 60 00 02 	wh16	r0,0x2
      3c:	10 a0 00 60 	st32	r3,r0
      40:	0d 40 00 10 	wl16	r0,0x10
      44:	0d 60 00 02 	wh16	r0,0x2
      48:	10 a0 01 00 	st32	r8,r0
      4c:	0d 40 00 14 	wl16	r0,0x14
      50:	0d 60 00 02 	wh16	r0,0x2
      54:	10 a0 01 20 	st32	r9,r0

00000058 <finish>:
      58:	0d 40 00 04 	wl16	r0,0x4
      5c:	0d 60 00 02 	wh16	r0,0x2
      60:	0e c0 00 21 	lil	r1,1
      64:	10 a0 00 20 	st32	r1,r0
      68:	14 30 00 00 	br	68 <finish+0x10>,#al

0000006c <check>:
      6c:	0c 40 00 42 	xor	r2,r2
      70:	0c 40 00 63 	xor	r3,r3
      74:	0d 40 01 00 	wl16	r8,0x0
      78:	0d 60 01 03 	wh16	r8,0x3
      7c:	10 40 01 08 	ld32	r8,r8
      80:	0d 40 16 1c 	wl16	r16,0xbc
      84:	0d 60 02 03 	wh16	r16,0x3
      88:	10 40 02 10 	ld32	r16,r16
      8c:	0d 40 2d 38 	wl16	r9,0x178
      90:	0d 60 01 23 	wh16	r9,0x3
      94:	10 40 01 29 	ld32	r9,r9
      98:	08 00 01 10 	shl	r8,r16
      9c:	20 70 03 e2 	movepc	rret,8
      a0:	14 30 ff dc 	br	10 <compare>,#al
      a4:	00 10 00 41 	add	r2,1
      a8:	0d 40 01 04 	wl16	r8,0x4
      ac:	0d 60 01 03 	wh16	r8,0x3
      b0:	10 40 01 08 	ld32	r8,r8
      b4:	0d 40 1a 00 	wl16	r16,0xc0
      b8:	0d 60 02 03 	wh16	r16,0x3
      bc:	10 40 02 10 	ld32	r16,r16
      c0:	0d 40 2d 3c 	wl16	r9,0x17c
      c4:	0d 60 01 23 	wh16	r9,0x3
      c8:	10 40 01 29 	ld32	r9,r9
      cc:	08 00 01 10 	shl	r8,r16
      d0:	20 70 03 e2 	movepc	rret,8
      d4:	14 30 ff cf 	br	10 <compare>,#al
      d8:	00 10 00 41 	add	r2,1
      dc:	0d 40 01 08 	wl16	r8,0x8
      e0:	0d 60 01 03 	wh16	r8,0x3
      e4:	10 40 01 08 	ld32	r8,r8
      e8:	0d 40 1a 04 	wl16	r16,0xc4
      ec:	0d 60 02 03 	wh16	r16,0x3
      f0:	10 40 02 10 	ld32	r16,r16
      f4:	0d 40 31 20 	wl16	r9,0x180
      f8:	0d 60 01 23 	wh16	r9,0x3
      fc:	10 40 01 29 	ld32	r9,r9
     100:	08 00 01 10 	shl	r8,r16
     104:	20 70 03 e2 	movepc	rret,8
     108:	14 30 ff c2 	br	10 <compare>,#al
     10c:	00 10 00 41 	add	r2,1
     110:	0d 40 01 0c 	wl16	r8,0xc
     114:	0d 60 01 03 	wh16	r8,0x3
     118:	10 40 01 08 	ld32	r8,r8
     11c:	0d 40 1a 08 	wl16	r16,0xc8
     120:	0d 60 02 03 	wh16	r16,0x3
     124:	10 40 02 10 	ld32	r16,r16
     128:	0d 40 31 24 	wl16	r9,0x184
     12c:	0d 60 01 23 	wh16	r9,0x3
     130:	10 40 01 29 	ld32	r9,r9
     134:	08 00 01 10 	shl	r8,r16
     138:	20 70 03 e2 	movepc	rret,8
     13c:	14 30 ff b5 	br	10 <compare>,#al
     140:	00 10 00 41 	add	r2,1
     144:	0d 40 01 10 	wl16	r8,0x10
     148:	0d 60 01 03 	wh16	r8,0x3
     14c:	10 40 01 08 	ld32	r8,r8
     150:	0d 40 1a 0c 	wl16	r16,0xcc
     154:	0d 60 02 03 	wh16	r16,0x3
     158:	10 40 02 10 	ld32	r16,r16
     15c:	0d 40 31 28 	wl16	r9,0x188
     160:	0d 60 01 23 	wh16	r9,0x3
     164:	10 40 01 29 	ld32	r9,r9
     168:	08 00 01 10 	shl	r8,r16
     16c:	20 70 03 e2 	movepc	rret,8
     170:	14 30 ff a8 	br	10 <compare>,#al
     174:	00 10 00 41 	add	r2,1
     178:	0d 40 01 14 	wl16	r8,0x14
     17c:	0d 60 01 03 	wh16	r8,0x3
     180:	10 40 01 08 	ld32	r8,r8
     184:	0d 40 1a 10 	wl16	r16,0xd0
     188:	0d 60 02 03 	wh16	r16,0x3
     18c:	10 40 02 10 	ld32	r16,r16
     190:	0d 40 31 2c 	wl16	r9,0x18c
     194:	0d 60 01 23 	wh16	r9,0x3
     198:	10 40 01 29 	ld32	r9,r9
     19c:	08 00 01 10 	shl	r8,r16
     1a0:	20 70 03 e2 	movepc	rret,8
     1a4:	14 30 ff 9b 	br	10 <compare>,#al
     1a8:	00 10 00 41 	add	r2,1
     1ac:	0d 40 01 18 	wl16	r8,0x18
     1b0:	0d 60 01 03 	wh16	r8,0x3
     1b4:	10 40 01 08 	ld32	r8,r8
     1b8:	0d 40 1a 14 	wl16	r16,0xd4
     1bc:	0d 60 02 03 	wh16	r16,0x3
     1c0:	10 40 02 10 	ld32	r16,r16
     1c4:	0d 40 31 30 	wl16	r9,0x190
     1c8:	0d 60 01 23 	wh16	r9,0x3
     1cc:	10 40 01 29 	ld32	r9,r9
     1d0:	08 00 01 10 	shl	r8,r16
     1d4:	20 70 03 e2 	movepc	rret,8
     1d8:	14 30 ff 8e 	br	10 <compare>,#al
     1dc:	00 10 00 41 	add	r2,1
     1e0:	0d 40 01 1c 	wl16	r8,0x1c
     1e4:	0d 60 01 03 	wh16	r8,0x3
     1e8:	10 40 01 08 	ld32	r8,r8
     1ec:	0d 40 1a 18 	wl16	r16,0xd8
     1f0:	0d 60 02 03 	wh16	r16,0x3
     1f4:	10 40 02 10 	ld32	r16,r16
     1f8:	0d 40 31 34 	wl16	r9,0x194
     1fc:	0d 60 01 23 	wh16	r9,0x3
     200:	10 40 01 29 	ld32	r9,r9
     204:	08 00 01 10 	shl	r8,r16
     208:	20 70 03 e2 	movepc	rret,8
     20c:	14 30 ff 81 	br	10 <compare>,#al
     210:	00 10 00 41 	add	r2,1
     214:	0d 40 05 00 	wl16	r8,0x20
     218:	0d 60 01 03 	wh16	r8,0x3
     21c:	10 40 01 08 	ld32	r8,r8
     220:	0d 40 1a 1c 	wl16	r16,0xdc
     224:	0d 60 02 03 	wh16	r16,0x3
     228:	10 40 02 10 	ld32	r16,r16
     22c:	0d 40 31 38 	wl16	r9,0x198
     230:	0d 60 01 23 	wh16	r9,0x3
     234:	10 40 01 29 	ld32	r9,r9
     238:	08 00 01 10 	shl	r8,r16
     23c:	20 70 03 e2 	movepc	rret,8
     240:	14 30 ff 74 	br	10 <compare>,#al
     244:	00 10 00 41 	add	r2,1
     248:	0d 40 05 04 	wl16	r8,0x24
     24c:	0d 60 01 03 	wh16	r8,0x3
     250:	10 40 01 08 	ld32	r8,r8
     254:	0d 40 1e 00 	wl16	r16,0xe0
     258:	0d 60 02 03 	wh16	r16,0x3
     25c:	10 40 02 10 	ld32	r16,r16
     260:	0d 40 31 3c 	wl16	r9,0x19c
     264:	0d 60 01 23 	wh16	r9,0x3
     268:	10 40 01 29 	ld32	r9,r9
     26c:	08 00 01 10 	shl	r8,r16
     270:	20 70 03 e2 	movepc	rret,8
     274:	14 30 ff 67 	br	10 <compare>,#al
     278:	00 10 00 41 	add	r2,1
     27c:	0d 40 05 08 	wl16	r8,0x28
     280:	0d 60 01 03 	wh16	r8,0x3
     284:	10 40 01 08 	ld32	r8,r8
     288:	0d 40 1e 04 	wl16	r16,0xe4
     28c:	0d 60 02 03 	wh16	r16,0x3
     290:	10 40 02 10 	ld32	r16,r16
     294:	0d 40 35 20 	wl16	r9,0x1a0
     298:	0d 60 01 23 	wh16	r9,0x3
     29c:	10 40 01 29 	ld32	r9,r9
     2a0:	08 00 01 10 	shl	r8,r16
     2a4:	20 70 03 e2 	movepc	rret,8
     2a8:	14 30 ff 5a 	br	10 <compare>,#al
     2ac:	00 10 00 41 	add	r2,1
     2b0:	0d 40 05 0c 	wl16	r8,0x2c
     2b4:	0d 60 01 03 	wh16	r8,0x3
     2b8:	10 40 01 08 	ld32	r8,r8
     2bc:	0d 40 1e 08 	wl16	r16,0xe8
     2c0:	0d 60 02 03 	wh16	r16,0x3
     2c4:	10 40 02 10 	ld32	r16,r16
     2c8:	0d 40 35 24 	wl16	r9,0x1a4
     2cc:	0d 60 01 23 	wh16	r9,0x3
     2d0:	10 40 01 29 	ld32	r9,r9
     2d4:	08 00 01 10 	shl	r8,r16
     2d8:	20 70 03 e2 	movepc	rret,8
     2dc:	14 30 ff 4d 	br	10 <compare>,#al
     2e0:	00 10 00 41 	add	r2,1
     2e4:	0d 40 05 10 	wl16	r8,0x30
     2e8:	0d 60 01 03 	wh16	r8,0x3
     2ec:	10 40 01 08 	ld32	r8,r8
     2f0:	0d 40 1e 0c 	wl16	r16,0xec
     2f4:	0d 60 02 03 	wh16	r16,0x3
     2f8:	10 40 02 10 	ld32	r16,r16
     2fc:	0d 40 35 28 	wl16	r9,0x1a8
     300:	0d 60 01 23 	wh16	r9,0x3
     304:	10 40 01 29 	ld32	r9,r9
     308:	08 00 01 10 	shl	r8,r16
     30c:	20 70 03 e2 	movepc	rret,8
     310:	14 30 ff 40 	br	10 <compare>,#al
     314:	00 10 00 41 	add	r2,1
     318:	0d 40 05 14 	wl16	r8,0x34
     31c:	0d 60 01 03 	wh16	r8,0x3
     320:	10 40 01 08 	ld32	r8,r8
     324:	0d 40 1e 10 	wl16	r16,0xf0
     328:	0d 60 02 03 	wh16	r16,0x3
     32c:	10 40 02 10 	ld32	r16,r16
     330:	0d 40 35 2c 	wl16	r9,0x1ac
     334:	0d 60 01 23 	wh16	r9,0x3
     338:	10 40 01 29 	ld32	r9,r9
     33c:	08 00 01 10 	shl	r8,r16
     340:	20 70 03 e2 	movepc	rret,8
     344:	14 30 ff 33 	br	10 <compare>,#al
     348:	00 10 00 41 	add	r2,1
     34c:	0d 40 05 18 	wl16	r8,0x38
     350:	0d 60 01 03 	wh16	r8,0x3
     354:	10 40 01 08 	ld32	r8,r8
     358:	0d 40 1e 14 	wl16	r16,0xf4
     35c:	0d 60 02 03 	wh16	r16,0x3
     360:	10 40 02 10 	ld32	r16,r16
     364:	0d 40 35 30 	wl16	r9,0x1b0
     368:	0d 60 01 23 	wh16	r9,0x3
     36c:	10 40 01 29 	ld32	r9,r9
     370:	08 00 01 10 	shl	r8,r16
     374:	20 70 03 e2 	movepc	rret,8
     378:	14 30 ff 26 	br	10 <compare>,#al
     37c:	00 10 00 41 	add	r2,1
     380:	0d 40 05 1c 	wl16	r8,0x3c
     384:	0d 60 01 03 	wh16	r8,0x3
     388:	10 40 01 08 	ld32	r8,r8
     38c:	0d 40 1e 18 	wl16	r16,0xf8
     390:	0d 60 02 03 	wh16	r16,0x3
     394:	10 40 02 10 	ld32	r16,r16
     398:	0d 40 35 34 	wl16	r9,0x1b4
     39c:	0d 60 01 23 	wh16	r9,0x3
     3a0:	10 40 01 29 	ld32	r9,r9
     3a4:	08 00 01 10 	shl	r8,r16
     3a8:	20 70 03 e2 	movepc	rret,8
     3ac:	14 30 ff 19 	br	10 <compare>,#al
     3b0:	00 10 00 41 	add	r2,1
     3b4:	0d 40 09 00 	wl16	r8,0x40
     3b8:	0d 60 01 03 	wh16	r8,0x3
     3bc:	10 40 01 08 	ld32	r8,r8
     3c0:	0d 40 1e 1c 	wl16	r16,0xfc
     3c4:	0d 60 02 03 	wh16	r16,0x3
     3c8:	10 40 02 10 	ld32	r16,r16
     3cc:	0d 40 35 38 	wl16	r9,0x1b8
     3d0:	0d 60 01 23 	wh16	r9,0x3
     3d4:	10 40 01 29 	ld32	r9,r9
     3d8:	08 00 01 10 	shl	r8,r16
     3dc:	20 70 03 e2 	movepc	rret,8
     3e0:	14 30 ff 0c 	br	10 <compare>,#al
     3e4:	00 10 00 41 	add	r2,1
     3e8:	0d 40 09 04 	wl16	r8,0x44
     3ec:	0d 60 01 03 	wh16	r8,0x3
     3f0:	10 40 01 08 	ld32	r8,r8
     3f4:	0d 40 22 00 	wl16	r16,0x100
     3f8:	0d 60 02 03 	wh16	r16,0x3
     3fc:	10 40 02 10 	ld32	r16,r16
     400:	0d 40 35 3c 	wl16	r9,0x1bc
     404:	0d 60 01 23 	wh16	r9,0x3
     408:	10 40 01 29 	ld32	r9,r9
     40c:	08 00 01 10 	shl	r8,r16
     410:	20 70 03 e2 	movepc	rret,8
     414:	14 30 fe ff 	br	10 <compare>,#al
     418:	00 10 00 41 	add	r2,1
     41c:	0d 40 09 08 	wl16	r8,0x48
     420:	0d 60 01 03 	wh16	r8,0x3
     424:	10 40 01 08 	ld32	r8,r8
     428:	0d 40 22 04 	wl16	r16,0x104
     42c:	0d 60 02 03 	wh16	r16,0x3
     430:	10 40 02 10 	ld32	r16,r16
     434:	0d 40 39 20 	wl16	r9,0x1c0
     438:	0d 60 01 23 	wh16	r9,0x3
     43c:	10 40 01 29 	ld32	r9,r9
     440:	08 00 01 10 	shl	r8,r16
     444:	20 70 03 e2 	movepc	rret,8
     448:	14 30 fe f2 	br	10 <compare>,#al
     44c:	00 10 00 41 	add	r2,1
     450:	0d 40 09 0c 	wl16	r8,0x4c
     454:	0d 60 01 03 	wh16	r8,0x3
     458:	10 40 01 08 	ld32	r8,r8
     45c:	0d 40 22 08 	wl16	r16,0x108
     460:	0d 60 02 03 	wh16	r16,0x3
     464:	10 40 02 10 	ld32	r16,r16
     468:	0d 40 39 24 	wl16	r9,0x1c4
     46c:	0d 60 01 23 	wh16	r9,0x3
     470:	10 40 01 29 	ld32	r9,r9
     474:	08 00 01 10 	shl	r8,r16
     478:	20 70 03 e2 	movepc	rret,8
     47c:	14 30 fe e5 	br	10 <compare>,#al
     480:	00 10 00 41 	add	r2,1
     484:	0d 40 09 10 	wl16	r8,0x50
     488:	0d 60 01 03 	wh16	r8,0x3
     48c:	10 40 01 08 	ld32	r8,r8
     490:	0d 40 22 0c 	wl16	r16,0x10c
     494:	0d 60 02 03 	wh16	r16,0x3
     498:	10 40 02 10 	ld32	r16,r16
     49c:	0d 40 39 28 	wl16	r9,0x1c8
     4a0:	0d 60 01 23 	wh16	r9,0x3
     4a4:	10 40 01 29 	ld32	r9,r9
     4a8:	08 00 01 10 	shl	r8,r16
     4ac:	20 70 03 e2 	movepc	rret,8
     4b0:	14 30 fe d8 	br	10 <compare>,#al
     4b4:	00 10 00 41 	add	r2,1
     4b8:	0d 40 09 14 	wl16	r8,0x54
     4bc:	0d 60 01 03 	wh16	r8,0x3
     4c0:	10 40 01 08 	ld32	r8,r8
     4c4:	0d 40 22 10 	wl16	r16,0x110
     4c8:	0d 60 02 03 	wh16	r16,0x3
     4cc:	10 40 02 10 	ld32	r16,r16
     4d0:	0d 40 39 2c 	wl16	r9,0x1cc
     4d4:	0d 60 01 23 	wh16	r9,0x3
     4d8:	10 40 01 29 	ld32	r9,r9
     4dc:	08 00 01 10 	shl	r8,r16
     4e0:	20 70 03 e2 	movepc	rret,8
     4e4:	14 30 fe cb 	br	10 <compare>,#al
     4e8:	00 10 00 41 	add	r2,1
     4ec:	0d 40 09 18 	wl16	r8,0x58
     4f0:	0d 60 01 03 	wh16	r8,0x3
     4f4:	10 40 01 08 	ld32	r8,r8
     4f8:	0d 40 22 14 	wl16	r16,0x114
     4fc:	0d 60 02 03 	wh16	r16,0x3
     500:	10 40 02 10 	ld32	r16,r16
     504:	0d 40 39 30 	wl16	r9,0x1d0
     508:	0d 60 01 23 	wh16	r9,0x3
     50c:	10 40 01 29 	ld32	r9,r9
     510:	08 00 01 10 	shl	r8,r16
     514:	20 70 03 e2 	movepc	rret,8
     518:	14 30 fe be 	br	10 <compare>,#al
     51c:	00 10 00 41 	add	r2,1
     520:	0d 40 09 1c 	wl16	r8,0x5c
     524:	0d 60 01 03 	wh16	r8,0x3
     528:	10 40 01 08 	ld32	r8,r8
     52c:	0d 40 22 18 	wl16	r16,0x118
     530:	0d 60 02 03 	wh16	r16,0x3
     534:	10 40 02 10 	ld32	r16,r16
     538:	0d 40 39 34 	wl16	r9,0x1d4
     53c:	0d 60 01 23 	wh16	r9,0x3
     540:	10 40 01 29 	ld32	r9,r9
     544:	08 00 01 10 	shl	r8,r16
     548:	20 70 03 e2 	movepc	rret,8
     54c:	14 30 fe b1 	br	10 <compare>,#al
     550:	00 10 00 41 	add	r2,1
     554:	0d 40 0d 00 	wl16	r8,0x60
     558:	0d 60 01 03 	wh16	r8,0x3
     55c:	10 40 01 08 	ld32	r8,r8
     560:	0d 40 22 1c 	wl16	r16,0x11c
     564:	0d 60 02 03 	wh16	r16,0x3
     568:	10 40 02 10 	ld32	r16,r16
     56c:	0d 40 39 38 	wl16	r9,0x1d8
     570:	0d 60 01 23 	wh16	r9,0x3
     574:	10 40 01 29 	ld32	r9,r9
     578:	08 00 01 10 	shl	r8,r16
     57c:	20 70 03 e2 	movepc	rret,8
     580:	14 30 fe a4 	br	10 <compare>,#al
     584:	00 10 00 41 	add	r2,1
     588:	0d 40 0d 04 	wl16	r8,0x64
     58c:	0d 60 01 03 	wh16	r8,0x3
     590:	10 40 01 08 	ld32	r8,r8
     594:	0d 40 26 00 	wl16	r16,0x120
     598:	0d 60 02 03 	wh16	r16,0x3
     59c:	10 40 02 10 	ld32	r16,r16
     5a0:	0d 40 39 3c 	wl16	r9,0x1dc
     5a4:	0d 60 01 23 	wh16	r9,0x3
     5a8:	10 40 01 29 	ld32	r9,r9
     5ac:	08 00 01 10 	shl	r8,r16
     5b0:	20 70 03 e2 	movepc	rret,8
     5b4:	14 30 fe 97 	br	10 <compare>,#al
     5b8:	00 10 00 41 	add	r2,1
     5bc:	0d 40 0d 08 	wl16	r8,0x68
     5c0:	0d 60 01 03 	wh16	r8,0x3
     5c4:	10 40 01 08 	ld32	r8,r8
     5c8:	0d 40 26 04 	wl16	r16,0x124
     5cc:	0d 60 02 03 	wh16	r16,0x3
     5d0:	10 40 02 10 	ld32	r16,r16
     5d4:	0d 40 3d 20 	wl16	r9,0x1e0
     5d8:	0d 60 01 23 	wh16	r9,0x3
     5dc:	10 40 01 29 	ld32	r9,r9
     5e0:	08 00 01 10 	shl	r8,r16
     5e4:	20 70 03 e2 	movepc	rret,8
     5e8:	14 30 fe 8a 	br	10 <compare>,#al
     5ec:	00 10 00 41 	add	r2,1
     5f0:	0d 40 0d 0c 	wl16	r8,0x6c
     5f4:	0d 60 01 03 	wh16	r8,0x3
     5f8:	10 40 01 08 	ld32	r8,r8
     5fc:	0d 40 26 08 	wl16	r16,0x128
     600:	0d 60 02 03 	wh16	r16,0x3
     604:	10 40 02 10 	ld32	r16,r16
     608:	0d 40 3d 24 	wl16	r9,0x1e4
     60c:	0d 60 01 23 	wh16	r9,0x3
     610:	10 40 01 29 	ld32	r9,r9
     614:	08 00 01 10 	shl	r8,r16
     618:	20 70 03 e2 	movepc	rret,8
     61c:	14 30 fe 7d 	br	10 <compare>,#al
     620:	00 10 00 41 	add	r2,1
     624:	0d 40 0d 10 	wl16	r8,0x70
     628:	0d 60 01 03 	wh16	r8,0x3
     62c:	10 40 01 08 	ld32	r8,r8
     630:	0d 40 26 0c 	wl16	r16,0x12c
     634:	0d 60 02 03 	wh16	r16,0x3
     638:	10 40 02 10 	ld32	r16,r16
     63c:	0d 40 3d 28 	wl16	r9,0x1e8
     640:	0d 60 01 23 	wh16	r9,0x3
     644:	10 40 01 29 	ld32	r9,r9
     648:	08 00 01 10 	shl	r8,r16
     64c:	20 70 03 e2 	movepc	rret,8
     650:	14 30 fe 70 	br	10 <compare>,#al
     654:	00 10 00 41 	add	r2,1
     658:	0d 40 0d 14 	wl16	r8,0x74
     65c:	0d 60 01 03 	wh16	r8,0x3
     660:	10 40 01 08 	ld32	r8,r8
     664:	0d 40 26 10 	wl16	r16,0x130
     668:	0d 60 02 03 	wh16	r16,0x3
     66c:	10 40 02 10 	ld32	r16,r16
     670:	0d 40 3d 2c 	wl16	r9,0x1ec
     674:	0d 60 01 23 	wh16	r9,0x3
     678:	10 40 01 29 	ld32	r9,r9
     67c:	08 00 01 10 	shl	r8,r16
     680:	20 70 03 e2 	movepc	rret,8
     684:	14 30 fe 63 	br	10 <compare>,#al
     688:	00 10 00 41 	add	r2,1
     68c:	0d 40 0d 18 	wl16	r8,0x78
     690:	0d 60 01 03 	wh16	r8,0x3
     694:	10 40 01 08 	ld32	r8,r8
     698:	0d 40 26 14 	wl16	r16,0x134
     69c:	0d 60 02 03 	wh16	r16,0x3
     6a0:	10 40 02 10 	ld32	r16,r16
     6a4:	0d 40 3d 30 	wl16	r9,0x1f0
     6a8:	0d 60 01 23 	wh16	r9,0x3
     6ac:	10 40 01 29 	ld32	r9,r9
     6b0:	08 00 01 10 	shl	r8,r16
     6b4:	20 70 03 e2 	movepc	rret,8
     6b8:	14 30 fe 56 	br	10 <compare>,#al
     6bc:	00 10 00 41 	add	r2,1
     6c0:	0d 40 0d 1c 	wl16	r8,0x7c
     6c4:	0d 60 01 03 	wh16	r8,0x3
     6c8:	10 40 01 08 	ld32	r8,r8
     6cc:	0d 40 26 18 	wl16	r16,0x138
     6d0:	0d 60 02 03 	wh16	r16,0x3
     6d4:	10 40 02 10 	ld32	r16,r16
     6d8:	0d 40 3d 34 	wl16	r9,0x1f4
     6dc:	0d 60 01 23 	wh16	r9,0x3
     6e0:	10 40 01 29 	ld32	r9,r9
     6e4:	08 00 01 10 	shl	r8,r16
     6e8:	20 70 03 e2 	movepc	rret,8
     6ec:	14 30 fe 49 	br	10 <compare>,#al
     6f0:	00 10 00 41 	add	r2,1
     6f4:	0d 40 11 00 	wl16	r8,0x80
     6f8:	0d 60 01 03 	wh16	r8,0x3
     6fc:	10 40 01 08 	ld32	r8,r8
     700:	0d 40 26 1c 	wl16	r16,0x13c
     704:	0d 60 02 03 	wh16	r16,0x3
     708:	10 40 02 10 	ld32	r16,r16
     70c:	0d 40 3d 38 	wl16	r9,0x1f8
     710:	0d 60 01 23 	wh16	r9,0x3
     714:	10 40 01 29 	ld32	r9,r9
     718:	08 00 01 10 	shl	r8,r16
     71c:	20 70 03 e2 	movepc	rret,8
     720:	14 30 fe 3c 	br	10 <compare>,#al
     724:	00 10 00 41 	add	r2,1
     728:	0d 40 11 04 	wl16	r8,0x84
     72c:	0d 60 01 03 	wh16	r8,0x3
     730:	10 40 01 08 	ld32	r8,r8
     734:	0d 40 2a 00 	wl16	r16,0x140
     738:	0d 60 02 03 	wh16	r16,0x3
     73c:	10 40 02 10 	ld32	r16,r16
     740:	0d 40 3d 3c 	wl16	r9,0x1fc
     744:	0d 60 01 23 	wh16	r9,0x3
     748:	10 40 01 29 	ld32	r9,r9
     74c:	08 00 01 10 	shl	r8,r16
     750:	20 70 03 e2 	movepc	rret,8
     754:	14 30 fe 2f 	br	10 <compare>,#al
     758:	00 10 00 41 	add	r2,1
     75c:	0d 40 11 08 	wl16	r8,0x88
     760:	0d 60 01 03 	wh16	r8,0x3
     764:	10 40 01 08 	ld32	r8,r8
     768:	0d 40 2a 04 	wl16	r16,0x144
     76c:	0d 60 02 03 	wh16	r16,0x3
     770:	10 40 02 10 	ld32	r16,r16
     774:	0d 40 41 20 	wl16	r9,0x200
     778:	0d 60 01 23 	wh16	r9,0x3
     77c:	10 40 01 29 	ld32	r9,r9
     780:	08 00 01 10 	shl	r8,r16
     784:	20 70 03 e2 	movepc	rret,8
     788:	14 30 fe 22 	br	10 <compare>,#al
     78c:	00 10 00 41 	add	r2,1
     790:	0d 40 11 0c 	wl16	r8,0x8c
     794:	0d 60 01 03 	wh16	r8,0x3
     798:	10 40 01 08 	ld32	r8,r8
     79c:	0d 40 2a 08 	wl16	r16,0x148
     7a0:	0d 60 02 03 	wh16	r16,0x3
     7a4:	10 40 02 10 	ld32	r16,r16
     7a8:	0d 40 41 24 	wl16	r9,0x204
     7ac:	0d 60 01 23 	wh16	r9,0x3
     7b0:	10 40 01 29 	ld32	r9,r9
     7b4:	08 00 01 10 	shl	r8,r16
     7b8:	20 70 03 e2 	movepc	rret,8
     7bc:	14 30 fe 15 	br	10 <compare>,#al
     7c0:	00 10 00 41 	add	r2,1
     7c4:	0d 40 11 10 	wl16	r8,0x90
     7c8:	0d 60 01 03 	wh16	r8,0x3
     7cc:	10 40 01 08 	ld32	r8,r8
     7d0:	0d 40 2a 0c 	wl16	r16,0x14c
     7d4:	0d 60 02 03 	wh16	r16,0x3
     7d8:	10 40 02 10 	ld32	r16,r16
     7dc:	0d 40 41 28 	wl16	r9,0x208
     7e0:	0d 60 01 23 	wh16	r9,0x3
     7e4:	10 40 01 29 	ld32	r9,r9
     7e8:	08 00 01 10 	shl	r8,r16
     7ec:	20 70 03 e2 	movepc	rret,8
     7f0:	14 30 fe 08 	br	10 <compare>,#al
     7f4:	00 10 00 41 	add	r2,1
     7f8:	0d 40 11 14 	wl16	r8,0x94
     7fc:	0d 60 01 03 	wh16	r8,0x3
     800:	10 40 01 08 	ld32	r8,r8
     804:	0d 40 2a 10 	wl16	r16,0x150
     808:	0d 60 02 03 	wh16	r16,0x3
     80c:	10 40 02 10 	ld32	r16,r16
     810:	0d 40 41 2c 	wl16	r9,0x20c
     814:	0d 60 01 23 	wh16	r9,0x3
     818:	10 40 01 29 	ld32	r9,r9
     81c:	08 00 01 10 	shl	r8,r16
     820:	20 70 03 e2 	movepc	rret,8
     824:	14 30 fd fb 	br	10 <compare>,#al
     828:	00 10 00 41 	add	r2,1
     82c:	0d 40 11 18 	wl16	r8,0x98
     830:	0d 60 01 03 	wh16	r8,0x3
     834:	10 40 01 08 	ld32	r8,r8
     838:	0d 40 2a 14 	wl16	r16,0x154
     83c:	0d 60 02 03 	wh16	r16,0x3
     840:	10 40 02 10 	ld32	r16,r16
     844:	0d 40 41 30 	wl16	r9,0x210
     848:	0d 60 01 23 	wh16	r9,0x3
     84c:	10 40 01 29 	ld32	r9,r9
     850:	08 00 01 10 	shl	r8,r16
     854:	20 70 03 e2 	movepc	rret,8
     858:	14 30 fd ee 	br	10 <compare>,#al
     85c:	00 10 00 41 	add	r2,1
     860:	0d 40 11 1c 	wl16	r8,0x9c
     864:	0d 60 01 03 	wh16	r8,0x3
     868:	10 40 01 08 	ld32	r8,r8
     86c:	0d 40 2a 18 	wl16	r16,0x158
     870:	0d 60 02 03 	wh16	r16,0x3
     874:	10 40 02 10 	ld32	r16,r16
     878:	0d 40 41 34 	wl16	r9,0x214
     87c:	0d 60 01 23 	wh16	r9,0x3
     880:	10 40 01 29 	ld32	r9,r9
     884:	08 00 01 10 	shl	r8,r16
     888:	20 70 03 e2 	movepc	rret,8
     88c:	14 30 fd e1 	br	10 <compare>,#al
     890:	00 10 00 41 	add	r2,1
     894:	0d 40 15 00 	wl16	r8,0xa0
     898:	0d 60 01 03 	wh16	r8,0x3
     89c:	10 40 01 08 	ld32	r8,r8
     8a0:	0d 40 2a 1c 	wl16	r16,0x15c
     8a4:	0d 60 02 03 	wh16	r16,0x3
     8a8:	10 40 02 10 	ld32	r16,r16
     8ac:	0d 40 41 38 	wl16	r9,0x218
     8b0:	0d 60 01 23 	wh16	r9,0x3
     8b4:	10 40 01 29 	ld32	r9,r9
     8b8:	08 00 01 10 	shl	r8,r16
     8bc:	20 70 03 e2 	movepc	rret,8
     8c0:	14 30 fd d4 	br	10 <compare>,#al
     8c4:	00 10 00 41 	add	r2,1
     8c8:	0d 40 15 04 	wl16	r8,0xa4
     8cc:	0d 60 01 03 	wh16	r8,0x3
     8d0:	10 40 01 08 	ld32	r8,r8
     8d4:	0d 40 2e 00 	wl16	r16,0x160
     8d8:	0d 60 02 03 	wh16	r16,0x3
     8dc:	10 40 02 10 	ld32	r16,r16
     8e0:	0d 40 41 3c 	wl16	r9,0x21c
     8e4:	0d 60 01 23 	wh16	r9,0x3
     8e8:	10 40 01 29 	ld32	r9,r9
     8ec:	08 00 01 10 	shl	r8,r16
     8f0:	20 70 03 e2 	movepc	rret,8
     8f4:	14 30 fd c7 	br	10 <compare>,#al
     8f8:	00 10 00 41 	add	r2,1
     8fc:	0d 40 15 08 	wl16	r8,0xa8
     900:	0d 60 01 03 	wh16	r8,0x3
     904:	10 40 01 08 	ld32	r8,r8
     908:	0d 40 2e 04 	wl16	r16,0x164
     90c:	0d 60 02 03 	wh16	r16,0x3
     910:	10 40 02 10 	ld32	r16,r16
     914:	0d 40 45 20 	wl16	r9,0x220
     918:	0d 60 01 23 	wh16	r9,0x3
     91c:	10 40 01 29 	ld32	r9,r9
     920:	08 00 01 10 	shl	r8,r16
     924:	20 70 03 e2 	movepc	rret,8
     928:	14 30 fd ba 	br	10 <compare>,#al
     92c:	00 10 00 41 	add	r2,1
     930:	0d 40 15 0c 	wl16	r8,0xac
     934:	0d 60 01 03 	wh16	r8,0x3
     938:	10 40 01 08 	ld32	r8,r8
     93c:	0d 40 2e 08 	wl16	r16,0x168
     940:	0d 60 02 03 	wh16	r16,0x3
     944:	10 40 02 10 	ld32	r16,r16
     948:	0d 40 45 24 	wl16	r9,0x224
     94c:	0d 60 01 23 	wh16	r9,0x3
     950:	10 40 01 29 	ld32	r9,r9
     954:	08 00 01 10 	shl	r8,r16
     958:	20 70 03 e2 	movepc	rret,8
     95c:	14 30 fd ad 	br	10 <compare>,#al
     960:	00 10 00 41 	add	r2,1
     964:	0d 40 15 10 	wl16	r8,0xb0
     968:	0d 60 01 03 	wh16	r8,0x3
     96c:	10 40 01 08 	ld32	r8,r8
     970:	0d 40 2e 0c 	wl16	r16,0x16c
     974:	0d 60 02 03 	wh16	r16,0x3
     978:	10 40 02 10 	ld32	r16,r16
     97c:	0d 40 45 28 	wl16	r9,0x228
     980:	0d 60 01 23 	wh16	r9,0x3
     984:	10 40 01 29 	ld32	r9,r9
     988:	08 00 01 10 	shl	r8,r16
     98c:	20 70 03 e2 	movepc	rret,8
     990:	14 30 fd a0 	br	10 <compare>,#al
     994:	00 10 00 41 	add	r2,1
     998:	0d 40 15 14 	wl16	r8,0xb4
     99c:	0d 60 01 03 	wh16	r8,0x3
     9a0:	10 40 01 08 	ld32	r8,r8
     9a4:	0d 40 2e 10 	wl16	r16,0x170
     9a8:	0d 60 02 03 	wh16	r16,0x3
     9ac:	10 40 02 10 	ld32	r16,r16
     9b0:	0d 40 45 2c 	wl16	r9,0x22c
     9b4:	0d 60 01 23 	wh16	r9,0x3
     9b8:	10 40 01 29 	ld32	r9,r9
     9bc:	08 00 01 10 	shl	r8,r16
     9c0:	20 70 03 e2 	movepc	rret,8
     9c4:	14 30 fd 93 	br	10 <compare>,#al
     9c8:	00 10 00 41 	add	r2,1
     9cc:	0d 40 15 18 	wl16	r8,0xb8
     9d0:	0d 60 01 03 	wh16	r8,0x3
     9d4:	10 40 01 08 	ld32	r8,r8
     9d8:	0d 40 2e 14 	wl16	r16,0x174
     9dc:	0d 60 02 03 	wh16	r16,0x3
     9e0:	10 40 02 10 	ld32	r16,r16
     9e4:	0d 40 45 30 	wl16	r9,0x230
     9e8:	0d 60 01 23 	wh16	r9,0x3
     9ec:	10 40 01 29 	ld32	r9,r9
     9f0:	08 00 01 10 	shl	r8,r16
     9f4:	20 70 03 e2 	movepc	rret,8
     9f8:	14 30 fd 86 	br	10 <compare>,#al
     9fc:	00 10 00 41 	add	r2,1
     a00:	0c 40 00 42 	xor	r2,r2
     a04:	00 10 00 61 	add	r3,1
     a08:	0d 40 45 14 	wl16	r8,0x234
     a0c:	0d 60 01 03 	wh16	r8,0x3
     a10:	10 40 01 08 	ld32	r8,r8
     a14:	0d 40 5d 30 	wl16	r9,0x2f0
     a18:	0d 60 01 23 	wh16	r9,0x3
     a1c:	10 40 01 29 	ld32	r9,r9
     a20:	08 10 01 01 	shl	r8,0x1
     a24:	20 70 03 e2 	movepc	rret,8
     a28:	14 30 fd 7a 	br	10 <compare>,#al
     a2c:	00 10 00 41 	add	r2,1
     a30:	0d 40 45 18 	wl16	r8,0x238
     a34:	0d 60 01 03 	wh16	r8,0x3
     a38:	10 40 01 08 	ld32	r8,r8
     a3c:	0d 40 5d 34 	wl16	r9,0x2f4
     a40:	0d 60 01 23 	wh16	r9,0x3
     a44:	10 40 01 29 	ld32	r9,r9
     a48:	08 10 01 02 	shl	r8,0x2
     a4c:	20 70 03 e2 	movepc	rret,8
     a50:	14 30 fd 70 	br	10 <compare>,#al
     a54:	00 10 00 41 	add	r2,1
     a58:	0d 40 45 1c 	wl16	r8,0x23c
     a5c:	0d 60 01 03 	wh16	r8,0x3
     a60:	10 40 01 08 	ld32	r8,r8
     a64:	0d 40 5d 38 	wl16	r9,0x2f8
     a68:	0d 60 01 23 	wh16	r9,0x3
     a6c:	10 40 01 29 	ld32	r9,r9
     a70:	08 10 01 04 	shl	r8,0x4
     a74:	20 70 03 e2 	movepc	rret,8
     a78:	14 30 fd 66 	br	10 <compare>,#al
     a7c:	00 10 00 41 	add	r2,1
     a80:	0d 40 49 00 	wl16	r8,0x240
     a84:	0d 60 01 03 	wh16	r8,0x3
     a88:	10 40 01 08 	ld32	r8,r8
     a8c:	0d 40 5d 3c 	wl16	r9,0x2fc
     a90:	0d 60 01 23 	wh16	r9,0x3
     a94:	10 40 01 29 	ld32	r9,r9
     a98:	08 10 01 08 	shl	r8,0x8
     a9c:	20 70 03 e2 	movepc	rret,8
     aa0:	14 30 fd 5c 	br	10 <compare>,#al
     aa4:	00 10 00 41 	add	r2,1
     aa8:	0d 40 49 04 	wl16	r8,0x244
     aac:	0d 60 01 03 	wh16	r8,0x3
     ab0:	10 40 01 08 	ld32	r8,r8
     ab4:	0d 40 61 20 	wl16	r9,0x300
     ab8:	0d 60 01 23 	wh16	r9,0x3
     abc:	10 40 01 29 	ld32	r9,r9
     ac0:	08 10 01 10 	shl	r8,0x10
     ac4:	20 70 03 e2 	movepc	rret,8
     ac8:	14 30 fd 52 	br	10 <compare>,#al
     acc:	00 10 00 41 	add	r2,1
     ad0:	0d 40 49 08 	wl16	r8,0x248
     ad4:	0d 60 01 03 	wh16	r8,0x3
     ad8:	10 40 01 08 	ld32	r8,r8
     adc:	0d 40 61 24 	wl16	r9,0x304
     ae0:	0d 60 01 23 	wh16	r9,0x3
     ae4:	10 40 01 29 	ld32	r9,r9
     ae8:	08 10 05 00 	shl	r8,0x20
     aec:	20 70 03 e2 	movepc	rret,8
     af0:	14 30 fd 48 	br	10 <compare>,#al
     af4:	00 10 00 41 	add	r2,1
     af8:	0d 40 49 0c 	wl16	r8,0x24c
     afc:	0d 60 01 03 	wh16	r8,0x3
     b00:	10 40 01 08 	ld32	r8,r8
     b04:	0d 40 61 28 	wl16	r9,0x308
     b08:	0d 60 01 23 	wh16	r9,0x3
     b0c:	10 40 01 29 	ld32	r9,r9
     b10:	08 10 01 01 	shl	r8,0x1
     b14:	20 70 03 e2 	movepc	rret,8
     b18:	14 30 fd 3e 	br	10 <compare>,#al
     b1c:	00 10 00 41 	add	r2,1
     b20:	0d 40 49 10 	wl16	r8,0x250
     b24:	0d 60 01 03 	wh16	r8,0x3
     b28:	10 40 01 08 	ld32	r8,r8
     b2c:	0d 40 61 2c 	wl16	r9,0x30c
     b30:	0d 60 01 23 	wh16	r9,0x3
     b34:	10 40 01 29 	ld32	r9,r9
     b38:	08 10 01 02 	shl	r8,0x2
     b3c:	20 70 03 e2 	movepc	rret,8
     b40:	14 30 fd 34 	br	10 <compare>,#al
     b44:	00 10 00 41 	add	r2,1
     b48:	0d 40 49 14 	wl16	r8,0x254
     b4c:	0d 60 01 03 	wh16	r8,0x3
     b50:	10 40 01 08 	ld32	r8,r8
     b54:	0d 40 61 30 	wl16	r9,0x310
     b58:	0d 60 01 23 	wh16	r9,0x3
     b5c:	10 40 01 29 	ld32	r9,r9
     b60:	08 10 01 04 	shl	r8,0x4
     b64:	20 70 03 e2 	movepc	rret,8
     b68:	14 30 fd 2a 	br	10 <compare>,#al
     b6c:	00 10 00 41 	add	r2,1
     b70:	0d 40 49 18 	wl16	r8,0x258
     b74:	0d 60 01 03 	wh16	r8,0x3
     b78:	10 40 01 08 	ld32	r8,r8
     b7c:	0d 40 61 34 	wl16	r9,0x314
     b80:	0d 60 01 23 	wh16	r9,0x3
     b84:	10 40 01 29 	ld32	r9,r9
     b88:	08 10 01 08 	shl	r8,0x8
     b8c:	20 70 03 e2 	movepc	rret,8
     b90:	14 30 fd 20 	br	10 <compare>,#al
     b94:	00 10 00 41 	add	r2,1
     b98:	0d 40 49 1c 	wl16	r8,0x25c
     b9c:	0d 60 01 03 	wh16	r8,0x3
     ba0:	10 40 01 08 	ld32	r8,r8
     ba4:	0d 40 61 38 	wl16	r9,0x318
     ba8:	0d 60 01 23 	wh16	r9,0x3
     bac:	10 40 01 29 	ld32	r9,r9
     bb0:	08 10 01 10 	shl	r8,0x10
     bb4:	20 70 03 e2 	movepc	rret,8
     bb8:	14 30 fd 16 	br	10 <compare>,#al
     bbc:	00 10 00 41 	add	r2,1
     bc0:	0d 40 4d 00 	wl16	r8,0x260
     bc4:	0d 60 01 03 	wh16	r8,0x3
     bc8:	10 40 01 08 	ld32	r8,r8
     bcc:	0d 40 61 3c 	wl16	r9,0x31c
     bd0:	0d 60 01 23 	wh16	r9,0x3
     bd4:	10 40 01 29 	ld32	r9,r9
     bd8:	08 10 05 00 	shl	r8,0x20
     bdc:	20 70 03 e2 	movepc	rret,8
     be0:	14 30 fd 0c 	br	10 <compare>,#al
     be4:	00 10 00 41 	add	r2,1
     be8:	0d 40 4d 04 	wl16	r8,0x264
     bec:	0d 60 01 03 	wh16	r8,0x3
     bf0:	10 40 01 08 	ld32	r8,r8
     bf4:	0d 40 65 20 	wl16	r9,0x320
     bf8:	0d 60 01 23 	wh16	r9,0x3
     bfc:	10 40 01 29 	ld32	r9,r9
     c00:	08 10 01 01 	shl	r8,0x1
     c04:	20 70 03 e2 	movepc	rret,8
     c08:	14 30 fd 02 	br	10 <compare>,#al
     c0c:	00 10 00 41 	add	r2,1
     c10:	0d 40 4d 08 	wl16	r8,0x268
     c14:	0d 60 01 03 	wh16	r8,0x3
     c18:	10 40 01 08 	ld32	r8,r8
     c1c:	0d 40 65 24 	wl16	r9,0x324
     c20:	0d 60 01 23 	wh16	r9,0x3
     c24:	10 40 01 29 	ld32	r9,r9
     c28:	08 10 01 02 	shl	r8,0x2
     c2c:	20 70 03 e2 	movepc	rret,8
     c30:	14 30 fc f8 	br	10 <compare>,#al
     c34:	00 10 00 41 	add	r2,1
     c38:	0d 40 4d 0c 	wl16	r8,0x26c
     c3c:	0d 60 01 03 	wh16	r8,0x3
     c40:	10 40 01 08 	ld32	r8,r8
     c44:	0d 40 65 28 	wl16	r9,0x328
     c48:	0d 60 01 23 	wh16	r9,0x3
     c4c:	10 40 01 29 	ld32	r9,r9
     c50:	08 10 01 04 	shl	r8,0x4
     c54:	20 70 03 e2 	movepc	rret,8
     c58:	14 30 fc ee 	br	10 <compare>,#al
     c5c:	00 10 00 41 	add	r2,1
     c60:	0d 40 4d 10 	wl16	r8,0x270
     c64:	0d 60 01 03 	wh16	r8,0x3
     c68:	10 40 01 08 	ld32	r8,r8
     c6c:	0d 40 65 2c 	wl16	r9,0x32c
     c70:	0d 60 01 23 	wh16	r9,0x3
     c74:	10 40 01 29 	ld32	r9,r9
     c78:	08 10 01 08 	shl	r8,0x8
     c7c:	20 70 03 e2 	movepc	rret,8
     c80:	14 30 fc e4 	br	10 <compare>,#al
     c84:	00 10 00 41 	add	r2,1
     c88:	0d 40 4d 14 	wl16	r8,0x274
     c8c:	0d 60 01 03 	wh16	r8,0x3
     c90:	10 40 01 08 	ld32	r8,r8
     c94:	0d 40 65 30 	wl16	r9,0x330
     c98:	0d 60 01 23 	wh16	r9,0x3
     c9c:	10 40 01 29 	ld32	r9,r9
     ca0:	08 10 01 10 	shl	r8,0x10
     ca4:	20 70 03 e2 	movepc	rret,8
     ca8:	14 30 fc da 	br	10 <compare>,#al
     cac:	00 10 00 41 	add	r2,1
     cb0:	0d 40 4d 18 	wl16	r8,0x278
     cb4:	0d 60 01 03 	wh16	r8,0x3
     cb8:	10 40 01 08 	ld32	r8,r8
     cbc:	0d 40 65 34 	wl16	r9,0x334
     cc0:	0d 60 01 23 	wh16	r9,0x3
     cc4:	10 40 01 29 	ld32	r9,r9
     cc8:	08 10 05 00 	shl	r8,0x20
     ccc:	20 70 03 e2 	movepc	rret,8
     cd0:	14 30 fc d0 	br	10 <compare>,#al
     cd4:	00 10 00 41 	add	r2,1
     cd8:	0d 40 4d 1c 	wl16	r8,0x27c
     cdc:	0d 60 01 03 	wh16	r8,0x3
     ce0:	10 40 01 08 	ld32	r8,r8
     ce4:	0d 40 65 38 	wl16	r9,0x338
     ce8:	0d 60 01 23 	wh16	r9,0x3
     cec:	10 40 01 29 	ld32	r9,r9
     cf0:	08 10 01 01 	shl	r8,0x1
     cf4:	20 70 03 e2 	movepc	rret,8
     cf8:	14 30 fc c6 	br	10 <compare>,#al
     cfc:	00 10 00 41 	add	r2,1
     d00:	0d 40 51 00 	wl16	r8,0x280
     d04:	0d 60 01 03 	wh16	r8,0x3
     d08:	10 40 01 08 	ld32	r8,r8
     d0c:	0d 40 65 3c 	wl16	r9,0x33c
     d10:	0d 60 01 23 	wh16	r9,0x3
     d14:	10 40 01 29 	ld32	r9,r9
     d18:	08 10 01 02 	shl	r8,0x2
     d1c:	20 70 03 e2 	movepc	rret,8
     d20:	14 30 fc bc 	br	10 <compare>,#al
     d24:	00 10 00 41 	add	r2,1
     d28:	0d 40 51 04 	wl16	r8,0x284
     d2c:	0d 60 01 03 	wh16	r8,0x3
     d30:	10 40 01 08 	ld32	r8,r8
     d34:	0d 40 69 20 	wl16	r9,0x340
     d38:	0d 60 01 23 	wh16	r9,0x3
     d3c:	10 40 01 29 	ld32	r9,r9
     d40:	08 10 01 04 	shl	r8,0x4
     d44:	20 70 03 e2 	movepc	rret,8
     d48:	14 30 fc b2 	br	10 <compare>,#al
     d4c:	00 10 00 41 	add	r2,1
     d50:	0d 40 51 08 	wl16	r8,0x288
     d54:	0d 60 01 03 	wh16	r8,0x3
     d58:	10 40 01 08 	ld32	r8,r8
     d5c:	0d 40 69 24 	wl16	r9,0x344
     d60:	0d 60 01 23 	wh16	r9,0x3
     d64:	10 40 01 29 	ld32	r9,r9
     d68:	08 10 01 08 	shl	r8,0x8
     d6c:	20 70 03 e2 	movepc	rret,8
     d70:	14 30 fc a8 	br	10 <compare>,#al
     d74:	00 10 00 41 	add	r2,1
     d78:	0d 40 51 0c 	wl16	r8,0x28c
     d7c:	0d 60 01 03 	wh16	r8,0x3
     d80:	10 40 01 08 	ld32	r8,r8
     d84:	0d 40 69 28 	wl16	r9,0x348
     d88:	0d 60 01 23 	wh16	r9,0x3
     d8c:	10 40 01 29 	ld32	r9,r9
     d90:	08 10 01 10 	shl	r8,0x10
     d94:	20 70 03 e2 	movepc	rret,8
     d98:	14 30 fc 9e 	br	10 <compare>,#al
     d9c:	00 10 00 41 	add	r2,1
     da0:	0d 40 51 10 	wl16	r8,0x290
     da4:	0d 60 01 03 	wh16	r8,0x3
     da8:	10 40 01 08 	ld32	r8,r8
     dac:	0d 40 69 2c 	wl16	r9,0x34c
     db0:	0d 60 01 23 	wh16	r9,0x3
     db4:	10 40 01 29 	ld32	r9,r9
     db8:	08 10 05 00 	shl	r8,0x20
     dbc:	20 70 03 e2 	movepc	rret,8
     dc0:	14 30 fc 94 	br	10 <compare>,#al
     dc4:	00 10 00 41 	add	r2,1
     dc8:	0d 40 51 14 	wl16	r8,0x294
     dcc:	0d 60 01 03 	wh16	r8,0x3
     dd0:	10 40 01 08 	ld32	r8,r8
     dd4:	0d 40 69 30 	wl16	r9,0x350
     dd8:	0d 60 01 23 	wh16	r9,0x3
     ddc:	10 40 01 29 	ld32	r9,r9
     de0:	08 10 01 01 	shl	r8,0x1
     de4:	20 70 03 e2 	movepc	rret,8
     de8:	14 30 fc 8a 	br	10 <compare>,#al
     dec:	00 10 00 41 	add	r2,1
     df0:	0d 40 51 18 	wl16	r8,0x298
     df4:	0d 60 01 03 	wh16	r8,0x3
     df8:	10 40 01 08 	ld32	r8,r8
     dfc:	0d 40 69 34 	wl16	r9,0x354
     e00:	0d 60 01 23 	wh16	r9,0x3
     e04:	10 40 01 29 	ld32	r9,r9
     e08:	08 10 01 02 	shl	r8,0x2
     e0c:	20 70 03 e2 	movepc	rret,8
     e10:	14 30 fc 80 	br	10 <compare>,#al
     e14:	00 10 00 41 	add	r2,1
     e18:	0d 40 51 1c 	wl16	r8,0x29c
     e1c:	0d 60 01 03 	wh16	r8,0x3
     e20:	10 40 01 08 	ld32	r8,r8
     e24:	0d 40 69 38 	wl16	r9,0x358
     e28:	0d 60 01 23 	wh16	r9,0x3
     e2c:	10 40 01 29 	ld32	r9,r9
     e30:	08 10 01 04 	shl	r8,0x4
     e34:	20 70 03 e2 	movepc	rret,8
     e38:	14 30 fc 76 	br	10 <compare>,#al
     e3c:	00 10 00 41 	add	r2,1
     e40:	0d 40 55 00 	wl16	r8,0x2a0
     e44:	0d 60 01 03 	wh16	r8,0x3
     e48:	10 40 01 08 	ld32	r8,r8
     e4c:	0d 40 69 3c 	wl16	r9,0x35c
     e50:	0d 60 01 23 	wh16	r9,0x3
     e54:	10 40 01 29 	ld32	r9,r9
     e58:	08 10 01 08 	shl	r8,0x8
     e5c:	20 70 03 e2 	movepc	rret,8
     e60:	14 30 fc 6c 	br	10 <compare>,#al
     e64:	00 10 00 41 	add	r2,1
     e68:	0d 40 55 04 	wl16	r8,0x2a4
     e6c:	0d 60 01 03 	wh16	r8,0x3
     e70:	10 40 01 08 	ld32	r8,r8
     e74:	0d 40 6d 20 	wl16	r9,0x360
     e78:	0d 60 01 23 	wh16	r9,0x3
     e7c:	10 40 01 29 	ld32	r9,r9
     e80:	08 10 01 10 	shl	r8,0x10
     e84:	20 70 03 e2 	movepc	rret,8
     e88:	14 30 fc 62 	br	10 <compare>,#al
     e8c:	00 10 00 41 	add	r2,1
     e90:	0d 40 55 08 	wl16	r8,0x2a8
     e94:	0d 60 01 03 	wh16	r8,0x3
     e98:	10 40 01 08 	ld32	r8,r8
     e9c:	0d 40 6d 24 	wl16	r9,0x364
     ea0:	0d 60 01 23 	wh16	r9,0x3
     ea4:	10 40 01 29 	ld32	r9,r9
     ea8:	08 10 05 00 	shl	r8,0x20
     eac:	20 70 03 e2 	movepc	rret,8
     eb0:	14 30 fc 58 	br	10 <compare>,#al
     eb4:	00 10 00 41 	add	r2,1
     eb8:	0d 40 55 0c 	wl16	r8,0x2ac
     ebc:	0d 60 01 03 	wh16	r8,0x3
     ec0:	10 40 01 08 	ld32	r8,r8
     ec4:	0d 40 6d 28 	wl16	r9,0x368
     ec8:	0d 60 01 23 	wh16	r9,0x3
     ecc:	10 40 01 29 	ld32	r9,r9
     ed0:	08 10 01 01 	shl	r8,0x1
     ed4:	20 70 03 e2 	movepc	rret,8
     ed8:	14 30 fc 4e 	br	10 <compare>,#al
     edc:	00 10 00 41 	add	r2,1
     ee0:	0d 40 55 10 	wl16	r8,0x2b0
     ee4:	0d 60 01 03 	wh16	r8,0x3
     ee8:	10 40 01 08 	ld32	r8,r8
     eec:	0d 40 6d 2c 	wl16	r9,0x36c
     ef0:	0d 60 01 23 	wh16	r9,0x3
     ef4:	10 40 01 29 	ld32	r9,r9
     ef8:	08 10 01 02 	shl	r8,0x2
     efc:	20 70 03 e2 	movepc	rret,8
     f00:	14 30 fc 44 	br	10 <compare>,#al
     f04:	00 10 00 41 	add	r2,1
     f08:	0d 40 55 14 	wl16	r8,0x2b4
     f0c:	0d 60 01 03 	wh16	r8,0x3
     f10:	10 40 01 08 	ld32	r8,r8
     f14:	0d 40 6d 30 	wl16	r9,0x370
     f18:	0d 60 01 23 	wh16	r9,0x3
     f1c:	10 40 01 29 	ld32	r9,r9
     f20:	08 10 01 04 	shl	r8,0x4
     f24:	20 70 03 e2 	movepc	rret,8
     f28:	14 30 fc 3a 	br	10 <compare>,#al
     f2c:	00 10 00 41 	add	r2,1
     f30:	0d 40 55 18 	wl16	r8,0x2b8
     f34:	0d 60 01 03 	wh16	r8,0x3
     f38:	10 40 01 08 	ld32	r8,r8
     f3c:	0d 40 6d 34 	wl16	r9,0x374
     f40:	0d 60 01 23 	wh16	r9,0x3
     f44:	10 40 01 29 	ld32	r9,r9
     f48:	08 10 01 08 	shl	r8,0x8
     f4c:	20 70 03 e2 	movepc	rret,8
     f50:	14 30 fc 30 	br	10 <compare>,#al
     f54:	00 10 00 41 	add	r2,1
     f58:	0d 40 55 1c 	wl16	r8,0x2bc
     f5c:	0d 60 01 03 	wh16	r8,0x3
     f60:	10 40 01 08 	ld32	r8,r8
     f64:	0d 40 6d 38 	wl16	r9,0x378
     f68:	0d 60 01 23 	wh16	r9,0x3
     f6c:	10 40 01 29 	ld32	r9,r9
     f70:	08 10 01 10 	shl	r8,0x10
     f74:	20 70 03 e2 	movepc	rret,8
     f78:	14 30 fc 26 	br	10 <compare>,#al
     f7c:	00 10 00 41 	add	r2,1
     f80:	0d 40 59 00 	wl16	r8,0x2c0
     f84:	0d 60 01 03 	wh16	r8,0x3
     f88:	10 40 01 08 	ld32	r8,r8
     f8c:	0d 40 6d 3c 	wl16	r9,0x37c
     f90:	0d 60 01 23 	wh16	r9,0x3
     f94:	10 40 01 29 	ld32	r9,r9
     f98:	08 10 05 00 	shl	r8,0x20
     f9c:	20 70 03 e2 	movepc	rret,8
     fa0:	14 30 fc 1c 	br	10 <compare>,#al
     fa4:	00 10 00 41 	add	r2,1
     fa8:	0d 40 59 04 	wl16	r8,0x2c4
     fac:	0d 60 01 03 	wh16	r8,0x3
     fb0:	10 40 01 08 	ld32	r8,r8
     fb4:	0d 40 71 20 	wl16	r9,0x380
     fb8:	0d 60 01 23 	wh16	r9,0x3
     fbc:	10 40 01 29 	ld32	r9,r9
     fc0:	08 10 01 01 	shl	r8,0x1
     fc4:	20 70 03 e2 	movepc	rret,8
     fc8:	14 30 fc 12 	br	10 <compare>,#al
     fcc:	00 10 00 41 	add	r2,1
     fd0:	0d 40 59 08 	wl16	r8,0x2c8
     fd4:	0d 60 01 03 	wh16	r8,0x3
     fd8:	10 40 01 08 	ld32	r8,r8
     fdc:	0d 40 71 24 	wl16	r9,0x384
     fe0:	0d 60 01 23 	wh16	r9,0x3
     fe4:	10 40 01 29 	ld32	r9,r9
     fe8:	08 10 01 02 	shl	r8,0x2
     fec:	20 70 03 e2 	movepc	rret,8
     ff0:	14 30 fc 08 	br	10 <compare>,#al
     ff4:	00 10 00 41 	add	r2,1
     ff8:	0d 40 59 0c 	wl16	r8,0x2cc
     ffc:	0d 60 01 03 	wh16	r8,0x3
    1000:	10 40 01 08 	ld32	r8,r8
    1004:	0d 40 71 28 	wl16	r9,0x388
    1008:	0d 60 01 23 	wh16	r9,0x3
    100c:	10 40 01 29 	ld32	r9,r9
    1010:	08 10 01 04 	shl	r8,0x4
    1014:	20 70 03 e2 	movepc	rret,8
    1018:	14 30 fb fe 	br	10 <compare>,#al
    101c:	00 10 00 41 	add	r2,1
    1020:	0d 40 59 10 	wl16	r8,0x2d0
    1024:	0d 60 01 03 	wh16	r8,0x3
    1028:	10 40 01 08 	ld32	r8,r8
    102c:	0d 40 71 2c 	wl16	r9,0x38c
    1030:	0d 60 01 23 	wh16	r9,0x3
    1034:	10 40 01 29 	ld32	r9,r9
    1038:	08 10 01 08 	shl	r8,0x8
    103c:	20 70 03 e2 	movepc	rret,8
    1040:	14 30 fb f4 	br	10 <compare>,#al
    1044:	00 10 00 41 	add	r2,1
    1048:	0d 40 59 14 	wl16	r8,0x2d4
    104c:	0d 60 01 03 	wh16	r8,0x3
    1050:	10 40 01 08 	ld32	r8,r8
    1054:	0d 40 71 30 	wl16	r9,0x390
    1058:	0d 60 01 23 	wh16	r9,0x3
    105c:	10 40 01 29 	ld32	r9,r9
    1060:	08 10 01 10 	shl	r8,0x10
    1064:	20 70 03 e2 	movepc	rret,8
    1068:	14 30 fb ea 	br	10 <compare>,#al
    106c:	00 10 00 41 	add	r2,1
    1070:	0d 40 59 18 	wl16	r8,0x2d8
    1074:	0d 60 01 03 	wh16	r8,0x3
    1078:	10 40 01 08 	ld32	r8,r8
    107c:	0d 40 71 34 	wl16	r9,0x394
    1080:	0d 60 01 23 	wh16	r9,0x3
    1084:	10 40 01 29 	ld32	r9,r9
    1088:	08 10 05 00 	shl	r8,0x20
    108c:	20 70 03 e2 	movepc	rret,8
    1090:	14 30 fb e0 	br	10 <compare>,#al
    1094:	00 10 00 41 	add	r2,1
    1098:	0d 40 59 1c 	wl16	r8,0x2dc
    109c:	0d 60 01 03 	wh16	r8,0x3
    10a0:	10 40 01 08 	ld32	r8,r8
    10a4:	0d 40 71 38 	wl16	r9,0x398
    10a8:	0d 60 01 23 	wh16	r9,0x3
    10ac:	10 40 01 29 	ld32	r9,r9
    10b0:	08 10 01 03 	shl	r8,0x3
    10b4:	20 70 03 e2 	movepc	rret,8
    10b8:	14 30 fb d6 	br	10 <compare>,#al
    10bc:	00 10 00 41 	add	r2,1
    10c0:	0d 40 5d 00 	wl16	r8,0x2e0
    10c4:	0d 60 01 03 	wh16	r8,0x3
    10c8:	10 40 01 08 	ld32	r8,r8
    10cc:	0d 40 71 3c 	wl16	r9,0x39c
    10d0:	0d 60 01 23 	wh16	r9,0x3
    10d4:	10 40 01 29 	ld32	r9,r9
    10d8:	08 10 01 07 	shl	r8,0x7
    10dc:	20 70 03 e2 	movepc	rret,8
    10e0:	14 30 fb cc 	br	10 <compare>,#al
    10e4:	00 10 00 41 	add	r2,1
    10e8:	0d 40 5d 04 	wl16	r8,0x2e4
    10ec:	0d 60 01 03 	wh16	r8,0x3
    10f0:	10 40 01 08 	ld32	r8,r8
    10f4:	0d 40 75 20 	wl16	r9,0x3a0
    10f8:	0d 60 01 23 	wh16	r9,0x3
    10fc:	10 40 01 29 	ld32	r9,r9
    1100:	08 10 01 0f 	shl	r8,0xf
    1104:	20 70 03 e2 	movepc	rret,8
    1108:	14 30 fb c2 	br	10 <compare>,#al
    110c:	00 10 00 41 	add	r2,1
    1110:	0d 40 5d 08 	wl16	r8,0x2e8
    1114:	0d 60 01 03 	wh16	r8,0x3
    1118:	10 40 01 08 	ld32	r8,r8
    111c:	0d 40 75 24 	wl16	r9,0x3a4
    1120:	0d 60 01 23 	wh16	r9,0x3
    1124:	10 40 01 29 	ld32	r9,r9
    1128:	08 10 01 1f 	shl	r8,0x1f
    112c:	20 70 03 e2 	movepc	rret,8
    1130:	14 30 fb b8 	br	10 <compare>,#al
    1134:	00 10 00 41 	add	r2,1
    1138:	0d 40 5d 0c 	wl16	r8,0x2ec
    113c:	0d 60 01 03 	wh16	r8,0x3
    1140:	10 40 01 08 	ld32	r8,r8
    1144:	0d 40 75 28 	wl16	r9,0x3a8
    1148:	0d 60 01 23 	wh16	r9,0x3
    114c:	10 40 01 29 	ld32	r9,r9
    1150:	08 10 05 1f 	shl	r8,0x3f
    1154:	20 70 03 e2 	movepc	rret,8
    1158:	14 30 fb ae 	br	10 <compare>,#al
    115c:	00 10 00 41 	add	r2,1
    1160:	14 30 fb be 	br	58 <finish>,#al

セクション .assert の逆アセンブル:

00020000 <CHECK_FLAG>:
   20000:	00 00 00 01 	add	r0,r1

00020004 <CHECK_FINISH>:
   20004:	00 00 00 00 	add	r0,r0

00020008 <ERROR_TYPE>:
   20008:	00 00 00 00 	add	r0,r0

0002000c <ERROR_NUMBER>:
   2000c:	00 00 00 00 	add	r0,r0

00020010 <ERROR_RESULT>:
   20010:	00 00 00 00 	add	r0,r0

00020014 <ERROR_EXPECT>:
   20014:	00 00 00 00 	add	r0,r0

セクション .data の逆アセンブル:

00030000 <T_SRC0_0>:
   30000:	00 00 00 00 	add	r0,r0

00030004 <T_SRC0_1>:
   30004:	00 00 00 00 	add	r0,r0

00030008 <T_SRC0_2>:
   30008:	00 00 00 00 	add	r0,r0

0003000c <T_SRC0_3>:
   3000c:	00 00 00 00 	add	r0,r0

00030010 <T_SRC0_4>:
   30010:	00 00 00 00 	add	r0,r0

00030014 <T_SRC0_5>:
   30014:	00 00 00 00 	add	r0,r0

00030018 <T_SRC0_6>:
   30018:	00 00 00 01 	add	r0,r1

0003001c <T_SRC0_7>:
   3001c:	00 00 00 01 	add	r0,r1

00030020 <T_SRC0_8>:
   30020:	00 00 00 01 	add	r0,r1

00030024 <T_SRC0_9>:
   30024:	00 00 00 01 	add	r0,r1

00030028 <T_SRC0_10>:
   30028:	00 00 00 01 	add	r0,r1

0003002c <T_SRC0_11>:
   3002c:	00 00 00 01 	add	r0,r1

00030030 <T_SRC0_12>:
   30030:	00 00 00 02 	add	r0,r2

00030034 <T_SRC0_13>:
   30034:	00 00 00 02 	add	r0,r2

00030038 <T_SRC0_14>:
   30038:	00 00 00 02 	add	r0,r2

0003003c <T_SRC0_15>:
   3003c:	00 00 00 02 	add	r0,r2

00030040 <T_SRC0_16>:
   30040:	00 00 00 02 	add	r0,r2

00030044 <T_SRC0_17>:
   30044:	00 00 00 02 	add	r0,r2

00030048 <T_SRC0_18>:
   30048:	00 00 00 04 	add	r0,r4

0003004c <T_SRC0_19>:
   3004c:	00 00 00 04 	add	r0,r4

00030050 <T_SRC0_20>:
   30050:	00 00 00 04 	add	r0,r4

00030054 <T_SRC0_21>:
   30054:	00 00 00 04 	add	r0,r4

00030058 <T_SRC0_22>:
   30058:	00 00 00 04 	add	r0,r4

0003005c <T_SRC0_23>:
   3005c:	00 00 00 04 	add	r0,r4

00030060 <T_SRC0_24>:
   30060:	00 00 00 08 	add	r0,r8

00030064 <T_SRC0_25>:
   30064:	00 00 00 08 	add	r0,r8

00030068 <T_SRC0_26>:
   30068:	00 00 00 08 	add	r0,r8

0003006c <T_SRC0_27>:
   3006c:	00 00 00 08 	add	r0,r8

00030070 <T_SRC0_28>:
   30070:	00 00 00 08 	add	r0,r8

00030074 <T_SRC0_29>:
   30074:	00 00 00 08 	add	r0,r8

00030078 <T_SRC0_30>:
   30078:	00 00 00 10 	add	r0,r16

0003007c <T_SRC0_31>:
   3007c:	00 00 00 10 	add	r0,r16

00030080 <T_SRC0_32>:
   30080:	00 00 00 10 	add	r0,r16

00030084 <T_SRC0_33>:
   30084:	00 00 00 10 	add	r0,r16

00030088 <T_SRC0_34>:
   30088:	00 00 00 10 	add	r0,r16

0003008c <T_SRC0_35>:
   3008c:	00 00 00 10 	add	r0,r16

00030090 <T_SRC0_36>:
   30090:	00 00 00 20 	add	r1,r0

00030094 <T_SRC0_37>:
   30094:	00 00 00 20 	add	r1,r0

00030098 <T_SRC0_38>:
   30098:	00 00 00 20 	add	r1,r0

0003009c <T_SRC0_39>:
   3009c:	00 00 00 20 	add	r1,r0

000300a0 <T_SRC0_40>:
   300a0:	00 00 00 20 	add	r1,r0

000300a4 <T_SRC0_41>:
   300a4:	00 00 00 20 	add	r1,r0

000300a8 <T_SRC0_42>:
   300a8:	00 00 00 03 	add	r0,r3

000300ac <T_SRC0_43>:
   300ac:	00 00 00 07 	add	r0,rtmp

000300b0 <T_SRC0_44>:
   300b0:	00 00 00 0f 	add	r0,r15

000300b4 <T_SRC0_45>:
   300b4:	00 00 00 1f 	add	r0,rret

000300b8 <T_SRC0_46>:
   300b8:	00 00 00 3f 	add	r1,rret

000300bc <T_SRC1_0>:
   300bc:	00 00 00 01 	add	r0,r1

000300c0 <T_SRC1_1>:
   300c0:	00 00 00 02 	add	r0,r2

000300c4 <T_SRC1_2>:
   300c4:	00 00 00 04 	add	r0,r4

000300c8 <T_SRC1_3>:
   300c8:	00 00 00 08 	add	r0,r8

000300cc <T_SRC1_4>:
   300cc:	00 00 00 10 	add	r0,r16

000300d0 <T_SRC1_5>:
   300d0:	00 00 00 20 	add	r1,r0

000300d4 <T_SRC1_6>:
   300d4:	00 00 00 01 	add	r0,r1

000300d8 <T_SRC1_7>:
   300d8:	00 00 00 02 	add	r0,r2

000300dc <T_SRC1_8>:
   300dc:	00 00 00 04 	add	r0,r4

000300e0 <T_SRC1_9>:
   300e0:	00 00 00 08 	add	r0,r8

000300e4 <T_SRC1_10>:
   300e4:	00 00 00 10 	add	r0,r16

000300e8 <T_SRC1_11>:
   300e8:	00 00 00 20 	add	r1,r0

000300ec <T_SRC1_12>:
   300ec:	00 00 00 01 	add	r0,r1

000300f0 <T_SRC1_13>:
   300f0:	00 00 00 02 	add	r0,r2

000300f4 <T_SRC1_14>:
   300f4:	00 00 00 04 	add	r0,r4

000300f8 <T_SRC1_15>:
   300f8:	00 00 00 08 	add	r0,r8

000300fc <T_SRC1_16>:
   300fc:	00 00 00 10 	add	r0,r16

00030100 <T_SRC1_17>:
   30100:	00 00 00 20 	add	r1,r0

00030104 <T_SRC1_18>:
   30104:	00 00 00 01 	add	r0,r1

00030108 <T_SRC1_19>:
   30108:	00 00 00 02 	add	r0,r2

0003010c <T_SRC1_20>:
   3010c:	00 00 00 04 	add	r0,r4

00030110 <T_SRC1_21>:
   30110:	00 00 00 08 	add	r0,r8

00030114 <T_SRC1_22>:
   30114:	00 00 00 10 	add	r0,r16

00030118 <T_SRC1_23>:
   30118:	00 00 00 20 	add	r1,r0

0003011c <T_SRC1_24>:
   3011c:	00 00 00 01 	add	r0,r1

00030120 <T_SRC1_25>:
   30120:	00 00 00 02 	add	r0,r2

00030124 <T_SRC1_26>:
   30124:	00 00 00 04 	add	r0,r4

00030128 <T_SRC1_27>:
   30128:	00 00 00 08 	add	r0,r8

0003012c <T_SRC1_28>:
   3012c:	00 00 00 10 	add	r0,r16

00030130 <T_SRC1_29>:
   30130:	00 00 00 20 	add	r1,r0

00030134 <T_SRC1_30>:
   30134:	00 00 00 01 	add	r0,r1

00030138 <T_SRC1_31>:
   30138:	00 00 00 02 	add	r0,r2

0003013c <T_SRC1_32>:
   3013c:	00 00 00 04 	add	r0,r4

00030140 <T_SRC1_33>:
   30140:	00 00 00 08 	add	r0,r8

00030144 <T_SRC1_34>:
   30144:	00 00 00 10 	add	r0,r16

00030148 <T_SRC1_35>:
   30148:	00 00 00 20 	add	r1,r0

0003014c <T_SRC1_36>:
   3014c:	00 00 00 01 	add	r0,r1

00030150 <T_SRC1_37>:
   30150:	00 00 00 02 	add	r0,r2

00030154 <T_SRC1_38>:
   30154:	00 00 00 04 	add	r0,r4

00030158 <T_SRC1_39>:
   30158:	00 00 00 08 	add	r0,r8

0003015c <T_SRC1_40>:
   3015c:	00 00 00 10 	add	r0,r16

00030160 <T_SRC1_41>:
   30160:	00 00 00 20 	add	r1,r0

00030164 <T_SRC1_42>:
   30164:	00 00 00 03 	add	r0,r3

00030168 <T_SRC1_43>:
   30168:	00 00 00 07 	add	r0,rtmp

0003016c <T_SRC1_44>:
   3016c:	00 00 00 0f 	add	r0,r15

00030170 <T_SRC1_45>:
   30170:	00 00 00 1f 	add	r0,rret

00030174 <T_SRC1_46>:
   30174:	00 00 00 3f 	add	r1,rret

00030178 <T_EXPECT0>:
   30178:	00 00 00 00 	add	r0,r0

0003017c <T_EXPECT1>:
   3017c:	00 00 00 00 	add	r0,r0

00030180 <T_EXPECT2>:
   30180:	00 00 00 00 	add	r0,r0

00030184 <T_EXPECT3>:
   30184:	00 00 00 00 	add	r0,r0

00030188 <T_EXPECT4>:
   30188:	00 00 00 00 	add	r0,r0

0003018c <T_EXPECT5>:
   3018c:	00 00 00 00 	add	r0,r0

00030190 <T_EXPECT6>:
   30190:	00 00 00 02 	add	r0,r2

00030194 <T_EXPECT7>:
   30194:	00 00 00 04 	add	r0,r4

00030198 <T_EXPECT8>:
   30198:	00 00 00 10 	add	r0,r16

0003019c <T_EXPECT9>:
   3019c:	00 00 01 00 	add	r8,r0

000301a0 <T_EXPECT10>:
   301a0:	00 01 00 00 	*unknown*

000301a4 <T_EXPECT11>:
   301a4:	00 00 00 00 	add	r0,r0

000301a8 <T_EXPECT12>:
   301a8:	00 00 00 04 	add	r0,r4

000301ac <T_EXPECT13>:
   301ac:	00 00 00 08 	add	r0,r8

000301b0 <T_EXPECT14>:
   301b0:	00 00 00 20 	add	r1,r0

000301b4 <T_EXPECT15>:
   301b4:	00 00 02 00 	add	r16,r0

000301b8 <T_EXPECT16>:
   301b8:	00 02 00 00 	*unknown*

000301bc <T_EXPECT17>:
   301bc:	00 00 00 00 	add	r0,r0

000301c0 <T_EXPECT18>:
   301c0:	00 00 00 08 	add	r0,r8

000301c4 <T_EXPECT19>:
   301c4:	00 00 00 10 	add	r0,r16

000301c8 <T_EXPECT20>:
   301c8:	00 00 00 40 	add	r2,r0

000301cc <T_EXPECT21>:
   301cc:	00 00 04 00 	*unknown*

000301d0 <T_EXPECT22>:
   301d0:	00 04 00 00 	*unknown*

000301d4 <T_EXPECT23>:
   301d4:	00 00 00 00 	add	r0,r0

000301d8 <T_EXPECT24>:
   301d8:	00 00 00 10 	add	r0,r16

000301dc <T_EXPECT25>:
   301dc:	00 00 00 20 	add	r1,r0

000301e0 <T_EXPECT26>:
   301e0:	00 00 00 80 	add	r4,r0

000301e4 <T_EXPECT27>:
   301e4:	00 00 08 00 	*unknown*

000301e8 <T_EXPECT28>:
   301e8:	00 08 00 00 	*unknown*

000301ec <T_EXPECT29>:
   301ec:	00 00 00 00 	add	r0,r0

000301f0 <T_EXPECT30>:
   301f0:	00 00 00 20 	add	r1,r0

000301f4 <T_EXPECT31>:
   301f4:	00 00 00 40 	add	r2,r0

000301f8 <T_EXPECT32>:
   301f8:	00 00 01 00 	add	r8,r0

000301fc <T_EXPECT33>:
   301fc:	00 00 10 00 	*unknown*

00030200 <T_EXPECT34>:
   30200:	00 10 00 00 	add	r0,0

00030204 <T_EXPECT35>:
   30204:	00 00 00 00 	add	r0,r0

00030208 <T_EXPECT36>:
   30208:	00 00 00 40 	add	r2,r0

0003020c <T_EXPECT37>:
   3020c:	00 00 00 80 	add	r4,r0

00030210 <T_EXPECT38>:
   30210:	00 00 02 00 	add	r16,r0

00030214 <T_EXPECT39>:
   30214:	00 00 20 00 	*unknown*

00030218 <T_EXPECT40>:
   30218:	00 20 00 00 	sub	r0,r0

0003021c <T_EXPECT41>:
   3021c:	00 00 00 00 	add	r0,r0

00030220 <T_EXPECT42>:
   30220:	00 00 00 18 	add	r0,r24

00030224 <T_EXPECT43>:
   30224:	00 00 03 80 	add	r28,r0

00030228 <T_EXPECT44>:
   30228:	00 07 80 00 	*unknown*

0003022c <T_EXPECT45>:
   3022c:	80 00 00 00 	*unknown*

00030230 <T_EXPECT46>:
   30230:	00 00 00 00 	add	r0,r0

00030234 <T_IMM_DST0>:
   30234:	00 00 00 00 	add	r0,r0

00030238 <T_IMM_DST1>:
   30238:	00 00 00 00 	add	r0,r0

0003023c <T_IMM_DST2>:
   3023c:	00 00 00 00 	add	r0,r0

00030240 <T_IMM_DST3>:
   30240:	00 00 00 00 	add	r0,r0

00030244 <T_IMM_DST4>:
   30244:	00 00 00 00 	add	r0,r0

00030248 <T_IMM_DST5>:
   30248:	00 00 00 00 	add	r0,r0

0003024c <T_IMM_DST6>:
   3024c:	00 00 00 01 	add	r0,r1

00030250 <T_IMM_DST7>:
   30250:	00 00 00 01 	add	r0,r1

00030254 <T_IMM_DST8>:
   30254:	00 00 00 01 	add	r0,r1

00030258 <T_IMM_DST9>:
   30258:	00 00 00 01 	add	r0,r1

0003025c <T_IMM_DST10>:
   3025c:	00 00 00 01 	add	r0,r1

00030260 <T_IMM_DST11>:
   30260:	00 00 00 01 	add	r0,r1

00030264 <T_IMM_DST12>:
   30264:	00 00 00 02 	add	r0,r2

00030268 <T_IMM_DST13>:
   30268:	00 00 00 02 	add	r0,r2

0003026c <T_IMM_DST14>:
   3026c:	00 00 00 02 	add	r0,r2

00030270 <T_IMM_DST15>:
   30270:	00 00 00 02 	add	r0,r2

00030274 <T_IMM_DST16>:
   30274:	00 00 00 02 	add	r0,r2

00030278 <T_IMM_DST17>:
   30278:	00 00 00 02 	add	r0,r2

0003027c <T_IMM_DST18>:
   3027c:	00 00 00 04 	add	r0,r4

00030280 <T_IMM_DST19>:
   30280:	00 00 00 04 	add	r0,r4

00030284 <T_IMM_DST20>:
   30284:	00 00 00 04 	add	r0,r4

00030288 <T_IMM_DST21>:
   30288:	00 00 00 04 	add	r0,r4

0003028c <T_IMM_DST22>:
   3028c:	00 00 00 04 	add	r0,r4

00030290 <T_IMM_DST23>:
   30290:	00 00 00 04 	add	r0,r4

00030294 <T_IMM_DST24>:
   30294:	00 00 00 08 	add	r0,r8

00030298 <T_IMM_DST25>:
   30298:	00 00 00 08 	add	r0,r8

0003029c <T_IMM_DST26>:
   3029c:	00 00 00 08 	add	r0,r8

000302a0 <T_IMM_DST27>:
   302a0:	00 00 00 08 	add	r0,r8

000302a4 <T_IMM_DST28>:
   302a4:	00 00 00 08 	add	r0,r8

000302a8 <T_IMM_DST29>:
   302a8:	00 00 00 08 	add	r0,r8

000302ac <T_IMM_DST30>:
   302ac:	00 00 00 10 	add	r0,r16

000302b0 <T_IMM_DST31>:
   302b0:	00 00 00 10 	add	r0,r16

000302b4 <T_IMM_DST32>:
   302b4:	00 00 00 10 	add	r0,r16

000302b8 <T_IMM_DST33>:
   302b8:	00 00 00 10 	add	r0,r16

000302bc <T_IMM_DST34>:
   302bc:	00 00 00 10 	add	r0,r16

000302c0 <T_IMM_DST35>:
   302c0:	00 00 00 10 	add	r0,r16

000302c4 <T_IMM_DST36>:
   302c4:	00 00 00 20 	add	r1,r0

000302c8 <T_IMM_DST37>:
   302c8:	00 00 00 20 	add	r1,r0

000302cc <T_IMM_DST38>:
   302cc:	00 00 00 20 	add	r1,r0

000302d0 <T_IMM_DST39>:
   302d0:	00 00 00 20 	add	r1,r0

000302d4 <T_IMM_DST40>:
   302d4:	00 00 00 20 	add	r1,r0

000302d8 <T_IMM_DST41>:
   302d8:	00 00 00 20 	add	r1,r0

000302dc <T_IMM_DST42>:
   302dc:	00 00 00 03 	add	r0,r3

000302e0 <T_IMM_DST43>:
   302e0:	00 00 00 07 	add	r0,rtmp

000302e4 <T_IMM_DST44>:
   302e4:	00 00 00 0f 	add	r0,r15

000302e8 <T_IMM_DST45>:
   302e8:	00 00 00 1f 	add	r0,rret

000302ec <T_IMM_DST46>:
   302ec:	00 00 00 3f 	add	r1,rret

000302f0 <T_IMM_EXPECT0>:
   302f0:	00 00 00 00 	add	r0,r0

000302f4 <T_IMM_EXPECT1>:
   302f4:	00 00 00 00 	add	r0,r0

000302f8 <T_IMM_EXPECT2>:
   302f8:	00 00 00 00 	add	r0,r0

000302fc <T_IMM_EXPECT3>:
   302fc:	00 00 00 00 	add	r0,r0

00030300 <T_IMM_EXPECT4>:
   30300:	00 00 00 00 	add	r0,r0

00030304 <T_IMM_EXPECT5>:
   30304:	00 00 00 00 	add	r0,r0

00030308 <T_IMM_EXPECT6>:
   30308:	00 00 00 02 	add	r0,r2

0003030c <T_IMM_EXPECT7>:
   3030c:	00 00 00 04 	add	r0,r4

00030310 <T_IMM_EXPECT8>:
   30310:	00 00 00 10 	add	r0,r16

00030314 <T_IMM_EXPECT9>:
   30314:	00 00 01 00 	add	r8,r0

00030318 <T_IMM_EXPECT10>:
   30318:	00 01 00 00 	*unknown*

0003031c <T_IMM_EXPECT11>:
   3031c:	00 00 00 00 	add	r0,r0

00030320 <T_IMM_EXPECT12>:
   30320:	00 00 00 04 	add	r0,r4

00030324 <T_IMM_EXPECT13>:
   30324:	00 00 00 08 	add	r0,r8

00030328 <T_IMM_EXPECT14>:
   30328:	00 00 00 20 	add	r1,r0

0003032c <T_IMM_EXPECT15>:
   3032c:	00 00 02 00 	add	r16,r0

00030330 <T_IMM_EXPECT16>:
   30330:	00 02 00 00 	*unknown*

00030334 <T_IMM_EXPECT17>:
   30334:	00 00 00 00 	add	r0,r0

00030338 <T_IMM_EXPECT18>:
   30338:	00 00 00 08 	add	r0,r8

0003033c <T_IMM_EXPECT19>:
   3033c:	00 00 00 10 	add	r0,r16

00030340 <T_IMM_EXPECT20>:
   30340:	00 00 00 40 	add	r2,r0

00030344 <T_IMM_EXPECT21>:
   30344:	00 00 04 00 	*unknown*

00030348 <T_IMM_EXPECT22>:
   30348:	00 04 00 00 	*unknown*

0003034c <T_IMM_EXPECT23>:
   3034c:	00 00 00 00 	add	r0,r0

00030350 <T_IMM_EXPECT24>:
   30350:	00 00 00 10 	add	r0,r16

00030354 <T_IMM_EXPECT25>:
   30354:	00 00 00 20 	add	r1,r0

00030358 <T_IMM_EXPECT26>:
   30358:	00 00 00 80 	add	r4,r0

0003035c <T_IMM_EXPECT27>:
   3035c:	00 00 08 00 	*unknown*

00030360 <T_IMM_EXPECT28>:
   30360:	00 08 00 00 	*unknown*

00030364 <T_IMM_EXPECT29>:
   30364:	00 00 00 00 	add	r0,r0

00030368 <T_IMM_EXPECT30>:
   30368:	00 00 00 20 	add	r1,r0

0003036c <T_IMM_EXPECT31>:
   3036c:	00 00 00 40 	add	r2,r0

00030370 <T_IMM_EXPECT32>:
   30370:	00 00 01 00 	add	r8,r0

00030374 <T_IMM_EXPECT33>:
   30374:	00 00 10 00 	*unknown*

00030378 <T_IMM_EXPECT34>:
   30378:	00 10 00 00 	add	r0,0

0003037c <T_IMM_EXPECT35>:
   3037c:	00 00 00 00 	add	r0,r0

00030380 <T_IMM_EXPECT36>:
   30380:	00 00 00 40 	add	r2,r0

00030384 <T_IMM_EXPECT37>:
   30384:	00 00 00 80 	add	r4,r0

00030388 <T_IMM_EXPECT38>:
   30388:	00 00 02 00 	add	r16,r0

0003038c <T_IMM_EXPECT39>:
   3038c:	00 00 20 00 	*unknown*

00030390 <T_IMM_EXPECT40>:
   30390:	00 20 00 00 	sub	r0,r0

00030394 <T_IMM_EXPECT41>:
   30394:	00 00 00 00 	add	r0,r0

00030398 <T_IMM_EXPECT42>:
   30398:	00 00 00 18 	add	r0,r24

0003039c <T_IMM_EXPECT43>:
   3039c:	00 00 03 80 	add	r28,r0

000303a0 <T_IMM_EXPECT44>:
   303a0:	00 07 80 00 	*unknown*

000303a4 <T_IMM_EXPECT45>:
   303a4:	80 00 00 00 	*unknown*

000303a8 <T_IMM_EXPECT46>:
   303a8:	00 00 00 00 	add	r0,r0

セクション .stack の逆アセンブル:

000f0000 <STACK_INDEX>:
   f0000:	00 00 00 00 	add	r0,r0
