
user/_primes：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:

#define READ 0
#define WRITE 1

void primes(int num[],int size)
{
   0:	7155                	addi	sp,sp,-208
   2:	e586                	sd	ra,200(sp)
   4:	e1a2                	sd	s0,192(sp)
   6:	f94a                	sd	s2,176(sp)
   8:	f54e                	sd	s3,168(sp)
   a:	0980                	addi	s0,sp,208
   c:	892a                	mv	s2,a0
   e:	89ae                	mv	s3,a1
    int my_pipe[2];
    pipe(my_pipe);
  10:	fc840513          	addi	a0,s0,-56
  14:	00000097          	auipc	ra,0x0
  18:	3a6080e7          	jalr	934(ra) # 3ba <pipe>
    if(fork() > 0)   /*write to right pipe*/
  1c:	00000097          	auipc	ra,0x0
  20:	386080e7          	jalr	902(ra) # 3a2 <fork>
  24:	04a05b63          	blez	a0,7a <primes+0x7a>
    {
        close(my_pipe[READ]); 
  28:	fc842503          	lw	a0,-56(s0)
  2c:	00000097          	auipc	ra,0x0
  30:	3a6080e7          	jalr	934(ra) # 3d2 <close>

        for(int i=0;i<size;i++)
  34:	03305263          	blez	s3,58 <primes+0x58>
  38:	fd26                	sd	s1,184(sp)
  3a:	84ca                	mv	s1,s2
  3c:	098a                	slli	s3,s3,0x2
  3e:	994e                	add	s2,s2,s3
        write(my_pipe[WRITE],&num[i],sizeof(num[i]));
  40:	4611                	li	a2,4
  42:	85a6                	mv	a1,s1
  44:	fcc42503          	lw	a0,-52(s0)
  48:	00000097          	auipc	ra,0x0
  4c:	382080e7          	jalr	898(ra) # 3ca <write>
        for(int i=0;i<size;i++)
  50:	0491                	addi	s1,s1,4
  52:	ff2497e3          	bne	s1,s2,40 <primes+0x40>
  56:	74ea                	ld	s1,184(sp)

        close(my_pipe[WRITE]);
  58:	fcc42503          	lw	a0,-52(s0)
  5c:	00000097          	auipc	ra,0x0
  60:	376080e7          	jalr	886(ra) # 3d2 <close>
        wait(0);
  64:	4501                	li	a0,0
  66:	00000097          	auipc	ra,0x0
  6a:	34c080e7          	jalr	844(ra) # 3b2 <wait>
        close(my_pipe[READ]);
        primes(chr_num,index-1);
        exit(0);

    }
}
  6e:	60ae                	ld	ra,200(sp)
  70:	640e                	ld	s0,192(sp)
  72:	794a                	ld	s2,176(sp)
  74:	79aa                	ld	s3,168(sp)
  76:	6169                	addi	sp,sp,208
  78:	8082                	ret
  7a:	fd26                	sd	s1,184(sp)
  7c:	f152                	sd	s4,160(sp)
  7e:	4481                	li	s1,0
        close(my_pipe[WRITE]);
  80:	fcc42503          	lw	a0,-52(s0)
  84:	00000097          	auipc	ra,0x0
  88:	34e080e7          	jalr	846(ra) # 3d2 <close>
        int chr_num[34],index=0;
  8c:	4901                	li	s2,0
                    printf("prime %d\n",min);
  8e:	00001a17          	auipc	s4,0x1
  92:	842a0a13          	addi	s4,s4,-1982 # 8d0 <malloc+0x106>
                    index++;
  96:	4985                	li	s3,1
            if(read(my_pipe[READ],&tmp,sizeof(tmp)))
  98:	4611                	li	a2,4
  9a:	f3c40593          	addi	a1,s0,-196
  9e:	fc842503          	lw	a0,-56(s0)
  a2:	00000097          	auipc	ra,0x0
  a6:	320080e7          	jalr	800(ra) # 3c2 <read>
  aa:	cd05                	beqz	a0,e2 <primes+0xe2>
                if(index ==0)
  ac:	02090163          	beqz	s2,ce <primes+0xce>
                if(tmp%min != 0) /* not primes*/
  b0:	f3c42703          	lw	a4,-196(s0)
  b4:	029767bb          	remw	a5,a4,s1
  b8:	d3e5                	beqz	a5,98 <primes+0x98>
                    chr_num[index-1]=tmp;
  ba:	fff9079b          	addiw	a5,s2,-1
  be:	078a                	slli	a5,a5,0x2
  c0:	fd078793          	addi	a5,a5,-48
  c4:	97a2                	add	a5,a5,s0
  c6:	f6e7a823          	sw	a4,-144(a5)
                    index++;
  ca:	2905                	addiw	s2,s2,1
  cc:	b7f1                	j	98 <primes+0x98>
                    min =tmp;
  ce:	f3c42483          	lw	s1,-196(s0)
                    printf("prime %d\n",min);
  d2:	85a6                	mv	a1,s1
  d4:	8552                	mv	a0,s4
  d6:	00000097          	auipc	ra,0x0
  da:	63c080e7          	jalr	1596(ra) # 712 <printf>
                    index++;
  de:	894e                	mv	s2,s3
  e0:	bfc1                	j	b0 <primes+0xb0>
        close(my_pipe[READ]);
  e2:	fc842503          	lw	a0,-56(s0)
  e6:	00000097          	auipc	ra,0x0
  ea:	2ec080e7          	jalr	748(ra) # 3d2 <close>
        primes(chr_num,index-1);
  ee:	fff9059b          	addiw	a1,s2,-1
  f2:	f4040513          	addi	a0,s0,-192
  f6:	00000097          	auipc	ra,0x0
  fa:	f0a080e7          	jalr	-246(ra) # 0 <primes>
        exit(0);
  fe:	4501                	li	a0,0
 100:	00000097          	auipc	ra,0x0
 104:	2aa080e7          	jalr	682(ra) # 3aa <exit>

