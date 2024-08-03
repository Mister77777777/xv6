
user/_xargs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	7125                	addi	sp,sp,-416
   2:	ef06                	sd	ra,408(sp)
   4:	eb22                	sd	s0,400(sp)
   6:	e726                	sd	s1,392(sp)
   8:	e34a                	sd	s2,384(sp)
   a:	fece                	sd	s3,376(sp)
   c:	fad2                	sd	s4,368(sp)
   e:	f6d6                	sd	s5,360(sp)
  10:	f2da                	sd	s6,352(sp)
  12:	eede                	sd	s7,344(sp)
  14:	eae2                	sd	s8,336(sp)
  16:	e6e6                	sd	s9,328(sp)
  18:	1300                	addi	s0,sp,416
  1a:	8c2e                	mv	s8,a1
  1c:	4785                	li	a5,1
  1e:	06a7d063          	bge	a5,a0,7e <main+0x7e>
  22:	00858713          	addi	a4,a1,8
  26:	ea040793          	addi	a5,s0,-352
  2a:	0005099b          	sext.w	s3,a0
  2e:	ffe5061b          	addiw	a2,a0,-2
  32:	02061693          	slli	a3,a2,0x20
  36:	01d6d613          	srli	a2,a3,0x1d
  3a:	ea840693          	addi	a3,s0,-344
  3e:	9636                	add	a2,a2,a3
  40:	6314                	ld	a3,0(a4)
  42:	e394                	sd	a3,0(a5)
  44:	0721                	addi	a4,a4,8
  46:	07a1                	addi	a5,a5,8
  48:	fec79ce3          	bne	a5,a2,40 <main+0x40>
  4c:	39fd                	addiw	s3,s3,-1
  4e:	e6040c93          	addi	s9,s0,-416
  52:	4901                	li	s2,0
  54:	4aa9                	li	s5,10
  56:	fff50b9b          	addiw	s7,a0,-1
  5a:	02000613          	li	a2,32
  5e:	e8040593          	addi	a1,s0,-384
  62:	4501                	li	a0,0
  64:	00000097          	auipc	ra,0x0
  68:	34a080e7          	jalr	842(ra) # 3ae <read>
  6c:	0aa05a63          	blez	a0,120 <main+0x120>
  70:	e8040493          	addi	s1,s0,-384
  74:	00950a33          	add	s4,a0,s1
  78:	02000b13          	li	s6,32
  7c:	a069                	j	106 <main+0x106>
  7e:	4981                	li	s3,0
  80:	b7f9                	j	4e <main+0x4e>
  82:	fa090793          	addi	a5,s2,-96
  86:	00878933          	add	s2,a5,s0
  8a:	ec090023          	sb	zero,-320(s2)
  8e:	00399793          	slli	a5,s3,0x3
  92:	fa078793          	addi	a5,a5,-96
  96:	97a2                	add	a5,a5,s0
  98:	f197b023          	sd	s9,-256(a5)
  9c:	2985                	addiw	s3,s3,1
  9e:	098e                	slli	s3,s3,0x3
  a0:	fa098793          	addi	a5,s3,-96
  a4:	008789b3          	add	s3,a5,s0
  a8:	f009b023          	sd	zero,-256(s3)
  ac:	89de                	mv	s3,s7
  ae:	00000097          	auipc	ra,0x0
  b2:	2e0080e7          	jalr	736(ra) # 38e <fork>
  b6:	c911                	beqz	a0,ca <main+0xca>
  b8:	4501                	li	a0,0
  ba:	00000097          	auipc	ra,0x0
  be:	2e4080e7          	jalr	740(ra) # 39e <wait>
  c2:	e6040c93          	addi	s9,s0,-416
  c6:	4901                	li	s2,0
  c8:	a825                	j	100 <main+0x100>
  ca:	ea040593          	addi	a1,s0,-352
  ce:	008c3503          	ld	a0,8(s8)
  d2:	00000097          	auipc	ra,0x0
  d6:	2fc080e7          	jalr	764(ra) # 3ce <exec>
  da:	bff9                	j	b8 <main+0xb8>
  dc:	fa090793          	addi	a5,s2,-96
  e0:	97a2                	add	a5,a5,s0
  e2:	ec078023          	sb	zero,-320(a5)
  e6:	2905                	addiw	s2,s2,1
  e8:	00399793          	slli	a5,s3,0x3
  ec:	fa078793          	addi	a5,a5,-96
  f0:	97a2                	add	a5,a5,s0
  f2:	f197b023          	sd	s9,-256(a5)
  f6:	2985                	addiw	s3,s3,1
  f8:	e6040793          	addi	a5,s0,-416
  fc:	01278cb3          	add	s9,a5,s2
 100:	0485                	addi	s1,s1,1
 102:	f5448ce3          	beq	s1,s4,5a <main+0x5a>
 106:	0004c783          	lbu	a5,0(s1)
 10a:	f7578ce3          	beq	a5,s5,82 <main+0x82>
 10e:	fd6787e3          	beq	a5,s6,dc <main+0xdc>
 112:	fa090713          	addi	a4,s2,-96
 116:	9722                	add	a4,a4,s0
 118:	ecf70023          	sb	a5,-320(a4)
 11c:	2905                	addiw	s2,s2,1
 11e:	b7cd                	j	100 <main+0x100>
 120:	4501                	li	a0,0
 122:	00000097          	auipc	ra,0x0
 126:	274080e7          	jalr	628(ra) # 396 <exit>

