
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path , char *filename)
{
   0:	d9010113          	addi	sp,sp,-624
   4:	26113423          	sd	ra,616(sp)
   8:	26813023          	sd	s0,608(sp)
   c:	25213823          	sd	s2,592(sp)
  10:	25313423          	sd	s3,584(sp)
  14:	1c80                	addi	s0,sp,624
  16:	892a                	mv	s2,a0
  18:	89ae                	mv	s3,a1
    char buf[512], *tmp;
    int file;
    struct dirent de;
    struct stat st;

    if((file = open(path, 0)) < 0)
  1a:	4581                	li	a1,0
  1c:	00000097          	auipc	ra,0x0
  20:	4d8080e7          	jalr	1240(ra) # 4f4 <open>
  24:	04054963          	bltz	a0,76 <find+0x76>
  28:	24913c23          	sd	s1,600(sp)
  2c:	84aa                	mv	s1,a0
    {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if(fstat(file, &st) < 0)
  2e:	d9840593          	addi	a1,s0,-616
  32:	00000097          	auipc	ra,0x0
  36:	4da080e7          	jalr	1242(ra) # 50c <fstat>
  3a:	04054963          	bltz	a0,8c <find+0x8c>
    {
        fprintf(2, "find: cannot stat %s\n", path);
        close(file);
        return;
    }
    if(st.type == T_FILE)
  3e:	da041703          	lh	a4,-608(s0)
  42:	4789                	li	a5,2
  44:	06f70663          	beq	a4,a5,b0 <find+0xb0>
        if(strcmp( path + strlen(path) - strlen(filename) , filename ) ==0)
            {
                 printf("%s\n", path);
            }
    }
    if(st.type == T_DIR)
  48:	da041703          	lh	a4,-608(s0)
  4c:	4785                	li	a5,1
  4e:	0af70c63          	beq	a4,a5,106 <find+0x106>
                if(strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0)
                find(buf, filename);
                
            }
    }
    close(file);
  52:	8526                	mv	a0,s1
  54:	00000097          	auipc	ra,0x0
  58:	488080e7          	jalr	1160(ra) # 4dc <close>
  5c:	25813483          	ld	s1,600(sp)

}
  60:	26813083          	ld	ra,616(sp)
  64:	26013403          	ld	s0,608(sp)
  68:	25013903          	ld	s2,592(sp)
  6c:	24813983          	ld	s3,584(sp)
  70:	27010113          	addi	sp,sp,624
  74:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);
  76:	864a                	mv	a2,s2
  78:	00001597          	auipc	a1,0x1
  7c:	96058593          	addi	a1,a1,-1696 # 9d8 <malloc+0x104>
  80:	4509                	li	a0,2
  82:	00000097          	auipc	ra,0x0
  86:	76c080e7          	jalr	1900(ra) # 7ee <fprintf>
        return;
  8a:	bfd9                	j	60 <find+0x60>
        fprintf(2, "find: cannot stat %s\n", path);
  8c:	864a                	mv	a2,s2
  8e:	00001597          	auipc	a1,0x1
  92:	96a58593          	addi	a1,a1,-1686 # 9f8 <malloc+0x124>
  96:	4509                	li	a0,2
  98:	00000097          	auipc	ra,0x0
  9c:	756080e7          	jalr	1878(ra) # 7ee <fprintf>
        close(file);
  a0:	8526                	mv	a0,s1
  a2:	00000097          	auipc	ra,0x0
  a6:	43a080e7          	jalr	1082(ra) # 4dc <close>
        return;
  aa:	25813483          	ld	s1,600(sp)
  ae:	bf4d                	j	60 <find+0x60>
  b0:	25413023          	sd	s4,576(sp)
        if(strcmp( path + strlen(path) - strlen(filename) , filename ) ==0)
  b4:	854a                	mv	a0,s2
  b6:	00000097          	auipc	ra,0x0
  ba:	1da080e7          	jalr	474(ra) # 290 <strlen>
  be:	00050a1b          	sext.w	s4,a0
  c2:	854e                	mv	a0,s3
  c4:	00000097          	auipc	ra,0x0
  c8:	1cc080e7          	jalr	460(ra) # 290 <strlen>
  cc:	1a02                	slli	s4,s4,0x20
  ce:	020a5a13          	srli	s4,s4,0x20
  d2:	1502                	slli	a0,a0,0x20
  d4:	9101                	srli	a0,a0,0x20
  d6:	40aa0533          	sub	a0,s4,a0
  da:	85ce                	mv	a1,s3
  dc:	954a                	add	a0,a0,s2
  de:	00000097          	auipc	ra,0x0
  e2:	186080e7          	jalr	390(ra) # 264 <strcmp>
  e6:	c501                	beqz	a0,ee <find+0xee>
  e8:	24013a03          	ld	s4,576(sp)
  ec:	bfb1                	j	48 <find+0x48>
                 printf("%s\n", path);
  ee:	85ca                	mv	a1,s2
  f0:	00001517          	auipc	a0,0x1
  f4:	92050513          	addi	a0,a0,-1760 # a10 <malloc+0x13c>
  f8:	00000097          	auipc	ra,0x0
  fc:	724080e7          	jalr	1828(ra) # 81c <printf>
 100:	24013a03          	ld	s4,576(sp)
 104:	b791                	j	48 <find+0x48>
 106:	25413023          	sd	s4,576(sp)
 10a:	23513c23          	sd	s5,568(sp)
         if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
 10e:	854a                	mv	a0,s2
 110:	00000097          	auipc	ra,0x0
 114:	180080e7          	jalr	384(ra) # 290 <strlen>
 118:	2541                	addiw	a0,a0,16
 11a:	20000793          	li	a5,512
 11e:	0aa7ec63          	bltu	a5,a0,1d6 <find+0x1d6>
            strcpy(buf, path);
 122:	85ca                	mv	a1,s2
 124:	dc040513          	addi	a0,s0,-576
 128:	00000097          	auipc	ra,0x0
 12c:	120080e7          	jalr	288(ra) # 248 <strcpy>
            tmp = buf+strlen(buf);
 130:	dc040513          	addi	a0,s0,-576
 134:	00000097          	auipc	ra,0x0
 138:	15c080e7          	jalr	348(ra) # 290 <strlen>
 13c:	1502                	slli	a0,a0,0x20
 13e:	9101                	srli	a0,a0,0x20
 140:	dc040793          	addi	a5,s0,-576
 144:	00a78933          	add	s2,a5,a0
            *tmp++ = '/';
 148:	00190a13          	addi	s4,s2,1
 14c:	02f00793          	li	a5,47
 150:	00f90023          	sb	a5,0(s2)
                if(strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0)
 154:	00001a97          	auipc	s5,0x1
 158:	8dca8a93          	addi	s5,s5,-1828 # a30 <malloc+0x15c>
            while(read(file, &de, sizeof(de)) == sizeof(de))
 15c:	4641                	li	a2,16
 15e:	db040593          	addi	a1,s0,-592
 162:	8526                	mv	a0,s1
 164:	00000097          	auipc	ra,0x0
 168:	368080e7          	jalr	872(ra) # 4cc <read>
 16c:	47c1                	li	a5,16
 16e:	08f51863          	bne	a0,a5,1fe <find+0x1fe>
                if(de.inum == 0)
 172:	db045783          	lhu	a5,-592(s0)
 176:	d3fd                	beqz	a5,15c <find+0x15c>
                memmove(tmp, de.name, DIRSIZ);
 178:	4639                	li	a2,14
 17a:	db240593          	addi	a1,s0,-590
 17e:	8552                	mv	a0,s4
 180:	00000097          	auipc	ra,0x0
 184:	282080e7          	jalr	642(ra) # 402 <memmove>
                tmp[DIRSIZ] = 0;
 188:	000907a3          	sb	zero,15(s2)
                if(stat(buf, &st) < 0)
 18c:	d9840593          	addi	a1,s0,-616
 190:	dc040513          	addi	a0,s0,-576
 194:	00000097          	auipc	ra,0x0
 198:	1e0080e7          	jalr	480(ra) # 374 <stat>
 19c:	04054663          	bltz	a0,1e8 <find+0x1e8>
                if(strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0)
 1a0:	db240593          	addi	a1,s0,-590
 1a4:	8556                	mv	a0,s5
 1a6:	00000097          	auipc	ra,0x0
 1aa:	0be080e7          	jalr	190(ra) # 264 <strcmp>
 1ae:	d55d                	beqz	a0,15c <find+0x15c>
 1b0:	db240593          	addi	a1,s0,-590
 1b4:	00001517          	auipc	a0,0x1
 1b8:	88450513          	addi	a0,a0,-1916 # a38 <malloc+0x164>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	0a8080e7          	jalr	168(ra) # 264 <strcmp>
 1c4:	dd41                	beqz	a0,15c <find+0x15c>
                find(buf, filename);
 1c6:	85ce                	mv	a1,s3
 1c8:	dc040513          	addi	a0,s0,-576
 1cc:	00000097          	auipc	ra,0x0
 1d0:	e34080e7          	jalr	-460(ra) # 0 <find>
 1d4:	b761                	j	15c <find+0x15c>
                printf("find: path too long\n");
 1d6:	00001517          	auipc	a0,0x1
 1da:	84250513          	addi	a0,a0,-1982 # a18 <malloc+0x144>
 1de:	00000097          	auipc	ra,0x0
 1e2:	63e080e7          	jalr	1598(ra) # 81c <printf>
 1e6:	bf35                	j	122 <find+0x122>
                    printf("find: cannot stat %s\n", buf);
 1e8:	dc040593          	addi	a1,s0,-576
 1ec:	00001517          	auipc	a0,0x1
 1f0:	80c50513          	addi	a0,a0,-2036 # 9f8 <malloc+0x124>
 1f4:	00000097          	auipc	ra,0x0
 1f8:	628080e7          	jalr	1576(ra) # 81c <printf>
                    continue;
 1fc:	b785                	j	15c <find+0x15c>
 1fe:	24013a03          	ld	s4,576(sp)
 202:	23813a83          	ld	s5,568(sp)
 206:	b5b1                	j	52 <find+0x52>