0000000000000108 <main>:

int main(int argc,char *argv[])
{
 108:	7135                	addi	sp,sp,-160
 10a:	ed06                	sd	ra,152(sp)
 10c:	e922                	sd	s0,144(sp)
 10e:	1100                	addi	s0,sp,160
    int num[34];
    for (int i=2,index =0;i<=35;i++)
 110:	f6840713          	addi	a4,s0,-152
 114:	4789                	li	a5,2
 116:	02400693          	li	a3,36
    {
        num[index]=i;
 11a:	c31c                	sw	a5,0(a4)
    for (int i=2,index =0;i<=35;i++)
 11c:	2785                	addiw	a5,a5,1
 11e:	0711                	addi	a4,a4,4
 120:	fed79de3          	bne	a5,a3,11a <main+0x12>
        index++;
    }
    primes(num,34);
 124:	02200593          	li	a1,34
 128:	f6840513          	addi	a0,s0,-152
 12c:	00000097          	auipc	ra,0x0
 130:	ed4080e7          	jalr	-300(ra) # 0 <primes>
    exit(0);
 134:	4501                	li	a0,0
 136:	00000097          	auipc	ra,0x0
 13a:	274080e7          	jalr	628(ra) # 3aa <exit>

000000000000013e <strcpy>:
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
 144:	87aa                	mv	a5,a0
 146:	0585                	addi	a1,a1,1
 148:	0785                	addi	a5,a5,1
 14a:	fff5c703          	lbu	a4,-1(a1)
 14e:	fee78fa3          	sb	a4,-1(a5)
 152:	fb75                	bnez	a4,146 <strcpy+0x8>
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strcmp>:
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
 160:	00054783          	lbu	a5,0(a0)
 164:	cb91                	beqz	a5,178 <strcmp+0x1e>
 166:	0005c703          	lbu	a4,0(a1)
 16a:	00f71763          	bne	a4,a5,178 <strcmp+0x1e>
 16e:	0505                	addi	a0,a0,1
 170:	0585                	addi	a1,a1,1
 172:	00054783          	lbu	a5,0(a0)
 176:	fbe5                	bnez	a5,166 <strcmp+0xc>
 178:	0005c503          	lbu	a0,0(a1)
 17c:	40a7853b          	subw	a0,a5,a0
 180:	6422                	ld	s0,8(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <strlen>:
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
 18c:	00054783          	lbu	a5,0(a0)
 190:	cf91                	beqz	a5,1ac <strlen+0x26>
 192:	0505                	addi	a0,a0,1
 194:	87aa                	mv	a5,a0
 196:	86be                	mv	a3,a5
 198:	0785                	addi	a5,a5,1
 19a:	fff7c703          	lbu	a4,-1(a5)
 19e:	ff65                	bnez	a4,196 <strlen+0x10>
 1a0:	40a6853b          	subw	a0,a3,a0
 1a4:	2505                	addiw	a0,a0,1
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
 1ac:	4501                	li	a0,0
 1ae:	bfe5                	j	1a6 <strlen+0x20>

00000000000001b0 <memset>:
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
 1b6:	ca19                	beqz	a2,1cc <memset+0x1c>
 1b8:	87aa                	mv	a5,a0
 1ba:	1602                	slli	a2,a2,0x20
 1bc:	9201                	srli	a2,a2,0x20
 1be:	00a60733          	add	a4,a2,a0
 1c2:	00b78023          	sb	a1,0(a5)
 1c6:	0785                	addi	a5,a5,1
 1c8:	fee79de3          	bne	a5,a4,1c2 <memset+0x12>
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret

00000000000001d2 <strchr>:
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	cb99                	beqz	a5,1f2 <strchr+0x20>
 1de:	00f58763          	beq	a1,a5,1ec <strchr+0x1a>
 1e2:	0505                	addi	a0,a0,1
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	fbfd                	bnez	a5,1de <strchr+0xc>
 1ea:	4501                	li	a0,0
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret
 1f2:	4501                	li	a0,0
 1f4:	bfe5                	j	1ec <strchr+0x1a>

00000000000001f6 <gets>:
 1f6:	711d                	addi	sp,sp,-96
 1f8:	ec86                	sd	ra,88(sp)
 1fa:	e8a2                	sd	s0,80(sp)
 1fc:	e4a6                	sd	s1,72(sp)
 1fe:	e0ca                	sd	s2,64(sp)
 200:	fc4e                	sd	s3,56(sp)
 202:	f852                	sd	s4,48(sp)
 204:	f456                	sd	s5,40(sp)
 206:	f05a                	sd	s6,32(sp)
 208:	ec5e                	sd	s7,24(sp)
 20a:	1080                	addi	s0,sp,96
 20c:	8baa                	mv	s7,a0
 20e:	8a2e                	mv	s4,a1
 210:	892a                	mv	s2,a0
 212:	4481                	li	s1,0
 214:	4aa9                	li	s5,10
 216:	4b35                	li	s6,13
 218:	89a6                	mv	s3,s1
 21a:	2485                	addiw	s1,s1,1
 21c:	0344d863          	bge	s1,s4,24c <gets+0x56>
 220:	4605                	li	a2,1
 222:	faf40593          	addi	a1,s0,-81
 226:	4501                	li	a0,0
 228:	00000097          	auipc	ra,0x0
 22c:	19a080e7          	jalr	410(ra) # 3c2 <read>
 230:	00a05e63          	blez	a0,24c <gets+0x56>
 234:	faf44783          	lbu	a5,-81(s0)
 238:	00f90023          	sb	a5,0(s2)
 23c:	01578763          	beq	a5,s5,24a <gets+0x54>
 240:	0905                	addi	s2,s2,1
 242:	fd679be3          	bne	a5,s6,218 <gets+0x22>
 246:	89a6                	mv	s3,s1
 248:	a011                	j	24c <gets+0x56>
 24a:	89a6                	mv	s3,s1
 24c:	99de                	add	s3,s3,s7
 24e:	00098023          	sb	zero,0(s3)
 252:	855e                	mv	a0,s7
 254:	60e6                	ld	ra,88(sp)
 256:	6446                	ld	s0,80(sp)
 258:	64a6                	ld	s1,72(sp)
 25a:	6906                	ld	s2,64(sp)
 25c:	79e2                	ld	s3,56(sp)
 25e:	7a42                	ld	s4,48(sp)
 260:	7aa2                	ld	s5,40(sp)
 262:	7b02                	ld	s6,32(sp)
 264:	6be2                	ld	s7,24(sp)
 266:	6125                	addi	sp,sp,96
 268:	8082                	ret

000000000000026a <stat>:
 26a:	1101                	addi	sp,sp,-32
 26c:	ec06                	sd	ra,24(sp)
 26e:	e822                	sd	s0,16(sp)
 270:	e04a                	sd	s2,0(sp)
 272:	1000                	addi	s0,sp,32
 274:	892e                	mv	s2,a1
 276:	4581                	li	a1,0
 278:	00000097          	auipc	ra,0x0
 27c:	172080e7          	jalr	370(ra) # 3ea <open>
 280:	02054663          	bltz	a0,2ac <stat+0x42>
 284:	e426                	sd	s1,8(sp)
 286:	84aa                	mv	s1,a0
 288:	85ca                	mv	a1,s2
 28a:	00000097          	auipc	ra,0x0
 28e:	178080e7          	jalr	376(ra) # 402 <fstat>
 292:	892a                	mv	s2,a0
 294:	8526                	mv	a0,s1
 296:	00000097          	auipc	ra,0x0
 29a:	13c080e7          	jalr	316(ra) # 3d2 <close>
 29e:	64a2                	ld	s1,8(sp)
 2a0:	854a                	mv	a0,s2
 2a2:	60e2                	ld	ra,24(sp)
 2a4:	6442                	ld	s0,16(sp)
 2a6:	6902                	ld	s2,0(sp)
 2a8:	6105                	addi	sp,sp,32
 2aa:	8082                	ret
 2ac:	597d                	li	s2,-1
 2ae:	bfcd                	j	2a0 <stat+0x36>

00000000000002b0 <atoi>:
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
 2b6:	00054683          	lbu	a3,0(a0)
 2ba:	fd06879b          	addiw	a5,a3,-48
 2be:	0ff7f793          	zext.b	a5,a5
 2c2:	4625                	li	a2,9
 2c4:	02f66863          	bltu	a2,a5,2f4 <atoi+0x44>
 2c8:	872a                	mv	a4,a0
 2ca:	4501                	li	a0,0
 2cc:	0705                	addi	a4,a4,1
 2ce:	0025179b          	slliw	a5,a0,0x2
 2d2:	9fa9                	addw	a5,a5,a0
 2d4:	0017979b          	slliw	a5,a5,0x1
 2d8:	9fb5                	addw	a5,a5,a3
 2da:	fd07851b          	addiw	a0,a5,-48
 2de:	00074683          	lbu	a3,0(a4)
 2e2:	fd06879b          	addiw	a5,a3,-48
 2e6:	0ff7f793          	zext.b	a5,a5
 2ea:	fef671e3          	bgeu	a2,a5,2cc <atoi+0x1c>
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
 2f4:	4501                	li	a0,0
 2f6:	bfe5                	j	2ee <atoi+0x3e>

00000000000002f8 <memmove>:
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
 2fe:	02b57463          	bgeu	a0,a1,326 <memmove+0x2e>
 302:	00c05f63          	blez	a2,320 <memmove+0x28>
 306:	1602                	slli	a2,a2,0x20
 308:	9201                	srli	a2,a2,0x20
 30a:	00c507b3          	add	a5,a0,a2
 30e:	872a                	mv	a4,a0
 310:	0585                	addi	a1,a1,1
 312:	0705                	addi	a4,a4,1
 314:	fff5c683          	lbu	a3,-1(a1)
 318:	fed70fa3          	sb	a3,-1(a4)
 31c:	fef71ae3          	bne	a4,a5,310 <memmove+0x18>
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
 326:	00c50733          	add	a4,a0,a2
 32a:	95b2                	add	a1,a1,a2
 32c:	fec05ae3          	blez	a2,320 <memmove+0x28>
 330:	fff6079b          	addiw	a5,a2,-1
 334:	1782                	slli	a5,a5,0x20
 336:	9381                	srli	a5,a5,0x20
 338:	fff7c793          	not	a5,a5
 33c:	97ba                	add	a5,a5,a4
 33e:	15fd                	addi	a1,a1,-1
 340:	177d                	addi	a4,a4,-1
 342:	0005c683          	lbu	a3,0(a1)
 346:	00d70023          	sb	a3,0(a4)
 34a:	fee79ae3          	bne	a5,a4,33e <memmove+0x46>
 34e:	bfc9                	j	320 <memmove+0x28>

0000000000000350 <memcmp>:
 350:	1141                	addi	sp,sp,-16
 352:	e422                	sd	s0,8(sp)
 354:	0800                	addi	s0,sp,16
 356:	ca05                	beqz	a2,386 <memcmp+0x36>
 358:	fff6069b          	addiw	a3,a2,-1
 35c:	1682                	slli	a3,a3,0x20
 35e:	9281                	srli	a3,a3,0x20
 360:	0685                	addi	a3,a3,1
 362:	96aa                	add	a3,a3,a0
 364:	00054783          	lbu	a5,0(a0)
 368:	0005c703          	lbu	a4,0(a1)
 36c:	00e79863          	bne	a5,a4,37c <memcmp+0x2c>
 370:	0505                	addi	a0,a0,1
 372:	0585                	addi	a1,a1,1
 374:	fed518e3          	bne	a0,a3,364 <memcmp+0x14>
 378:	4501                	li	a0,0
 37a:	a019                	j	380 <memcmp+0x30>
 37c:	40e7853b          	subw	a0,a5,a4
 380:	6422                	ld	s0,8(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
 386:	4501                	li	a0,0
 388:	bfe5                	j	380 <memcmp+0x30>

000000000000038a <memcpy>:
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
 392:	00000097          	auipc	ra,0x0
 396:	f66080e7          	jalr	-154(ra) # 2f8 <memmove>
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a2:	4885                	li	a7,1
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3aa:	4889                	li	a7,2
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b2:	488d                	li	a7,3
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ba:	4891                	li	a7,4
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <read>:
.global read
read:
 li a7, SYS_read
 3c2:	4895                	li	a7,5
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <write>:
.global write
write:
 li a7, SYS_write
 3ca:	48c1                	li	a7,16
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <close>:
.global close
close:
 li a7, SYS_close
 3d2:	48d5                	li	a7,21
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <kill>:
.global kill
kill:
 li a7, SYS_kill
 3da:	4899                	li	a7,6
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e2:	489d                	li	a7,7
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <open>:
.global open
open:
 li a7, SYS_open
 3ea:	48bd                	li	a7,15
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f2:	48c5                	li	a7,17
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fa:	48c9                	li	a7,18
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 402:	48a1                	li	a7,8
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <link>:
.global link
link:
 li a7, SYS_link
 40a:	48cd                	li	a7,19
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 412:	48d1                	li	a7,20
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41a:	48a5                	li	a7,9
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <dup>:
.global dup
dup:
 li a7, SYS_dup
 422:	48a9                	li	a7,10
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42a:	48ad                	li	a7,11
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 432:	48b1                	li	a7,12
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43a:	48b5                	li	a7,13
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 442:	48b9                	li	a7,14
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44a:	1101                	addi	sp,sp,-32
 44c:	ec06                	sd	ra,24(sp)
 44e:	e822                	sd	s0,16(sp)
 450:	1000                	addi	s0,sp,32
 452:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 456:	4605                	li	a2,1
 458:	fef40593          	addi	a1,s0,-17
 45c:	00000097          	auipc	ra,0x0
 460:	f6e080e7          	jalr	-146(ra) # 3ca <write>
}
 464:	60e2                	ld	ra,24(sp)
 466:	6442                	ld	s0,16(sp)
 468:	6105                	addi	sp,sp,32
 46a:	8082                	ret

000000000000046c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46c:	7139                	addi	sp,sp,-64
 46e:	fc06                	sd	ra,56(sp)
 470:	f822                	sd	s0,48(sp)
 472:	f426                	sd	s1,40(sp)
 474:	0080                	addi	s0,sp,64
 476:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 478:	c299                	beqz	a3,47e <printint+0x12>
 47a:	0805cb63          	bltz	a1,510 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47e:	2581                	sext.w	a1,a1
  neg = 0;
 480:	4881                	li	a7,0
 482:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 486:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 488:	2601                	sext.w	a2,a2
 48a:	00000517          	auipc	a0,0x0
 48e:	4b650513          	addi	a0,a0,1206 # 940 <digits>
 492:	883a                	mv	a6,a4
 494:	2705                	addiw	a4,a4,1
 496:	02c5f7bb          	remuw	a5,a1,a2
 49a:	1782                	slli	a5,a5,0x20
 49c:	9381                	srli	a5,a5,0x20
 49e:	97aa                	add	a5,a5,a0
 4a0:	0007c783          	lbu	a5,0(a5)
 4a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a8:	0005879b          	sext.w	a5,a1
 4ac:	02c5d5bb          	divuw	a1,a1,a2
 4b0:	0685                	addi	a3,a3,1
 4b2:	fec7f0e3          	bgeu	a5,a2,492 <printint+0x26>
  if(neg)
 4b6:	00088c63          	beqz	a7,4ce <printint+0x62>
    buf[i++] = '-';
 4ba:	fd070793          	addi	a5,a4,-48
 4be:	00878733          	add	a4,a5,s0
 4c2:	02d00793          	li	a5,45
 4c6:	fef70823          	sb	a5,-16(a4)
 4ca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ce:	02e05c63          	blez	a4,506 <printint+0x9a>
 4d2:	f04a                	sd	s2,32(sp)
 4d4:	ec4e                	sd	s3,24(sp)
 4d6:	fc040793          	addi	a5,s0,-64
 4da:	00e78933          	add	s2,a5,a4
 4de:	fff78993          	addi	s3,a5,-1
 4e2:	99ba                	add	s3,s3,a4
 4e4:	377d                	addiw	a4,a4,-1
 4e6:	1702                	slli	a4,a4,0x20
 4e8:	9301                	srli	a4,a4,0x20
 4ea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ee:	fff94583          	lbu	a1,-1(s2)
 4f2:	8526                	mv	a0,s1
 4f4:	00000097          	auipc	ra,0x0
 4f8:	f56080e7          	jalr	-170(ra) # 44a <putc>
  while(--i >= 0)
 4fc:	197d                	addi	s2,s2,-1
 4fe:	ff3918e3          	bne	s2,s3,4ee <printint+0x82>
 502:	7902                	ld	s2,32(sp)
 504:	69e2                	ld	s3,24(sp)
}
 506:	70e2                	ld	ra,56(sp)
 508:	7442                	ld	s0,48(sp)
 50a:	74a2                	ld	s1,40(sp)
 50c:	6121                	addi	sp,sp,64
 50e:	8082                	ret
    x = -xx;
 510:	40b005bb          	negw	a1,a1
    neg = 1;
 514:	4885                	li	a7,1
    x = -xx;
 516:	b7b5                	j	482 <printint+0x16>

0000000000000518 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 518:	715d                	addi	sp,sp,-80
 51a:	e486                	sd	ra,72(sp)
 51c:	e0a2                	sd	s0,64(sp)
 51e:	f84a                	sd	s2,48(sp)
 520:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 522:	0005c903          	lbu	s2,0(a1)
 526:	1a090a63          	beqz	s2,6da <vprintf+0x1c2>
 52a:	fc26                	sd	s1,56(sp)
 52c:	f44e                	sd	s3,40(sp)
 52e:	f052                	sd	s4,32(sp)
 530:	ec56                	sd	s5,24(sp)
 532:	e85a                	sd	s6,16(sp)
 534:	e45e                	sd	s7,8(sp)
 536:	8aaa                	mv	s5,a0
 538:	8bb2                	mv	s7,a2
 53a:	00158493          	addi	s1,a1,1
  state = 0;
 53e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 540:	02500a13          	li	s4,37
 544:	4b55                	li	s6,21
 546:	a839                	j	564 <vprintf+0x4c>
        putc(fd, c);
 548:	85ca                	mv	a1,s2
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	efe080e7          	jalr	-258(ra) # 44a <putc>
 554:	a019                	j	55a <vprintf+0x42>
    } else if(state == '%'){
 556:	01498d63          	beq	s3,s4,570 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 55a:	0485                	addi	s1,s1,1
 55c:	fff4c903          	lbu	s2,-1(s1)
 560:	16090763          	beqz	s2,6ce <vprintf+0x1b6>
    if(state == 0){
 564:	fe0999e3          	bnez	s3,556 <vprintf+0x3e>
      if(c == '%'){
 568:	ff4910e3          	bne	s2,s4,548 <vprintf+0x30>
        state = '%';
 56c:	89d2                	mv	s3,s4
 56e:	b7f5                	j	55a <vprintf+0x42>
      if(c == 'd'){
 570:	13490463          	beq	s2,s4,698 <vprintf+0x180>
 574:	f9d9079b          	addiw	a5,s2,-99
 578:	0ff7f793          	zext.b	a5,a5
 57c:	12fb6763          	bltu	s6,a5,6aa <vprintf+0x192>
 580:	f9d9079b          	addiw	a5,s2,-99
 584:	0ff7f713          	zext.b	a4,a5
 588:	12eb6163          	bltu	s6,a4,6aa <vprintf+0x192>
 58c:	00271793          	slli	a5,a4,0x2
 590:	00000717          	auipc	a4,0x0
 594:	35870713          	addi	a4,a4,856 # 8e8 <malloc+0x11e>
 598:	97ba                	add	a5,a5,a4
 59a:	439c                	lw	a5,0(a5)
 59c:	97ba                	add	a5,a5,a4
 59e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	ebe080e7          	jalr	-322(ra) # 46c <printint>
 5b6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b745                	j	55a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	ea2080e7          	jalr	-350(ra) # 46c <printint>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b751                	j	55a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e86080e7          	jalr	-378(ra) # 46c <printint>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b7a5                	j	55a <vprintf+0x42>
 5f4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5f6:	008b8c13          	addi	s8,s7,8
 5fa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fe:	03000593          	li	a1,48
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e46080e7          	jalr	-442(ra) # 44a <putc>
  putc(fd, 'x');
 60c:	07800593          	li	a1,120
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	e38080e7          	jalr	-456(ra) # 44a <putc>
 61a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61c:	00000b97          	auipc	s7,0x0
 620:	324b8b93          	addi	s7,s7,804 # 940 <digits>
 624:	03c9d793          	srli	a5,s3,0x3c
 628:	97de                	add	a5,a5,s7
 62a:	0007c583          	lbu	a1,0(a5)
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	e1a080e7          	jalr	-486(ra) # 44a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 638:	0992                	slli	s3,s3,0x4
 63a:	397d                	addiw	s2,s2,-1
 63c:	fe0914e3          	bnez	s2,624 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 640:	8be2                	mv	s7,s8
      state = 0;
 642:	4981                	li	s3,0
 644:	6c02                	ld	s8,0(sp)
 646:	bf11                	j	55a <vprintf+0x42>
        s = va_arg(ap, char*);
 648:	008b8993          	addi	s3,s7,8
 64c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 650:	02090163          	beqz	s2,672 <vprintf+0x15a>
        while(*s != 0){
 654:	00094583          	lbu	a1,0(s2)
 658:	c9a5                	beqz	a1,6c8 <vprintf+0x1b0>
          putc(fd, *s);
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	dee080e7          	jalr	-530(ra) # 44a <putc>
          s++;
 664:	0905                	addi	s2,s2,1
        while(*s != 0){
 666:	00094583          	lbu	a1,0(s2)
 66a:	f9e5                	bnez	a1,65a <vprintf+0x142>
        s = va_arg(ap, char*);
 66c:	8bce                	mv	s7,s3
      state = 0;
 66e:	4981                	li	s3,0
 670:	b5ed                	j	55a <vprintf+0x42>
          s = "(null)";
 672:	00000917          	auipc	s2,0x0
 676:	26e90913          	addi	s2,s2,622 # 8e0 <malloc+0x116>
        while(*s != 0){
 67a:	02800593          	li	a1,40
 67e:	bff1                	j	65a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 680:	008b8913          	addi	s2,s7,8
 684:	000bc583          	lbu	a1,0(s7)
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	dc0080e7          	jalr	-576(ra) # 44a <putc>
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
 696:	b5d1                	j	55a <vprintf+0x42>
        putc(fd, c);
 698:	02500593          	li	a1,37
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	dac080e7          	jalr	-596(ra) # 44a <putc>
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bd4d                	j	55a <vprintf+0x42>
        putc(fd, '%');
 6aa:	02500593          	li	a1,37
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	d9a080e7          	jalr	-614(ra) # 44a <putc>
        putc(fd, c);
 6b8:	85ca                	mv	a1,s2
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	d8e080e7          	jalr	-626(ra) # 44a <putc>
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bd51                	j	55a <vprintf+0x42>
        s = va_arg(ap, char*);
 6c8:	8bce                	mv	s7,s3
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b579                	j	55a <vprintf+0x42>
 6ce:	74e2                	ld	s1,56(sp)
 6d0:	79a2                	ld	s3,40(sp)
 6d2:	7a02                	ld	s4,32(sp)
 6d4:	6ae2                	ld	s5,24(sp)
 6d6:	6b42                	ld	s6,16(sp)
 6d8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6da:	60a6                	ld	ra,72(sp)
 6dc:	6406                	ld	s0,64(sp)
 6de:	7942                	ld	s2,48(sp)
 6e0:	6161                	addi	sp,sp,80
 6e2:	8082                	ret

00000000000006e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e4:	715d                	addi	sp,sp,-80
 6e6:	ec06                	sd	ra,24(sp)
 6e8:	e822                	sd	s0,16(sp)
 6ea:	1000                	addi	s0,sp,32
 6ec:	e010                	sd	a2,0(s0)
 6ee:	e414                	sd	a3,8(s0)
 6f0:	e818                	sd	a4,16(s0)
 6f2:	ec1c                	sd	a5,24(s0)
 6f4:	03043023          	sd	a6,32(s0)
 6f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 700:	8622                	mv	a2,s0
 702:	00000097          	auipc	ra,0x0
 706:	e16080e7          	jalr	-490(ra) # 518 <vprintf>
}
 70a:	60e2                	ld	ra,24(sp)
 70c:	6442                	ld	s0,16(sp)
 70e:	6161                	addi	sp,sp,80
 710:	8082                	ret

0000000000000712 <printf>:

void
printf(const char *fmt, ...)
{
 712:	711d                	addi	sp,sp,-96
 714:	ec06                	sd	ra,24(sp)
 716:	e822                	sd	s0,16(sp)
 718:	1000                	addi	s0,sp,32
 71a:	e40c                	sd	a1,8(s0)
 71c:	e810                	sd	a2,16(s0)
 71e:	ec14                	sd	a3,24(s0)
 720:	f018                	sd	a4,32(s0)
 722:	f41c                	sd	a5,40(s0)
 724:	03043823          	sd	a6,48(s0)
 728:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 72c:	00840613          	addi	a2,s0,8
 730:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 734:	85aa                	mv	a1,a0
 736:	4505                	li	a0,1
 738:	00000097          	auipc	ra,0x0
 73c:	de0080e7          	jalr	-544(ra) # 518 <vprintf>
}
 740:	60e2                	ld	ra,24(sp)
 742:	6442                	ld	s0,16(sp)
 744:	6125                	addi	sp,sp,96
 746:	8082                	ret

0000000000000748 <free>:
 748:	1141                	addi	sp,sp,-16
 74a:	e422                	sd	s0,8(sp)
 74c:	0800                	addi	s0,sp,16
 74e:	ff050693          	addi	a3,a0,-16
 752:	00000797          	auipc	a5,0x0
 756:	5fe7b783          	ld	a5,1534(a5) # d50 <freep>
 75a:	a02d                	j	784 <free+0x3c>
 75c:	4618                	lw	a4,8(a2)
 75e:	9f2d                	addw	a4,a4,a1
 760:	fee52c23          	sw	a4,-8(a0)
 764:	6398                	ld	a4,0(a5)
 766:	6310                	ld	a2,0(a4)
 768:	a83d                	j	7a6 <free+0x5e>
 76a:	ff852703          	lw	a4,-8(a0)
 76e:	9f31                	addw	a4,a4,a2
 770:	c798                	sw	a4,8(a5)
 772:	ff053683          	ld	a3,-16(a0)
 776:	a091                	j	7ba <free+0x72>
 778:	6398                	ld	a4,0(a5)
 77a:	00e7e463          	bltu	a5,a4,782 <free+0x3a>
 77e:	00e6ea63          	bltu	a3,a4,792 <free+0x4a>
 782:	87ba                	mv	a5,a4
 784:	fed7fae3          	bgeu	a5,a3,778 <free+0x30>
 788:	6398                	ld	a4,0(a5)
 78a:	00e6e463          	bltu	a3,a4,792 <free+0x4a>
 78e:	fee7eae3          	bltu	a5,a4,782 <free+0x3a>
 792:	ff852583          	lw	a1,-8(a0)
 796:	6390                	ld	a2,0(a5)
 798:	02059813          	slli	a6,a1,0x20
 79c:	01c85713          	srli	a4,a6,0x1c
 7a0:	9736                	add	a4,a4,a3
 7a2:	fae60de3          	beq	a2,a4,75c <free+0x14>
 7a6:	fec53823          	sd	a2,-16(a0)
 7aa:	4790                	lw	a2,8(a5)
 7ac:	02061593          	slli	a1,a2,0x20
 7b0:	01c5d713          	srli	a4,a1,0x1c
 7b4:	973e                	add	a4,a4,a5
 7b6:	fae68ae3          	beq	a3,a4,76a <free+0x22>
 7ba:	e394                	sd	a3,0(a5)
 7bc:	00000717          	auipc	a4,0x0
 7c0:	58f73a23          	sd	a5,1428(a4) # d50 <freep>
 7c4:	6422                	ld	s0,8(sp)
 7c6:	0141                	addi	sp,sp,16
 7c8:	8082                	ret

00000000000007ca <malloc>:
 7ca:	7139                	addi	sp,sp,-64
 7cc:	fc06                	sd	ra,56(sp)
 7ce:	f822                	sd	s0,48(sp)
 7d0:	f426                	sd	s1,40(sp)
 7d2:	ec4e                	sd	s3,24(sp)
 7d4:	0080                	addi	s0,sp,64
 7d6:	02051493          	slli	s1,a0,0x20
 7da:	9081                	srli	s1,s1,0x20
 7dc:	04bd                	addi	s1,s1,15
 7de:	8091                	srli	s1,s1,0x4
 7e0:	0014899b          	addiw	s3,s1,1
 7e4:	0485                	addi	s1,s1,1
 7e6:	00000517          	auipc	a0,0x0
 7ea:	56a53503          	ld	a0,1386(a0) # d50 <freep>
 7ee:	c915                	beqz	a0,822 <malloc+0x58>
 7f0:	611c                	ld	a5,0(a0)
 7f2:	4798                	lw	a4,8(a5)
 7f4:	08977e63          	bgeu	a4,s1,890 <malloc+0xc6>
 7f8:	f04a                	sd	s2,32(sp)
 7fa:	e852                	sd	s4,16(sp)
 7fc:	e456                	sd	s5,8(sp)
 7fe:	e05a                	sd	s6,0(sp)
 800:	8a4e                	mv	s4,s3
 802:	0009871b          	sext.w	a4,s3
 806:	6685                	lui	a3,0x1
 808:	00d77363          	bgeu	a4,a3,80e <malloc+0x44>
 80c:	6a05                	lui	s4,0x1
 80e:	000a0b1b          	sext.w	s6,s4
 812:	004a1a1b          	slliw	s4,s4,0x4
 816:	00000917          	auipc	s2,0x0
 81a:	53a90913          	addi	s2,s2,1338 # d50 <freep>
 81e:	5afd                	li	s5,-1
 820:	a091                	j	864 <malloc+0x9a>
 822:	f04a                	sd	s2,32(sp)
 824:	e852                	sd	s4,16(sp)
 826:	e456                	sd	s5,8(sp)
 828:	e05a                	sd	s6,0(sp)
 82a:	00000797          	auipc	a5,0x0
 82e:	52e78793          	addi	a5,a5,1326 # d58 <base>
 832:	00000717          	auipc	a4,0x0
 836:	50f73f23          	sd	a5,1310(a4) # d50 <freep>
 83a:	e39c                	sd	a5,0(a5)
 83c:	0007a423          	sw	zero,8(a5)
 840:	b7c1                	j	800 <malloc+0x36>
 842:	6398                	ld	a4,0(a5)
 844:	e118                	sd	a4,0(a0)
 846:	a08d                	j	8a8 <malloc+0xde>
 848:	01652423          	sw	s6,8(a0)
 84c:	0541                	addi	a0,a0,16
 84e:	00000097          	auipc	ra,0x0
 852:	efa080e7          	jalr	-262(ra) # 748 <free>
 856:	00093503          	ld	a0,0(s2)
 85a:	c13d                	beqz	a0,8c0 <malloc+0xf6>
 85c:	611c                	ld	a5,0(a0)
 85e:	4798                	lw	a4,8(a5)
 860:	02977463          	bgeu	a4,s1,888 <malloc+0xbe>
 864:	00093703          	ld	a4,0(s2)
 868:	853e                	mv	a0,a5
 86a:	fef719e3          	bne	a4,a5,85c <malloc+0x92>
 86e:	8552                	mv	a0,s4
 870:	00000097          	auipc	ra,0x0
 874:	bc2080e7          	jalr	-1086(ra) # 432 <sbrk>
 878:	fd5518e3          	bne	a0,s5,848 <malloc+0x7e>
 87c:	4501                	li	a0,0
 87e:	7902                	ld	s2,32(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
 886:	a03d                	j	8b4 <malloc+0xea>
 888:	7902                	ld	s2,32(sp)
 88a:	6a42                	ld	s4,16(sp)
 88c:	6aa2                	ld	s5,8(sp)
 88e:	6b02                	ld	s6,0(sp)
 890:	fae489e3          	beq	s1,a4,842 <malloc+0x78>
 894:	4137073b          	subw	a4,a4,s3
 898:	c798                	sw	a4,8(a5)
 89a:	02071693          	slli	a3,a4,0x20
 89e:	01c6d713          	srli	a4,a3,0x1c
 8a2:	97ba                	add	a5,a5,a4
 8a4:	0137a423          	sw	s3,8(a5)
 8a8:	00000717          	auipc	a4,0x0
 8ac:	4aa73423          	sd	a0,1192(a4) # d50 <freep>
 8b0:	01078513          	addi	a0,a5,16
 8b4:	70e2                	ld	ra,56(sp)
 8b6:	7442                	ld	s0,48(sp)
 8b8:	74a2                	ld	s1,40(sp)
 8ba:	69e2                	ld	s3,24(sp)
 8bc:	6121                	addi	sp,sp,64
 8be:	8082                	ret
 8c0:	7902                	ld	s2,32(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
 8c8:	b7f5                	j	8b4 <malloc+0xea>