000000000000012a <strcpy>:
 12a:	1141                	addi	sp,sp,-16
 12c:	e422                	sd	s0,8(sp)
 12e:	0800                	addi	s0,sp,16
 130:	87aa                	mv	a5,a0
 132:	0585                	addi	a1,a1,1
 134:	0785                	addi	a5,a5,1
 136:	fff5c703          	lbu	a4,-1(a1)
 13a:	fee78fa3          	sb	a4,-1(a5)
 13e:	fb75                	bnez	a4,132 <strcpy+0x8>
 140:	6422                	ld	s0,8(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret

0000000000000146 <strcmp>:
 146:	1141                	addi	sp,sp,-16
 148:	e422                	sd	s0,8(sp)
 14a:	0800                	addi	s0,sp,16
 14c:	00054783          	lbu	a5,0(a0)
 150:	cb91                	beqz	a5,164 <strcmp+0x1e>
 152:	0005c703          	lbu	a4,0(a1)
 156:	00f71763          	bne	a4,a5,164 <strcmp+0x1e>
 15a:	0505                	addi	a0,a0,1
 15c:	0585                	addi	a1,a1,1
 15e:	00054783          	lbu	a5,0(a0)
 162:	fbe5                	bnez	a5,152 <strcmp+0xc>
 164:	0005c503          	lbu	a0,0(a1)
 168:	40a7853b          	subw	a0,a5,a0
 16c:	6422                	ld	s0,8(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret

0000000000000172 <strlen>:
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
 178:	00054783          	lbu	a5,0(a0)
 17c:	cf91                	beqz	a5,198 <strlen+0x26>
 17e:	0505                	addi	a0,a0,1
 180:	87aa                	mv	a5,a0
 182:	86be                	mv	a3,a5
 184:	0785                	addi	a5,a5,1
 186:	fff7c703          	lbu	a4,-1(a5)
 18a:	ff65                	bnez	a4,182 <strlen+0x10>
 18c:	40a6853b          	subw	a0,a3,a0
 190:	2505                	addiw	a0,a0,1
 192:	6422                	ld	s0,8(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret
 198:	4501                	li	a0,0
 19a:	bfe5                	j	192 <strlen+0x20>

000000000000019c <memset>:
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
 1a2:	ca19                	beqz	a2,1b8 <memset+0x1c>
 1a4:	87aa                	mv	a5,a0
 1a6:	1602                	slli	a2,a2,0x20
 1a8:	9201                	srli	a2,a2,0x20
 1aa:	00a60733          	add	a4,a2,a0
 1ae:	00b78023          	sb	a1,0(a5)
 1b2:	0785                	addi	a5,a5,1
 1b4:	fee79de3          	bne	a5,a4,1ae <memset+0x12>
 1b8:	6422                	ld	s0,8(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <strchr>:
 1be:	1141                	addi	sp,sp,-16
 1c0:	e422                	sd	s0,8(sp)
 1c2:	0800                	addi	s0,sp,16
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	cb99                	beqz	a5,1de <strchr+0x20>
 1ca:	00f58763          	beq	a1,a5,1d8 <strchr+0x1a>
 1ce:	0505                	addi	a0,a0,1
 1d0:	00054783          	lbu	a5,0(a0)
 1d4:	fbfd                	bnez	a5,1ca <strchr+0xc>
 1d6:	4501                	li	a0,0
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret
 1de:	4501                	li	a0,0
 1e0:	bfe5                	j	1d8 <strchr+0x1a>

00000000000001e2 <gets>:
 1e2:	711d                	addi	sp,sp,-96
 1e4:	ec86                	sd	ra,88(sp)
 1e6:	e8a2                	sd	s0,80(sp)
 1e8:	e4a6                	sd	s1,72(sp)
 1ea:	e0ca                	sd	s2,64(sp)
 1ec:	fc4e                	sd	s3,56(sp)
 1ee:	f852                	sd	s4,48(sp)
 1f0:	f456                	sd	s5,40(sp)
 1f2:	f05a                	sd	s6,32(sp)
 1f4:	ec5e                	sd	s7,24(sp)
 1f6:	1080                	addi	s0,sp,96
 1f8:	8baa                	mv	s7,a0
 1fa:	8a2e                	mv	s4,a1
 1fc:	892a                	mv	s2,a0
 1fe:	4481                	li	s1,0
 200:	4aa9                	li	s5,10
 202:	4b35                	li	s6,13
 204:	89a6                	mv	s3,s1
 206:	2485                	addiw	s1,s1,1
 208:	0344d863          	bge	s1,s4,238 <gets+0x56>
 20c:	4605                	li	a2,1
 20e:	faf40593          	addi	a1,s0,-81
 212:	4501                	li	a0,0
 214:	00000097          	auipc	ra,0x0
 218:	19a080e7          	jalr	410(ra) # 3ae <read>
 21c:	00a05e63          	blez	a0,238 <gets+0x56>
 220:	faf44783          	lbu	a5,-81(s0)
 224:	00f90023          	sb	a5,0(s2)
 228:	01578763          	beq	a5,s5,236 <gets+0x54>
 22c:	0905                	addi	s2,s2,1
 22e:	fd679be3          	bne	a5,s6,204 <gets+0x22>
 232:	89a6                	mv	s3,s1
 234:	a011                	j	238 <gets+0x56>
 236:	89a6                	mv	s3,s1
 238:	99de                	add	s3,s3,s7
 23a:	00098023          	sb	zero,0(s3)
 23e:	855e                	mv	a0,s7
 240:	60e6                	ld	ra,88(sp)
 242:	6446                	ld	s0,80(sp)
 244:	64a6                	ld	s1,72(sp)
 246:	6906                	ld	s2,64(sp)
 248:	79e2                	ld	s3,56(sp)
 24a:	7a42                	ld	s4,48(sp)
 24c:	7aa2                	ld	s5,40(sp)
 24e:	7b02                	ld	s6,32(sp)
 250:	6be2                	ld	s7,24(sp)
 252:	6125                	addi	sp,sp,96
 254:	8082                	ret

0000000000000256 <stat>:
 256:	1101                	addi	sp,sp,-32
 258:	ec06                	sd	ra,24(sp)
 25a:	e822                	sd	s0,16(sp)
 25c:	e04a                	sd	s2,0(sp)
 25e:	1000                	addi	s0,sp,32
 260:	892e                	mv	s2,a1
 262:	4581                	li	a1,0
 264:	00000097          	auipc	ra,0x0
 268:	172080e7          	jalr	370(ra) # 3d6 <open>
 26c:	02054663          	bltz	a0,298 <stat+0x42>
 270:	e426                	sd	s1,8(sp)
 272:	84aa                	mv	s1,a0
 274:	85ca                	mv	a1,s2
 276:	00000097          	auipc	ra,0x0
 27a:	178080e7          	jalr	376(ra) # 3ee <fstat>
 27e:	892a                	mv	s2,a0
 280:	8526                	mv	a0,s1
 282:	00000097          	auipc	ra,0x0
 286:	13c080e7          	jalr	316(ra) # 3be <close>
 28a:	64a2                	ld	s1,8(sp)
 28c:	854a                	mv	a0,s2
 28e:	60e2                	ld	ra,24(sp)
 290:	6442                	ld	s0,16(sp)
 292:	6902                	ld	s2,0(sp)
 294:	6105                	addi	sp,sp,32
 296:	8082                	ret
 298:	597d                	li	s2,-1
 29a:	bfcd                	j	28c <stat+0x36>

000000000000029c <atoi>:
 29c:	1141                	addi	sp,sp,-16
 29e:	e422                	sd	s0,8(sp)
 2a0:	0800                	addi	s0,sp,16
 2a2:	00054683          	lbu	a3,0(a0)
 2a6:	fd06879b          	addiw	a5,a3,-48
 2aa:	0ff7f793          	zext.b	a5,a5
 2ae:	4625                	li	a2,9
 2b0:	02f66863          	bltu	a2,a5,2e0 <atoi+0x44>
 2b4:	872a                	mv	a4,a0
 2b6:	4501                	li	a0,0
 2b8:	0705                	addi	a4,a4,1
 2ba:	0025179b          	slliw	a5,a0,0x2
 2be:	9fa9                	addw	a5,a5,a0
 2c0:	0017979b          	slliw	a5,a5,0x1
 2c4:	9fb5                	addw	a5,a5,a3
 2c6:	fd07851b          	addiw	a0,a5,-48
 2ca:	00074683          	lbu	a3,0(a4)
 2ce:	fd06879b          	addiw	a5,a3,-48
 2d2:	0ff7f793          	zext.b	a5,a5
 2d6:	fef671e3          	bgeu	a2,a5,2b8 <atoi+0x1c>
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
 2e0:	4501                	li	a0,0
 2e2:	bfe5                	j	2da <atoi+0x3e>

00000000000002e4 <memmove>:
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	addi	s0,sp,16
 2ea:	02b57463          	bgeu	a0,a1,312 <memmove+0x2e>
 2ee:	00c05f63          	blez	a2,30c <memmove+0x28>
 2f2:	1602                	slli	a2,a2,0x20
 2f4:	9201                	srli	a2,a2,0x20
 2f6:	00c507b3          	add	a5,a0,a2
 2fa:	872a                	mv	a4,a0
 2fc:	0585                	addi	a1,a1,1
 2fe:	0705                	addi	a4,a4,1
 300:	fff5c683          	lbu	a3,-1(a1)
 304:	fed70fa3          	sb	a3,-1(a4)
 308:	fef71ae3          	bne	a4,a5,2fc <memmove+0x18>
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret
 312:	00c50733          	add	a4,a0,a2
 316:	95b2                	add	a1,a1,a2
 318:	fec05ae3          	blez	a2,30c <memmove+0x28>
 31c:	fff6079b          	addiw	a5,a2,-1
 320:	1782                	slli	a5,a5,0x20
 322:	9381                	srli	a5,a5,0x20
 324:	fff7c793          	not	a5,a5
 328:	97ba                	add	a5,a5,a4
 32a:	15fd                	addi	a1,a1,-1
 32c:	177d                	addi	a4,a4,-1
 32e:	0005c683          	lbu	a3,0(a1)
 332:	00d70023          	sb	a3,0(a4)
 336:	fee79ae3          	bne	a5,a4,32a <memmove+0x46>
 33a:	bfc9                	j	30c <memmove+0x28>

000000000000033c <memcmp>:
 33c:	1141                	addi	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	addi	s0,sp,16
 342:	ca05                	beqz	a2,372 <memcmp+0x36>
 344:	fff6069b          	addiw	a3,a2,-1
 348:	1682                	slli	a3,a3,0x20
 34a:	9281                	srli	a3,a3,0x20
 34c:	0685                	addi	a3,a3,1
 34e:	96aa                	add	a3,a3,a0
 350:	00054783          	lbu	a5,0(a0)
 354:	0005c703          	lbu	a4,0(a1)
 358:	00e79863          	bne	a5,a4,368 <memcmp+0x2c>
 35c:	0505                	addi	a0,a0,1
 35e:	0585                	addi	a1,a1,1
 360:	fed518e3          	bne	a0,a3,350 <memcmp+0x14>
 364:	4501                	li	a0,0
 366:	a019                	j	36c <memcmp+0x30>
 368:	40e7853b          	subw	a0,a5,a4
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret
 372:	4501                	li	a0,0
 374:	bfe5                	j	36c <memcmp+0x30>

0000000000000376 <memcpy>:
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
 37e:	00000097          	auipc	ra,0x0
 382:	f66080e7          	jalr	-154(ra) # 2e4 <memmove>
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret

000000000000038e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38e:	4885                	li	a7,1
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <exit>:
.global exit
exit:
 li a7, SYS_exit
 396:	4889                	li	a7,2
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <wait>:
.global wait
wait:
 li a7, SYS_wait
 39e:	488d                	li	a7,3
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a6:	4891                	li	a7,4
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <read>:
.global read
read:
 li a7, SYS_read
 3ae:	4895                	li	a7,5
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <write>:
.global write
write:
 li a7, SYS_write
 3b6:	48c1                	li	a7,16
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <close>:
.global close
close:
 li a7, SYS_close
 3be:	48d5                	li	a7,21
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c6:	4899                	li	a7,6
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ce:	489d                	li	a7,7
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <open>:
.global open
open:
 li a7, SYS_open
 3d6:	48bd                	li	a7,15
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3de:	48c5                	li	a7,17
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e6:	48c9                	li	a7,18
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ee:	48a1                	li	a7,8
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <link>:
.global link
link:
 li a7, SYS_link
 3f6:	48cd                	li	a7,19
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fe:	48d1                	li	a7,20
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 406:	48a5                	li	a7,9
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <dup>:
.global dup
dup:
 li a7, SYS_dup
 40e:	48a9                	li	a7,10
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 416:	48ad                	li	a7,11
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41e:	48b1                	li	a7,12
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 426:	48b5                	li	a7,13
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42e:	48b9                	li	a7,14
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 436:	1101                	addi	sp,sp,-32
 438:	ec06                	sd	ra,24(sp)
 43a:	e822                	sd	s0,16(sp)
 43c:	1000                	addi	s0,sp,32
 43e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 442:	4605                	li	a2,1
 444:	fef40593          	addi	a1,s0,-17
 448:	00000097          	auipc	ra,0x0
 44c:	f6e080e7          	jalr	-146(ra) # 3b6 <write>
}
 450:	60e2                	ld	ra,24(sp)
 452:	6442                	ld	s0,16(sp)
 454:	6105                	addi	sp,sp,32
 456:	8082                	ret

0000000000000458 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 458:	7139                	addi	sp,sp,-64
 45a:	fc06                	sd	ra,56(sp)
 45c:	f822                	sd	s0,48(sp)
 45e:	f426                	sd	s1,40(sp)
 460:	0080                	addi	s0,sp,64
 462:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 464:	c299                	beqz	a3,46a <printint+0x12>
 466:	0805cb63          	bltz	a1,4fc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 46a:	2581                	sext.w	a1,a1
  neg = 0;
 46c:	4881                	li	a7,0
 46e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 472:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 474:	2601                	sext.w	a2,a2
 476:	00000517          	auipc	a0,0x0
 47a:	4a250513          	addi	a0,a0,1186 # 918 <digits>
 47e:	883a                	mv	a6,a4
 480:	2705                	addiw	a4,a4,1
 482:	02c5f7bb          	remuw	a5,a1,a2
 486:	1782                	slli	a5,a5,0x20
 488:	9381                	srli	a5,a5,0x20
 48a:	97aa                	add	a5,a5,a0
 48c:	0007c783          	lbu	a5,0(a5)
 490:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 494:	0005879b          	sext.w	a5,a1
 498:	02c5d5bb          	divuw	a1,a1,a2
 49c:	0685                	addi	a3,a3,1
 49e:	fec7f0e3          	bgeu	a5,a2,47e <printint+0x26>
  if(neg)
 4a2:	00088c63          	beqz	a7,4ba <printint+0x62>
    buf[i++] = '-';
 4a6:	fd070793          	addi	a5,a4,-48
 4aa:	00878733          	add	a4,a5,s0
 4ae:	02d00793          	li	a5,45
 4b2:	fef70823          	sb	a5,-16(a4)
 4b6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ba:	02e05c63          	blez	a4,4f2 <printint+0x9a>
 4be:	f04a                	sd	s2,32(sp)
 4c0:	ec4e                	sd	s3,24(sp)
 4c2:	fc040793          	addi	a5,s0,-64
 4c6:	00e78933          	add	s2,a5,a4
 4ca:	fff78993          	addi	s3,a5,-1
 4ce:	99ba                	add	s3,s3,a4
 4d0:	377d                	addiw	a4,a4,-1
 4d2:	1702                	slli	a4,a4,0x20
 4d4:	9301                	srli	a4,a4,0x20
 4d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4da:	fff94583          	lbu	a1,-1(s2)
 4de:	8526                	mv	a0,s1
 4e0:	00000097          	auipc	ra,0x0
 4e4:	f56080e7          	jalr	-170(ra) # 436 <putc>
  while(--i >= 0)
 4e8:	197d                	addi	s2,s2,-1
 4ea:	ff3918e3          	bne	s2,s3,4da <printint+0x82>
 4ee:	7902                	ld	s2,32(sp)
 4f0:	69e2                	ld	s3,24(sp)
}
 4f2:	70e2                	ld	ra,56(sp)
 4f4:	7442                	ld	s0,48(sp)
 4f6:	74a2                	ld	s1,40(sp)
 4f8:	6121                	addi	sp,sp,64
 4fa:	8082                	ret
    x = -xx;
 4fc:	40b005bb          	negw	a1,a1
    neg = 1;
 500:	4885                	li	a7,1
    x = -xx;
 502:	b7b5                	j	46e <printint+0x16>

0000000000000504 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 504:	715d                	addi	sp,sp,-80
 506:	e486                	sd	ra,72(sp)
 508:	e0a2                	sd	s0,64(sp)
 50a:	f84a                	sd	s2,48(sp)
 50c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 50e:	0005c903          	lbu	s2,0(a1)
 512:	1a090a63          	beqz	s2,6c6 <vprintf+0x1c2>
 516:	fc26                	sd	s1,56(sp)
 518:	f44e                	sd	s3,40(sp)
 51a:	f052                	sd	s4,32(sp)
 51c:	ec56                	sd	s5,24(sp)
 51e:	e85a                	sd	s6,16(sp)
 520:	e45e                	sd	s7,8(sp)
 522:	8aaa                	mv	s5,a0
 524:	8bb2                	mv	s7,a2
 526:	00158493          	addi	s1,a1,1
  state = 0;
 52a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 52c:	02500a13          	li	s4,37
 530:	4b55                	li	s6,21
 532:	a839                	j	550 <vprintf+0x4c>
        putc(fd, c);
 534:	85ca                	mv	a1,s2
 536:	8556                	mv	a0,s5
 538:	00000097          	auipc	ra,0x0
 53c:	efe080e7          	jalr	-258(ra) # 436 <putc>
 540:	a019                	j	546 <vprintf+0x42>
    } else if(state == '%'){
 542:	01498d63          	beq	s3,s4,55c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 546:	0485                	addi	s1,s1,1
 548:	fff4c903          	lbu	s2,-1(s1)
 54c:	16090763          	beqz	s2,6ba <vprintf+0x1b6>
    if(state == 0){
 550:	fe0999e3          	bnez	s3,542 <vprintf+0x3e>
      if(c == '%'){
 554:	ff4910e3          	bne	s2,s4,534 <vprintf+0x30>
        state = '%';
 558:	89d2                	mv	s3,s4
 55a:	b7f5                	j	546 <vprintf+0x42>
      if(c == 'd'){
 55c:	13490463          	beq	s2,s4,684 <vprintf+0x180>
 560:	f9d9079b          	addiw	a5,s2,-99
 564:	0ff7f793          	zext.b	a5,a5
 568:	12fb6763          	bltu	s6,a5,696 <vprintf+0x192>
 56c:	f9d9079b          	addiw	a5,s2,-99
 570:	0ff7f713          	zext.b	a4,a5
 574:	12eb6163          	bltu	s6,a4,696 <vprintf+0x192>
 578:	00271793          	slli	a5,a4,0x2
 57c:	00000717          	auipc	a4,0x0
 580:	34470713          	addi	a4,a4,836 # 8c0 <malloc+0x10a>
 584:	97ba                	add	a5,a5,a4
 586:	439c                	lw	a5,0(a5)
 588:	97ba                	add	a5,a5,a4
 58a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 58c:	008b8913          	addi	s2,s7,8
 590:	4685                	li	a3,1
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	ebe080e7          	jalr	-322(ra) # 458 <printint>
 5a2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b745                	j	546 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4629                	li	a2,10
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	ea2080e7          	jalr	-350(ra) # 458 <printint>
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b751                	j	546 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4641                	li	a2,16
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e86080e7          	jalr	-378(ra) # 458 <printint>
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b7a5                	j	546 <vprintf+0x42>
 5e0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5e2:	008b8c13          	addi	s8,s7,8
 5e6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ea:	03000593          	li	a1,48
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e46080e7          	jalr	-442(ra) # 436 <putc>
  putc(fd, 'x');
 5f8:	07800593          	li	a1,120
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e38080e7          	jalr	-456(ra) # 436 <putc>
 606:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 608:	00000b97          	auipc	s7,0x0
 60c:	310b8b93          	addi	s7,s7,784 # 918 <digits>
 610:	03c9d793          	srli	a5,s3,0x3c
 614:	97de                	add	a5,a5,s7
 616:	0007c583          	lbu	a1,0(a5)
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	e1a080e7          	jalr	-486(ra) # 436 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 624:	0992                	slli	s3,s3,0x4
 626:	397d                	addiw	s2,s2,-1
 628:	fe0914e3          	bnez	s2,610 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 62c:	8be2                	mv	s7,s8
      state = 0;
 62e:	4981                	li	s3,0
 630:	6c02                	ld	s8,0(sp)
 632:	bf11                	j	546 <vprintf+0x42>
        s = va_arg(ap, char*);
 634:	008b8993          	addi	s3,s7,8
 638:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 63c:	02090163          	beqz	s2,65e <vprintf+0x15a>
        while(*s != 0){
 640:	00094583          	lbu	a1,0(s2)
 644:	c9a5                	beqz	a1,6b4 <vprintf+0x1b0>
          putc(fd, *s);
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	dee080e7          	jalr	-530(ra) # 436 <putc>
          s++;
 650:	0905                	addi	s2,s2,1
        while(*s != 0){
 652:	00094583          	lbu	a1,0(s2)
 656:	f9e5                	bnez	a1,646 <vprintf+0x142>
        s = va_arg(ap, char*);
 658:	8bce                	mv	s7,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b5ed                	j	546 <vprintf+0x42>
          s = "(null)";
 65e:	00000917          	auipc	s2,0x0
 662:	25a90913          	addi	s2,s2,602 # 8b8 <malloc+0x102>
        while(*s != 0){
 666:	02800593          	li	a1,40
 66a:	bff1                	j	646 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 66c:	008b8913          	addi	s2,s7,8
 670:	000bc583          	lbu	a1,0(s7)
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	dc0080e7          	jalr	-576(ra) # 436 <putc>
 67e:	8bca                	mv	s7,s2
      state = 0;
 680:	4981                	li	s3,0
 682:	b5d1                	j	546 <vprintf+0x42>
        putc(fd, c);
 684:	02500593          	li	a1,37
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	dac080e7          	jalr	-596(ra) # 436 <putc>
      state = 0;
 692:	4981                	li	s3,0
 694:	bd4d                	j	546 <vprintf+0x42>
        putc(fd, '%');
 696:	02500593          	li	a1,37
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	d9a080e7          	jalr	-614(ra) # 436 <putc>
        putc(fd, c);
 6a4:	85ca                	mv	a1,s2
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	d8e080e7          	jalr	-626(ra) # 436 <putc>
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bd51                	j	546 <vprintf+0x42>
        s = va_arg(ap, char*);
 6b4:	8bce                	mv	s7,s3
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b579                	j	546 <vprintf+0x42>
 6ba:	74e2                	ld	s1,56(sp)
 6bc:	79a2                	ld	s3,40(sp)
 6be:	7a02                	ld	s4,32(sp)
 6c0:	6ae2                	ld	s5,24(sp)
 6c2:	6b42                	ld	s6,16(sp)
 6c4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6c6:	60a6                	ld	ra,72(sp)
 6c8:	6406                	ld	s0,64(sp)
 6ca:	7942                	ld	s2,48(sp)
 6cc:	6161                	addi	sp,sp,80
 6ce:	8082                	ret

00000000000006d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d0:	715d                	addi	sp,sp,-80
 6d2:	ec06                	sd	ra,24(sp)
 6d4:	e822                	sd	s0,16(sp)
 6d6:	1000                	addi	s0,sp,32
 6d8:	e010                	sd	a2,0(s0)
 6da:	e414                	sd	a3,8(s0)
 6dc:	e818                	sd	a4,16(s0)
 6de:	ec1c                	sd	a5,24(s0)
 6e0:	03043023          	sd	a6,32(s0)
 6e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ec:	8622                	mv	a2,s0
 6ee:	00000097          	auipc	ra,0x0
 6f2:	e16080e7          	jalr	-490(ra) # 504 <vprintf>
}
 6f6:	60e2                	ld	ra,24(sp)
 6f8:	6442                	ld	s0,16(sp)
 6fa:	6161                	addi	sp,sp,80
 6fc:	8082                	ret

00000000000006fe <printf>:

void
printf(const char *fmt, ...)
{
 6fe:	711d                	addi	sp,sp,-96
 700:	ec06                	sd	ra,24(sp)
 702:	e822                	sd	s0,16(sp)
 704:	1000                	addi	s0,sp,32
 706:	e40c                	sd	a1,8(s0)
 708:	e810                	sd	a2,16(s0)
 70a:	ec14                	sd	a3,24(s0)
 70c:	f018                	sd	a4,32(s0)
 70e:	f41c                	sd	a5,40(s0)
 710:	03043823          	sd	a6,48(s0)
 714:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 718:	00840613          	addi	a2,s0,8
 71c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 720:	85aa                	mv	a1,a0
 722:	4505                	li	a0,1
 724:	00000097          	auipc	ra,0x0
 728:	de0080e7          	jalr	-544(ra) # 504 <vprintf>
}
 72c:	60e2                	ld	ra,24(sp)
 72e:	6442                	ld	s0,16(sp)
 730:	6125                	addi	sp,sp,96
 732:	8082                	ret

0000000000000734 <free>:
 734:	1141                	addi	sp,sp,-16
 736:	e422                	sd	s0,8(sp)
 738:	0800                	addi	s0,sp,16
 73a:	ff050693          	addi	a3,a0,-16
 73e:	00000797          	auipc	a5,0x0
 742:	5ba7b783          	ld	a5,1466(a5) # cf8 <freep>
 746:	a02d                	j	770 <free+0x3c>
 748:	4618                	lw	a4,8(a2)
 74a:	9f2d                	addw	a4,a4,a1
 74c:	fee52c23          	sw	a4,-8(a0)
 750:	6398                	ld	a4,0(a5)
 752:	6310                	ld	a2,0(a4)
 754:	a83d                	j	792 <free+0x5e>
 756:	ff852703          	lw	a4,-8(a0)
 75a:	9f31                	addw	a4,a4,a2
 75c:	c798                	sw	a4,8(a5)
 75e:	ff053683          	ld	a3,-16(a0)
 762:	a091                	j	7a6 <free+0x72>
 764:	6398                	ld	a4,0(a5)
 766:	00e7e463          	bltu	a5,a4,76e <free+0x3a>
 76a:	00e6ea63          	bltu	a3,a4,77e <free+0x4a>
 76e:	87ba                	mv	a5,a4
 770:	fed7fae3          	bgeu	a5,a3,764 <free+0x30>
 774:	6398                	ld	a4,0(a5)
 776:	00e6e463          	bltu	a3,a4,77e <free+0x4a>
 77a:	fee7eae3          	bltu	a5,a4,76e <free+0x3a>
 77e:	ff852583          	lw	a1,-8(a0)
 782:	6390                	ld	a2,0(a5)
 784:	02059813          	slli	a6,a1,0x20
 788:	01c85713          	srli	a4,a6,0x1c
 78c:	9736                	add	a4,a4,a3
 78e:	fae60de3          	beq	a2,a4,748 <free+0x14>
 792:	fec53823          	sd	a2,-16(a0)
 796:	4790                	lw	a2,8(a5)
 798:	02061593          	slli	a1,a2,0x20
 79c:	01c5d713          	srli	a4,a1,0x1c
 7a0:	973e                	add	a4,a4,a5
 7a2:	fae68ae3          	beq	a3,a4,756 <free+0x22>
 7a6:	e394                	sd	a3,0(a5)
 7a8:	00000717          	auipc	a4,0x0
 7ac:	54f73823          	sd	a5,1360(a4) # cf8 <freep>
 7b0:	6422                	ld	s0,8(sp)
 7b2:	0141                	addi	sp,sp,16
 7b4:	8082                	ret

00000000000007b6 <malloc>:
 7b6:	7139                	addi	sp,sp,-64
 7b8:	fc06                	sd	ra,56(sp)
 7ba:	f822                	sd	s0,48(sp)
 7bc:	f426                	sd	s1,40(sp)
 7be:	ec4e                	sd	s3,24(sp)
 7c0:	0080                	addi	s0,sp,64
 7c2:	02051493          	slli	s1,a0,0x20
 7c6:	9081                	srli	s1,s1,0x20
 7c8:	04bd                	addi	s1,s1,15
 7ca:	8091                	srli	s1,s1,0x4
 7cc:	0014899b          	addiw	s3,s1,1
 7d0:	0485                	addi	s1,s1,1
 7d2:	00000517          	auipc	a0,0x0
 7d6:	52653503          	ld	a0,1318(a0) # cf8 <freep>
 7da:	c915                	beqz	a0,80e <malloc+0x58>
 7dc:	611c                	ld	a5,0(a0)
 7de:	4798                	lw	a4,8(a5)
 7e0:	08977e63          	bgeu	a4,s1,87c <malloc+0xc6>
 7e4:	f04a                	sd	s2,32(sp)
 7e6:	e852                	sd	s4,16(sp)
 7e8:	e456                	sd	s5,8(sp)
 7ea:	e05a                	sd	s6,0(sp)
 7ec:	8a4e                	mv	s4,s3
 7ee:	0009871b          	sext.w	a4,s3
 7f2:	6685                	lui	a3,0x1
 7f4:	00d77363          	bgeu	a4,a3,7fa <malloc+0x44>
 7f8:	6a05                	lui	s4,0x1
 7fa:	000a0b1b          	sext.w	s6,s4
 7fe:	004a1a1b          	slliw	s4,s4,0x4
 802:	00000917          	auipc	s2,0x0
 806:	4f690913          	addi	s2,s2,1270 # cf8 <freep>
 80a:	5afd                	li	s5,-1
 80c:	a091                	j	850 <malloc+0x9a>
 80e:	f04a                	sd	s2,32(sp)
 810:	e852                	sd	s4,16(sp)
 812:	e456                	sd	s5,8(sp)
 814:	e05a                	sd	s6,0(sp)
 816:	00000797          	auipc	a5,0x0
 81a:	4ea78793          	addi	a5,a5,1258 # d00 <base>
 81e:	00000717          	auipc	a4,0x0
 822:	4cf73d23          	sd	a5,1242(a4) # cf8 <freep>
 826:	e39c                	sd	a5,0(a5)
 828:	0007a423          	sw	zero,8(a5)
 82c:	b7c1                	j	7ec <malloc+0x36>
 82e:	6398                	ld	a4,0(a5)
 830:	e118                	sd	a4,0(a0)
 832:	a08d                	j	894 <malloc+0xde>
 834:	01652423          	sw	s6,8(a0)
 838:	0541                	addi	a0,a0,16
 83a:	00000097          	auipc	ra,0x0
 83e:	efa080e7          	jalr	-262(ra) # 734 <free>
 842:	00093503          	ld	a0,0(s2)
 846:	c13d                	beqz	a0,8ac <malloc+0xf6>
 848:	611c                	ld	a5,0(a0)
 84a:	4798                	lw	a4,8(a5)
 84c:	02977463          	bgeu	a4,s1,874 <malloc+0xbe>
 850:	00093703          	ld	a4,0(s2)
 854:	853e                	mv	a0,a5
 856:	fef719e3          	bne	a4,a5,848 <malloc+0x92>
 85a:	8552                	mv	a0,s4
 85c:	00000097          	auipc	ra,0x0
 860:	bc2080e7          	jalr	-1086(ra) # 41e <sbrk>
 864:	fd5518e3          	bne	a0,s5,834 <malloc+0x7e>
 868:	4501                	li	a0,0
 86a:	7902                	ld	s2,32(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6b02                	ld	s6,0(sp)
 872:	a03d                	j	8a0 <malloc+0xea>
 874:	7902                	ld	s2,32(sp)
 876:	6a42                	ld	s4,16(sp)
 878:	6aa2                	ld	s5,8(sp)
 87a:	6b02                	ld	s6,0(sp)
 87c:	fae489e3          	beq	s1,a4,82e <malloc+0x78>
 880:	4137073b          	subw	a4,a4,s3
 884:	c798                	sw	a4,8(a5)
 886:	02071693          	slli	a3,a4,0x20
 88a:	01c6d713          	srli	a4,a3,0x1c
 88e:	97ba                	add	a5,a5,a4
 890:	0137a423          	sw	s3,8(a5)
 894:	00000717          	auipc	a4,0x0
 898:	46a73223          	sd	a0,1124(a4) # cf8 <freep>
 89c:	01078513          	addi	a0,a5,16
 8a0:	70e2                	ld	ra,56(sp)
 8a2:	7442                	ld	s0,48(sp)
 8a4:	74a2                	ld	s1,40(sp)
 8a6:	69e2                	ld	s3,24(sp)
 8a8:	6121                	addi	sp,sp,64
 8aa:	8082                	ret
 8ac:	7902                	ld	s2,32(sp)
 8ae:	6a42                	ld	s4,16(sp)
 8b0:	6aa2                	ld	s5,8(sp)
 8b2:	6b02                	ld	s6,0(sp)
 8b4:	b7f5                	j	8a0 <malloc+0xea>