0000000000000208 <main>:


int main(int argc, char *argv[])
{
 208:	1141                	addi	sp,sp,-16
 20a:	e406                	sd	ra,8(sp)
 20c:	e022                	sd	s0,0(sp)
 20e:	0800                	addi	s0,sp,16
    if(argc != 3)
 210:	470d                	li	a4,3
 212:	00e50f63          	beq	a0,a4,230 <main+0x28>
    {
        printf("input arguments : find <path> <file name>\n");
 216:	00001517          	auipc	a0,0x1
 21a:	82a50513          	addi	a0,a0,-2006 # a40 <malloc+0x16c>
 21e:	00000097          	auipc	ra,0x0
 222:	5fe080e7          	jalr	1534(ra) # 81c <printf>
        exit(1);
 226:	4505                	li	a0,1
 228:	00000097          	auipc	ra,0x0
 22c:	28c080e7          	jalr	652(ra) # 4b4 <exit>
 230:	87ae                	mv	a5,a1
    }
   
    find(argv[1], argv[2]);
 232:	698c                	ld	a1,16(a1)
 234:	6788                	ld	a0,8(a5)
 236:	00000097          	auipc	ra,0x0
 23a:	dca080e7          	jalr	-566(ra) # 0 <find>
    exit(0);
 23e:	4501                	li	a0,0
 240:	00000097          	auipc	ra,0x0
 244:	274080e7          	jalr	628(ra) # 4b4 <exit>

0000000000000248 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 24e:	87aa                	mv	a5,a0
 250:	0585                	addi	a1,a1,1
 252:	0785                	addi	a5,a5,1
 254:	fff5c703          	lbu	a4,-1(a1)
 258:	fee78fa3          	sb	a4,-1(a5)
 25c:	fb75                	bnez	a4,250 <strcpy+0x8>
    ;
  return os;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret

0000000000000264 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 264:	1141                	addi	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 26a:	00054783          	lbu	a5,0(a0)
 26e:	cb91                	beqz	a5,282 <strcmp+0x1e>
 270:	0005c703          	lbu	a4,0(a1)
 274:	00f71763          	bne	a4,a5,282 <strcmp+0x1e>
    p++, q++;
 278:	0505                	addi	a0,a0,1
 27a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 27c:	00054783          	lbu	a5,0(a0)
 280:	fbe5                	bnez	a5,270 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 282:	0005c503          	lbu	a0,0(a1)
}
 286:	40a7853b          	subw	a0,a5,a0
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <strlen>:

uint
strlen(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 296:	00054783          	lbu	a5,0(a0)
 29a:	cf91                	beqz	a5,2b6 <strlen+0x26>
 29c:	0505                	addi	a0,a0,1
 29e:	87aa                	mv	a5,a0
 2a0:	86be                	mv	a3,a5
 2a2:	0785                	addi	a5,a5,1
 2a4:	fff7c703          	lbu	a4,-1(a5)
 2a8:	ff65                	bnez	a4,2a0 <strlen+0x10>
 2aa:	40a6853b          	subw	a0,a3,a0
 2ae:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
  for(n = 0; s[n]; n++)
 2b6:	4501                	li	a0,0
 2b8:	bfe5                	j	2b0 <strlen+0x20>

00000000000002ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2c0:	ca19                	beqz	a2,2d6 <memset+0x1c>
 2c2:	87aa                	mv	a5,a0
 2c4:	1602                	slli	a2,a2,0x20
 2c6:	9201                	srli	a2,a2,0x20
 2c8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2cc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2d0:	0785                	addi	a5,a5,1
 2d2:	fee79de3          	bne	a5,a4,2cc <memset+0x12>
  }
  return dst;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <strchr>:

char*
strchr(const char *s, char c)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	cb99                	beqz	a5,2fc <strchr+0x20>
    if(*s == c)
 2e8:	00f58763          	beq	a1,a5,2f6 <strchr+0x1a>
  for(; *s; s++)
 2ec:	0505                	addi	a0,a0,1
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	fbfd                	bnez	a5,2e8 <strchr+0xc>
      return (char*)s;
  return 0;
 2f4:	4501                	li	a0,0
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
  return 0;
 2fc:	4501                	li	a0,0
 2fe:	bfe5                	j	2f6 <strchr+0x1a>

0000000000000300 <gets>:

char*
gets(char *buf, int max)
{
 300:	711d                	addi	sp,sp,-96
 302:	ec86                	sd	ra,88(sp)
 304:	e8a2                	sd	s0,80(sp)
 306:	e4a6                	sd	s1,72(sp)
 308:	e0ca                	sd	s2,64(sp)
 30a:	fc4e                	sd	s3,56(sp)
 30c:	f852                	sd	s4,48(sp)
 30e:	f456                	sd	s5,40(sp)
 310:	f05a                	sd	s6,32(sp)
 312:	ec5e                	sd	s7,24(sp)
 314:	1080                	addi	s0,sp,96
 316:	8baa                	mv	s7,a0
 318:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 31a:	892a                	mv	s2,a0
 31c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 31e:	4aa9                	li	s5,10
 320:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 322:	89a6                	mv	s3,s1
 324:	2485                	addiw	s1,s1,1
 326:	0344d863          	bge	s1,s4,356 <gets+0x56>
    cc = read(0, &c, 1);
 32a:	4605                	li	a2,1
 32c:	faf40593          	addi	a1,s0,-81
 330:	4501                	li	a0,0
 332:	00000097          	auipc	ra,0x0
 336:	19a080e7          	jalr	410(ra) # 4cc <read>
    if(cc < 1)
 33a:	00a05e63          	blez	a0,356 <gets+0x56>
    buf[i++] = c;
 33e:	faf44783          	lbu	a5,-81(s0)
 342:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 346:	01578763          	beq	a5,s5,354 <gets+0x54>
 34a:	0905                	addi	s2,s2,1
 34c:	fd679be3          	bne	a5,s6,322 <gets+0x22>
    buf[i++] = c;
 350:	89a6                	mv	s3,s1
 352:	a011                	j	356 <gets+0x56>
 354:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 356:	99de                	add	s3,s3,s7
 358:	00098023          	sb	zero,0(s3)
  return buf;
}
 35c:	855e                	mv	a0,s7
 35e:	60e6                	ld	ra,88(sp)
 360:	6446                	ld	s0,80(sp)
 362:	64a6                	ld	s1,72(sp)
 364:	6906                	ld	s2,64(sp)
 366:	79e2                	ld	s3,56(sp)
 368:	7a42                	ld	s4,48(sp)
 36a:	7aa2                	ld	s5,40(sp)
 36c:	7b02                	ld	s6,32(sp)
 36e:	6be2                	ld	s7,24(sp)
 370:	6125                	addi	sp,sp,96
 372:	8082                	ret

0000000000000374 <stat>:

int
stat(const char *n, struct stat *st)
{
 374:	1101                	addi	sp,sp,-32
 376:	ec06                	sd	ra,24(sp)
 378:	e822                	sd	s0,16(sp)
 37a:	e04a                	sd	s2,0(sp)
 37c:	1000                	addi	s0,sp,32
 37e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 380:	4581                	li	a1,0
 382:	00000097          	auipc	ra,0x0
 386:	172080e7          	jalr	370(ra) # 4f4 <open>
  if(fd < 0)
 38a:	02054663          	bltz	a0,3b6 <stat+0x42>
 38e:	e426                	sd	s1,8(sp)
 390:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 392:	85ca                	mv	a1,s2
 394:	00000097          	auipc	ra,0x0
 398:	178080e7          	jalr	376(ra) # 50c <fstat>
 39c:	892a                	mv	s2,a0
  close(fd);
 39e:	8526                	mv	a0,s1
 3a0:	00000097          	auipc	ra,0x0
 3a4:	13c080e7          	jalr	316(ra) # 4dc <close>
  return r;
 3a8:	64a2                	ld	s1,8(sp)
}
 3aa:	854a                	mv	a0,s2
 3ac:	60e2                	ld	ra,24(sp)
 3ae:	6442                	ld	s0,16(sp)
 3b0:	6902                	ld	s2,0(sp)
 3b2:	6105                	addi	sp,sp,32
 3b4:	8082                	ret
    return -1;
 3b6:	597d                	li	s2,-1
 3b8:	bfcd                	j	3aa <stat+0x36>

00000000000003ba <atoi>:

int
atoi(const char *s)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e422                	sd	s0,8(sp)
 3be:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c0:	00054683          	lbu	a3,0(a0)
 3c4:	fd06879b          	addiw	a5,a3,-48
 3c8:	0ff7f793          	zext.b	a5,a5
 3cc:	4625                	li	a2,9
 3ce:	02f66863          	bltu	a2,a5,3fe <atoi+0x44>
 3d2:	872a                	mv	a4,a0
  n = 0;
 3d4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3d6:	0705                	addi	a4,a4,1
 3d8:	0025179b          	slliw	a5,a0,0x2
 3dc:	9fa9                	addw	a5,a5,a0
 3de:	0017979b          	slliw	a5,a5,0x1
 3e2:	9fb5                	addw	a5,a5,a3
 3e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e8:	00074683          	lbu	a3,0(a4)
 3ec:	fd06879b          	addiw	a5,a3,-48
 3f0:	0ff7f793          	zext.b	a5,a5
 3f4:	fef671e3          	bgeu	a2,a5,3d6 <atoi+0x1c>
  return n;
}
 3f8:	6422                	ld	s0,8(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret
  n = 0;
 3fe:	4501                	li	a0,0
 400:	bfe5                	j	3f8 <atoi+0x3e>

0000000000000402 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 408:	02b57463          	bgeu	a0,a1,430 <memmove+0x2e>
    while(n-- > 0)
 40c:	00c05f63          	blez	a2,42a <memmove+0x28>
 410:	1602                	slli	a2,a2,0x20
 412:	9201                	srli	a2,a2,0x20
 414:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 418:	872a                	mv	a4,a0
      *dst++ = *src++;
 41a:	0585                	addi	a1,a1,1
 41c:	0705                	addi	a4,a4,1
 41e:	fff5c683          	lbu	a3,-1(a1)
 422:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 426:	fef71ae3          	bne	a4,a5,41a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 42a:	6422                	ld	s0,8(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret
    dst += n;
 430:	00c50733          	add	a4,a0,a2
    src += n;
 434:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 436:	fec05ae3          	blez	a2,42a <memmove+0x28>
 43a:	fff6079b          	addiw	a5,a2,-1
 43e:	1782                	slli	a5,a5,0x20
 440:	9381                	srli	a5,a5,0x20
 442:	fff7c793          	not	a5,a5
 446:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 448:	15fd                	addi	a1,a1,-1
 44a:	177d                	addi	a4,a4,-1
 44c:	0005c683          	lbu	a3,0(a1)
 450:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 454:	fee79ae3          	bne	a5,a4,448 <memmove+0x46>
 458:	bfc9                	j	42a <memmove+0x28>

000000000000045a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 45a:	1141                	addi	sp,sp,-16
 45c:	e422                	sd	s0,8(sp)
 45e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 460:	ca05                	beqz	a2,490 <memcmp+0x36>
 462:	fff6069b          	addiw	a3,a2,-1
 466:	1682                	slli	a3,a3,0x20
 468:	9281                	srli	a3,a3,0x20
 46a:	0685                	addi	a3,a3,1
 46c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 46e:	00054783          	lbu	a5,0(a0)
 472:	0005c703          	lbu	a4,0(a1)
 476:	00e79863          	bne	a5,a4,486 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 47a:	0505                	addi	a0,a0,1
    p2++;
 47c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 47e:	fed518e3          	bne	a0,a3,46e <memcmp+0x14>
  }
  return 0;
 482:	4501                	li	a0,0
 484:	a019                	j	48a <memcmp+0x30>
      return *p1 - *p2;
 486:	40e7853b          	subw	a0,a5,a4
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
  return 0;
 490:	4501                	li	a0,0
 492:	bfe5                	j	48a <memcmp+0x30>

0000000000000494 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 494:	1141                	addi	sp,sp,-16
 496:	e406                	sd	ra,8(sp)
 498:	e022                	sd	s0,0(sp)
 49a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 49c:	00000097          	auipc	ra,0x0
 4a0:	f66080e7          	jalr	-154(ra) # 402 <memmove>
}
 4a4:	60a2                	ld	ra,8(sp)
 4a6:	6402                	ld	s0,0(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret

00000000000004ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ac:	4885                	li	a7,1
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b4:	4889                	li	a7,2
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 4bc:	488d                	li	a7,3
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c4:	4891                	li	a7,4
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <read>:
.global read
read:
 li a7, SYS_read
 4cc:	4895                	li	a7,5
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <write>:
.global write
write:
 li a7, SYS_write
 4d4:	48c1                	li	a7,16
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <close>:
.global close
close:
 li a7, SYS_close
 4dc:	48d5                	li	a7,21
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e4:	4899                	li	a7,6
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ec:	489d                	li	a7,7
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <open>:
.global open
open:
 li a7, SYS_open
 4f4:	48bd                	li	a7,15
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4fc:	48c5                	li	a7,17
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 504:	48c9                	li	a7,18
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 50c:	48a1                	li	a7,8
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <link>:
.global link
link:
 li a7, SYS_link
 514:	48cd                	li	a7,19
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 51c:	48d1                	li	a7,20
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 524:	48a5                	li	a7,9
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <dup>:
.global dup
dup:
 li a7, SYS_dup
 52c:	48a9                	li	a7,10
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 534:	48ad                	li	a7,11
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 53c:	48b1                	li	a7,12
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 544:	48b5                	li	a7,13
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 54c:	48b9                	li	a7,14
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 554:	1101                	addi	sp,sp,-32
 556:	ec06                	sd	ra,24(sp)
 558:	e822                	sd	s0,16(sp)
 55a:	1000                	addi	s0,sp,32
 55c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 560:	4605                	li	a2,1
 562:	fef40593          	addi	a1,s0,-17
 566:	00000097          	auipc	ra,0x0
 56a:	f6e080e7          	jalr	-146(ra) # 4d4 <write>
}
 56e:	60e2                	ld	ra,24(sp)
 570:	6442                	ld	s0,16(sp)
 572:	6105                	addi	sp,sp,32
 574:	8082                	ret

0000000000000576 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 576:	7139                	addi	sp,sp,-64
 578:	fc06                	sd	ra,56(sp)
 57a:	f822                	sd	s0,48(sp)
 57c:	f426                	sd	s1,40(sp)
 57e:	0080                	addi	s0,sp,64
 580:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 582:	c299                	beqz	a3,588 <printint+0x12>
 584:	0805cb63          	bltz	a1,61a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 588:	2581                	sext.w	a1,a1
  neg = 0;
 58a:	4881                	li	a7,0
 58c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 590:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 592:	2601                	sext.w	a2,a2
 594:	00000517          	auipc	a0,0x0
 598:	53c50513          	addi	a0,a0,1340 # ad0 <digits>
 59c:	883a                	mv	a6,a4
 59e:	2705                	addiw	a4,a4,1
 5a0:	02c5f7bb          	remuw	a5,a1,a2
 5a4:	1782                	slli	a5,a5,0x20
 5a6:	9381                	srli	a5,a5,0x20
 5a8:	97aa                	add	a5,a5,a0
 5aa:	0007c783          	lbu	a5,0(a5)
 5ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b2:	0005879b          	sext.w	a5,a1
 5b6:	02c5d5bb          	divuw	a1,a1,a2
 5ba:	0685                	addi	a3,a3,1
 5bc:	fec7f0e3          	bgeu	a5,a2,59c <printint+0x26>
  if(neg)
 5c0:	00088c63          	beqz	a7,5d8 <printint+0x62>
    buf[i++] = '-';
 5c4:	fd070793          	addi	a5,a4,-48
 5c8:	00878733          	add	a4,a5,s0
 5cc:	02d00793          	li	a5,45
 5d0:	fef70823          	sb	a5,-16(a4)
 5d4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5d8:	02e05c63          	blez	a4,610 <printint+0x9a>
 5dc:	f04a                	sd	s2,32(sp)
 5de:	ec4e                	sd	s3,24(sp)
 5e0:	fc040793          	addi	a5,s0,-64
 5e4:	00e78933          	add	s2,a5,a4
 5e8:	fff78993          	addi	s3,a5,-1
 5ec:	99ba                	add	s3,s3,a4
 5ee:	377d                	addiw	a4,a4,-1
 5f0:	1702                	slli	a4,a4,0x20
 5f2:	9301                	srli	a4,a4,0x20
 5f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f8:	fff94583          	lbu	a1,-1(s2)
 5fc:	8526                	mv	a0,s1
 5fe:	00000097          	auipc	ra,0x0
 602:	f56080e7          	jalr	-170(ra) # 554 <putc>
  while(--i >= 0)
 606:	197d                	addi	s2,s2,-1
 608:	ff3918e3          	bne	s2,s3,5f8 <printint+0x82>
 60c:	7902                	ld	s2,32(sp)
 60e:	69e2                	ld	s3,24(sp)
}
 610:	70e2                	ld	ra,56(sp)
 612:	7442                	ld	s0,48(sp)
 614:	74a2                	ld	s1,40(sp)
 616:	6121                	addi	sp,sp,64
 618:	8082                	ret
    x = -xx;
 61a:	40b005bb          	negw	a1,a1
    neg = 1;
 61e:	4885                	li	a7,1
    x = -xx;
 620:	b7b5                	j	58c <printint+0x16>

0000000000000622 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 622:	715d                	addi	sp,sp,-80
 624:	e486                	sd	ra,72(sp)
 626:	e0a2                	sd	s0,64(sp)
 628:	f84a                	sd	s2,48(sp)
 62a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 62c:	0005c903          	lbu	s2,0(a1)
 630:	1a090a63          	beqz	s2,7e4 <vprintf+0x1c2>
 634:	fc26                	sd	s1,56(sp)
 636:	f44e                	sd	s3,40(sp)
 638:	f052                	sd	s4,32(sp)
 63a:	ec56                	sd	s5,24(sp)
 63c:	e85a                	sd	s6,16(sp)
 63e:	e45e                	sd	s7,8(sp)
 640:	8aaa                	mv	s5,a0
 642:	8bb2                	mv	s7,a2
 644:	00158493          	addi	s1,a1,1
  state = 0;
 648:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 64a:	02500a13          	li	s4,37
 64e:	4b55                	li	s6,21
 650:	a839                	j	66e <vprintf+0x4c>
        putc(fd, c);
 652:	85ca                	mv	a1,s2
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	efe080e7          	jalr	-258(ra) # 554 <putc>
 65e:	a019                	j	664 <vprintf+0x42>
    } else if(state == '%'){
 660:	01498d63          	beq	s3,s4,67a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 664:	0485                	addi	s1,s1,1
 666:	fff4c903          	lbu	s2,-1(s1)
 66a:	16090763          	beqz	s2,7d8 <vprintf+0x1b6>
    if(state == 0){
 66e:	fe0999e3          	bnez	s3,660 <vprintf+0x3e>
      if(c == '%'){
 672:	ff4910e3          	bne	s2,s4,652 <vprintf+0x30>
        state = '%';
 676:	89d2                	mv	s3,s4
 678:	b7f5                	j	664 <vprintf+0x42>
      if(c == 'd'){
 67a:	13490463          	beq	s2,s4,7a2 <vprintf+0x180>
 67e:	f9d9079b          	addiw	a5,s2,-99
 682:	0ff7f793          	zext.b	a5,a5
 686:	12fb6763          	bltu	s6,a5,7b4 <vprintf+0x192>
 68a:	f9d9079b          	addiw	a5,s2,-99
 68e:	0ff7f713          	zext.b	a4,a5
 692:	12eb6163          	bltu	s6,a4,7b4 <vprintf+0x192>
 696:	00271793          	slli	a5,a4,0x2
 69a:	00000717          	auipc	a4,0x0
 69e:	3de70713          	addi	a4,a4,990 # a78 <malloc+0x1a4>
 6a2:	97ba                	add	a5,a5,a4
 6a4:	439c                	lw	a5,0(a5)
 6a6:	97ba                	add	a5,a5,a4
 6a8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6aa:	008b8913          	addi	s2,s7,8
 6ae:	4685                	li	a3,1
 6b0:	4629                	li	a2,10
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	ebe080e7          	jalr	-322(ra) # 576 <printint>
 6c0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b745                	j	664 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c6:	008b8913          	addi	s2,s7,8
 6ca:	4681                	li	a3,0
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	ea2080e7          	jalr	-350(ra) # 576 <printint>
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b751                	j	664 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4641                	li	a2,16
 6ea:	000ba583          	lw	a1,0(s7)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e86080e7          	jalr	-378(ra) # 576 <printint>
 6f8:	8bca                	mv	s7,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b7a5                	j	664 <vprintf+0x42>
 6fe:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 700:	008b8c13          	addi	s8,s7,8
 704:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 708:	03000593          	li	a1,48
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	e46080e7          	jalr	-442(ra) # 554 <putc>
  putc(fd, 'x');
 716:	07800593          	li	a1,120
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e38080e7          	jalr	-456(ra) # 554 <putc>
 724:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 726:	00000b97          	auipc	s7,0x0
 72a:	3aab8b93          	addi	s7,s7,938 # ad0 <digits>
 72e:	03c9d793          	srli	a5,s3,0x3c
 732:	97de                	add	a5,a5,s7
 734:	0007c583          	lbu	a1,0(a5)
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	e1a080e7          	jalr	-486(ra) # 554 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 742:	0992                	slli	s3,s3,0x4
 744:	397d                	addiw	s2,s2,-1
 746:	fe0914e3          	bnez	s2,72e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 74a:	8be2                	mv	s7,s8
      state = 0;
 74c:	4981                	li	s3,0
 74e:	6c02                	ld	s8,0(sp)
 750:	bf11                	j	664 <vprintf+0x42>
        s = va_arg(ap, char*);
 752:	008b8993          	addi	s3,s7,8
 756:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 75a:	02090163          	beqz	s2,77c <vprintf+0x15a>
        while(*s != 0){
 75e:	00094583          	lbu	a1,0(s2)
 762:	c9a5                	beqz	a1,7d2 <vprintf+0x1b0>
          putc(fd, *s);
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	dee080e7          	jalr	-530(ra) # 554 <putc>
          s++;
 76e:	0905                	addi	s2,s2,1
        while(*s != 0){
 770:	00094583          	lbu	a1,0(s2)
 774:	f9e5                	bnez	a1,764 <vprintf+0x142>
        s = va_arg(ap, char*);
 776:	8bce                	mv	s7,s3
      state = 0;
 778:	4981                	li	s3,0
 77a:	b5ed                	j	664 <vprintf+0x42>
          s = "(null)";
 77c:	00000917          	auipc	s2,0x0
 780:	2f490913          	addi	s2,s2,756 # a70 <malloc+0x19c>
        while(*s != 0){
 784:	02800593          	li	a1,40
 788:	bff1                	j	764 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 78a:	008b8913          	addi	s2,s7,8
 78e:	000bc583          	lbu	a1,0(s7)
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	dc0080e7          	jalr	-576(ra) # 554 <putc>
 79c:	8bca                	mv	s7,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b5d1                	j	664 <vprintf+0x42>
        putc(fd, c);
 7a2:	02500593          	li	a1,37
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	dac080e7          	jalr	-596(ra) # 554 <putc>
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	bd4d                	j	664 <vprintf+0x42>
        putc(fd, '%');
 7b4:	02500593          	li	a1,37
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	d9a080e7          	jalr	-614(ra) # 554 <putc>
        putc(fd, c);
 7c2:	85ca                	mv	a1,s2
 7c4:	8556                	mv	a0,s5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	d8e080e7          	jalr	-626(ra) # 554 <putc>
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	bd51                	j	664 <vprintf+0x42>
        s = va_arg(ap, char*);
 7d2:	8bce                	mv	s7,s3
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b579                	j	664 <vprintf+0x42>
 7d8:	74e2                	ld	s1,56(sp)
 7da:	79a2                	ld	s3,40(sp)
 7dc:	7a02                	ld	s4,32(sp)
 7de:	6ae2                	ld	s5,24(sp)
 7e0:	6b42                	ld	s6,16(sp)
 7e2:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7e4:	60a6                	ld	ra,72(sp)
 7e6:	6406                	ld	s0,64(sp)
 7e8:	7942                	ld	s2,48(sp)
 7ea:	6161                	addi	sp,sp,80
 7ec:	8082                	ret

00000000000007ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ee:	715d                	addi	sp,sp,-80
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	addi	s0,sp,32
 7f6:	e010                	sd	a2,0(s0)
 7f8:	e414                	sd	a3,8(s0)
 7fa:	e818                	sd	a4,16(s0)
 7fc:	ec1c                	sd	a5,24(s0)
 7fe:	03043023          	sd	a6,32(s0)
 802:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 806:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80a:	8622                	mv	a2,s0
 80c:	00000097          	auipc	ra,0x0
 810:	e16080e7          	jalr	-490(ra) # 622 <vprintf>
}
 814:	60e2                	ld	ra,24(sp)
 816:	6442                	ld	s0,16(sp)
 818:	6161                	addi	sp,sp,80
 81a:	8082                	ret

000000000000081c <printf>:

void
printf(const char *fmt, ...)
{
 81c:	711d                	addi	sp,sp,-96
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	e40c                	sd	a1,8(s0)
 826:	e810                	sd	a2,16(s0)
 828:	ec14                	sd	a3,24(s0)
 82a:	f018                	sd	a4,32(s0)
 82c:	f41c                	sd	a5,40(s0)
 82e:	03043823          	sd	a6,48(s0)
 832:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 836:	00840613          	addi	a2,s0,8
 83a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83e:	85aa                	mv	a1,a0
 840:	4505                	li	a0,1
 842:	00000097          	auipc	ra,0x0
 846:	de0080e7          	jalr	-544(ra) # 622 <vprintf>
}
 84a:	60e2                	ld	ra,24(sp)
 84c:	6442                	ld	s0,16(sp)
 84e:	6125                	addi	sp,sp,96
 850:	8082                	ret

0000000000000852 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 852:	1141                	addi	sp,sp,-16
 854:	e422                	sd	s0,8(sp)
 856:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 858:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85c:	00000797          	auipc	a5,0x0
 860:	69c7b783          	ld	a5,1692(a5) # ef8 <freep>
 864:	a02d                	j	88e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 866:	4618                	lw	a4,8(a2)
 868:	9f2d                	addw	a4,a4,a1
 86a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	6310                	ld	a2,0(a4)
 872:	a83d                	j	8b0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 874:	ff852703          	lw	a4,-8(a0)
 878:	9f31                	addw	a4,a4,a2
 87a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 87c:	ff053683          	ld	a3,-16(a0)
 880:	a091                	j	8c4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 882:	6398                	ld	a4,0(a5)
 884:	00e7e463          	bltu	a5,a4,88c <free+0x3a>
 888:	00e6ea63          	bltu	a3,a4,89c <free+0x4a>
{
 88c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88e:	fed7fae3          	bgeu	a5,a3,882 <free+0x30>
 892:	6398                	ld	a4,0(a5)
 894:	00e6e463          	bltu	a3,a4,89c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 898:	fee7eae3          	bltu	a5,a4,88c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 89c:	ff852583          	lw	a1,-8(a0)
 8a0:	6390                	ld	a2,0(a5)
 8a2:	02059813          	slli	a6,a1,0x20
 8a6:	01c85713          	srli	a4,a6,0x1c
 8aa:	9736                	add	a4,a4,a3
 8ac:	fae60de3          	beq	a2,a4,866 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8b0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8b4:	4790                	lw	a2,8(a5)
 8b6:	02061593          	slli	a1,a2,0x20
 8ba:	01c5d713          	srli	a4,a1,0x1c
 8be:	973e                	add	a4,a4,a5
 8c0:	fae68ae3          	beq	a3,a4,874 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8c6:	00000717          	auipc	a4,0x0
 8ca:	62f73923          	sd	a5,1586(a4) # ef8 <freep>
}
 8ce:	6422                	ld	s0,8(sp)
 8d0:	0141                	addi	sp,sp,16
 8d2:	8082                	ret

00000000000008d4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d4:	7139                	addi	sp,sp,-64
 8d6:	fc06                	sd	ra,56(sp)
 8d8:	f822                	sd	s0,48(sp)
 8da:	f426                	sd	s1,40(sp)
 8dc:	ec4e                	sd	s3,24(sp)
 8de:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e0:	02051493          	slli	s1,a0,0x20
 8e4:	9081                	srli	s1,s1,0x20
 8e6:	04bd                	addi	s1,s1,15
 8e8:	8091                	srli	s1,s1,0x4
 8ea:	0014899b          	addiw	s3,s1,1
 8ee:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8f0:	00000517          	auipc	a0,0x0
 8f4:	60853503          	ld	a0,1544(a0) # ef8 <freep>
 8f8:	c915                	beqz	a0,92c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fc:	4798                	lw	a4,8(a5)
 8fe:	08977e63          	bgeu	a4,s1,99a <malloc+0xc6>
 902:	f04a                	sd	s2,32(sp)
 904:	e852                	sd	s4,16(sp)
 906:	e456                	sd	s5,8(sp)
 908:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 90a:	8a4e                	mv	s4,s3
 90c:	0009871b          	sext.w	a4,s3
 910:	6685                	lui	a3,0x1
 912:	00d77363          	bgeu	a4,a3,918 <malloc+0x44>
 916:	6a05                	lui	s4,0x1
 918:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 91c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 920:	00000917          	auipc	s2,0x0
 924:	5d890913          	addi	s2,s2,1496 # ef8 <freep>
  if(p == (char*)-1)
 928:	5afd                	li	s5,-1
 92a:	a091                	j	96e <malloc+0x9a>
 92c:	f04a                	sd	s2,32(sp)
 92e:	e852                	sd	s4,16(sp)
 930:	e456                	sd	s5,8(sp)
 932:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 934:	00000797          	auipc	a5,0x0
 938:	5cc78793          	addi	a5,a5,1484 # f00 <base>
 93c:	00000717          	auipc	a4,0x0
 940:	5af73e23          	sd	a5,1468(a4) # ef8 <freep>
 944:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 946:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 94a:	b7c1                	j	90a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 94c:	6398                	ld	a4,0(a5)
 94e:	e118                	sd	a4,0(a0)
 950:	a08d                	j	9b2 <malloc+0xde>
  hp->s.size = nu;
 952:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 956:	0541                	addi	a0,a0,16
 958:	00000097          	auipc	ra,0x0
 95c:	efa080e7          	jalr	-262(ra) # 852 <free>
  return freep;
 960:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 964:	c13d                	beqz	a0,9ca <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 966:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 968:	4798                	lw	a4,8(a5)
 96a:	02977463          	bgeu	a4,s1,992 <malloc+0xbe>
    if(p == freep)
 96e:	00093703          	ld	a4,0(s2)
 972:	853e                	mv	a0,a5
 974:	fef719e3          	bne	a4,a5,966 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 978:	8552                	mv	a0,s4
 97a:	00000097          	auipc	ra,0x0
 97e:	bc2080e7          	jalr	-1086(ra) # 53c <sbrk>
  if(p == (char*)-1)
 982:	fd5518e3          	bne	a0,s5,952 <malloc+0x7e>
        return 0;
 986:	4501                	li	a0,0
 988:	7902                	ld	s2,32(sp)
 98a:	6a42                	ld	s4,16(sp)
 98c:	6aa2                	ld	s5,8(sp)
 98e:	6b02                	ld	s6,0(sp)
 990:	a03d                	j	9be <malloc+0xea>
 992:	7902                	ld	s2,32(sp)
 994:	6a42                	ld	s4,16(sp)
 996:	6aa2                	ld	s5,8(sp)
 998:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 99a:	fae489e3          	beq	s1,a4,94c <malloc+0x78>
        p->s.size -= nunits;
 99e:	4137073b          	subw	a4,a4,s3
 9a2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a4:	02071693          	slli	a3,a4,0x20
 9a8:	01c6d713          	srli	a4,a3,0x1c
 9ac:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ae:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b2:	00000717          	auipc	a4,0x0
 9b6:	54a73323          	sd	a0,1350(a4) # ef8 <freep>
      return (void*)(p + 1);
 9ba:	01078513          	addi	a0,a5,16
  }
}
 9be:	70e2                	ld	ra,56(sp)
 9c0:	7442                	ld	s0,48(sp)
 9c2:	74a2                	ld	s1,40(sp)
 9c4:	69e2                	ld	s3,24(sp)
 9c6:	6121                	addi	sp,sp,64
 9c8:	8082                	ret
 9ca:	7902                	ld	s2,32(sp)
 9cc:	6a42                	ld	s4,16(sp)
 9ce:	6aa2                	ld	s5,8(sp)
 9d0:	6b02                	ld	s6,0(sp)
 9d2:	b7f5                	j	9be <malloc+0xea>
